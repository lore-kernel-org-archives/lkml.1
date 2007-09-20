Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbXITU0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbXITU0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 16:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbXITU0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 16:26:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40069 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbXITU03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 16:26:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when booted, USB-related WARNING
Date: Thu, 20 Sep 2007 22:39:10 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <1190299841.3481.37.camel@chaos> <1190303393.3639.0.camel@chaos>
In-Reply-To: <1190303393.3639.0.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709202239.11070.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 20 September 2007 17:49, Thomas Gleixner wrote:
> On Thu, 2007-09-20 at 16:50 +0200, Thomas Gleixner wrote:
> > > > > Well, the above may affect SMP systems, but the Vaio is UP.  Hmm?
> > > > 
> > > > My jinxed VAIO variant is SMP, but it looks like the same mysterious
> > > > error.
> > > 
> > > Hm.  Have you tried
> > > 
> > > # echo test > /sys/power/disk
> > > # echo disk > /sys/power/state
> > > 
> > > (should suspend devices and disable the nonboot CPUs, wait for 5 sec. and
> > > restore everything)?
> > 
> > Works fine, but I need to reboot into a non debug kernel to verify.
> 
> Works as well. What's the difference between this and the real thing ?

The real thing also calls device_power_down(PMSG_FREEZE), which is a
counterpart of sysdev_shutdown(), more or less, and I think that's what goes
belly up.

You can use the patch below (on top of -rc6-mm1), which just disables the image
creation (that should be irrelevant anyway) and see what happens.

Greetings,
Rafael

---
 kernel/power/disk.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: linux-2.6.23-rc6-mm1/kernel/power/disk.c
===================================================================
--- linux-2.6.23-rc6-mm1.orig/kernel/power/disk.c
+++ linux-2.6.23-rc6-mm1/kernel/power/disk.c
@@ -168,13 +168,14 @@ int create_image(int platform_mode)
 	}
 
 	save_processor_state();
-	error = swsusp_arch_suspend();
-	if (error)
-		printk(KERN_ERR "Error %d while creating the image\n", error);
+	//error = swsusp_arch_suspend();
+	//if (error)
+	//	printk(KERN_ERR "Error %d while creating the image\n", error);
 	/* Restore control flow magically appears here */
 	restore_processor_state();
-	if (!in_suspend)
-		platform_leave(platform_mode);
+	//if (!in_suspend)
+	//	platform_leave(platform_mode);
+	in_suspend = 0;
 	/* NOTE:  device_power_up() is just a resume() for devices
 	 * that suspended with irqs off ... no overall powerup.
 	 */
