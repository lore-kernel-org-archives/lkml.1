Return-Path: <linux-kernel-owner+w=401wt.eu-S1752118AbXBDGfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbXBDGfx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 01:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbXBDGfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 01:35:53 -0500
Received: from 1wt.eu ([62.212.114.60]:2248 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbXBDGfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 01:35:52 -0500
Date: Sun, 4 Feb 2007 07:35:37 +0100
From: Willy Tarreau <w@1wt.eu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Roland Dreier <rdreier@cisco.com>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       linux-kernel@vger.kernel.org
Subject: Re: A CodingStyle suggestion
Message-ID: <20070204063537.GH24090@1wt.eu>
References: <20070203215848.GA10440@Ahmed> <45C51310.6070304@student.ltu.se> <20070204000532.GA20721@Ahmed> <aday7neydq9.fsf@cisco.com> <20070203164042.237f156b.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070203164042.237f156b.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 03, 2007 at 04:40:42PM -0800, Randy Dunlap wrote:
> On Sat, 03 Feb 2007 16:21:18 -0800 Roland Dreier wrote:
> 
> >  > Good catch :). A small grep of `access_ok' reveals that it's always used in the 
> >  > form of:
> >  > if (!access_ok()) { .. }
> >  > 
> >  > I can conclude that verbal/imperative methods like `kmalloc, add_work' be 
> >  > checked as:
> >  > ret = do_work();
> >  > if (ret) { ... }
> >  > and predicate methods like `acess_ok, pci_dev_present' be checked like:
> >  > if (!access_ok) { ... }
> >  > if (pci_dev_present) { ...}
> >  > 
> >  > Any comments ?
> > 
> > I don't think that's really the distinction that matters.  I think
> > really the issue is that assignment within an if is hard to read, so
> > 
> > 	ret = foo(a, b);
> >         if (ret) { ... }
> > 
> > is clearly preferred to
> > 
> > 	if ((ret = foo(a,b))) { ... }
> > 
> > However, in my opinion something like
> > 
> > 	if (foo(a,b)) { ... }
> > 
> > if perfectly fine if the return value of foo is not needed anywhere
> > else.  In other words, there's no sense introducing a temporary
> > variable to hold the return value if you're never going to do anything
> > with it other than check it on the next line.
> 
> I agree with Roland's comments here.
> 
> And with Tim's about side effects.

Generally, a function which only returns a boolean is fine in a condition,
because that's exactly how the result will be used. The problem with
functions in if() is that many ifs are used to check for errors, and
during debugging phases, it's quite common to comment out an if block.

So the functions with side effects, including those who modify the
arguments, should never be used in a if() or while() which might be
commented out.

So the following block should be OK :

	if (!netif_running(dev)) {
		reset_driver(dev);
		retry--;
	}

While the following one is dangerous :

	if (!read_next_word(hw, &word))
		return -EINVAL;

During debugging, a block like above might end up like this :

	if (!read_next_word(hw, &word));
	//	return -EINVAL;

You can imagine what will result from this code later : the
return will be uncommented and the semi-colon forgotten :

	if (!read_next_word(hw, &word));
		return -EINVAL;

We have already found many bugs following this exact construction.
With the obvious solution, there would be no problem :

	ret = read_next_word(hw, &word);
	if (!ret)
		return -EINVAL;

Best regards,
Willy

