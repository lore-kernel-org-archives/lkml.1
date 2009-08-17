Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbZHQWtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbZHQWtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 18:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757957AbZHQWtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 18:49:41 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52413 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752350AbZHQWtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 18:49:40 -0400
Subject: Re: kernel segv with 2.6.31-rc6 ?
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Helge Deller <deller@gmx.de>
Cc: linux-parisc <linux-parisc@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4A89CC4D.5040801@gmx.de>
References: <4A89CC4D.5040801@gmx.de>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 22:49:36 +0000
Message-Id: <1250549376.7858.96.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-17 at 23:31 +0200, Helge Deller wrote:
> anyone else seeing this with 2.6.31-rc6 ?
> 
> <...system boots up...>
> Waiting for /dev to be fully populated...
>   
> sysfs: cannot create duplicate filename '/module/ac97_bus/sections/.text'
> ------------[ cut here ]------------
> Badness at fs/sysfs/dir.c:487
>   
>       YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
> PSW: 00000000000001000000000000001111 Not tainted
> r00-03  0004000f 10669bd0 10204ff8 7ce58340
> r04-07  7efcd000 ffffffef 7f881d74 7efcd000
> r08-11  0008746c 00000000 7f1c6400 0008441c
> r12-15  00000019 00084332 105a96c8 00000124
> r16-19  0000fff1 00000017 00084abc ffffffff
> r20-23  7eeff080 00000060 102f5898 10330dec
> r24-27  ffffffff 0000000e 10669c04 10656670
> r28-31  00000050 00000190 7ce583c0 10123988
> sr00-03  00000000 00000000 00000000 00000008
> sr04-07  00000000 00000000 00000000 00000000
>   
> IASQ: 00000000 00000000 IAOQ: 10204ff8 10204ffc
>   IIR: 03ffe01f    ISR: 00000000  IOR: 00000000
>   CPU:        0   CR30: 7ce58000 CR31: 11111111
>   ORIG_R28: 00000001
>   IAOQ[0]: sysfs_add_one+0xb8/0xd0
>   IAOQ[1]: sysfs_add_one+0xbc/0xd0
>   RP(r2): sysfs_add_one+0xb8/0xd0
> Backtrace:
>   [<102045b8>] sysfs_add_file_mode+0x60/0xc4
>   [<1020748c>] internal_create_group+0xf0/0x1d8
>   
> Backtrace:
>   [<1016f0f0>] load_module+0x10e8/0x1294
>   
> 
> Kernel Fault: Code=26 regs=7ce58200 (Addr=00000030)
>   
>       YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
> PSW: 00000000000001100000000000001111 Tainted: G        W
> r00-03  0006000f 7ce58200 1016f0f0 7ce58140
> r04-07  00084444 00000019 00087424 7eddb660
> r08-11  00084000 00000001 7f1c66a4 0008441c
> r12-15  00000019 00084332 105a96c8 00000124
> r16-19  0000fff1 00000017 00084abc 00000000
> r20-23  00000000 1016d3e0 7eddb668 00000124
> r24-27  105a96cc 00000000 7eddb660 10656670
> r28-31  00000000 00000001 7ce58200 00000000
> sr00-03  00000000 00000000 00000000 00000008
> sr04-07  00000000 00000000 00000000 00000000
>   
> IASQ: 00000000 00000000 IAOQ: 1016f130 1016f134
>   IIR: 4b940060    ISR: 00000000  IOR: 00000030
>   CPU:        0   CR30: 7ce58000 CR31: 11111111
>   ORIG_R28: 00084332
>   IAOQ[0]: load_module+0x1128/0x1294
>   IAOQ[1]: load_module+0x112c/0x1294
>   RP(r2): load_module+0x10e8/0x1294
> Backtrace:
>   [<1016f0f0>] load_module+0x10e8/0x1294
>   
> Kernel panic - not syncing: Kernel Fault
> Backtrace:
>   [<1011ac28>] show_stack+0x18/0x28
>   [<1013f3a0>] vprintk+0x19c/0x430

The root cause is a duplicate section name (.text); is this legal?

However, there's a problem with commit
6d76013381ed28979cd122eb4b249a88b5e384fa in that if you fail to allocate
a mod->sect_attrs (in this case it's null because of the duplication),
it still gets used without checking in add_notes_attrs()

This should fix it

Signed-off-by: James Bottomley <James.Bottomley@suse.de>

---

diff --git a/kernel/module.c b/kernel/module.c
index fd14114..a703c49 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2353,7 +2353,8 @@ static noinline struct module *load_module(void __user *umod,
 	if (err < 0)
 		goto unlink;
 	add_sect_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
-	add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
+	if (mod->sect_attrs)
+		add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
 
 	/* Get rid of temporary copy */
 	vfree(hdr);


