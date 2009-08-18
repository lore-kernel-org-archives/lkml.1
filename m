Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbZHRNnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbZHRNnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 09:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbZHRNnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 09:43:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37843 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbZHRNno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 09:43:44 -0400
Date: Tue, 18 Aug 2009 15:43:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] task_struct: stack_canary is not needed without
	CC_STACKPROTECTOR
Message-ID: <20090818134328.GA28366@elte.hu>
References: <4A8A44CA.2020701@ct.jp.nec.com> <87ws51r2wh.fsf@basil.nowhere.org> <4A8A5FD4.5070908@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8A5FD4.5070908@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> Andi Kleen wrote:
> > Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> writes:
> > 
> >> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> >>
> >> The field stack_canary is only used with CC_STACKPROTECTOR.
> >> This patch reduces task_struct size without CC_STACKPROTECTOR.
> > 
> > Adding a ifdef in the middle of a widely used structure is 
> > nasty.  It means that if someone changes the option then the 
> > newly loaded modules don't work anymore (yes that's not 
> > officially supported, but works most of the time and is often 
> > convenient in practice)

( Ugh. Not having clean builds and clean modules is utterly 
  dangerous and taints the kernel. I ignore all bugreports from
  people that do that - a kernel that has been butchered like that
  is just not trustable. )

> > So when you add a ifdef please move the field to the end at 
> > least.

Moving the stack canary it last is futile and makes no sense 
whatsoever, for three independent reasons:

It's stupidly shortsighted: there's 20 other config options in the 
middle of struct task struct already. Half of struct task_struct is
#ifdef-ed, and there can only be one 'last' field.

It's merge unfriendly: moving fields last in structs can cause 
patch conflict problems: new subsystems/features tend to append to 
task_struct, colliding with this patch. task_struct is frequently 
patched.

It hurts performance: the canary is used very frequently on 
stackprotector kernels and has been placed on a hot cacheline 
intentionally. Moving it last just adds a small but real 
performance regression.

Really, Andi, if you give 'advice' like this you should be declared 
armed and dangerous ... ;-)

> Here's the update.

I've applied v1, thanks Hiroshi!

	Ingo
