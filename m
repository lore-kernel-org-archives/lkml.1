Return-Path: <linux-kernel-owner+w=401wt.eu-S1753639AbYJCMbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbYJCMbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 08:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750699AbYJCMbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 08:31:14 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:22991 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750866AbYJCMbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 08:31:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dFqMn1LLJ/RHsNP2mtQy0wcugdXV3DovwVkLtK+kr4mEMUCPvLbt4PLiHxaqL9PnDXt2NXCrXdQ6I7rg8Ilw83pQg/zPL56XXLKYGoLxCSoAY9KfTV/NGOh6/xVIErf3NboAZsuGO+EVPF85nOYlSb8+if3qyuzhInkZX1LPy+o=  ;
X-YMail-OSG: xItp3MAVM1l.aXq6j_l.DN8kiCwamRxixySUK3mFj9GFexd_F2YtiOKJ90fu9JcOOOX0yj.uGm9G_viIwBmpSo7uRw3WybCNWKEHQyvWKvytGY0Eg13M6MLY9mEQtb4hoGNilOg99e_N5vd4drrH.AJqnISiBw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] Memory management livelock
Date: Fri, 3 Oct 2008 22:31:03 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, agk@redhat.com, mbroz@redhat.com,
       chris@arachsys.com
References: <20080911101616.GA24064@agk.fab.redhat.com> <200810031254.29121.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0810030716310.4875@hs20-bc2-1.build.redhat.com>
In-Reply-To: <Pine.LNX.4.64.0810030716310.4875@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810032231.03985.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 October 2008 21:26, Mikulas Patocka wrote:
> > > *What* is, forever? Data integrity syncs should have pages operated on
> > > in-order, until we get to the end of the range. Circular writeback
> > > could go through again, possibly, but no more than once.
> >
> > OK, I have been able to reproduce it somewhat. It is not a livelock,
> > but what is happening is that direct IO read basically does an fsync
> > on the file before performing the IO. The fsync gets stuck behind the
> > dd that is dirtying the pages, and ends up following behind it and
> > doing all its IO for it.
> >
> > The following patch avoids the issue for direct IO, by using the range
> > syncs rather than trying to sync the whole file.
> >
> > The underlying problem I guess is unchanged. Is it really a problem,
> > though? The way I'd love to solve it is actually by adding another bit
> > or two to the pagecache radix tree,  that can be used to transiently tag
> > the tree for future operations. That way we could record the dirty and
> > writeback pages up front, and then only bother with operating on them.
> >
> > That's *if* it really is a problem. I don't have much pity for someone
> > doing buffered IO and direct IO to the same pages of the same file :)
>
> LVM does (that is where the bug was discovered). Basically, it scans all
> the block devices with direct IO and if someone else does buffered IO on
> any device simultaneously, it locks up.

Scans all block devices with direct IO? Hmm, why, I wonder? Should
really consider using buffered (posix_fadvise to readahead/dropbehind).


> That fsync-vs-write livelock is quite improbably (why would some
> application do it?) --- although it could be used as a DoS --- getting
> unkillable process.

I'm not sure.
