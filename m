Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbZKTR7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbZKTR7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbZKTR7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:59:30 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:59093 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754915AbZKTR71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:59:27 -0500
X-Greylist: delayed 2212 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2009 12:58:46 EST
Date: Fri, 20 Nov 2009 17:24:18 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: rostedt@goodmis.org, Nicholas Mc Guire <der.herr@hofr.at>,
       zhangfx@lemote.com, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH v9 06/10] tracing: add function graph tracer support
	for MIPS
Message-ID: <20091120172418.GF6869@linux-mips.org>
References: <cover.1258719323.git.wuzhangjin@gmail.com> <2276758e661b2b2362432851003df1d7c99d6cc0.1258719323.git.wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2276758e661b2b2362432851003df1d7c99d6cc0.1258719323.git.wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 08:34:34PM +0800, Wu Zhangjin wrote:

> The implementation of function graph tracer for MIPS is a little
> different from X86.
> 
> in MIPS, gcc(with -pg) only transfer the caller's return address(at) and
> the _mcount's return address(ra) to us.
> 
> For the kernel part without -mlong-calls:
> 
> move at, ra
> jal _mcount
> 
> For the module part with -mlong-calls:
> 
> lui v1, hi16bit_of_mcount
> addiu v1, v1, low16bit_of_mcount
> move at, ra
> jal _mcount
> 
> Without -mlong-calls,
> 
> if the function is a leaf, it will not save the return address(ra):
> 
> ffffffff80101298 <au1k_wait>:
> ffffffff80101298:       67bdfff0        daddiu  sp,sp,-16
> ffffffff8010129c:       ffbe0008        sd      s8,8(sp)
> ffffffff801012a0:       03a0f02d        move    s8,sp
> ffffffff801012a4:       03e0082d        move    at,ra
> ffffffff801012a8:       0c042930        jal     ffffffff8010a4c0 <_mcount>
> ffffffff801012ac:       00020021        nop
> 
> so, we can hijack it directly in _mcount, but if the function is non-leaf, the
> return address is saved in the stack.
> 
> ffffffff80133030 <copy_process>:
> ffffffff80133030:       67bdff50        daddiu  sp,sp,-176
> ffffffff80133034:       ffbe00a0        sd      s8,160(sp)
> ffffffff80133038:       03a0f02d        move    s8,sp
> ffffffff8013303c:       ffbf00a8        sd      ra,168(sp)
> ffffffff80133040:       ffb70098        sd      s7,152(sp)
> ffffffff80133044:       ffb60090        sd      s6,144(sp)
> ffffffff80133048:       ffb50088        sd      s5,136(sp)
> ffffffff8013304c:       ffb40080        sd      s4,128(sp)
> ffffffff80133050:       ffb30078        sd      s3,120(sp)
> ffffffff80133054:       ffb20070        sd      s2,112(sp)
> ffffffff80133058:       ffb10068        sd      s1,104(sp)
> ffffffff8013305c:       ffb00060        sd      s0,96(sp)
> ffffffff80133060:       03e0082d        move    at,ra
> ffffffff80133064:       0c042930        jal     ffffffff8010a4c0 <_mcount>
> ffffffff80133068:       00020021        nop
> 
> but we can not get the exact stack address(which saved ra) directly in
> _mcount, we need to search the content of at register in the stack space
> or search the "s{d,w} ra, offset(sp)" instruction in the text. 'Cause we
> can not prove there is only a match in the stack space, so, we search
> the text instead.
> 
> as we can see, if the first instruction above "move at, ra" is not a
> store instruction, there should be a leaf function, so we hijack the at
> register directly via putting &return_to_handler into it, otherwise, we
> search the "s{d,w} ra, offset(sp)" instruction to get the stack offset,
> and then the stack address. we use the above copy_process() as an
> example, we at last find "ffbf00a8", 0xa8 is the stack offset, we plus
> it with s8(fp), that is the stack address, we hijack the content via
> writing the &return_to_handler in.
> 
> If with -mlong-calls, since there are two more instructions above "move
> at, ra", so, we can move the pointer to the position above "lui v1,
> hi16bit_of_mcount".
> 
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>

Queued for 2.6.33 but due to patch 3/3 I won't propagate this series
immediately to linux-next.

Thanks!

  Ralf
