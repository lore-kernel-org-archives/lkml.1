Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbZJLMV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbZJLMV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 08:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbZJLMV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 08:21:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53719 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbZJLMV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 08:21:26 -0400
Date: Mon, 12 Oct 2009 14:20:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] panic.c: export panic_on_oops
Message-ID: <20091012122023.GA19365@elte.hu>
References: <1255241458-11665-1-git-send-email-dedekind1@gmail.com> <20091012111545.GB8857@elte.hu> <1255346731.9659.31.camel@localhost> <20091012113758.GB11035@elte.hu> <20091012140149.6789efab@marrow.netinsight.se> <20091012120951.GA16799@elte.hu> <1255349748.10605.13.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255349748.10605.13.camel@macbook.infradead.org>
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


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Mon, 2009-10-12 at 14:09 +0200, Ingo Molnar wrote:
> > Also, would it be possible to just simplify the thing and not do any 
> > buffering at all? Extra buffering complexity in a console driver is only 
> > asking for trouble. Or is flash storage write cycles optimization that 
> > important in this case?
> 
> That and the fact that on NAND flash you have to write full pages at a 
> time -- that's 512 bytes, 2KiB or 4KiB depending on the type of chip. 
> So we really do want to buffer it where we can.
> 
> We don't want to write a 2KiB page for every line of printk output.

Then i think the buffering is at the wrong place: we should instead 
buffer in the generic layer and pass it to lowlevel if we know that we 
have gone past a 2K boundary.

The size of the generic log buffer is always a power of two so detecting 
2K boundaries is very easy. On any emergency the generic console layer 
will do faster flushes - this is nothing the console driver itself 
should bother with.

And that would avoid the whole workqueue logic - which is fragile to be 
done in a printk to begin with.

So what we need is an extension to struct console that sets a buffering 
limit. Zero (the default) means unbuffered.

(Btw., things like netconsole might make use of such buffering too.)

Agreed?

	Ingo
