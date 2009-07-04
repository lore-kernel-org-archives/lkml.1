Return-Path: <linux-kernel-owner+w=401wt.eu-S1753236AbZGDQEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbZGDQEd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 12:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbZGDQEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 12:04:25 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:3532 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbZGDQEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 12:04:24 -0400
X-IronPort-AV: E=Sophos;i="4.42,348,1243828800"; 
   d="scan'208";a="1085895"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Boot Consoles question...
Date: Sat, 4 Jul 2009 12:07:42 -0400
User-Agent: KMail/1.9.5
CC: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200907040017.26921.rgetz@blackfin.uclinux.org> <20090704102904.GB32257@elte.hu>
In-Reply-To: <20090704102904.GB32257@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200907041207.42388.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 04 Jul 2009 16:04:23.0576 (UTC) FILETIME=[190A4180:01C9FCC1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 4 Jul 2009 06:29, Ingo Molnar pondered:
> Could be changed i guess ... but is it really an issue?

It is just a change from "normal" (when the kernel has no boot console).

We were looking at shipping our default kernel, with a boot console that wrote 
to a fixed place in memory - If something got hosed before the "real" console 
was registered, the bootloader would print it out on the next boot...

No more people complaining about the kernel crashing or hanging without any 
output on the console. (which happens more often than you would like with 
people doing weird things to their kernel during embedded development).

The down side - is the above - the info before the "real" console starts does 
not come out the real console...

> All messages 
>  should be in the syslog buffer (if it's large enough).

Yes. it does - but it still changes the "normal" boot look & feel...

>  One artifact 
>  could be manual scroll-back - it would perhaps be nice indeed to
>  allow the scrollback to the top of the bootlog.

Exactly.

One of my thoughts (was since CON_PRINTBUFFER isn't used after 
register_console()) - was for the CON_BOOT's CON_PRINTBUFFER flag to control 
the clearing of the CON_PRINTBUFFER for the real console or not...

All early_printk consoles that I looked at have their CON_PRINTBUFFER set.

Which means that something like should do the trick -- allow people who want 
to override things to do so, and still have the today's setup work as is...

--- kernel/printk.c     (revision 6920)
+++ kernel/printk.c     (working copy)
@@ -1144,7 +1144,7 @@
@@ -1230,12 +1230,16 @@
                 * everything out, before we unregister the console(s)
                 */
                printk(KERN_INFO "console handover:");
-               for_each_console(bcon)
+               flags = 0;
+               for_each_console(bcon) {
                        printk("boot [%s%d] ", bcon->name, bcon->index);
+                       flags |= bcon->flags & CON_PRINTBUFFER;
+               }
                printk(" -> real [%s%d]\n", newcon->name, newcon->index);
                for_each_console(bcon)
                        unregister_console(bcon);
-               newcon->flags &= ~CON_PRINTBUFFER;
+               if (flags)
+                       newcon->flags &= ~CON_PRINTBUFFER;
        } else {
                printk(KERN_INFO "%sconsole [%s%d] enabled\n",
                        (newcon->flags & CON_BOOT) ? "boot" : "" ,

And then in my early_printk console_enable:

        register_console(&early_shadow_console);
        /* Make sure that the real console prints from the beginning */
        early_shadow_console->flags &= ~CON_PRINTBUFFER;

?

Thoughts?
