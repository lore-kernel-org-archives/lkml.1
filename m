Return-Path: <linux-kernel-owner+w=401wt.eu-S1752471AbYKXGiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbYKXGiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 01:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087AbYKXGiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 01:38:09 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41568 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbYKXGiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 01:38:08 -0500
Date: Mon, 24 Nov 2008 06:38:06 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 1/2] md: make devices disappear when they are no longer
	needed.
Message-ID: <20081124063806.GA28946@ZenIV.linux.org.uk>
References: <20081124035516.3465.66413.stgit@notabene.brown> <20081124035530.3465.26724.stgit@notabene.brown> <20081124042421.GY28946@ZenIV.linux.org.uk> <18730.12791.348848.849033@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18730.12791.348848.849033@notabene.brown>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 03:47:51PM +1100, Neil Brown wrote:

> > What lifetime rules do you really want?  I never liked the tricks pulled
> > by md wrt gendisk lifetimes and that might be a good time to sort that
> > out for good...
> 
> I'm not sure what 'tricks' you are referring to.  Can you elaborate?
> 
> I want the gendisk to appear as soon as it is needed (not because I
> think that is necessarily a good idea, but it is legacy functionality that I
> don't think we can easily discard).  And I want them to disappear when
> they contain no information and have nothing referring to them.

"Tricks" are about md_probe() and weird allocation time for these suckers.
But OK, legacy API is a good argument.

So you want the rules of the same nature as for module refcount?  Then
the natural place to do that would be in failure exit of __blkdev_get()
and in normal path in blkdev_put() (for the final opener going away).

However, let's try to do it right - there's a *lot* of drivers where
we do no work in ->release() until it's the final one.  It would be
nice to accomodate them as well while we are at it...
