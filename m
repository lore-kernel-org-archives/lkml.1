Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbZC2Q6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbZC2Q6Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbZC2Q57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:57:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:50779 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbZC2Q56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:57:58 -0400
Date: Sun, 29 Mar 2009 09:59:17 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to debug kernel startup time?
Message-ID: <20090329095917.20948680@infradead.org>
In-Reply-To: <4e5e476b0903290945u19572af6ub366001596a7fd3f@mail.gmail.com>
References: <4e5e476b0903290840o453bcccdm5800a636078fde6e@mail.gmail.com>
	<20090329085119.0c93fb21@infradead.org>
	<4e5e476b0903290945u19572af6ub366001596a7fd3f@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/+H+QXzsSpgJBbbeO/aNJZMd"
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/+H+QXzsSpgJBbbeO/aNJZMd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, 29 Mar 2009 18:45:36 +0200
Corrado Zoccolo <czoccolo@gmail.com> wrote:

> On Sun, Mar 29, 2009 at 5:51 PM, Arjan van de Ven
> <arjan@infradead.org> wrote:
> > On Sun, 29 Mar 2009 17:40:10 +0200
> > Corrado Zoccolo <czoccolo@gmail.com> wrote:
> >
> >> Hi,
> >> I'm seeing around 2 s "lost" during kernel boot, that are not
> >> accounted for any init call (excerpt of dmesg with initcall_debug
> >> follows, kernel is 2.6.29).
> >> What's the suggested way to investigate such problems?
> >
> > I take it you don't have an initrd ?
> 
> You guessed right.
> 
> >
> > If so I know what you are hitting; I have a patch to solve it but
> > it's a bit convoluted and not ready for mainline.... let me know if
> > you want to try it, I suspect it'll solve your issue ;)
> >
> 
> Sure. I'd like to test it.
> 

attached...

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

--MP_/+H+QXzsSpgJBbbeO/aNJZMd
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=linux-2.6.29-dont-wait-for-mouse.patch

Subject: [PATCH] fastboot: remove "wait for all devices before mounting root" delay

In the non-initrd case, we wait for all devices to finish their
probing before we try to mount the rootfs.
In practice, this means that we end up waiting 2 extra seconds for
the PS/2 mouse probing even though the root holding device has been
ready since a long time.

The previous two patches in this series made the RAID autodetect code
do it's own "wait for probing to be done" code, and added
"wait and retry" functionality in case the root device isn't actually
available.

These two changes should make it safe to remove the delay itself,
and this patch does this. On my test laptop, this reduces the boot time
by 2 seconds (kernel time goes from 3.9 to 1.9 seconds).

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
--- a/init/do_mounts.c	2009-01-07 18:42:10.000000000 -0800
+++ b/init/do_mounts.c	2009-01-07 18:43:02.000000000 -0800
@@ -370,14 +370,17 @@ void __init prepare_namespace(void)
 		ssleep(root_delay);
 	}
 
+#if 0
 	/*
 	 * wait for the known devices to complete their probing
 	 *
 	 * Note: this is a potential source of long boot delays.
 	 * For example, it is not atypical to wait 5 seconds here
 	 * for the touchpad of a laptop to initialize.
 	 */
 	wait_for_device_probe();
+#endif
+	async_synchronize_full();
 
 	md_run_setup();
 


--MP_/+H+QXzsSpgJBbbeO/aNJZMd
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=linux-2.6.29-retry-root-mount.patch

Subject: [PATCH] fastboot: retry mounting the root fs if we can't find init

currently we wait until all device init is done before trying to mount
the root fs, and to consequently execute init.

In preparation for relaxing the first delay, this patch adds a retry
attempt in case /sbin/init is not found. Before retrying, the code
will wait for all device init to complete.

While this patch by itself doesn't gain boot time yet (it needs follow on
patches), the alternative already is to panic()...

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
--- a/init/main.c	2009-01-07 18:29:11.000000000 -0800
+++ b/init/main.c	2009-01-07 18:32:08.000000000 -0800
@@ -837,6 +837,7 @@ static void run_init_process(char *init_
  */
 static noinline int init_post(void)
 {
+	int retry_count = 1;
 	/* need to finish all async __init code before freeing the memory */
 	async_synchronize_full();
 	free_initmem();
@@ -859,6 +860,8 @@ static noinline int init_post(void)
 				ramdisk_execute_command);
 	}
 
+retry:
+
 	/*
 	 * We try each of these until one succeeds.
 	 *
@@ -871,6 +874,23 @@ static noinline int init_post(void)
 					"defaults...\n", execute_command);
 	}
 	run_init_process("/sbin/init");
+
+        if (retry_count > 0) {
+               retry_count--;
+               /* 
+                * We haven't found init yet... potentially because the device
+                * is still being probed. We need to
+                * - flush keventd and friends
+                * - wait for the known devices to complete their probing
+                * - try to mount the root fs again
+                */
+               flush_scheduled_work();
+               while (driver_probe_done() != 0)
+                       msleep(100);
+               prepare_namespace();
+               goto retry;
+        }
+
 	run_init_process("/etc/init");
 	run_init_process("/bin/init");
 	run_init_process("/bin/sh");


--MP_/+H+QXzsSpgJBbbeO/aNJZMd--
