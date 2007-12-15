Return-Path: <linux-kernel-owner+w=401wt.eu-S1760925AbXLOR6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925AbXLOR6w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 12:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbXLOR6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 12:58:32 -0500
Received: from waste.org ([66.93.16.53]:47676 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079AbXLOR6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 12:58:31 -0500
Date: Sat, 15 Dec 2007 11:54:43 -0600
From: Matt Mackall <mpm@selenic.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Make WARN_ON/WARN_ON_ONCE no-ops when CONFIG_BUG is off
Message-ID: <20071215175443.GU19691@waste.org>
References: <20071214132755.GA18309@gondor.apana.org.au> <20071214180246.GT17536@waste.org> <20071215041659.GB25324@gondor.apana.org.au> <20071215055218.GM19691@waste.org> <20071215060449.GA26199@gondor.apana.org.au> <20071215065211.GA26579@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071215065211.GA26579@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2007 at 02:52:11PM +0800, Herbert Xu wrote:
> On Sat, Dec 15, 2007 at 02:04:49PM +0800, Herbert Xu wrote:
> >
> > I suppose we'll have to either introduce a new primitive or just
> > go back to using BUG_ON.
> 
> Let's do the conservative thing and add a new primitive.
> 
> [PATCH] Added BARF_ON/BARF_ON_ONCE
> 
> The description of CONFIG_BUG clearly states that both BUG and
> WARN_ON may be skipped.  However, our actual implementation still
> checks the condition on WARN_ON if it's used as part of an if
> statement or such.
> 
> I tried to compile it away but Matt Mackall pointed out that
> people may already be using it in ways that were not intended.
> In particular, it may have been used for conditions that are
> thought to be possible.
> 
> So this patch adds a new pair of macros BARF_ON and BARF_ON_ONCE
> that are clearly marked as such to prevent abuse.  The intended
> usage model is identical to WARN_ON except that they should only
> be used for conditions that are thought to be impossible.  In
> other words, only use them to replace BUG_ON's that may be called
> by an IRQ handler or within locks.

Egads, this just makes the whole bad BUG_ON vs WARN_ON situation
worse. This adds yet another non-distinction, because the difference
between BUG_ON and WARN_ON has absolutely nothing to do with the
(perceived or actual) probability of the condition.

We've got plenty of evidence that BUG_ON and WARN_ON conditions -do-
happen. So choosing between BUG_ON and WARN_ON is choosing whether a
box should be forcibly killed or not and nothing more.

You've clearly got a use-case in mind where WARN_ON + !CONFIG_BUG
isn't doing what you want, please share it with us.

-- 
Mathematics is the supreme nostalgia of our time.
