Return-Path: <linux-kernel-owner+w=401wt.eu-S1757493AbXI2UK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbXI2UK0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 16:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbXI2UKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 16:10:19 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43478 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbXI2UKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 16:10:17 -0400
Date: Sat, 29 Sep 2007 22:11:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] Extending kbuild syntax
Message-ID: <20070929201145.GA20377@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Over the last few weeks I have pondered with the idea
to extend the current kbuild syntax.
The idea have existed for long but only recently I started
to think how to do this in a truely flexible manner.

Two areas are in need for a bit of attention to improve
current kbuild files in the kernel.

The first issue is the EXTRA_CFLAGS.
They are often conditionally assigned like in the following
example:

ifeq ($(DEBUG),y)
EXTRA_CFLAGS := -DDEBUG
endif

Introducing the following new variable could make this a oneliner:
ccflags-y

ccflags-$(DEBUG) := -DDEBUG

grep -r -C 1 -B 1 EXTRA_CFLAGS shows that the above is a 
very common pattern especially in drivers/


The kbuild variable is named 'ccflags' to match the CC prefix
for the C compiler used in non-verose output.
And then it does not clash with current cflags-y usage too.


The second is the more controversial suggestion.
In several Makefile we have simple if expression of the variants:
if ($(CONFIG_FOO),y)
  obj-$(CONFIG_BAR) += fubar.o
endif

The pattern varies over this theme.
The suggestion here is to introduce a few helpers:

obj-y-if-$(CONFIG_FOO) += fubar.o
This one shall read:
if $(CONFIG_FOO) is y or m then set += to obj-y

In several cases we will need it to be more complicated like the this:
obj-y-ify-$(CONFIG_FOO) += fubar.o
This one shall read:
if $(CONFIG_FOO) is y (thats the ify thing) then += to obj-y

And we can mix it like the following:
obj-$(CONFIG_BAR)-ify-$(CONFIG_FOO) += fubar.o
This one shall read:
if $(CONFIG_FOO) equal y then += to obj-$(CONFIG_BAR)


The full list of new variables are (for obj-y):
obj-y-if-y
obj-y-if-m

obj-y-ify-y
obj-y-ifm-m

obj-y-ifn-

And similar for obj-m:
obj-m-if-y
obj-m-if-m

obj-m-ify-y
obj-m-ifm-m

obj-m-ifn-

The 'y' and 'm' can be replaced by $(CONFIG_FOO) but the one right
to the if are not supposed to be replaced.


To better express how to use it I have tried to update a few Makefiles
to use the new syntax. See below.

On MAJOR drawback is the linking order.
I have no way to keep the link order if the new syntax are sued. The
.o files will either be put before .o files specified with obj-y or obj-m or
after the same.

For some places this does not matter but for other places (fs/Makefile)
I will expect it to matter a lot.

Comments?
Is this just to magic for bare humans to grasp.
Or mabe the linking order is so important that we do not want it?

PS. The coming x86 merge triggered this. I would like to make the
Makefiles readable and the above can help here.

	Sam



 fs/Makefile             |   10 +++-------
 kernel/Makefile         |    8 ++------
 mm/Makefile             |    7 +++----
 sound/Makefile          |    4 +---
 sound/core/seq/Makefile |    9 +++------
 sound/i2c/Makefile      |    4 +---
 sound/isa/sb/Makefile   |    6 ++----
 sound/oss/Makefile      |    4 +---
 8 files changed, 16 insertions(+), 36 deletions(-)


diff --git a/fs/Makefile b/fs/Makefile
index 720c29d..1b0a48e 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -13,11 +13,8 @@ obj-y :=	open.o read_write.o file_table.o super.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
 		stack.o
 
-ifeq ($(CONFIG_BLOCK),y)
-obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
-else
-obj-y +=	no-block.o
-endif
+obj-y-ify-$(CONFIG_BLOCK) := buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
+obj-y-ifn-$(CONFIG_BLOCK) := no-block.o
 
 obj-$(CONFIG_INOTIFY)		+= inotify.o
 obj-$(CONFIG_INOTIFY_USER)	+= inotify_user.o
@@ -28,8 +25,7 @@ obj-$(CONFIG_TIMERFD)		+= timerfd.o
 obj-$(CONFIG_EVENTFD)		+= eventfd.o
 obj-$(CONFIG_COMPAT)		+= compat.o compat_ioctl.o
 
-nfsd-$(CONFIG_NFSD)		:= nfsctl.o
-obj-y				+= $(nfsd-y) $(nfsd-m)
+obj-y-if-$(CONFIG_NFSD)		+= nfsctl.o
 
 obj-$(CONFIG_BINFMT_AOUT)	+= binfmt_aout.o
 obj-$(CONFIG_BINFMT_EM86)	+= binfmt_em86.o
diff --git a/kernel/Makefile b/kernel/Makefile
index 2a99983..5d7706e 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -15,13 +15,9 @@ obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
 obj-$(CONFIG_DEBUG_MUTEXES) += mutex-debug.o
 obj-$(CONFIG_LOCKDEP) += lockdep.o
-ifeq ($(CONFIG_PROC_FS),y)
-obj-$(CONFIG_LOCKDEP) += lockdep_proc.o
-endif
+obj-$(CONFIG_LOCKDEP)-if-$(CONFIG_PROC_FS) += lockdep_proc.o
 obj-$(CONFIG_FUTEX) += futex.o
-ifeq ($(CONFIG_COMPAT),y)
-obj-$(CONFIG_FUTEX) += futex_compat.o
-endif
+obj-$(CONFIG_FUTEX)-if-$(CONFIG_COMPAT) += futex_compat.o
 obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
diff --git a/mm/Makefile b/mm/Makefile
index 245e33a..3a55991 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -2,16 +2,15 @@
 # Makefile for the linux memory manager.
 #
 
-mmu-y			:= nommu.o
-mmu-$(CONFIG_MMU)	:= fremap.o highmem.o madvise.o memory.o mincore.o \
+obj-y-ifn-$(CONFIG_MMU) := nommu.o
+obj-$(CONFIG_MMU)	:= fremap.o highmem.o madvise.o memory.o mincore.o \
 			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
 			   vmalloc.o
 
 obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
 			   page_alloc.o page-writeback.o pdflush.o \
 			   readahead.o swap.o truncate.o vmscan.o \
-			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
-			   $(mmu-y)
+			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o
 
 obj-$(CONFIG_BOUNCE)	+= bounce.o
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
diff --git a/sound/Makefile b/sound/Makefile
index 3ead922..cc2bba0 100644
--- a/sound/Makefile
+++ b/sound/Makefile
@@ -11,8 +11,6 @@ obj-$(CONFIG_SND_AOA) += aoa/
 # This one must be compilable even if sound is configured out
 obj-$(CONFIG_AC97_BUS) += ac97_bus.o
 
-ifeq ($(CONFIG_SND),y)
-  obj-y += last.o
-endif
+objy-ify-$(CONFIG_SND) += last.o
 
 soundcore-objs  := sound_core.o
diff --git a/sound/core/seq/Makefile b/sound/core/seq/Makefile
index 402e2b4..1e676d9 100644
--- a/sound/core/seq/Makefile
+++ b/sound/core/seq/Makefile
@@ -4,9 +4,7 @@
 #
 
 obj-$(CONFIG_SND) += instr/
-ifeq ($(CONFIG_SND_SEQUENCER_OSS),y)
-  obj-$(CONFIG_SND_SEQUENCER) += oss/
-endif
+obj-$(CONFIG_SND_SEQUENCER)-ify-$(CONFIG_SND_SEQUENCER_OSS) += oss/
 
 snd-seq-device-objs := seq_device.o
 snd-seq-objs := seq.o seq_lock.o seq_clientmgr.o seq_memory.o seq_queue.o \
@@ -28,9 +26,8 @@ snd-seq-virmidi-objs := seq_virmidi.o
 sequencer = $(if $(subst y,,$(CONFIG_SND_SEQUENCER)),$(if $(1),m),$(if $(CONFIG_SND_SEQUENCER),$(1)))
 
 obj-$(CONFIG_SND_SEQUENCER) += snd-seq.o snd-seq-device.o
-ifeq ($(CONFIG_SND_SEQUENCER_OSS),y)
-obj-$(CONFIG_SND_SEQUENCER) += snd-seq-midi-event.o
-endif
+
+obj-$(CONFIG_SND_SEQUENCER)-ify-$(CONFIG_SND_SEQUENCER_OSS) += snd-seq-midi-event.o
 obj-$(CONFIG_SND_SEQ_DUMMY) += snd-seq-dummy.o
 
 # Toplevel Module Dependency
diff --git a/sound/i2c/Makefile b/sound/i2c/Makefile
index 45902d4..521708f 100644
--- a/sound/i2c/Makefile
+++ b/sound/i2c/Makefile
@@ -7,9 +7,7 @@ snd-i2c-objs := i2c.o
 snd-cs8427-objs := cs8427.o
 snd-tea6330t-objs := tea6330t.o
 
-ifeq ($(subst m,y,$(CONFIG_L3)),y)
-  obj-$(CONFIG_L3) += l3/
-endif
+obj-$(CONFIG_L3)-ifm-$(CONFIG_L3) += l3/
 
 obj-$(CONFIG_SND) += other/
 
diff --git a/sound/isa/sb/Makefile b/sound/isa/sb/Makefile
index 556e669..4681c46 100644
--- a/sound/isa/sb/Makefile
+++ b/sound/isa/sb/Makefile
@@ -29,10 +29,8 @@ obj-$(CONFIG_SND_SB8) += snd-sb8.o
 obj-$(CONFIG_SND_SB16) += snd-sb16.o
 obj-$(CONFIG_SND_SBAWE) += snd-sbawe.o
 obj-$(CONFIG_SND_ES968) += snd-es968.o
-ifeq ($(CONFIG_SND_SB16_CSP),y)
-  obj-$(CONFIG_SND_SB16) += snd-sb16-csp.o
-  obj-$(CONFIG_SND_SBAWE) += snd-sb16-csp.o
-endif
+obj-$(CONFIG_SND_SB16)-ify-$(CONFIG_SND_SB16_CSP)  += snd-sb16-csp.o
+obj-$(CONFIG_SND_SBAWE)-ify-$(CONFIG_SND_SB16_CSP) += snd-sb16-csp.o
 obj-$(call sequencer,$(CONFIG_SND_SBAWE)) += snd-emu8000-synth.o
 
 obj-m := $(sort $(obj-m))
diff --git a/sound/oss/Makefile b/sound/oss/Makefile
index 1200670..de54e00 100644
--- a/sound/oss/Makefile
+++ b/sound/oss/Makefile
@@ -29,9 +29,7 @@ obj-$(CONFIG_SOUND_VIDC)	+= vidc_mod.o
 obj-$(CONFIG_SOUND_WAVEARTIST)	+= waveartist.o
 
 obj-$(CONFIG_SOUND_VIA82CXXX)	+= via82cxxx_audio.o ac97_codec.o
-ifeq ($(CONFIG_MIDI_VIA82CXXX),y)
-  obj-$(CONFIG_SOUND_VIA82CXXX) += sound.o uart401.o
-endif
+obj-$(CONFIG_SOUND_VIA82CXXX)-ify-$(CONFIG_MIDI_VIA82CXXX) += sound.o uart401.o
 obj-$(CONFIG_SOUND_MSNDCLAS)	+= msnd.o msnd_classic.o
 obj-$(CONFIG_SOUND_MSNDPIN)	+= msnd.o msnd_pinnacle.o
 obj-$(CONFIG_SOUND_VWSND)	+= vwsnd.o

