Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbYKRI1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbYKRI1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbYKRI1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:27:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45573 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbYKRI1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:27:42 -0500
Date: Tue, 18 Nov 2008 09:27:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Tejun Heo <htejun@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Fix kunmap() argument in sg_miter_stop
Message-ID: <20081118082715.GH17838@elte.hu>
References: <20081117094147.GJ28786@elte.hu> <20081117094551.GI26778@kernel.dk> <20081117111350.GJ26778@kernel.dk> <4921A4F3.1030309@goop.org> <20081117171005.GA25729@elte.hu> <4921A6BE.7000206@goop.org> <alpine.LFD.2.00.0811170922000.3468@nehalem.linux-foundation.org> <20081117180738.GW26778@kernel.dk> <alpine.LFD.2.00.0811171015070.3468@nehalem.linux-foundation.org> <20081117182650.GY26778@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117182650.GY26778@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Mon, Nov 17 2008, Linus Torvalds wrote:
> > 
> > 
> > On Mon, 17 Nov 2008, Jens Axboe wrote:
> > > 
> > > Any opinions on the kunmap/kunmap_atomic pointer checking? It's a bit
> > > ugly that we have to enforce a void * rule for kunmap_atomic(),
> > 
> > I don't think that's a "bit ugly". I think it's unacceptable.
> > 
> > Making sure we pass in "struct page" to kunmap() sounds good, but the 
> > kunmap_atomic() part just sounds insane.
> 
> It's been the primary source of bugs that I have seen. The xen and 
> sg iter bug were kunmap() variants though, but otherwise I've mostly 
> seen the opposite. But it is ugly, no doubt about it. I can't think 
> of a better way to attempt to warn about it though, so if you really 
> dislike it I'll just drop the _atomic() bits.

The main ugliness comes from the tons of void * type casts that the 
kunmap_atomic() type check forces. Type casts are just as dangerous 
(and ugly) as type mismatches. (more dangerous in fact)

Perhaps we could try an opt-in 'type filter' approach instead. See 
kernel/tracing/trace.h's trace_assign_type()'s type checking magic for 
an example of how to do it.

( but it's a bit tricky here because we want to filter void * from
  struct page * - i'm not sure gcc will recognize them as incompatible
  types. )

	Ingo
