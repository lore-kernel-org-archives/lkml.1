Return-Path: <linux-kernel-owner+w=401wt.eu-S1759815AbXGCUS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815AbXGCUS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 16:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756975AbXGCUSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 16:18:50 -0400
Received: from terminus.zytor.com ([192.83.249.54]:55319 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645AbXGCUSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 16:18:49 -0400
Message-ID: <468AAF1F.6010909@zytor.com>
Date: Tue, 03 Jul 2007 13:18:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 06/10] Immediate Value - i386 Optimization
References: <20070703164046.645090494@polymtl.ca> <20070703164515.071300768@polymtl.ca> <468A9956.9050903@zytor.com> <20070703191605.GB4047@Krystal>
In-Reply-To: <20070703191605.GB4047@Krystal>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> Hi Peter,
> 
> I understand your concern. If you find a way to let the code be compiled
> by gcc, put at the end of the functions (never being a branch target)
> and then, dynamically, get the address of the branch instruction and
> patch it, all that in cooperation with gcc, I would be glad to hear from
> it. What I found is that gcc lets us do anything that touches
> variables/registers in an inline assembly, but does not permit to place
> branch instructions ourselves; it does not expect the execution flow to
> be changed in inline asms.
> 

I believe this is correct.  It probably would require requesting a gcc
builtin, which might be worthwhile to do if we

> <branch site>
>   77:   b8 00 00 00 00          mov    $0x0,%eax
>   7c:   85 c0                   test   %eax,%eax
>   7e:   0f 85 16 03 00 00       jne    39a <schedule+0x39a>
>     here, we just loaded 0 in eax (movl used to make sure we populate the
>     whole register so we do not stall the pipeline)a
>     When we activate the site,
>     line 77 becomes: b8 01 00 00 00    mov    $0x1,%eax
> </branch site>

One could, though, use an indirect jump to achieve, if not as good, at
least most of the effect:

	movl	$<patchable>,<reg>
	jmp	*<reg>

Some x86 cores will be able to detect the movl...jmp forwarding, and
collapse it into a known branch target; however, on the ones that can't,
it might be worse, since one would have to rely on the indirect branch
predictor.

This would, however, provide infrastructure that could be combined with
a future gcc builtin.

	-hpa

