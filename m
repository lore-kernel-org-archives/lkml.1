Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbZCTM7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbZCTM7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 08:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbZCTM7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 08:59:19 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:46164 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393AbZCTM7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 08:59:17 -0400
Date: Fri, 20 Mar 2009 13:59:12 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Jan Glauber <jang@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: linux-next: Tree for March 20 - crypto crash on s390
Message-ID: <20090320135912.53147d76@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20090320162800.24b0ad93.sfr@canb.auug.org.au>
References: <20090320162800.24b0ad93.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get the crash below when I compile hardware support for SHA512
(CONFIG_CRYPTO_SHA512_S390=y) into the kernel:

Unable to handle kernel pointer dereference at virtual kernel address 000000003f9b0000
Oops: 0011 [#1] PREEMPT SMP DEBUG_PAGEALLOC 
Modules linked in: 
CPU: 1 Not tainted 2.6.29-rc8-next-20090320-dirty #18 
Process cryptomgr_test (pid: 169, task: 000000003f8326a0, ksp: 000000003fb83d78)
 
Krnl PSW : 0704000180000000 0000000000032b80 (s390_sha_final+0x198/0x1d4) 
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3 
Krnl GPRS: 0000000000000003 00000000fffffff3 000000003f9affa4 0000000000fffffc 
           0000000000000080 0000000000000003 0000000000000000 000000003fb83d98 
           000000000060a6f0 000000003f9afc48 0000000000000000 000000003fb83b50 
           000000003f9afc58 0000000000403fb8 00000000001c4152 000000003fb83b50 
Krnl Code: 0000000000032b76: a7f4ff60           brc     15,32a36 
           0000000000032b7a: 1843               lr      %rr4,%rr3 
           0000000000032b7c: a7f4ffbb           brc     15,32af2 
          >0000000000032b80: d7ff20002000       xc      0(256,%rr2),0(%rr2) 
           0000000000032b86: 41202100           la      %rr2,256(%rr2) 
           0000000000032b8a: a737fffb           brctg   %rr3,32b80 
           0000000000032b8e: a7f4ff83           brc     15,32a94 
           0000000000032b92: d2ff30002000       mvc     0(256,%rr3),0(%rr2) 
Call Trace: 
([<000000003fb83c40>] 0x3fb83c40)
 [<00000000001c4152>] crypto_shash_final+0x46/0x70 
 [<00000000001c41f4>] shash_async_final+0x34/0x48 
 [<00000000001c47ce>] shash_async_digest+0x12a/0x158 
 [<00000000001c615e>] alg_test_hash+0x1ae/0x634 
 [<00000000001c802e>] alg_test+0xa2/0x210 
 [<00000000001c51d8>] cryptomgr_test+0x6c/0x70 
 [<0000000000067d4a>] kthread+0x76/0xbc 
 [<000000000001befa>] kernel_thread_starter+0x6/0xc 
 [<000000000001bef4>] kernel_thread_starter+0x0/0xc 
Last Breaking-Event-Address: 
 [<0000000000032b8a>] s390_sha_final+0x1a2/0x1d4 
 <4>---[ end trace 561bb236c800851f ]--- 

The problem here seems to be that
int s390_sha_final(struct shash_desc *desc, u8 *out)

gets called with an shash_desc where

bsize = crypto_shash_blocksize(desc->tfm);

results in bsize with zero.

Later in s390_sha_final we see this:

/* pad with zeros */
memset(ctx->buf + index, 0x00, end - index - 8);

because of bsize being zero the result of "end - index -8" is -12.
Obviously it isn't a very good thing to pass a length of -12 to memset.

I have no idea where the bug is: either the s390 arch specific part is
broken because it cannot handle zero sized block sizes or the common
code is broken because it even calls this function with a size of zero.

Jan, Herbert?
