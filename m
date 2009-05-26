Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbZEZPH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbZEZPH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 11:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZEZPHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 11:07:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43298 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbZEZPHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 11:07:52 -0400
Date: Tue, 26 May 2009 17:07:52 +0200
From: Michal Marek <mmarek@suse.cz>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: clean up the logic for building sequencer modules
Message-ID: <20090526150752.GA23158@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of mangling the CONFIG_* variables in the makefiles over and
over, set a few helper variables in Kconfig.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 sound/core/Kconfig          |    2 ++
 sound/core/seq/Kconfig      |   16 ++++++++++++++++
 sound/core/seq/Makefile     |   18 +++++-------------
 sound/drivers/opl3/Makefile |   10 +---------
 sound/drivers/opl4/Makefile |   10 +---------
 sound/isa/sb/Makefile       |   10 +---------
 sound/pci/emu10k1/Makefile  |   10 +---------
 sound/synth/Makefile        |   12 ++----------
 sound/synth/emux/Makefile   |   12 ++----------
 9 files changed, 31 insertions(+), 69 deletions(-)
 create mode 100644 sound/core/seq/Kconfig

diff --git a/sound/core/Kconfig b/sound/core/Kconfig
index 7bbdda0..6061fb5 100644
--- a/sound/core/Kconfig
+++ b/sound/core/Kconfig
@@ -205,3 +205,5 @@ config SND_PCM_XRUN_DEBUG
 
 config SND_VMASTER
 	bool
+
+source "sound/core/seq/Kconfig"
diff --git a/sound/core/seq/Kconfig b/sound/core/seq/Kconfig
new file mode 100644
index 0000000..b851fd8
--- /dev/null
+++ b/sound/core/seq/Kconfig
@@ -0,0 +1,16 @@
+# define SND_XXX_SEQ to min(SND_SEQUENCER,SND_XXX)
+
+config SND_RAWMIDI_SEQ
+	def_tristate SND_SEQUENCER && SND_RAWMIDI
+
+config SND_OPL3_LIB_SEQ
+	def_tristate SND_SEQUENCER && SND_OPL3_LIB
+
+config SND_OPL4_LIB_SEQ
+	def_tristate SND_SEQUENCER && SND_OPL4_LIB
+
+config SND_SBAWE_SEQ
+	def_tristate SND_SEQUENCER && SND_SBAWE
+
+config SND_EMU10K1_SEQ
+	def_tristate SND_SEQUENCER && SND_EMU10K1
diff --git a/sound/core/seq/Makefile b/sound/core/seq/Makefile
index 0695937..1bcb360 100644
--- a/sound/core/seq/Makefile
+++ b/sound/core/seq/Makefile
@@ -17,14 +17,6 @@ snd-seq-midi-event-objs := seq_midi_event.o
 snd-seq-dummy-objs := seq_dummy.o
 snd-seq-virmidi-objs := seq_virmidi.o
 
-#
-# this function returns:
-#   "m" - CONFIG_SND_SEQUENCER is m
-#   <empty string> - CONFIG_SND_SEQUENCER is undefined
-#   otherwise parameter #1 value
-#
-sequencer = $(if $(subst y,,$(CONFIG_SND_SEQUENCER)),$(if $(1),m),$(if $(CONFIG_SND_SEQUENCER),$(1)))
-
 obj-$(CONFIG_SND_SEQUENCER) += snd-seq.o snd-seq-device.o
 ifeq ($(CONFIG_SND_SEQUENCER_OSS),y)
 obj-$(CONFIG_SND_SEQUENCER) += snd-seq-midi-event.o
@@ -33,8 +25,8 @@ obj-$(CONFIG_SND_SEQ_DUMMY) += snd-seq-dummy.o
 
 # Toplevel Module Dependency
 obj-$(CONFIG_SND_VIRMIDI) += snd-seq-virmidi.o snd-seq-midi-event.o
-obj-$(call sequencer,$(CONFIG_SND_RAWMIDI)) += snd-seq-midi.o snd-seq-midi-event.o
-obj-$(call sequencer,$(CONFIG_SND_OPL3_LIB)) += snd-seq-midi-event.o snd-seq-midi-emul.o
-obj-$(call sequencer,$(CONFIG_SND_OPL4_LIB)) += snd-seq-midi-event.o snd-seq-midi-emul.o
-obj-$(call sequencer,$(CONFIG_SND_SBAWE)) += snd-seq-midi-emul.o snd-seq-virmidi.o
-obj-$(call sequencer,$(CONFIG_SND_EMU10K1)) += snd-seq-midi-emul.o snd-seq-virmidi.o
+obj-$(CONFIG_SND_RAWMIDI_SEQ) += snd-seq-midi.o snd-seq-midi-event.o
+obj-$(CONFIG_SND_OPL3_LIB_SEQ) += snd-seq-midi-event.o snd-seq-midi-emul.o
+obj-$(CONFIG_SND_OPL4_LIB_SEQ) += snd-seq-midi-event.o snd-seq-midi-emul.o
+obj-$(CONFIG_SND_SBAWE_SEQ) += snd-seq-midi-emul.o snd-seq-virmidi.o
+obj-$(CONFIG_SND_EMU10K1_SEQ) += snd-seq-midi-emul.o snd-seq-virmidi.o
diff --git a/sound/drivers/opl3/Makefile b/sound/drivers/opl3/Makefile
index 19767a6..7f2c2a1 100644
--- a/sound/drivers/opl3/Makefile
+++ b/sound/drivers/opl3/Makefile
@@ -7,14 +7,6 @@ snd-opl3-lib-objs := opl3_lib.o opl3_synth.o
 snd-opl3-synth-y := opl3_seq.o opl3_midi.o opl3_drums.o
 snd-opl3-synth-$(CONFIG_SND_SEQUENCER_OSS) += opl3_oss.o
 
-#
-# this function returns:
-#   "m" - CONFIG_SND_SEQUENCER is m
-#   <empty string> - CONFIG_SND_SEQUENCER is undefined
-#   otherwise parameter #1 value
-#
-sequencer = $(if $(subst y,,$(CONFIG_SND_SEQUENCER)),$(if $(1),m),$(if $(CONFIG_SND_SEQUENCER),$(1)))
-
 obj-$(CONFIG_SND_OPL3_LIB) += snd-opl3-lib.o
 obj-$(CONFIG_SND_OPL4_LIB) += snd-opl3-lib.o
-obj-$(call sequencer,$(CONFIG_SND_OPL3_LIB)) += snd-opl3-synth.o
+obj-$(CONFIG_SND_OPL3_LIB_SEQ) += snd-opl3-synth.o
diff --git a/sound/drivers/opl4/Makefile b/sound/drivers/opl4/Makefile
index d178b39..b94009b 100644
--- a/sound/drivers/opl4/Makefile
+++ b/sound/drivers/opl4/Makefile
@@ -6,13 +6,5 @@
 snd-opl4-lib-objs := opl4_lib.o opl4_mixer.o opl4_proc.o
 snd-opl4-synth-objs := opl4_seq.o opl4_synth.o yrw801.o
 
-#
-# this function returns:
-#   "m" - CONFIG_SND_SEQUENCER is m
-#   <empty string> - CONFIG_SND_SEQUENCER is undefined
-#   otherwise parameter #1 value
-#
-sequencer = $(if $(subst y,,$(CONFIG_SND_SEQUENCER)),$(if $(1),m),$(if $(CONFIG_SND_SEQUENCER),$(1)))
-
 obj-$(CONFIG_SND_OPL4_LIB) += snd-opl4-lib.o
-obj-$(call sequencer,$(CONFIG_SND_OPL4_LIB)) += snd-opl4-synth.o
+obj-$(CONFIG_SND_OPL4_LIB_SEQ) += snd-opl4-synth.o
diff --git a/sound/isa/sb/Makefile b/sound/isa/sb/Makefile
index 1098a56..faeffce 100644
--- a/sound/isa/sb/Makefile
+++ b/sound/isa/sb/Makefile
@@ -13,14 +13,6 @@ snd-sbawe-objs := sbawe.o emu8000.o
 snd-emu8000-synth-objs := emu8000_synth.o emu8000_callback.o emu8000_patch.o emu8000_pcm.o
 snd-es968-objs := es968.o
 
-#
-# this function returns:
-#   "m" - CONFIG_SND_SEQUENCER is m
-#   <empty string> - CONFIG_SND_SEQUENCER is undefined
-#   otherwise parameter #1 value
-#
-sequencer = $(if $(subst y,,$(CONFIG_SND_SEQUENCER)),$(if $(1),m),$(if $(CONFIG_SND_SEQUENCER),$(1)))
-
 # Toplevel Module Dependency
 obj-$(CONFIG_SND_SB_COMMON) += snd-sb-common.o
 obj-$(CONFIG_SND_SB16_DSP) += snd-sb16-dsp.o
@@ -33,4 +25,4 @@ ifeq ($(CONFIG_SND_SB16_CSP),y)
   obj-$(CONFIG_SND_SB16) += snd-sb16-csp.o
   obj-$(CONFIG_SND_SBAWE) += snd-sb16-csp.o
 endif
-obj-$(call sequencer,$(CONFIG_SND_SBAWE)) += snd-emu8000-synth.o
+obj-$(CONFIG_SND_SBAWE_SEQ) += snd-emu8000-synth.o
diff --git a/sound/pci/emu10k1/Makefile b/sound/pci/emu10k1/Makefile
index cf2d563..fc5591e 100644
--- a/sound/pci/emu10k1/Makefile
+++ b/sound/pci/emu10k1/Makefile
@@ -9,15 +9,7 @@ snd-emu10k1-objs := emu10k1.o emu10k1_main.o \
 snd-emu10k1-synth-objs := emu10k1_synth.o emu10k1_callback.o emu10k1_patch.o
 snd-emu10k1x-objs := emu10k1x.o
 
-#
-# this function returns:
-#   "m" - CONFIG_SND_SEQUENCER is m
-#   <empty string> - CONFIG_SND_SEQUENCER is undefined
-#   otherwise parameter #1 value
-#
-sequencer = $(if $(subst y,,$(CONFIG_SND_SEQUENCER)),$(if $(1),m),$(if $(CONFIG_SND_SEQUENCER),$(1)))
-
 # Toplevel Module Dependency
 obj-$(CONFIG_SND_EMU10K1) += snd-emu10k1.o
-obj-$(call sequencer,$(CONFIG_SND_EMU10K1)) += snd-emu10k1-synth.o
+obj-$(CONFIG_SND_EMU10K1_SEQ) += snd-emu10k1-synth.o
 obj-$(CONFIG_SND_EMU10K1X) += snd-emu10k1x.o
diff --git a/sound/synth/Makefile b/sound/synth/Makefile
index e99fd76..11eb06a 100644
--- a/sound/synth/Makefile
+++ b/sound/synth/Makefile
@@ -5,16 +5,8 @@
 
 snd-util-mem-objs := util_mem.o
 
-#
-# this function returns:
-#   "m" - CONFIG_SND_SEQUENCER is m
-#   <empty string> - CONFIG_SND_SEQUENCER is undefined
-#   otherwise parameter #1 value
-#
-sequencer = $(if $(subst y,,$(CONFIG_SND_SEQUENCER)),$(if $(1),m),$(if $(CONFIG_SND_SEQUENCER),$(1)))
-
 # Toplevel Module Dependency
 obj-$(CONFIG_SND_EMU10K1) += snd-util-mem.o
 obj-$(CONFIG_SND_TRIDENT) += snd-util-mem.o
-obj-$(call sequencer,$(CONFIG_SND_SBAWE)) += snd-util-mem.o
-obj-$(call sequencer,$(CONFIG_SND)) += emux/
+obj-$(CONFIG_SND_SBAWE_SEQ) += snd-util-mem.o
+obj-$(CONFIG_SND_SEQUENCER) += emux/
diff --git a/sound/synth/emux/Makefile b/sound/synth/emux/Makefile
index b690352..328594e 100644
--- a/sound/synth/emux/Makefile
+++ b/sound/synth/emux/Makefile
@@ -7,14 +7,6 @@ snd-emux-synth-objs := emux.o emux_synth.o emux_seq.o emux_nrpn.o \
 		       emux_effect.o emux_proc.o emux_hwdep.o soundfont.o \
 		       $(if $(CONFIG_SND_SEQUENCER_OSS),emux_oss.o)
 
-#
-# this function returns:
-#   "m" - CONFIG_SND_SEQUENCER is m
-#   <empty string> - CONFIG_SND_SEQUENCER is undefined
-#   otherwise parameter #1 value
-#
-sequencer = $(if $(subst y,,$(CONFIG_SND_SEQUENCER)),$(if $(1),m),$(if $(CONFIG_SND_SEQUENCER),$(1)))
-
 # Toplevel Module Dependencies
-obj-$(call sequencer,$(CONFIG_SND_SBAWE)) += snd-emux-synth.o
-obj-$(call sequencer,$(CONFIG_SND_EMU10K1)) += snd-emux-synth.o
+obj-$(CONFIG_SND_SBAWE_SEQ) += snd-emux-synth.o
+obj-$(CONFIG_SND_EMU10K1_SEQ) += snd-emux-synth.o
-- 
1.6.3
