Return-Path: <linux-kernel-owner+w=401wt.eu-S2992592AbXEBAso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992592AbXEBAso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 20:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992621AbXEBAsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 20:48:43 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992592AbXEBAs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 20:48:27 -0400
Date: Tue, 1 May 2007 17:48:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Juergen Beisert <juergen127@kreuzholzen.de>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] [1/1] CPU-i386-Geode: Chipset access macros do not work
 as expected (2nd try)
Message-Id: <20070501174808.4ac5378b.akpm@linux-foundation.org>
In-Reply-To: <200704301733.41903.juergen127@kreuzholzen.de>
References: <200704301409.l3UE9sFg019392@harpo.it.uu.se>
	<200704301733.41903.juergen127@kreuzholzen.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 17:33:41 +0200
Juergen Beisert <juergen127@kreuzholzen.de> wrote:

> From: Juergen Beisert <juergen.beisert@weihenstephan.org>
> 
> Replace NSC/Cyrix specific chipset access macros by inlined functions.
> With the macros a line like this fails (and does nothing):
> 	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
> With inlined functions this line will work as expected.
> 
> Note about a side effect: Seems on Geode GX1 based systems the
> "suspend on halt power saving feature" was never enabled due to this
> wrong macro expansion. With inlined functions it will be enabled, but
> this will stop the TSC when the CPU runs into a HLT instruction.
> Kernel outputs something like this:
> 	Clocksource tsc unstable (delta = -472746897 ns)
> Tested on a Geode GX1 system.
> 
> This is the second version with some modifications suggested by
> Mikael Pettersson
> 
> Signed-off-by: Juergen Beisert <juergen.beisert@weihenstephan.org>
> 
> Index: linux-2.6.21/include/asm-i386/processor.h
> ===================================================================
> --- linux-2.6.21.orig/include/asm-i386/processor.h
> +++ linux-2.6.21/include/asm-i386/processor.h
> @@ -202,37 +202,6 @@ static inline void clear_in_cr4 (unsigne
>  	write_cr4(cr4);
>  }
> 
> -/*
> - *      NSC/Cyrix CPU configuration register indexes
> - */
> -
> -#define CX86_PCR0 0x20
> -#define CX86_GCR  0xb8
> -#define CX86_CCR0 0xc0
> -#define CX86_CCR1 0xc1
> -#define CX86_CCR2 0xc2
> -#define CX86_CCR3 0xc3
> -#define CX86_CCR4 0xe8
> -#define CX86_CCR5 0xe9
> -#define CX86_CCR6 0xea
> -#define CX86_CCR7 0xeb
> -#define CX86_PCR1 0xf0
> -#define CX86_DIR0 0xfe
> -#define CX86_DIR1 0xff
> -#define CX86_ARR_BASE 0xc4
> -#define CX86_RCR_BASE 0xdc

This clashes with Andi's "msr-index" patch:

ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/msr-index

Perhaps it'd be best to wait until msr-index goes upstream and to raise a
patch then.  Or to redo and retest against 2.6.21-rc7-mm2, which includes
msr-index.

Also, include/asm-x86_64/processor.h has a getCx86(), too.  Does it also
need fixing?

