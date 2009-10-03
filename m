Return-Path: <linux-kernel-owner+w=401wt.eu-S1752967AbZJCHSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbZJCHSW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 03:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbZJCHSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 03:18:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34089 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbZJCHSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 03:18:20 -0400
Date: Sat, 3 Oct 2009 09:18:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <petkovbb@googlemail.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] EDAC: carve out AMD MCE decoding logic
Message-ID: <20091003071807.GA21407@elte.hu>
References: <20091001144637.GB11410@aftab> <20091001150046.GA21476@elte.hu> <20091001152140.GC11410@aftab> <20091001153250.GA25885@elte.hu> <20091002132101.GA28682@aftab> <20091002133148.GD28682@aftab> <20091002133954.GA29390@elte.hu> <20091002182659.GA16436@aftab> <20091002184714.GA21509@elte.hu> <20091003065752.GA8935@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091003065752.GA8935@liondog.tnic>
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


* Borislav Petkov <petkovbb@googlemail.com> wrote:

> On Fri, Oct 02, 2009 at 08:47:14PM +0200, Ingo Molnar wrote:
> > No, the locking was all that i meant. Using atomic_notifier would solve 
> > that. Make the default decoder low-prio, that way there's no need to do 
> > the callback save/restore sequence either.
> 
> Ok, how's that for starters, it has been only compile-tested and it
> looks straight-forward enough to me...

looks good at first sight. There's two further simplifications you could 
do:

> +int mce_register_decoder_notifier(struct notifier_block *nb);
> +int mce_unregister_decoder_notifier(struct notifier_block *nb);

expose the notifier list itself and dont create new register/unregister 
APIs. Doing:

	atomic_notifier_chain_register(&x86_mce_decoder_chain, nb);

straight from the EDAC code is clean enough.

plus:

> +static struct notifier_block amd_mce_dec_nb = {
> +	.notifier_call	= amd_decode_mce,
> +	.priority	= 100,
> +};
> +

it's better to set the default notifier to negative priority, and let 
the EDAC notifier(s) be at the default 0 priority. The 100 is arbitrary 
and ugly - that line can then be left out altogether.

	Ingo
