Return-Path: <linux-kernel-owner+w=401wt.eu-S1757467AbYEXPeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbYEXPeK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 11:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYEXPd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 11:33:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50177 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYEXPd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 11:33:56 -0400
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Takashi Iwai <tiwai@suse.de>
In-Reply-To: <1211642706.31212.85.camel@shinybook.infradead.org>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <1211550374.28967.10.camel@pmac.infradead.org>
	 <20080523164108.GA31545@uranus.ravnborg.org>
	 <1211640377.540.14.camel@pmac.infradead.org>
	 <20080524152214.GA12582@uranus.ravnborg.org>
	 <1211642706.31212.85.camel@shinybook.infradead.org>
Content-Type: text/plain
Date: Sat, 24 May 2008 16:34:05 +0100
Message-Id: <1211643245.31212.88.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-05-24 at 16:25 +0100, David Woodhouse wrote:
> Playing with it now. I fixed the mkdir thing by including $(objtree)
> in the target.

Here's what I have (on top of the git tree) now. I just need to sort out
the clean/mrproper behaviour -- and possibly should rename the korg
firmware to firmware/korg/k1212.c_shipped?

commit 728aa4212690701823ce3dcf22816f3953923530
Author: David Woodhouse <dwmw2@infradead.org>
Date:   Sat May 24 11:56:32 2008 +0100

    firmware: move firmware files into firmware/
    
    Signed-off-by: David Woodhouse <dwmw2@infradead.org>

diff --git a/firmware/Makefile b/firmware/Makefile
index f6b0c3c..62c2825 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -2,10 +2,15 @@
 # kbuild file for firmware/
 #
 
+firmware-$(CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL) += korg/k1212
+
 firmware_bins := $(subst ",,$(CONFIG_BUILTIN_FIRMWARE))
-firmware_objs := $(patsubst %,%.o, $(firmware_bins))
-firmware_srcs := $(patsubst %,$(obj)/%.c, $(firmware_bins))
+firmware_srcs_generated := $(patsubst %,$(obj)/%.c, $(firmware_bins))
+firmware_objs := $(patsubst %,%.o, $(firmware_bins) $(firmware-y)) 
+firmware_dirs := $(patsubst %,$(objtree)/$(obj)/%,$(dir $(firmware_objs)))
 
+quiet_cmd_mkdir = MKDIR   $@
+      cmd_mkdir = mkdir -p $@
 
 quiet_cmd_fwbin = MK_FW   $@
       cmd_fwbin = echo '/* File automatically generated */' > $@ ;	\
@@ -16,9 +21,14 @@ quiet_cmd_fwbin = MK_FW   $@
 		  echo '};' >> $@ ;					\
 		  echo 'DECLARE_BUILTIN_FIRMWARE("$(patsubst firmware/%.c,%,$@)",fw);' >> $@
 
-$(firmware_srcs): $(obj)/%.c: $(srctree)/$(obj)/%
+$(firmware_srcs_generated): $(obj)/%.c: $(srctree)/$(obj)/%
 	$(call cmd,fwbin)
 
+$(firmware_dirs):
+	$(call cmd,mkdir)
+
+$(patsubst %,$(obj)/%,$(firmware_objs)): $(firmware_dirs)
+
 obj-y := $(firmware_objs)
 
-targets := $(firmware_objs)
+targets := $(firmware_objs) $(patsubst $(obj)/%,%, $(firmware_srcs_generated))
diff --git a/sound/pci/korg1212/korg1212-firmware.c b/firmware/korg/k1212.c
similarity index 100%
rename from sound/pci/korg1212/korg1212-firmware.c
rename to firmware/korg/k1212.c
diff --git a/sound/pci/korg1212/Makefile b/sound/pci/korg1212/Makefile
index 7a5ebdf..f11ce1b 100644
--- a/sound/pci/korg1212/Makefile
+++ b/sound/pci/korg1212/Makefile
@@ -7,4 +7,3 @@ snd-korg1212-objs := korg1212.o
 
 # Toplevel Module Dependency
 obj-$(CONFIG_SND_KORG1212) += snd-korg1212.o
-obj-$(CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL) += korg1212-firmware.o


-- 
dwmw2

