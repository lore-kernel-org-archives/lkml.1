Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbZKHOKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbZKHOKX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 09:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbZKHOKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 09:10:23 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:59861 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbZKHOKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 09:10:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Nuq1tAkailLj81LGqo138q7PE6CMYyTt/xddAfM6QtdaCPsqZq2i3/QNEO/ZoBrUkB
         GzaNiNo4sRu6vrScM0FIpc6WWtnhnbd8QXIO7FYX5D+wv9dDyfeUxGwO5lWKYhZ1UKE/
         iOtv0L+qdN0Ck+7Qi1uN5gRxdopxwbn6F8wRE=
Date: Sun, 8 Nov 2009 15:10:17 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andreas Herrmann <herrmann.der.user@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/2] x86, amd-ucode: Check UCODE_MAGIC before loading
 the container file
Message-ID: <20091108141017.GA9595@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Andreas Herrmann <herrmann.der.user@googlemail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	Borislav Petkov <borislav.petkov@amd.com>
References: <20091029134552.GC30802@alberich.amd.com>
 <20091108120418.GV11372@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20091108120418.GV11372@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Sun, Nov 08, 2009 at 01:04:18PM +0100, Ingo Molnar wrote:
> hm, there's no changelog. How was it found,

code staring :)

> what's the significance,

required by design.

> do we want it for .32 - i suspect we want - but we need a better
> changelog for that.

Yes. How's that?

--
>From f41bced57e05c8adc0d2c13864b6323c191d45d2 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Thu, 29 Oct 2009 14:00:54 +0100
Subject: [PATCH] x86, amd-ucode: Check UCODE_MAGIC before loading the container file

When loading a microcode binary, we should check the microcode magic
value embedded in the image before continuing loading. The original
check got lost somehow so re-add it to the firmware requesting path.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/microcode_amd.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 366baa1..f4c538b 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -317,6 +317,12 @@ static enum ucode_state request_microcode_fw(int cpu, struct device *device)
 		return UCODE_NFOUND;
 	}
 
+	if (*(u32 *)firmware->data != UCODE_MAGIC) {
+		printk(KERN_ERR "microcode: invalid UCODE_MAGIC (0x%08x)\n",
+		       *(u32 *)firmware->data);
+		return UCODE_ERROR;
+	}
+
 	ret = generic_load_microcode(cpu, firmware->data, firmware->size);
 
 	release_firmware(firmware);
-- 
1.6.5


-- 
Regards/Gruss,
    Boris.
