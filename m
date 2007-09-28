Return-Path: <linux-kernel-owner+w=401wt.eu-S1761308AbXI1O2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761308AbXI1O2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbXI1O16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:27:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38775 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878AbXI1O15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:27:57 -0400
Date: Fri, 28 Sep 2007 07:27:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jkeating@redhat.com, cebbert@redhat.com, jordan.crouse@amd.com,
       pommnitz@yahoo.com
Subject: Re: [GIT PULL] Correct the SMAP check in the e820 probe
In-Reply-To: <200709280856.l8S8uvS5002291@tazenda.hos.anvin.org>
Message-ID: <alpine.LFD.0.999.0709280719010.3579@woody.linux-foundation.org>
References: <200709280856.l8S8uvS5002291@tazenda.hos.anvin.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 Sep 2007, H. Peter Anvin wrote:
>
>     [x86 setup] Correct the SMAP check for INT 0x15, AX=0xe820
>     
>     The e820 probe code was checking %edx, not %eax, for the SMAP
>     signature on return.  This worked on *almost* all systems, since %edx
>     still contained SMAP from the call on entry, but on a handful of
>     systems it failed -- plus, we would have missed real mismatches.
>     
>     Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> 
> diff --git a/arch/i386/boot/memory.c b/arch/i386/boot/memory.c
> index bccaa1c..2f37568 100644
> --- a/arch/i386/boot/memory.c
> +++ b/arch/i386/boot/memory.c
> @@ -28,11 +28,10 @@ static int detect_memory_e820(void)
>  
>  	do {
>  		size = sizeof(struct e820entry);
> -		id = SMAP;
>  		asm("int $0x15; setc %0"
> -		    : "=am" (err), "+b" (next), "+d" (id), "+c" (size),
> +		    : "=dm" (err), "+b" (next), "=a" (id), "+c" (size),
>  		      "=m" (*desc)
> -		    : "D" (desc), "a" (0xe820));
> +		    : "D" (desc), "d" (SMAP), "a" (0xe820));

Hmm. If I read this correctly, I don't think this can be right.

Why? You don't mark %edx as possibly corrupted by the asm any more.

The "=dm" means that quite often (probably effectively always), gcc will 
allocate %edx to be the output register for %0, but at least in theory, it 
could easily decide that it's going to put %0 in memory, and in that case, 
it may well decide that %edx is not modified by the asm statement. Which 
may or may not be true - I'd bet that there are BIOSes out there that *do* 
modify it.

So what happens then? If gcc decides that %edx isn't modified by the asm, 
it will assume that it still contains the value it had on entry, which is 
the "SMAP" value, and then it might decide to do the

	if (id != SMAP) {

check as a 

	cmpl %edx,%eax

since the "id" return is in %eax, and the compiler decides that it may be 
cheaper to re-use the register that already contains the constant, than to 
use a (longer) compare instruction with an explicit constant.

IOW, I think you need to either (a) _force_ gcc to use %edx for the "err" 
return, avoiding this issue, or (b) mark edx clobbered (which in turn 
means that you need to remove it from the output constraint for "err"). I 
suspect (a) is simpler/more straightforward.

I haven't pulled this, so maybe you can just amend the commit in-place, 
and we can avoid?

			Linus
