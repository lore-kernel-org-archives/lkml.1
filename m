Return-Path: <linux-kernel-owner+w=401wt.eu-S1750944AbXLDUxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750944AbXLDUxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXLDUw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:52:26 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:23052 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751755AbXLDUwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:52:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=R7j8q5445o/M/IZStypfS7PJ9YQpXHyQN3BGb7KrPm7MVYhq2UalAZ7+D+b/Dya6f3elbKfcIAtHA55pQ/zXC2Exd8XM/ihmcYKHRlJKQkHEpLxVTJ/WVbqM08g/4prtWhyu+r3tZQT/LuDToeZw1l3NKeKzlGZlYkaq/hDYwAc=  ;
X-YMail-OSG: ZxQ8klkVM1m7vB33oKLHyJbJ_DCvLtkGFrhJcPaPDm4wQEfsCZ9PHnL3c.4LmlukeFvFpv4NhA--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.24-rc4] pcmcia stops updating dev->power.power_state
Date: Tue, 4 Dec 2007 12:28:07 -0800
User-Agent: KMail/1.9.6
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-pcmcia@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712041228.07688.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This stops the pcmcia core from using dev->power.power_state;
that field is deprecated (overdue for removal) and the only reason
to update it was to make the /sys/devices/.../power/state files
(now removed) work better.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

--- pstate.orig/drivers/pcmcia/ds.c	2007-12-04 09:33:12.000000000 -0800
+++ pstate/drivers/pcmcia/ds.c	2007-12-04 09:36:15.000000000 -0800
@@ -1129,8 +1129,6 @@ static int runtime_suspend(struct device
 	down(&dev->sem);
 	rc = pcmcia_dev_suspend(dev, PMSG_SUSPEND);
 	up(&dev->sem);
-	if (!rc)
-		dev->power.power_state.event = PM_EVENT_SUSPEND;
 	return rc;
 }
 
@@ -1141,8 +1139,6 @@ static void runtime_resume(struct device
 	down(&dev->sem);
 	rc = pcmcia_dev_resume(dev);
 	up(&dev->sem);
-	if (!rc)
-		dev->power.power_state.event = PM_EVENT_ON;
 }
 
 /************************ per-device sysfs output ***************************/
@@ -1264,6 +1260,9 @@ static int pcmcia_dev_suspend(struct dev
 	struct pcmcia_driver *p_drv = NULL;
 	int ret = 0;
 
+	if (p_dev->suspended)
+		return 0;
+
 	ds_dbg(2, "suspending %s\n", dev->bus_id);
 
 	if (dev->driver)
@@ -1300,6 +1299,9 @@ static int pcmcia_dev_resume(struct devi
         struct pcmcia_driver *p_drv = NULL;
 	int ret = 0;
 
+	if (!p_dev->suspended)
+		return 0;
+
 	ds_dbg(2, "resuming %s\n", dev->bus_id);
 
 	if (dev->driver)
