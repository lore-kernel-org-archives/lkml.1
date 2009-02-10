Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbZBJNj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbZBJNj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 08:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbZBJNjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 08:39:20 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:49865 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbZBJNjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 08:39:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NIN7ou+VyuSoZPtKUHteT/y9rCOPlVCv0yVzF9EkNL9rIQlaU7ROd0Qlzc9hylC6O6
         QeZGVGVNkOavf6xrhtOeI5bisus/9hZtXz7T5nWQUvK31LIDs3LSXwz5Rj+n54pohQSN
         JSd2/53PPnuPaki3kR/Y54aPuIJI6gFsP7uco=
MIME-Version: 1.0
Date: Tue, 10 Feb 2009 14:39:17 +0100
Message-ID: <56e1b5710902100539l49a258b7g37b178efdaa8b4dc@mail.gmail.com>
Subject: Re: [PATCH]: Cleanup: Remove trivial gcc format string warnings when 
	compiling with -Wformat-security (part 2: cleanups)
From: Floris Kraak <randakar@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andreas Schwab <schwab@suse.de>, Mike Isely <isely@isely.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 2:26 PM, Floris Kraak <randakar@gmail.com> wrote:
> On Thu, Feb 5, 2009 at 3:41 PM, Floris Kraak <randakar@gmail.com> wrote:
>>
>> Here's the patch that I get when I blindly patch every single location
>> that emits this warning.
>>
>> If needed I can attempt to split this monster into 135 patches but
>> given my limited experience with the tools involved a little help on
>> how to go about creating such a series would be appreciated ;-)
>>
>
> Here's the first part of a split series of patches dealing with this.
> I will reply to this message with further patches in the series.
>

This patch contains cleaned up code; As in, changes to code that has
been restructured a bit to make the warning go away without
introducing extra "%s" arguments.


---
[PATCH]: Cleanup: Remove trivial gcc format string warnings when
compiling with -Wformat-security (part 2: cleanups)

When compiling the kernel with an allyesconfig and the gcc flags
-Wformat and -Wformat-security the build process emits ~150 warnings
along these lines:

init/main.c:557: warning: format not a string literal and no format arguments
init/initramfs.c:582: warning: format not a string literal and no
format arguments
arch/x86/kernel/dumpstack.c:115: warning: format not a string literal
and no format arguments
...

Many of these warnings are harmless - the format string is statically
set within the kernel itself and is known to not contain any format
qualifiers.
This patch fixes a number of cases by restructuring code a little to
avoid needing an extra "%s" argument.

Signed-off-by: Floris Kraak <randakar@gmail.com>
---
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 0b70813..99db356 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -591,14 +591,12 @@ find_codec_preset(struct hda_codec *codec)
 	mutex_unlock(&preset_mutex);

 	if (mod_requested < HDA_MODREQ_MAX_COUNT) {
-		char name[32];
 		if (!mod_requested)
-			snprintf(name, sizeof(name), "snd-hda-codec-id:%08x",
+			request_module("snd-hda-codec-id:%08x",
 				 codec->vendor_id);
 		else
-			snprintf(name, sizeof(name), "snd-hda-codec-id:%04x*",
+			request_module("snd-hda-codec-id:%04x*",
 				 (codec->vendor_id >> 16) & 0xffff);
-		request_module(name);
 		mod_requested++;
 		goto again;
 	}
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index e858268..c7ebb40 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1172,8 +1172,9 @@ u64 __init e820_hole_size(u64 start, u64 end)
 	return end - start - ((u64)ram << PAGE_SHIFT);
 }

-static void early_panic(char *msg)
+static inline void __init panic_memory_map_invalid(void)
 {
+	static const char msg[] = "Invalid user supplied memory map";
 	early_printk(msg);
 	panic(msg);
 }
@@ -1253,7 +1254,7 @@ void __init finish_e820_parsing(void)
 		int nr = e820.nr_map;

 		if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr) < 0)
-			early_panic("Invalid user supplied memory map");
+			panic_memory_map_invalid();
 		e820.nr_map = nr;

 		printk(KERN_INFO "user-defined physical RAM map:\n");
diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index bbdb311..5ededee 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -994,7 +994,7 @@ static int __init mkiss_init_driver(void)
 	printk(banner);

 	if ((status = tty_register_ldisc(N_AX25, &ax_ldisc)) != 0)
-		printk(msg_regfail);
+		printk(msg_regfail, status);

 	return status;
 }
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index c788bad..7472526 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1999,11 +1999,11 @@ static void b43_release_firmware(struct b43_wldev *dev)

 static void b43_print_fw_helptext(struct b43_wl *wl, bool error)
 {
-	const char *text;
+	static const char text[] =
+		"You must go to "
+		"http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
+		"and download the latest firmware (version 4).\n";

-	text = "You must go to "
-	       "http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
-	       "and download the latest firmware (version 4).\n";
 	if (error)
 		b43err(wl, text);
 	else
diff --git a/sound/core/sound.c b/sound/core/sound.c
index 7872a02..8e4237c 100644
--- a/sound/core/sound.c
+++ b/sound/core/sound.c
@@ -81,14 +81,14 @@ EXPORT_SYMBOL(snd_request_card);

 static void snd_request_other(int minor)
 {
-	char *str;
-
 	switch (minor) {
-	case SNDRV_MINOR_SEQUENCER:	str = "snd-seq";	break;
-	case SNDRV_MINOR_TIMER:		str = "snd-timer";	break;
-	default:			return;
+	case SNDRV_MINOR_SEQUENCER:
+		request_module("snd-seq");
+		break;
+	case SNDRV_MINOR_TIMER:
+		request_module("snd-timer");
+		break;
 	}
-	request_module(str);
 }

 #endif	/* modular kernel */
diff --git a/sound/drivers/opl3/opl3_seq.c b/sound/drivers/opl3/opl3_seq.c
index 2d33f53..7c0e0bc 100644
--- a/sound/drivers/opl3/opl3_seq.c
+++ b/sound/drivers/opl3/opl3_seq.c
@@ -220,6 +220,7 @@ static int snd_opl3_seq_new_device(struct
snd_seq_device *dev)
 	struct snd_opl3 *opl3;
 	int client, err;
 	char name[32];
+	static const char nameformat [] = "OPL%i FM synth";
 	int opl_ver;

 	opl3 = *(struct snd_opl3 **)SNDRV_SEQ_DEVICE_ARGPTR(dev);
@@ -232,10 +233,9 @@ static int snd_opl3_seq_new_device(struct
snd_seq_device *dev)

 	/* allocate new client */
 	opl_ver = (opl3->hardware & OPL3_HW_MASK) >> 8;
-	sprintf(name, "OPL%i FM synth", opl_ver);
 	client = opl3->seq_client =
 		snd_seq_create_kernel_client(opl3->card, opl3->seq_dev_num,
-					     name);
+					     nameformat, opl_ver);
 	if (client < 0)
 		return client;

@@ -253,6 +253,7 @@ static int snd_opl3_seq_new_device(struct
snd_seq_device *dev)
 	opl3->sys_timer_status = 0;

 #ifdef CONFIG_SND_SEQUENCER_OSS
+	sprintf(name, nameformat, opl_ver);
 	snd_opl3_init_seq_oss(opl3, name);
 #endif
 	return 0;
---

Regards,
Floris
---
"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."
  -- Ben Franklin

"The course of history shows that as a government grows, liberty
decreases."
  -- Thomas Jefferson
