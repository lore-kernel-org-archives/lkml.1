Return-Path: <linux-kernel-owner+w=401wt.eu-S1761339AbYCXOr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761339AbYCXOr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 10:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759734AbYCXOrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 10:47:05 -0400
Received: from lazybastard.de ([212.112.238.170]:50553 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758539AbYCXOrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 10:47:03 -0400
Date: Mon, 24 Mar 2008 15:46:47 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       Greg KH <greg@kroah.com>, dwmw2 <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>,
       linux-sh <linux-sh@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] 3/3 maple: update bus driver to support Dreamcast VMU
Message-ID: <20080324144647.GC2899@logfs.org>
References: <1206207805.6324.13.camel@localhost.localdomain> <1206209786.6324.41.camel@localhost.localdomain> <20080324033344.GB15872@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080324033344.GB15872@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 March 2008 12:33:44 +0900, Paul Mundt wrote:
> 
> So here we have the same issue as in the previous patch, but with the
> mutex API instead. The entire point of adding a comment for clarity is
> that it becomes obvious what this is trying to accomplish, which it still
> isn't. Maple shouldn't require a supplemental document to detail its
> locking strategy in a way that doesn't induce blindness.
> 
> The mutex_unlock() here looks very suspicious. You first try to grab the
> lock via the trylock, if it's contended, then you try to unlock it and
> then grab it again for yourself before continuing on. This sort of
> juggling looks really racy. Under what conditions will this lock be
> contended, and under what conditions is it released? If you have a
> transfer in place, you contend on the lock, and then this code suddenly
> unlocks, what happens to your queue? It seems like you are trying to lock
> down the mq for the duration of its lifetime, in addition to having a
> separate list lock for guarding against the list getting mangled from
> underneath you.
> 
> It looks like you are trying to roll your own complex queuing mechanism
> in a fairly non-obvious fashion. Have you considered using things like
> the block layer qeueing for dealing with a lot of this for you? This is
> what we ended up using for OMAP mailboxes and it worked out pretty well
> (arch/arm/plat-omap/mailbox.c) there.
> 
> This sort of obscure locking is going to cause you nothing but trouble in
> the long run.

As a general rule, locks should be taken and released in the same
function.  That allows the locking to be easily reviewed and errors
are easy to spot for most readers.

int foo(void)
{
	int err;

	err = bar();
	if (err)
		return err;
	mutex_lock(&foo_lock);
	err = baz();
	if (err)
		return err;
	mutex_unlock(&foo_lock);
	return bumble();
}

In the above example, one doesn't have to think twice, the bugfix
becomes almost mechanical.  But as soon as locks are taken in one
function and released in another, things get hairy.

int foo(void)
{
	int err;

	err = bar();
	if (err)
		return err;
	mutex_lock(&foo_lock);
	err = baz();
	/* baz implicitly unlocks the mutex */
	if (err)
		return err;
	return bumble();
}

Even with the comment, one cannot be sure.

int baz(void)
{
	int err;

	err = bee();
	if (err)
		return err;
	mutex_unlock(&foo_lock);
	return boo();
}

One always has to check all functions involved.  If bee() returns an
error, neither foo() nor baz() will unlock the mutex.  And after
changing baz() to always unlock the mutex, one next needs to check all
callers whether any of them unlock on errors.  Under some circumstances
those would have been correct before, but not after.  Unless...

In short, verifying the locking is about the least pleasurable thing to
do once locks are taken and released in seperate functions.

Jörn

-- 
He who knows others is wise.
He who knows himself is enlightened.
-- Lao Tsu
