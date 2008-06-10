Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbYFJBLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbYFJBLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 21:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbYFJBLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 21:11:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:39911 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015AbYFJBLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 21:11:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=jsaJTz0+70QRuzHEBibHb/dIRoO97PODB5mZClPHBEhDzheh5zpG/9YSA6Njv273V4
         gQExqZ2lcfwDkNergqlIiXhl5OaA3yX85o77uFCbGbyR+FOuyXVKN90MYLkPfuKSOsOR
         ZMfOMWseMfxNnAbsXDCfqIrIeufW0qoIKvACw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86: make generic arch support NUMAQ - fix #2
Date: Mon, 9 Jun 2008 18:11:36 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806050309.11197.yhlu.kernel@gmail.com> <200806070031.35322.yhlu.kernel@gmail.com> <200806081831.54869.yhlu.kernel@gmail.com>
In-Reply-To: <200806081831.54869.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806091811.36836.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


do not need reserve if it early scan smp table

we are checking mptable early for numaq, so don't need to reserve_bootmem for
it.  bootmem is not there yet.

do the samething like 64 bit.

find it on 64g above system from 64 bit kernel kexec to 32 bit kernel with
numaq support

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 6ae6090..7ac1b68 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -853,9 +853,13 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 			smp_found_config = 1;
 #endif
 			mpf_found = mpf;
-#ifdef CONFIG_X86_32
+
 			printk(KERN_INFO "found SMP MP-table at [%p] %08lx\n",
 			       mpf, virt_to_phys(mpf));
+
+			if (!reserve)
+				return 1;
+#ifdef CONFIG_X86_32
 			reserve_bootmem(virt_to_phys(mpf), PAGE_SIZE,
 					BOOTMEM_DEFAULT);
 			if (mpf->mpf_physptr) {
@@ -877,9 +881,6 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 			}
 
 #else
-			if (!reserve)
-				return 1;
-
 			reserve_bootmem_generic(virt_to_phys(mpf), PAGE_SIZE,
 				BOOTMEM_DEFAULT);
 			if (mpf->mpf_physptr)
