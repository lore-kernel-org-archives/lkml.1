Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbXLSKsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbXLSKsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 05:48:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbXLSKsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 05:48:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60745 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbXLSKsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 05:48:42 -0500
Date: Wed, 19 Dec 2007 11:48:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, ak@suse.de,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Fix DMI out of memory problems
Message-ID: <20071219104823.GI3521@elte.hu>
References: <Pine.LNX.4.64.0712181848430.3663@mini.warudkars.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712181848430.3663@mini.warudkars.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Parag Warudkar <parag.warudkar@gmail.com> wrote:

> People with HP Desktops (including me) encounter couple of DMI errors 
> during boot - dmi_save_oem_strings_devices: out of memory and 
> dmi_string: out of memory.
>
> On some HP desktops the DMI data include OEM strings (type 11) out of 
> which only few are meaningful and most other are empty. DMI code 
> religiously creates copies of these 27 strings (65 bytes each in my 
> case) and goes OOM in dmi_string().
>
> If DMI_MAX_DATA is bumped up a little then it goes and fails in 
> dmi_save_oem_strings while allocating dmi_devices of sizeof(struct 
> dmi_device) corresponding to these strings.
>
> On x86_64 since we cannot use alloc_bootmem this early, the code uses 
> a static array of 2048 bytes (DMI_MAX_DATA) for allocating the memory 
> DMI needs. It does not survive the creation of empty strings and 
> devices.
>
> Fix this by detecting and not newly allocating empty strings and 
> instead using a one statically defined dmi_empty_string.
>
> Also do not create a new struct dmi_device for each empty string - use 
> one statically define dmi_device with .name=dmi_empty_string and add 
> that to the dmi_devices list.
>
> On x64 this should stop the OOM with same current size of DMI_MAX_DATA 
> and on x86 this should save a good amount of (27*65 bytes + 
> 27*sizeof(struct dmi_device) bootmem.
>
> Compile and boot tested on both x86 and x86_64.

thanks, i've applied your patch to x86.git. (tentative merge target of 
2.6.25)

[ note: i had to manually fix up your patch because your email client 
  added an extra space to every diff line - see 
  Documentation/email-clients.txt on how to avoid that. I also did a few 
  small cleanups - please check patches via scripts/checkpatch.pl. I've 
  attached the merged patch below. ]

What's the worst-case symptom you get with that bug - any failure type 
thing - or only annoying boot messages? Could you perhaps post the diff 
-u between the unpatched and patched kernel's full dmesg/bootlog? Are 
there any specific DMI quirks that are skipped due to us wasting DMI 
space on empty strings?

Also, shouldnt we perhaps increase DMI_MAX_DATA from 2K to 4K?

	Ingo

--------------->
Subject: x86: fix DMI out of memory problems
From: Parag Warudkar <parag.warudkar@gmail.com>

People with HP Desktops (including me) encounter couple of DMI errors
during boot - dmi_save_oem_strings_devices: out of memory and
dmi_string: out of memory.

On some HP desktops the DMI data include OEM strings (type 11) out of
which only few are meaningful and most other are empty. DMI code
religiously creates copies of these 27 strings (65 bytes each in my
case) and goes OOM in dmi_string().

If DMI_MAX_DATA is bumped up a little then it goes and fails in
dmi_save_oem_strings while allocating dmi_devices of sizeof(struct
dmi_device) corresponding to these strings.

On x86_64 since we cannot use alloc_bootmem this early, the code uses a
static array of 2048 bytes (DMI_MAX_DATA) for allocating the memory DMI
needs. It does not survive the creation of empty strings and devices.

Fix this by detecting and not newly allocating empty strings and instead
using a one statically defined dmi_empty_string.

Also do not create a new struct dmi_device for each empty string - use
one statically define dmi_device with .name=dmi_empty_string and add
that to the dmi_devices list.

On x64 this should stop the OOM with same current size of DMI_MAX_DATA
and on x86 this should save a good amount of (27*65 bytes +
27*sizeof(struct dmi_device) bootmem.

Compile and boot tested on both 32-bit and 64-bit x86.

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/firmware/dmi_scan.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

Index: linux-x86.q/drivers/firmware/dmi_scan.c
===================================================================
--- linux-x86.q.orig/drivers/firmware/dmi_scan.c
+++ linux-x86.q/drivers/firmware/dmi_scan.c
@@ -8,6 +8,8 @@
 #include <linux/slab.h>
 #include <asm/dmi.h>
 
+static char dmi_empty_string[] = "        ";
+
 static char * __init dmi_string(const struct dmi_header *dm, u8 s)
 {
 	const u8 *bp = ((u8 *) dm) + dm->length;
@@ -21,11 +23,16 @@ static char * __init dmi_string(const st
 		}
 
 		if (*bp != 0) {
-			str = dmi_alloc(strlen(bp) + 1);
+			size_t len = strlen(bp)+1;
+			size_t cmp_len = len > 8 ? 8 : len;
+
+			if (!memcmp(bp, dmi_empty_string, cmp_len))
+				return dmi_empty_string;
+			str = dmi_alloc(len);
 			if (str != NULL)
 				strcpy(str, bp);
 			else
-				printk(KERN_ERR "dmi_string: out of memory.\n");
+				printk(KERN_ERR "dmi_string: cannot allocate %Zu bytes.\n", len);
 		}
 	}
 
@@ -175,12 +182,23 @@ static void __init dmi_save_devices(cons
 	}
 }
 
+static struct dmi_device empty_oem_string_dev = {
+	.name = dmi_empty_string,
+};
+
 static void __init dmi_save_oem_strings_devices(const struct dmi_header *dm)
 {
 	int i, count = *(u8 *)(dm + 1);
 	struct dmi_device *dev;
 
 	for (i = 1; i <= count; i++) {
+		char *devname = dmi_string(dm, i);
+
+		if (!strcmp(devname, dmi_empty_string)) {
+			list_add(&empty_oem_string_dev.list, &dmi_devices);
+			continue;
+		}
+
 		dev = dmi_alloc(sizeof(*dev));
 		if (!dev) {
 			printk(KERN_ERR
@@ -189,7 +207,7 @@ static void __init dmi_save_oem_strings_
 		}
 
 		dev->type = DMI_DEV_TYPE_OEM_STRING;
-		dev->name = dmi_string(dm, i);
+		dev->name = devname;
 		dev->device_data = NULL;
 
 		list_add(&dev->list, &dmi_devices);
