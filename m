Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbXLWMM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbXLWMM3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 07:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbXLWMMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 07:12:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50816 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbXLWMMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 07:12:20 -0500
Date: Sun, 23 Dec 2007 12:12:15 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: 2.6.24-rc6-mm1
Message-ID: <20071223121215.GE18629@infradead.org>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <20071223110456.GB10818@elte.hu> <20071223111004.GA2259@elte.hu> <20071223033424.01dab700.akpm@linux-foundation.org> <20071223115735.GA13423@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071223115735.GA13423@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2007 at 12:57:35PM +0100, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Still.  The crash is 100% repeatable and is the same every time.  
> > Happens on both my i386 test boxes.
> > 
> > http://userweb.kernel.org/~akpm/config-sony.txt
> > http://userweb.kernel.org/~akpm/config-vmm.txt
> > 
> > and I bisected it down to e3c1b141.
> 
> ok, can reproduce it - the patch below fixes it for me.
> 
> 	Ingo
> 
> ------------------------->
> Subject: x86: fix system gate related crash
> From: Ingo Molnar <mingo@elte.hu>
> 
> on 32-bit, system gates are traps.
> 
> on 64-bit, they are interrupts (which disable hardirqs).
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/asm-x86/desc.h |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux-x86.q/include/asm-x86/desc.h
> ===================================================================
> --- linux-x86.q.orig/include/asm-x86/desc.h
> +++ linux-x86.q/include/asm-x86/desc.h
> @@ -310,7 +310,11 @@ static inline void set_trap_gate(unsigne
>  static inline void set_system_gate(unsigned int n, void *addr)
>  {
>  	BUG_ON((unsigned)n > 0xFF);
> +#ifdef CONFIG_X86_32
> +	_set_gate(n, GATE_TRAP, addr, 0x3, 0, __KERNEL_CS);
> +#else
>  	_set_gate(n, GATE_INTERRUPT, addr, 0x3, 0, __KERNEL_CS);
> +#endif
>  }
>
This would be a lot cleaner with entirely separate implementations
of set_system_gate for 32 vs 64 bit.  Especially if the file already
has a large ifdef block for 32 vs 64 already.
