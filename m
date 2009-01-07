Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbZAGBt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbZAGBt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 20:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbZAGBtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 20:49:17 -0500
Received: from mx1.suse.de ([195.135.220.2]:58702 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbZAGBtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 20:49:17 -0500
Date: Wed, 7 Jan 2009 02:49:15 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090107014915.GE3390@wotan.suse.de>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090106225744.GA10553@infradead.org> <20090106151131.b6c4ff0b.akpm@linux-foundation.org> <20090106232418.GB25103@infradead.org> <20090107011448.GB3390@wotan.suse.de> <87tz8b3nfe.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tz8b3nfe.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 02:38:45AM +0100, Andi Kleen wrote:
> Nick Piggin <npiggin@suse.de> writes:
> >
> > I can't see a problem with putting a global mutex around sys_sync (almost
> > by definition, any app in the last 10+ years that calls sys_sync is not
> > performance critical).
> 
> Hmm, but sync() used to (is still?) livelocky and when it takes a

It's not livelocky because it no longer has to do repeated passes
over the superblock list. It is subject to the single inode syncing
issue where it can get stuck behind a process dirtying memory (same
as fsync) but we've decided not to add complexity to improve that
just yet, and see whether it turns out to be a real problem.


> minute or so to flush (and I've seen that) do you really want any
> other sync user to block for a minute too?

sys_sync B which is invoked *after* sys_sync caller A should not
return before A. If you didn't have a global lock, they'd tend to
block one another's pages anyway. I think it's OK.

