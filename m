Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbYGaHgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbYGaHgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 03:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbYGaHgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 03:36:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752891AbYGaHgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 03:36:35 -0400
Date: Thu, 31 Jul 2008 00:35:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: linux-next: sparc32/gcc-3.4.5/ld-2.15 build failure
Message-Id: <20080731003558.965581a6.akpm@linux-foundation.org>
In-Reply-To: <20080731171603.799c2c85.sfr@canb.auug.org.au>
References: <20080731171603.799c2c85.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008 17:16:03 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Dave,
> 
> linux-next builds (sparc32 defconfig) have been failing for some time
> like this:
> 
> .tmp_kallsyms2.o(.rodata+0x0): In function `kallsyms_addresses':
> : relocation truncated to fit: R_SPARC_32 _text
> .tmp_kallsyms2.o(.rodata+0x4): In function `kallsyms_addresses':
> : relocation truncated to fit: R_SPARC_32 _text
> .tmp_kallsyms2.o(.rodata+0x8): In function `kallsyms_addresses':
> : relocation truncated to fit: R_SPARC_32 _text
> 
> (several more)
> 
> I finally bisected it down to this commit:
> 
> commit f9247273cb69ba101877e946d2d83044409cc8c5
> Author: Steven Whitehouse <swhiteho@redhat.com>
> Date:   Thu Jul 24 17:22:13 2008 +0100
> 
>     UFS: add const to parser token table
>     
> Reverting this commit and the followup commit:
> 
> commit fb2e405fc1fc8b20d9c78eaa1c7fd5a297efde43
> Author: Adrian Bunk <bunk@kernel.org>
> Date:   Fri Jul 25 02:55:49 2008 +0300
> 
>     fix fs/nfs/nfsroot.c compilation
> 
> allows the sparc32 build to succeed.  This is toolchain specific as a
> different cross toolchain I have does not get this error.
> 
> Failing toolchain:
> 
> $ gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu/bin/sparc64-unknown-linux-gnu-gcc --version
> sparc64-unknown-linux-gnu-gcc (GCC) 3.4.5
> $ gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu/bin/sparc64-unknown-linux-gnu-ld --version
> GNU ld version 2.15
> 
> An OK toolchain:
> $ cross/bin/sparc64-linux-gcc --version
> sparc64-linux-gcc (GCC) 4.2.4
> $ cross/bin/sparc64-linux-ld --version
> GNU ld (GNU Binutils) 2.18
> 
> Both these commits are actually in Linus' tree, now.

gee.  nfsroot.c is now effectively doing `const __initconst' which
might be upsetting the compiler.  And perhaps one of the forty-odd
other users of match_table_t needs __initconst or somesuch.

Yes, I'd second a revert-and-try-again-later on that one.
