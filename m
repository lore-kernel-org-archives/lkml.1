Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbYJCEIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbYJCEIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 00:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750721AbYJCEIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 00:08:06 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:24496 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750746AbYJCEIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 00:08:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=OvtQNOT86ex0ijJkIv4va9Alsufikh637s0pySqWULM2oQhyZC9/VZYQR71YAzP0yFpYUzKten9wc06yJu/6oHNhLiiM5h1dN5yrRufL+Cq6Nhd+VTXCgWKIpkfVqAqkiwK6hp3REAsXPGghlQV0j39j+j7sH0SMofCLdGElRks=  ;
X-YMail-OSG: pSs75IwVM1mWoRnI6E.ZfgOp6LHExRDluFRbrOmJ9Wu2w5NMrQFRnh6rLQN4uXW84KHrsF9VX.oajTZHNxi54muEgJtbxKWla.jZhwXEpc37I5ra2QJcphUo5AioMG2CrOh2O8lexbblcJxthaQQRuhnAOE9MoO9Ve9WMtlc7HH6KAtF7uM-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Memory management livelock
Date: Fri, 3 Oct 2008 14:07:55 +1000
User-Agent: KMail/1.9.5
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, agk@redhat.com, mbroz@redhat.com,
       chris@arachsys.com
References: <20080911101616.GA24064@agk.fab.redhat.com> <200810031347.21586.nickpiggin@yahoo.com.au> <20081002205604.47910d6d.akpm@linux-foundation.org>
In-Reply-To: <20081002205604.47910d6d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810031407.55406.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 October 2008 13:56, Andrew Morton wrote:
> On Fri, 3 Oct 2008 13:47:21 +1000 Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> > > I expect there's no solution which avoids blocking the writers at some
> > > stage.
> >
> > See my other email. Something roughly like this would do the trick
> > (hey, it actually boots and runs and does fix the problem too).
>
> It needs exclusion to protect all those temp tags.  Is do_fsync()'s
> i_mutex sufficient?  It's qute unobvious (and unmaintainable?) that all
> the callers of this stuff are running under that lock.

Yeah... it does need a lock, which I brushed under the carpet :P
I was going to just say use i_mutex, but then we really would start
impacting on other fastpaths (eg writers).

Possibly a new mutex in the address_space? That way we can say
"anybody who holds this mutex is allowed to use the tag for anything"
and it doesn't have to be fsync specific (whether that would be of
any use to anything else, I don't know).


> > It's ugly because we don't have quite the right radix tree operations
> > yet (eg. lookup multiple tags, set tag X if tag Y was set, proper range
> > lookups). But the theory is to up-front tag the pages that we need to
> > get to disk.
>
> Perhaps some callback-calling radix tree walker.

Possibly, yes. That would make it fairly general. I'll have a look...


> > Completely no impact or slowdown to any writers (although it does add
> > 8 bytes of tags to the radix tree node... but doesn't increase memory
> > footprint as such due to slab).
>
> Can we reduce the amount of copy-n-pasting here?

Yeah... I went to break the sync/async cases into two, but it looks like
it may not have been worthwhile. Just another branch might be the best
way to go.

As far as the c&p in setting the FSYNC tag, yes that should all go away
if the radix-tree is up to scratch. Basically:

radix_tree_tag_set_if_tagged(start, end, ifWRITEBACK|DIRTY, setFSYNC);

should be able to replace the whole thing, and we'd hold the tree_lock, so
we would not have to take the page lock etc. Basically it would be much
nicer... even somewhere close to a viable solution.
