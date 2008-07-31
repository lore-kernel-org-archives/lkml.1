Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbYGaMHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbYGaMHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 08:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYGaMHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 08:07:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbYGaMHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 08:07:36 -0400
Subject: Re: linux-next: sparc32/gcc-3.4.5/ld-2.15 build failure
From: Steven Whitehouse <swhiteho@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080731003558.965581a6.akpm@linux-foundation.org>
References: <20080731171603.799c2c85.sfr@canb.auug.org.au>
	 <20080731003558.965581a6.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Thu, 31 Jul 2008 13:02:07 +0100
Message-Id: <1217505727.6317.3.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2008-07-31 at 00:35 -0700, Andrew Morton wrote:
> On Thu, 31 Jul 2008 17:16:03 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Dave,
> > 
> > linux-next builds (sparc32 defconfig) have been failing for some time
> > like this:
> > 
> > .tmp_kallsyms2.o(.rodata+0x0): In function `kallsyms_addresses':
> > : relocation truncated to fit: R_SPARC_32 _text
> > .tmp_kallsyms2.o(.rodata+0x4): In function `kallsyms_addresses':
> > : relocation truncated to fit: R_SPARC_32 _text
> > .tmp_kallsyms2.o(.rodata+0x8): In function `kallsyms_addresses':
> > : relocation truncated to fit: R_SPARC_32 _text
> > 
> > (several more)
> > 
> > I finally bisected it down to this commit:
> > 
> > commit f9247273cb69ba101877e946d2d83044409cc8c5
> > Author: Steven Whitehouse <swhiteho@redhat.com>
> > Date:   Thu Jul 24 17:22:13 2008 +0100
> > 
> >     UFS: add const to parser token table
> >     
> > Reverting this commit and the followup commit:
> > 
> > commit fb2e405fc1fc8b20d9c78eaa1c7fd5a297efde43
> > Author: Adrian Bunk <bunk@kernel.org>
> > Date:   Fri Jul 25 02:55:49 2008 +0300
> > 
> >     fix fs/nfs/nfsroot.c compilation
> > 
> > allows the sparc32 build to succeed.  This is toolchain specific as a
> > different cross toolchain I have does not get this error.
> > 
> > Failing toolchain:
> > 
> > $ gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu/bin/sparc64-unknown-linux-gnu-gcc --version
> > sparc64-unknown-linux-gnu-gcc (GCC) 3.4.5
> > $ gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu/bin/sparc64-unknown-linux-gnu-ld --version
> > GNU ld version 2.15
> > 
> > An OK toolchain:
> > $ cross/bin/sparc64-linux-gcc --version
> > sparc64-linux-gcc (GCC) 4.2.4
> > $ cross/bin/sparc64-linux-ld --version
> > GNU ld (GNU Binutils) 2.18
> > 
> > Both these commits are actually in Linus' tree, now.
> 
> gee.  nfsroot.c is now effectively doing `const __initconst' which
> might be upsetting the compiler.  And perhaps one of the forty-odd
> other users of match_table_t needs __initconst or somesuch.
> 
According to my find & grep there is only the one place which has marked
out the match_table_t for a different section.

> Yes, I'd second a revert-and-try-again-later on that one.
It looks like there is no simple solution, so I guess we'll have to do
that :( The only other alternative would be to remove the __initconst
which isn't ideal either,

Steve.


