Return-Path: <linux-kernel-owner+w=401wt.eu-S934831AbZLPJQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934831AbZLPJQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 04:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932265AbZLPJQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 04:16:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53763 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182AbZLPJQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 04:16:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
Date: Wed, 16 Dec 2009 09:15:45 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.32-07500-g8bea867-dirty; KDE/4.3.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
References: <20091212101032.GB25286@elte.hu> <20091213191606.GB7297@nowhere> <20091213213015.653307b5@infradead.org>
In-Reply-To: <20091213213015.653307b5@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912160915.45606.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19BgD0j8bsLH9ZKe35FGcRfuq8T+KGSGKhGc+1
 F5KeK6zJOjUShDQWNluPWJp0CxjJdw94zGTBTAaWdKQnzgWqdu
 +eWvB6k8+w7kwaSO77TwA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 December 2009 05:30:15 Arjan van de Ven wrote:
> On Sun, 13 Dec 2009 20:16:08 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
> > We have the bkl tracepoints for that, attaching an example below,
> > blkdev_get/bkldev_put is among the highest consumer for me.
> 
> we have a trace, but not a number that anyone can just pull out without
> having to go through great lengths to set stuff up... (esp to capture a
> boot)...
> Adding a counter always to the lock_kernel function should be fine
> instead...

FWIW, I've hacked up some debugging logic in lib/kernel_lock.c to count
and measure the BKL. If anyone is interested in this, I can bring the
patch into a form that is usable. The output for a boot followed by
building a kernel on a four-way box with today's git looks like:

fs/ioctl.c:51 vfs_ioctl,5672809,0,9,108968293432,40528
drivers/char/vt_ioctl.c:512 vt_ioctl,15615,0,45,7967944,16400928
fs/locks.c:826 __posix_lock_file,1272,0,57,2815752,2013920
sound/core/sound.c:175 snd_open,1201,0,0,3863432,0
fs/block_dev.c:1192 __blkdev_get,479,26,14,39860472,686636416
drivers/usb/core/devio.c:656 usbdev_open,240,0,0,1640792,0
drivers/usb/core/devio.c:1868 usbdev_ioctl,240,0,0,369368,0
fs/read_write.c:110 default_llseek,185,0,5,88048,669224
drivers/char/tty_io.c:1761 tty_open,136,0,11,2878344,249472048
fs/block_dev.c:1358 __blkdev_put,117,1,1,10654208,3840
drivers/char/tty_io.c:1882 tty_open,106,0,5,44344,32056
drivers/char/tty_io.c:1603 tty_release,99,0,3,363496,8192
drivers/char/tty_io.c:1513 tty_release,99,0,3,639200,104312
kernel/ptrace.c:610 sys_ptrace,98,0,0,588432,0
block/ioctl.c:171 __blkdev_driver_ioctl,40,0,4,2960544,69288
fs/locks.c:1188 __break_lease,25,0,0,14960,0
fs/namespace.c:1650 do_new_mount,14,1,0,403088,0
fs/locks.c:733 flock_lock_file,14,0,0,33072,0
fs/locks.c:2022 locks_remove_flock,9,0,0,17160,0
drivers/char/pty.c:673 ptmx_open,8,0,0,406200,0
drivers/input/input.c:1767 input_open_file,7,0,0,83776,0
drivers/char/tty_io.c:717 disassociate_ctty,5,0,1,2376,322352
lib/kernel_lock.c:236 stat_read,3,0,0,590328,0
kernel/trace/trace.c:721 register_tracer,3,0,1,2420999112,17296
fs/locks.c:647 posix_test_lock,3,0,0,6920,0
drivers/gpu/drm/drm_fops.c:176 drm_stub_open,2,0,0,16712,0
init/main.c:849 kernel_init,1,0,0,334951112,0
init/main.c:546 start_kernel,1,0,0,873891904,0
fs/ext3/super.c:2548 ext3_remount,1,0,0,86592,0
fs/ext3/super.c:2036 ext3_fill_super,1,1,0,2656,0
drivers/gpu/drm/drm_fops.c:473 drm_release,1,0,0,6360,0
block/ioctl.c:316 blkdev_ioctl,1,0,1,848,32352

The comma-separated fields are
1. caller location
2. number of lock_kernel() calls
3. number of times it was called with BKL held already
4. number of times it blocked
5. total time it was held in get_cycles() units, not counting
   time spent during release-on-sleep
6. total time that this lock_kernel() was blocked by another
   thread holding the BKL.

It would be easy to add some recording of who is nesting
or blocking whom, or which ones call a function that might_sleep().

	Arnd
