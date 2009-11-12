Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbZKLWBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbZKLWBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 17:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbZKLWBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 17:01:31 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:23900 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbZKLWBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 17:01:30 -0500
Date: Thu, 12 Nov 2009 17:00:05 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [PATCH 0/7] Reduce GFP_ATOMIC allocation failures, candidate
 fix V3
Message-ID: <20091112220005.GD2811@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Mel Gorman <mel@csn.ul.ie>,
	Andrew Morton <akpm@linux-foundation.org>,
	Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
	Sven Geggus <lists@fuchsschwanzdomain.de>,
	Karol Lewandowski <karol.k.lewandowski@gmail.com>,
	Tobias Oetiker <tobi@oetiker.ch>, linux-kernel@vger.kernel.org,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Rik van Riel <riel@redhat.com>,
	Christoph Lameter <cl@linux-foundation.org>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Kernel Testers List <kernel-testers@vger.kernel.org>
References: <1258054211-2854-1-git-send-email-mel@csn.ul.ie>
 <20091112202748.GC2811@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112202748.GC2811@think>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4AFC8572.0089:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 03:27:48PM -0500, Chris Mason wrote:
> On Thu, Nov 12, 2009 at 07:30:06PM +0000, Mel Gorman wrote:
> > Sorry for the long delay in posting another version. Testing is extremely
> > time-consuming and I wasn't getting to work on this as much as I'd have liked.
> > 
> > Changelog since V2
> >   o Dropped the kswapd-quickly-notice-high-order patch. In more detailed
> >     testing, it made latencies even worse as kswapd slept more on high-order
> >     congestion causing order-0 direct reclaims.
> >   o Added changes to how congestion_wait() works
> >   o Added a number of new patches altering the behaviour of reclaim
> > 
> > Since 2.6.31-rc1, there have been an increasing number of GFP_ATOMIC
> > failures. A significant number of these have been high-order GFP_ATOMIC
> > failures and while they are generally brushed away, there has been a large
> > increase in them recently and there are a number of possible areas the
> > problem could be in - core vm, page writeback and a specific driver. The
> > bugs affected by this that I am aware of are;
> 
> Thanks for all the time you've spent on this one.  Let me start with
> some more questions about the workload ;)
> 
> So the workload is gitk reading a git repo and a program reading data
> over the network.  Which part of the workload writes to disk?

Sorry for the self reply, I started digging through your data (man,
that's a lot of data ;).  I took another tour through dm-crypt and
things make more sense now.

dm-crypt has two different single threaded workqueues for each dm-crypt
device.  The first one is meant to deal with the actual encryption and
decryption, and the second one is meant to do the IO.

So the path for a write looks something like this:

filesystem -> crypt thread -> encrypt the data -> io thread -> disk

And the path for read looks something like this:

filesystem -> io thread -> disk -> crypt thread -> decrypt data -> FS

One thread does encryption and one thread does IO, and these threads are
shared for reads and writes.  The end result is that all of the sync
reads get stuck behind any async write congestion and all of the async
writes get stuck behind any sync read congestion.

It's almost like you need to check for both sync and async congestion
before you have any hopes of a new IO making progress.

The confusing part is that dm hasn't gotten any worse in this regard
since 2.6.30 but the workload here is generating more sync reads
(hopefully from gitk and swapin) than async writes (from the low
bandwidth rsync).  So in general if you were to change mm/*.c wait
for sync congestion instead of async, things should appear better.

The punch line is that the btrfs guy thinks we can solve all of this with
just one more thread.  If we change dm-crypt to have a thread dedicated
to sync IO and a thread dedicated to async IO the system should smooth
out.

-chris

