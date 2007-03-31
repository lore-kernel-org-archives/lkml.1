Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbXCaSS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbXCaSS7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 14:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbXCaSS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 14:18:59 -0400
Received: from smtp114.sbc.mail.mud.yahoo.com ([68.142.198.213]:31858 "HELO
	smtp114.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753741AbXCaSS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 14:18:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JIAvjMP3LlCoZZtXMAS6nQdXlpHBX7fSnUoJIFAincPK+a/ls3OiQGbZGbdVI9N27hi/+zH/Y0e3PBqnmuPaI8U9diUHSgK3A7oc8IptI6/eD7v3JblM9jNQmYWrb+PCW6uN/5WgzXl3zvoHze6+b2NFDP5Hemn3FVCueVxj8Dc=  ;
X-YMail-OSG: DdBtJe4VM1lVMOKyBznzjJp4i0aEJ.MbUpXXkHA.9S6LMgI0iHjOu0zxqKPXN_V4tvJVGxhFmkCHzQd8qgiTldVQUgK2Ki0BRWHU3Pax_dP9r9lImq0-
From: David Brownell <david-b@pacbell.net>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH v2] Add suspend/resume for HPET
Date: Sat, 31 Mar 2007 11:18:53 -0700
User-Agent: KMail/1.7.1
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, gregkh@suse.de,
       Ingo Molnar <mingo@elte.hu>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, jgarzik@pobox.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Thomas Gleixner <tglx@linutronix.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <Pine.LNX.4.64.0703310943190.6730@woody.linux-foundation.org> <20070331170245.GA9244@elte.hu>
In-Reply-To: <20070331170245.GA9244@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703311118.55132.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

( please remove obsolute linux-pm@lists.osdl.org  from further messages!! )

On Saturday 31 March 2007 10:02 am, Ingo Molnar wrote:
> 
> i dont think there's any particular problem here because suspend/resume 
> wont be done during bootup - but we might need a way to move a device to 
> earlier spots in the device tree, even if they got registered later on - 
> instead of forcing the time devices to be registered very early?

I'm about ready to test the appended patch... a "move one device" call
might be safest at this point in the release cycle though.

- Dave

========================	SNIP!
Change how the PM list is constructed, so that devices are added right
after their parents (when they have one) rather than at the end of the
list.  This preserves sequencing guarantees, but enables sequencing of
suspend/resume operations by more important characteristics than "when
device happened to enumerate" ... e.g. clocksources and clockevents
at a clearly defined point during suspend and resume.

This patch has a potential downside for devices that have multiple
power dependencies and which "just happened to work" before.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

--- g26.orig/drivers/base/power/main.c	2006-07-02 12:30:30.000000000 -0700
+++ g26/drivers/base/power/main.c	2007-03-31 11:02:28.000000000 -0700
@@ -52,12 +52,17 @@ EXPORT_SYMBOL_GPL(device_pm_set_parent);
 int device_pm_add(struct device * dev)
 {
 	int error;
+	struct device *parent = dev->parent;
 
-	pr_debug("PM: Adding info for %s:%s\n",
-		 dev->bus ? dev->bus->name : "No Bus", dev->kobj.name);
+	pr_debug("PM: Adding info for %s:%s, after %s\n",
+		 dev->bus ? dev->bus->name : "No Bus", dev->kobj.name,
+		 parent ? parent->bus_id : "(no parent)");
 	down(&dpm_list_sem);
-	list_add_tail(&dev->power.entry, &dpm_active);
-	device_pm_set_parent(dev, dev->parent);
+	if (parent)
+		list_add(&dev->power.entry, &parent->power.entry);
+	else
+		list_add_tail(&dev->power.entry, &dpm_active);
+	device_pm_set_parent(dev, parent);
 	if ((error = dpm_sysfs_add(dev)))
 		list_del(&dev->power.entry);
 	up(&dpm_list_sem);
