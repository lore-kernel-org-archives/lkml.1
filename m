Return-Path: <linux-kernel-owner+w=401wt.eu-S1754370AbZAOW5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbZAOW5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935859AbZAOWfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:35:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42497 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935625AbZAOWfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:35:19 -0500
Date: Thu, 15 Jan 2009 23:34:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: roel kluin <roel.kluin@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, ebiederm@xmission.com,
       cl@linux-foundation.org, rusty@rustcorp.com.au, travis@sgi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: Re: [patch] add optimized generic percpu accessors
Message-ID: <20090115223438.GA7463@elte.hu>
References: <496D8CEB.5060402@zytor.com> <20090114093834.GA19799@elte.hu> <25e057c00901150204x61c54d9fl91afe23477d1f12f@mail.gmail.com> <496F0F5E.3080404@kernel.org> <20090115113230.GH22850@elte.hu> <496F1FA6.6050204@kernel.org> <20090115122222.GI22850@elte.hu> <496F3577.4020303@kernel.org> <20090115133206.GA31416@elte.hu> <20090115133916.GA3417@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115133916.GA3417@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0791]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > FYI, -tip testing found the following bug with your percpu stuff:
> > 
> > There's an early exception during bootup, on 64-bit x86:
> > 
> >   PANIC: early exception 0e rip 10:ffffffff80276855: error ? cr2 6688
> > 
> >  - gcc version 4.3.2 20081007 (Red Hat 4.3.2-6) (GCC) 
> >  - binutils-2.18.50.0.6-2.x86_64
> > 
> > config attached. You can find the disassembly of lock_release_holdtime() 
> > below - that's where it crashed:
> 
> Gut feeling: we must have gotten a window where the PDA is not right. 
> Note how it crashes in lock_release_holdtime() - that is 
> CONFIG_LOCK_STAT instrumentation - very lowlevel and pervasive. Function 
> tracing is also enabled although it should be inactive at the early 
> stages.
> 
> So i'd take a good look at the PDA setup portion of the boot code, and 
> see whether some spinlock acquire/release can slip in while the 
> PDA/percpu-area is not reliable.

Btw., if this turns out to be a genuine linker bug due to us crossing 
RIP-relative references from minus-1.9G-ish negative addresses up to 
slightly-above-zero positive addresses (or something similar - we are 
pushing the linker here quite a bit), we still have a contingency plan:

We can relocate the percpu symbols to small-negative addresses, and place 
it so that the end of the dynamic percpu area ends at zero.

Then we could bootmem alloc the percpu size plus 4096 bytes. Voila: we've 
got a page free for the canary field, at the end of the percpu area, and 
placed just correctly for gcc to see it at %gs:40.

But this isnt as totally clean and simple as your current patchset, so 
lets only do it if needed. It will also put some constraints on how we can 
shape dynamic percpu areas, and an overflow near the end of the dynamic 
percpu area could affect the canary - but still, it's a workable path as 
well, should the zero-based approach fail.

OTOH, this crash does not have the feeling of a linker bug to me - it has 
the feeling of a setup ordering anomaly.

	Ingo
