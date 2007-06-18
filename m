Return-Path: <linux-kernel-owner+w=401wt.eu-S1760175AbXFRHS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175AbXFRHS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 03:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758206AbXFRHSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 03:18:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:58010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756941AbXFRHSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 03:18:21 -0400
Date: Mon, 18 Jun 2007 09:18:19 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] blink: Only blink when parameter is set
Message-ID: <20070618071819.GA9953@suse.de>
Mail-Followup-To: Randy Dunlap <randy.dunlap@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
References: <20070617083904.GC4496@suse.de> <20070617212601.38f952fe.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070617212601.38f952fe.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap <randy.dunlap@oracle.com> [2007-06-18 06:26]:
> > +static int blink = 0;
> 
> no need to init to 0.

Does it harm?

> > +module_param(blink, bool, S_IRUGO);
> > +MODULE_PARM_DESC(blink, "Enable blinking (without that, the module does nothing)\n");
> 
> unneeded "\n"

Fixed. Please use the following patch.

-----

This patch in the blink driver changes the module to only blink when
the parameter 'blink' is set to true. This is to allow the module to be
compiled in the kernel and not as module.

As the blink module was initially written for kdump, and as the kernel is
relocatable on lots of architectures, there's no need to compile a separate
kdump kernel. The blinking can now enabled via the boot command line
for the kdump kernel when necessary.

The patch also adds some author/license information and marks the init function
as '__init'.

Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 drivers/misc/blink.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/misc/blink.c
+++ b/drivers/misc/blink.c
@@ -3,6 +3,10 @@
 #include <linux/timer.h>
 #include <linux/jiffies.h>
 
+static int blink;
+module_param(blink, bool, S_IRUGO);
+MODULE_PARM_DESC(blink, "Enable blinking (without that, the module does nothing)");
+
 static void do_blink(unsigned long data);
 
 static DEFINE_TIMER(blink_timer, do_blink, 0 ,0);
@@ -16,12 +20,19 @@ static void do_blink(unsigned long data)
 	add_timer(&blink_timer);
 }
 
-static int blink_init(void)
+static int __init blink_init(void)
 {
 	printk(KERN_INFO "Enabling keyboard blinking\n");
-	do_blink(0);
+
+	if (blink)
+		do_blink(0);
+
 	return 0;
 }
 
 module_init(blink_init);
 
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Andi Kleen <ak@suse.de>");
+MODULE_DESCRIPTION("Blinks the keyboard LEDs");
+
