Return-Path: <linux-kernel-owner+w=401wt.eu-S1754938AbZGSQ3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbZGSQ3q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 12:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbZGSQ3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 12:29:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:33815 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610AbZGSQ3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 12:29:43 -0400
Subject: [PATCH] SOUND: OSS sequencer should be initialized after
 snd_seq_system_client_init
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <s5h1voclkz0.wl%tiwai@suse.de>
References: <1247861644.4513.15.camel@ht.satnam>
	 <s5h4ot8op0b.wl%tiwai@suse.de> <1248017194.2548.3.camel@ht.satnam>
	 <s5h1voclkz0.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Sun, 19 Jul 2009 21:58:34 +0530
Message-Id: <1248020914.2471.4.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-19 at 18:02 +0200, Takashi Iwai wrote:

> Looks good.  Could you give a changelog and your sign-off to merge?
> 

[PATCH] SOUND: OSS sequencer should be initialized after snd_seq_system_client_init

When build SND_SEQUENCER in kernel then OSS sequencer(alsa_seq_oss_init)
is initialized before System (snd_seq_system_client_init) which leads to
memory leak :

unreferenced object 0xf6b0e680 (size 256):
  comm "swapper", pid 1, jiffies 4294670753
  backtrace:
    [<c108ac5c>] create_object+0x135/0x204
    [<c108adfe>] kmemleak_alloc+0x26/0x4c
    [<c1087de2>] kmem_cache_alloc+0x72/0xff
    [<c126d2ac>] seq_create_client1+0x22/0x160
    [<c126e3b6>] snd_seq_create_kernel_client+0x72/0xef
    [<c1485a05>] snd_seq_oss_create_client+0x86/0x142
    [<c1485920>] alsa_seq_oss_init+0xf6/0x155
    [<c1001059>] do_one_initcall+0x4f/0x111
    [<c14655be>] kernel_init+0x115/0x166
    [<c10032af>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff
unreferenced object 0xf688a580 (size 64):
  comm "swapper", pid 1, jiffies 4294670753
  backtrace:
    [<c108ac5c>] create_object+0x135/0x204
    [<c108adfe>] kmemleak_alloc+0x26/0x4c
    [<c1087de2>] kmem_cache_alloc+0x72/0xff
    [<c126f964>] snd_seq_pool_new+0x1c/0xb8
    [<c126d311>] seq_create_client1+0x87/0x160
    [<c126e3b6>] snd_seq_create_kernel_client+0x72/0xef
    [<c1485a05>] snd_seq_oss_create_client+0x86/0x142
    [<c1485920>] alsa_seq_oss_init+0xf6/0x155
    [<c1001059>] do_one_initcall+0x4f/0x111
    [<c14655be>] kernel_init+0x115/0x166
    [<c10032af>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6b0e480 (size 256):
  comm "swapper", pid 1, jiffies 4294670754
  backtrace:
    [<c108ac5c>] create_object+0x135/0x204
    [<c108adfe>] kmemleak_alloc+0x26/0x4c
    [<c1087de2>] kmem_cache_alloc+0x72/0xff
    [<c12725a0>] snd_seq_create_port+0x51/0x21c
    [<c126de50>] snd_seq_ioctl_create_port+0x57/0x13c
    [<c126d07a>] snd_seq_do_ioctl+0x4a/0x69
    [<c126d0de>] snd_seq_kernel_client_ctl+0x33/0x49
    [<c1485a74>] snd_seq_oss_create_client+0xf5/0x142
    [<c1485920>] alsa_seq_oss_init+0xf6/0x155
    [<c1001059>] do_one_initcall+0x4f/0x111
    [<c14655be>] kernel_init+0x115/0x166
    [<c10032af>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff

The correct order should be :

System (snd_seq_system_client_init) should be initialized before
OSS sequencer(alsa_seq_oss_init) which is equivalent to :

1. insmod sound/core/seq/snd-seq-device.ko
2. insmod sound/core/seq/snd-seq.ko
3. insmod sound/core/seq/snd-seq-midi-event.ko
4. insmod sound/core/seq/oss/snd-seq-oss.ko

Including sound/core/seq/oss/Makefile after other seq modules
fixes the ordering and memory leak.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 sound/core/seq/Makefile |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/sound/core/seq/Makefile b/sound/core/seq/Makefile
index 1bcb360..941f64a 100644
--- a/sound/core/seq/Makefile
+++ b/sound/core/seq/Makefile
@@ -3,10 +3,6 @@
 # Copyright (c) 1999 by Jaroslav Kysela <perex@perex.cz>
 #
 
-ifeq ($(CONFIG_SND_SEQUENCER_OSS),y)
-  obj-$(CONFIG_SND_SEQUENCER) += oss/
-endif
-
 snd-seq-device-objs := seq_device.o
 snd-seq-objs := seq.o seq_lock.o seq_clientmgr.o seq_memory.o seq_queue.o \
                 seq_fifo.o seq_prioq.o seq_timer.o \
@@ -19,7 +15,8 @@ snd-seq-virmidi-objs := seq_virmidi.o
 
 obj-$(CONFIG_SND_SEQUENCER) += snd-seq.o snd-seq-device.o
 ifeq ($(CONFIG_SND_SEQUENCER_OSS),y)
-obj-$(CONFIG_SND_SEQUENCER) += snd-seq-midi-event.o
+  obj-$(CONFIG_SND_SEQUENCER) += snd-seq-midi-event.o
+  obj-$(CONFIG_SND_SEQUENCER) += oss/
 endif
 obj-$(CONFIG_SND_SEQ_DUMMY) += snd-seq-dummy.o
 
-- 
1.6.0.6



