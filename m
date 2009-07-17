Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277AbZGQUOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbZGQUOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbZGQUOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:14:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:45214 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098AbZGQUOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:14:47 -0400
Subject: kmemleak issues in alsa
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Takashi Iwai <tiwai@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 18 Jul 2009 01:44:04 +0530
Message-Id: <1247861644.4513.15.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was getting these kmemleak reports when I build SND_SEQUENCER in
kernel :

unreferenced object 0xf6b0ac00 (size 512):
  comm "swapper", pid 1, jiffies 4294671240
  hex dump (first 32 bytes):
    02 00 00 00 03 4f 53 53 20 73 65 71 75 65 6e 63  .....OSS sequenc
    65 72 00 00 00 00 00 00 00 00 00 00 00 00 00 00  er..............
  backtrace:
    [<c12d7d83>] kmemleak_alloc+0x25/0x49
    [<c109350d>] kmem_cache_alloc+0x95/0x124
    [<c12568f0>] seq_create_client1+0x1d/0x165
    [<c1257b01>] snd_seq_create_kernel_client+0x68/0xe7
    [<c14c966f>] snd_seq_oss_create_client+0x86/0x143
    [<c14c958a>] alsa_seq_oss_init+0xf8/0x157
    [<c100104f>] do_one_initcall+0x4a/0x111
    [<c14a8608>] kernel_init+0x16b/0x1bc
    [<c100352b>] kernel_thread_helper+0x7/0x1a
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6b08700 (size 128):
  comm "swapper", pid 1, jiffies 4294671240
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<c12d7d83>] kmemleak_alloc+0x25/0x49
    [<c109350d>] kmem_cache_alloc+0x95/0x124
    [<c12591a3>] snd_seq_pool_new+0x17/0xbe
    [<c1256955>] seq_create_client1+0x82/0x165
    [<c1257b01>] snd_seq_create_kernel_client+0x68/0xe7
    [<c14c966f>] snd_seq_oss_create_client+0x86/0x143
    [<c14c958a>] alsa_seq_oss_init+0xf8/0x157
    [<c100104f>] do_one_initcall+0x4a/0x111
    [<c14a8608>] kernel_init+0x16b/0x1bc
    [<c100352b>] kernel_thread_helper+0x7/0x1a
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6b0aa00 (size 512):
  comm "swapper", pid 1, jiffies 4294671246
  hex dump (first 32 bytes):
    0f 00 00 00 00 00 00 00 52 65 63 65 69 76 65 72  ........Receiver
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<c12d7d83>] kmemleak_alloc+0x25/0x49
    [<c109350d>] kmem_cache_alloc+0x95/0x124
    [<c125bdf9>] snd_seq_create_port+0x4c/0x197
    [<c1257589>] snd_seq_ioctl_create_port+0x52/0x141
    [<c1256bb3>] snd_seq_do_ioctl+0x59/0x78
    [<c1256c11>] snd_seq_kernel_client_ctl+0x2f/0x48
    [<c14c96e1>] snd_seq_oss_create_client+0xf8/0x143
    [<c14c958a>] alsa_seq_oss_init+0xf8/0x157
    [<c100104f>] do_one_initcall+0x4a/0x111
    [<c14a8608>] kernel_init+0x16b/0x1bc
    [<c100352b>] kernel_thread_helper+0x7/0x1a
    [<ffffffff>] 0xffffffff

But when I build SND_SEQUENCER as module these kmemleak issues
disappear.

Then I noticed that issue was in ordering. 

When build in kernel flow is like this :

OSS sequencer(alsa_seq_oss_init) -> System (snd_seq_system_client_init)

When build as modules flow is like this :

System(snd_seq_system_client_init) -> OSS sequencer(alsa_seq_oss_init)

So this fixes above kmemleak issues in my case, I hope it will be
helpful :

diff --git a/sound/core/seq/oss/seq_oss.c b/sound/core/seq/oss/seq_oss.c
index f25e3cc..3ddf2c2 100644
--- a/sound/core/seq/oss/seq_oss.c
+++ b/sound/core/seq/oss/seq_oss.c
@@ -116,7 +116,7 @@ static void __exit alsa_seq_oss_exit(void)
 	unregister_device();
 }
 
-module_init(alsa_seq_oss_init)
+late_initcall(alsa_seq_oss_init);
 module_exit(alsa_seq_oss_exit)
 
 /*

--
JSR


