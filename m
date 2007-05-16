Return-Path: <linux-kernel-owner+w=401wt.eu-S1762744AbXEPRPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762744AbXEPRPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758678AbXEPRPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:15:35 -0400
Received: from twin.jikos.cz ([213.151.79.26]:55204 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbXEPRPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:15:34 -0400
Date: Wed, 16 May 2007 19:14:39 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Jan Kratochvil <honza@jikos.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] PIE randomization
In-Reply-To: <Pine.LNX.4.64.0705120048230.11493@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0705161851120.25986@twin.jikos.cz>
References: <alpine.LRH.0.98.0705111338230.22353@twin.jikos.cz>
 <20070511125629.3df919cf.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705112211440.16923@twin.jikos.cz>
 <20070511133651.63f8a14d.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705120048230.11493@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 May 2007, Jiri Kosina wrote:

> However, I seem to get "soft" hang on boot with this patch, 
> approximately at the time the init should be executed. The system is not 
> completely stuck - interrupts are delivered, keyboard is working, 
> alt-sysrq-t dumps proper output, but userspace doesn't seem to get 
> started. This happens on i386, didn't try on other archs.

Hi Jan,

I finally had time to look at it a little bit - I think you omitted 
porting of proper handling of *interp_load_addr == 0, which made my box 
hang. The patch below, when applied on top of what you have sent, makes it 
work again and also the randomization for ET_DYN executables seems to work 
OK. 

Could you please refresh your patch, update the Changelog in a proper way 
and resubmit?

Thanks.


diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index be6671e..8406f9a 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -347,7 +347,7 @@ static inline unsigned long total_mappin
    an ELF header */
 
 static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
-		struct file *interpreter, unsigned long *interp_load_addr,
+		struct file *interpreter, unsigned long *interp_map_addr,
 		unsigned long no_base)
 {
 	struct elf_phdr *elf_phdata;
@@ -421,6 +421,9 @@ static unsigned long load_elf_interp(str
 
 			map_addr = elf_map(interpreter, load_addr + vaddr,
 					   eppnt, elf_prot, elf_type, total_size);
+			total_size = 0;
+			if (!*interp_map_addr)
+				*interp_map_addr = map_addr;
 			error = map_addr;
 			if (BAD_ADDR(map_addr))
 				goto out_close;


