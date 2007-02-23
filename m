Return-Path: <linux-kernel-owner+w=401wt.eu-S933137AbXBWQgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137AbXBWQgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 11:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933139AbXBWQgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 11:36:40 -0500
Received: from smtp101.sbc.mail.re2.yahoo.com ([68.142.229.104]:32286 "HELO
	smtp101.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933137AbXBWQgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 11:36:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZwcH+MmClxrjVlxZKv66L8zFLMX8ENxew6WqTccxBHBFicDqGQjwz6ZhG7Dbp/yKmup+vNLsfYk2fOzh5pzJ01pIxBE4W1etxPiq8LygNJF3zDuhOum6XzAWbVOkOx4FLS1Lppj5nfw1C+tWyEnorDv87wSa+M8S6vEeHNoA4j0=  ;
X-YMail-OSG: LNp1LoMVM1mw8_SysCx4LhvJzpiUNs6krZBYH8XhEetdaUiwAOHBJuNZ2QpHEDSiUZG3VNhvw93IxvyvunuedE6T0EeTcNjICPGUCZ5QtPc5St6nkmcu8tudkqmSgJc.8jtnpPUOxCtUepQ-
From: David Brownell <david-b@pacbell.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.20-mm2
Date: Fri, 23 Feb 2007 08:36:36 -0800
User-Agent: KMail/1.7.1
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <200702182113.03481.david-b@pacbell.net> <200702202307.45432.rjw@sisk.pl>
In-Reply-To: <200702202307.45432.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702230836.37096.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
> > > > Unable to handle kernel NULL pointer dereference at 0000000000000030 RIP: 
> > > >  [<ffffffff804032c3>] rtc_sysfs_remove_device+0x23/0x50

The bug isn't in rtc_cmos, but that's the only driver that would currently
show the bug.  (Triggered by finding the IRQ claimed by the legacy driver,
result of a "but it should still be safe!" misconfiguration.)

The following fixes this on my 2.6.21-rc1 system; same fix should apply
to MM2.

=====================	CUT HERE
Fix an oops on the rtc_device_unregister() path by waiting until the
last moment before nulling the rtc->ops vector.  Fix some potential
oopses by having the rtc_class_open()/rtc_class_close() interface
increase the RTC's reference count while an RTC handle is available
outside the RTC framework.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Index: g26/drivers/rtc/class.c
===================================================================
--- g26.orig/drivers/rtc/class.c	2007-02-21 12:03:20.000000000 -0800
+++ g26/drivers/rtc/class.c	2007-02-23 08:00:52.000000000 -0800
@@ -204,10 +204,16 @@ EXPORT_SYMBOL_GPL(rtc_device_register);
  */
 void rtc_device_unregister(struct rtc_device *rtc)
 {
-	mutex_lock(&rtc->ops_lock);
-	rtc->ops = NULL;
-	mutex_unlock(&rtc->ops_lock);
-	class_device_unregister(&rtc->class_dev);
+	if (class_device_get(&rtc->class_dev) != NULL) {
+		mutex_lock(&rtc->ops_lock);
+		/* remove innards of this RTC, then disable it, before
+		 * letting any rtc_class_open() users access it again
+		 */
+		class_device_unregister(&rtc->class_dev);
+		rtc->ops = NULL;
+		mutex_unlock(&rtc->ops_lock);
+		class_device_put(&rtc->class_dev);
+	}
 }
 EXPORT_SYMBOL_GPL(rtc_device_unregister);
 
Index: g26/drivers/rtc/interface.c
===================================================================
--- g26.orig/drivers/rtc/interface.c	2006-11-27 15:37:13.000000000 -0800
+++ g26/drivers/rtc/interface.c	2007-02-23 07:45:09.000000000 -0800
@@ -179,7 +179,7 @@ struct class_device *rtc_class_open(char
 	down(&rtc_class->sem);
 	list_for_each_entry(class_dev_tmp, &rtc_class->children, node) {
 		if (strncmp(class_dev_tmp->class_id, name, BUS_ID_SIZE) == 0) {
-			class_dev = class_dev_tmp;
+			class_dev = class_device_get(class_dev_tmp);
 			break;
 		}
 	}
@@ -197,6 +197,7 @@ EXPORT_SYMBOL_GPL(rtc_class_open);
 void rtc_class_close(struct class_device *class_dev)
 {
 	module_put(to_rtc_device(class_dev)->owner);
+	class_device_put(class_dev);
 }
 EXPORT_SYMBOL_GPL(rtc_class_close);
 
