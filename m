Return-Path: <linux-kernel-owner+w=401wt.eu-S933718AbZDCRLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718AbZDCRLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932788AbZDCRKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:10:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43295 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479AbZDCRKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:10:43 -0400
Date: Fri, 3 Apr 2009 19:10:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Tejun Heo <htejun@gmail.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] percpu: convert SNMP mibs to new infra
Message-ID: <20090403171024.GG19982@elte.hu>
References: <49D32212.80607@cosmosbay.com> <49D32DC2.9010003@goop.org> <49D33E80.70802@cosmosbay.com> <20090401161218.GB3859@elte.hu> <49D3A0C2.9000403@cosmosbay.com> <49D3B61F.8010507@cosmosbay.com> <49D40323.2020406@gmail.com> <20090402040537.GB30442@elte.hu> <49D4724C.7010200@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49D4724C.7010200@cosmosbay.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> Ingo Molnar a écrit :
> > * Tejun Heo <htejun@gmail.com> wrote:
> > 
> >> Hello, Eric, Ingo.
> >>
> >> Eric Dumazet wrote:
> >>> diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
> >>> index aee103b..6b82f6b 100644
> >>> --- a/arch/x86/include/asm/percpu.h
> >>> +++ b/arch/x86/include/asm/percpu.h
> >>> @@ -135,6 +135,9 @@ do {							\
> >>>  #define percpu_read(var)	percpu_from_op("mov", per_cpu__##var)
> >>>  #define percpu_write(var, val)	percpu_to_op("mov", per_cpu__##var, val)
> >>>  #define percpu_add(var, val)	percpu_to_op("add", per_cpu__##var, val)
> >>> +#define indir_percpu_add(var, val)	percpu_to_op("add", *(var), val)
> >>> +#define indir_percpu_inc(var)       percpu_to_op("add", *(var), 1)
> >>> +#define indir_percpu_dec(var)       percpu_to_op("add", *(var), -1)
> >>>  #define percpu_sub(var, val)	percpu_to_op("sub", per_cpu__##var, val)
> >>>  #define percpu_and(var, val)	percpu_to_op("and", per_cpu__##var, val)
> >>>  #define percpu_or(var, val)	percpu_to_op("or", per_cpu__##var, val)
> >> The final goal is to unify static and dynamic accesses but we 
> >> aren't there yet, so, for the time being, we'll need some interim 
> >> solutions. I would prefer percpu_ptr_add() tho.
> > 
> > Yep, that's the standard naming scheme for new APIs: generic to 
> > specific, left to right.
> > 
> 
> Here is a second version of the patch, with percpu_ptr_xxx convention,
> and more polished form (snmp_mib_free() was forgoten in previous RFC)
> 
> Thank you all
> 
> [PATCH] percpu: convert SNMP mibs to new infra
> 
> Some arches can use percpu infrastructure for safe changes to mibs.
> (percpu_add() is safe against preemption and interrupts), but
> we want the real thing (a single instruction), not an emulation.
> 
> On arches still using an emulation, its better to keep the two views
> per mib and preemption disable/enable
> 
> This shrinks size of mibs by 50%, but also shrinks vmlinux text size
> (minimum IPV4 config)
> 
> $ size vmlinux.old vmlinux.new
>    text    data     bss     dec     hex filename
> 4308458  561092 1728512 6598062  64adae vmlinux.old
> 4303834  561092 1728512 6593438  649b9e vmlinux.new

Wow, that's pretty impressive!

> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> ---
>  arch/x86/include/asm/percpu.h |    3 +++

Acked-by: Ingo Molnar <mingo@elte.hu>

As far as x86 goes, feel free to pick it up into any of the 
networking trees, these bits are easily merged and it's probably 
best if the patch stays in a single piece - it looks compact enough 
and if it breaks it's going to break in networking code.

	Ingo
