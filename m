Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbYKRRfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbYKRRfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYKRRfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:35:20 -0500
Received: from gv-out-0910.google.com ([216.239.58.184]:50146 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbYKRRfS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:35:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=rraIvQ3WR122q5ooTuUmWzMUahzHSs9IrNR9MzXY2ZOSHoxzeSoi/FR8k7oVVste/l
         YQhmJ5WAbiLZOFpN0Wt6VOyUGWWx0RxfCr2g4s96jZfEpGJXzUBVOaKAM+2H0AjOAyt+
         2O4KLLNelkcp2c6vwcxGbqztK6lVJgcPlpDRI=
From: Eric Lacombe <goretux@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [x86] do_arch_prctl - bug?
Date: Tue, 18 Nov 2008 18:35:10 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.5; KDE/4.1.3; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <200811181533.33108.goretux@gmail.com> <20081118064556.6b7dc245@infradead.org> <200811181820.04064.goretux@gmail.com>
In-Reply-To: <200811181820.04064.goretux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811181835.11365.goretux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fact, if what I thought from that function was ok, we will have in fact the 
order of the two following lines inversed :
...
  load_gs_index(0);
  ret = checking_wrmsrl(MSR_KERNEL_GS_BASE, addr);
...

So that we would have :
...
  ret = checking_wrmsrl(MSR_KERNEL_GS_BASE, addr);
  load_gs_index(0);
...

Regards,

	Eric

Le mardi 18 novembre 2008 18:20:03 Eric Lacombe, vous avez écrit :
> Le mardi 18 novembre 2008 15:45:56, vous avez écrit :
> > On Tue, 18 Nov 2008 15:33:32 +0100
> >
> > Eric Lacombe <goretux@gmail.com> wrote:
> > > Hello,
> > >
> > > I would like to know why the ARCH_SET_GS action of sys_arch_prctl,
> > > write the MSR MSR_KERNEL_GS_BASE and not the MSR MSR_GS_BASE when the
> > > variable "doit" equals 1? Is that a bug?
> >
> > I don't think it is.
> > The trick is that we use "swapgs" on entering/leaving the kernel, and
> > that will "swap" gs with the MSR, so when we return to userspace, GS
> > gets loaded from the MSR_KERNEL_GS_BASE ...
>
> Yeah when we enter the kernel swapgs is used, so the MSR_GS_BASE is
> switched with the MSR_KERNEL_GS_BASE.
>
> In fact, what I certainly misunderstand is why load_gs_index use swapgs
> inside.
> From that function, I trust that only when gs is loaded, its hidden part is
> loaded with the MSR_GS_BASE.
>
> ENTRY(native_load_gs_index)
>         CFI_STARTPROC
>         pushf
>         CFI_ADJUST_CFA_OFFSET 8
>         DISABLE_INTERRUPTS(CLBR_ANY | ~(CLBR_RDI))
>         SWAPGS
> gs_change:
>         movl %edi,%gs
> 2:      mfence          /* workaround */
>         SWAPGS
>         popf
>         CFI_ADJUST_CFA_OFFSET -8
>         ret
>         CFI_ENDPROC
> ENDPROC(native_load_gs_index)
>
> Regards,
>
> 	Eric

