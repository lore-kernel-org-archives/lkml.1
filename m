Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbYJBWct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbYJBWct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 18:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYJBWck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 18:32:40 -0400
Received: from smtp2.ono.com ([62.42.230.20]:54473 "EHLO resmaa04.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752311AbYJBWck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 18:32:40 -0400
Date: Fri, 3 Oct 2008 00:32:37 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86: mtrr_cleanup try gran_size to less than 1M
Message-ID: <20081003003237.04469201@werewolf.home>
In-Reply-To: <1222739652-17169-2-git-send-email-yhlu.kernel@gmail.com>
References: <1222739652-17169-1-git-send-email-yhlu.kernel@gmail.com>
	<1222739652-17169-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: Claws Mail 3.5.0cvs144 (GTK+ 2.14.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008 18:54:12 -0700, Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> one have gran < 1M
> 
> reg00: base=0xd8000000 (3456MB), size= 128MB: uncachable, count=1
> reg01: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
> reg02: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
> reg03: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
> reg04: base=0x120000000 (4608MB), size= 128MB: write-back, count=1
> reg05: base=0xd7f80000 (3455MB), size= 512KB: uncachable, count=1
> 
> will get
> 
> Found optimal setting for mtrr clean up
> gran_size: 512K         chunk_size: 2M  num_reg: 7      lose RAM: 0G
> range0: 0000000000000000 - 00000000d8000000
> Setting variable MTRR 0, base: 0GB, range: 2GB, type WB
> Setting variable MTRR 1, base: 2GB, range: 1GB, type WB
> Setting variable MTRR 2, base: 3GB, range: 256MB, type WB
> Setting variable MTRR 3, base: 3328MB, range: 128MB, type WB
> hole: 00000000d7f00000 - 00000000d7f80000
> Setting variable MTRR 4, base: 3455MB, range: 512KB, type UC
> rangeX: 0000000100000000 - 0000000128000000
> Setting variable MTRR 5, base: 4GB, range: 512MB, type WB
> Setting variable MTRR 6, base: 4608MB, range: 128MB, type WB
> 
> so start from 64k instead of 1M
> 
>

Also, on a 64 bit box with 4Gb, it gives this:

cicely:~# cat /proc/mtrr
reg00: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
reg01: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
reg02: base=0x140000000 (5120MB), size= 512MB: write-back, count=1
reg03: base=0x160000000 (5632MB), size= 256MB: write-back, count=1
reg04: base=0x80000000 (2048MB), size=2048MB: uncachable, count=1

Patch below cleans up formatting, with space for big bases and sizes (64 Gb).

diff -p -up arch/x86/kernel/cpu/mtrr/if.c.orig arch/x86/kernel/cpu/mtrr/if.c
--- arch/x86/kernel/cpu/mtrr/if.c.orig	2008-10-03 00:16:37.000000000 +0200
+++ arch/x86/kernel/cpu/mtrr/if.c	2008-10-03 00:22:34.000000000 +0200
@@ -16,7 +16,7 @@
 static const char *const mtrr_strings[MTRR_NUM_TYPES] =
 {
     "uncachable",               /* 0 */
-    "write-combining",          /* 1 */
+    "write-combine",            /* 1 */
     "?",                        /* 2 */
     "?",                        /* 3 */
     "write-through",            /* 4 */
@@ -405,9 +405,9 @@ static int mtrr_seq_show(struct seq_file
 			}
 			/* RED-PEN: base can be > 32bit */ 
 			len += seq_printf(seq, 
-				   "reg%02i: base=0x%05lx000 (%4luMB), size=%4lu%cB: %s, count=%d\n",
+				   "reg%02i: base=0x%06lx000 (%5luMB), size=%5lu%cB, count=%d: %s\n",
 			     i, base, base >> (20 - PAGE_SHIFT), size, factor,
-			     mtrr_attrib_to_str(type), mtrr_usage_table[i]);
+			     mtrr_usage_table[i], mtrr_attrib_to_str(type));
 		}
 	}
 	return 0;

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
