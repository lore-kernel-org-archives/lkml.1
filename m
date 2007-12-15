Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbXLOFxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbXLOFxT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 00:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbXLOFxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 00:53:10 -0500
Received: from waste.org ([66.93.16.53]:33955 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbXLOFxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 00:53:09 -0500
Date: Fri, 14 Dec 2007 23:52:18 -0600
From: Matt Mackall <mpm@selenic.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Make WARN_ON/WARN_ON_ONCE no-ops when CONFIG_BUG is off
Message-ID: <20071215055218.GM19691@waste.org>
References: <20071214132755.GA18309@gondor.apana.org.au> <20071214180246.GT17536@waste.org> <20071215041659.GB25324@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071215041659.GB25324@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2007 at 12:16:59PM +0800, Herbert Xu wrote:
> On Fri, Dec 14, 2007 at 12:02:46PM -0600, Matt Mackall wrote:
> >
> > I added CONFIG_BUG, and I think the current behavior is correct. As
> > you've noticed, we have to evaluate condition, it may have
> > side-effects. And if code does:
> > 
> > 	/* this indicates a driver bug, report and fail gracefully */
> > 	if (WARN_ON(val == NULL))
> > 		return -EFAULT;
> 
> That's exactly the sort of use I had in mind :) I'm actually the
> one who added the ability to use WARN_ON inside an if clause.
> 
> Just as the case of a BUG_ON, a WARN_ON should never occur in
> practice, unless there is a bug which the code is not aware of.

Agreed.

> As such we want it to go away completely if CONFIG_BUG is off.

No. The code as written above should reduce to:

	if (val == NULL)
		return -EFAULT;

If I hadn't wanted to return -EFAULT in this case, I would have just written:

	WARN_ON(val == NULL);

I don't want code that was running safely (ie returning -EFAULT) to
start crashing the system just because I've, say, disabled printk.
That's creating an obnoxious heisenbug.

> > ..we surely want it to continue returning -EFAULT, regardless of
> > whether we log it, no? What use case did you have in mind?
> 
> If you're using it for a scenario which is known to actually
> occur, then some other mechanism should be chosen in place of
> WARN_ON.

Then I kindly submit that you should instead withdraw the code that
allows you to use WARN_ON in a condition in the first place.

Note that Dave Jones is currently poking at making WARN_ON
out-of-line, so you're liable to collide with him.

-- 
Mathematics is the supreme nostalgia of our time.
