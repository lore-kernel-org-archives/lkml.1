Return-Path: <linux-kernel-owner+w=401wt.eu-S1758292AbZGHJAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292AbZGHJAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 05:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756842AbZGHJAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 05:00:43 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:32864 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335AbZGHJAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 05:00:41 -0400
Date: Wed, 8 Jul 2009 04:58:27 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: should kernel support "rdinit=" parm without initrd support?
Message-ID: <alpine.LFD.2.00.0907080451160.22155@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  wasn't sure if this was an LKML or newbies list question, so i
flipped a coin.  you lost.

  from init/main.c:

=====

static int __init init_setup(char *str)
{
        unsigned int i;

        execute_command = str;
        /*
         * In case LILO is going to boot us with default command line,
         * it prepends "auto" before the whole cmdline which makes
         * the shell think it should execute a script with such name.
         * So we ignore all arguments entered _before_ init=... [MJ]
         */
        for (i = 1; i < MAX_INIT_ARGS; i++)
                argv_init[i] = NULL;
        return 1;
}
__setup("init=", init_setup);

static int __init rdinit_setup(char *str)
{
        unsigned int i;

        ramdisk_execute_command = str;
        /* See "auto" comment in init_setup */
        for (i = 1; i < MAX_INIT_ARGS; i++)
                argv_init[i] = NULL;
        return 1;
}
__setup("rdinit=", rdinit_setup);

=====

  so, as i read it (and i might be wrong), "rdinit=" is used to
override the initial program in *early* userspace, while "init=" is
typically used to override the initial program in the final root
filesystem.  is that a fairly accurate way to put it?

  however, if you don't configure initramfs support *at all* (by not
selecting BLK_DEV_INITRD), notice what happens in init_post():

=====

       if (ramdisk_execute_command) {
                run_init_process(ramdisk_execute_command);
                printk(KERN_WARNING "Failed to execute %s\n",
                                ramdisk_execute_command);
        }

        /*
         * We try each of these until one succeeds.
         *
         * The Bourne shell can be used instead of init if we are
         * trying to recover a really broken machine.
         */
        if (execute_command) {
                run_init_process(execute_command);
                printk(KERN_WARNING "Failed to execute %s.  Attempting "
                                        "defaults...\n", execute_command);
        }
        run_init_process("/sbin/init");
        run_init_process("/etc/init");
        run_init_process("/bin/init");
        run_init_process("/bin/sh");

=====

  even without BLK_DEV_INITRD initramfs support, the code will still
try to process a "rdinit=" command line parm (possibly overriding a
simultaneous "init=" parm).  does that make sense?  is there some
value to still processing "rdinit=" when you have no initramfs
support?  or would it make more sense to simply preprocess that code
away thusly:

=====

#ifdef CONFIG_BLK_DEV_INITRD
        if (ramdisk_execute_command) {
                run_init_process(ramdisk_execute_command);
                printk(KERN_WARNING "Failed to execute %s\n",
                                ramdisk_execute_command);
        }
#endif

=====

  or am i misreading this entirely?

rday
--


========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
