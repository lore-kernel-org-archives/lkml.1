Return-Path: <linux-kernel-owner+w=401wt.eu-S1758132AbZBXPT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbZBXPT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 10:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZBXPTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 10:19:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44590 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbZBXPTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 10:19:48 -0500
Date: Tue, 24 Feb 2009 16:19:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Subject: Re: [PATCHSET x86/core/percpu] improve the first percpu chunk
	allocation
Message-ID: <20090224151920.GB12438@elte.hu>
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224095708.GA20739@elte.hu> <49A3DE76.5010606@kernel.org> <20090224125132.GB31295@elte.hu> <49A4087B.8080405@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A4087B.8080405@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Hi,
> 
> Ingo Molnar wrote:
> --snip--
> > So what i'm saying is that these are strong reasons for us to 
> > want to make the unit size to be something like 2MB - on 64-bit 
> > x86 at least.
> >
> > ( Using a 2MB unit size will also have another advantage: _iff_ 
> >   we can still allocate a hugepage at that point we can map it 
> >   straight there when extending the dynamic area. )
> 
> Thanks for the explanation.  Yeap, it would be nice to have 
> units aligned on 2MB boundary.  We'll need to add @align to vm 
> area alloc function to do it correctly.  As for using large 
> page, it would be nice if we can do that automatically.  
> Upfront 2MB unit allocation is probably too expensive but 
> merging 4k pages into a large page (if we can get them) will 
> add a lot of irregular latency too.  Hmmm...

Yeah, largepage support - if we ever get there (the chances of 
finding a proper 2MB aligned 2MB sized chunk of physical memory 
are not very good except the first few minutes of uptime), 
should indeed be automatic to all get_vm_area() users - 
vmalloc(), ioremap() and now percpu.c.

I think a far more realistic angle to utilize more of the 2MB 
TLB will be to gradually increase PERCPU_ENOUGH_ROOM, as we 
observe more and more percpu_alloc() sites in the kernel. Right 
now it's pretty rare so going beyond the 8K we do for modules 
would probably be a waste of RAM.

	Ingo
