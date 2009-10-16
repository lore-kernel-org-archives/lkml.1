Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbZJPBc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbZJPBc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 21:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756941AbZJPBcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 21:32:55 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59674 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028AbZJPBcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 21:32:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 16 Oct 2009 10:29:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
       hongshin@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 7/9] swap_info: swap count continuations
Message-Id: <20091016102951.a4f66a19.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0910160016160.11643@sister.anvils>
References: <Pine.LNX.4.64.0910150130001.2250@sister.anvils>
	<Pine.LNX.4.64.0910150153560.3291@sister.anvils>
	<20091015123024.21ca3ef7.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0910160016160.11643@sister.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Oct 2009 00:53:36 +0100 (BST)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> On Thu, 15 Oct 2009, KAMEZAWA Hiroyuki wrote:
> > On Thu, 15 Oct 2009 01:56:01 +0100 (BST)
> > Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> > 
> > > This patch implements swap count continuations: when the count overflows,
> > > a continuation page is allocated and linked to the original vmalloc'ed
> > > map page, and this used to hold the continuation counts for that entry
> > > and its neighbours.  These continuation pages are seldom referenced:
> > > the common paths all work on the original swap_map, only referring to
> > > a continuation page when the low "digit" of a count is incremented or
> > > decremented through SWAP_MAP_MAX.
> > 
> > Hmm...maybe I don't understand the benefit of this style of data structure.
> 
> I can see that what I have there is not entirely transparent!
> 
> > 
> > Do we need fine grain chain ? 
> > Is  array of "unsigned long" counter is bad ?  (too big?)
> 
> I'll admit that that design just happens to be what first sprang
> to my mind.  It was only later, while implementing it, that I
> wondered, hey, wouldn't it be a lot simpler just to have an
> extension array of full counts?
> 
> It seemed to me (I'm not certain) that the char arrays I was
> implementing were better suited to (use less memory in) a "normal"
> workload in which the basic swap_map counts might overflow (but
> I wonder how normal is any workload in which they overflow).
> Whereas the array of full counts would be better suited to an
> "aberrant" workload in which a mischievous user is actually
> trying to maximize those counts.  I decided to carry on with
> the better solution for the (more) normal workload, the solution
> less likely to gobble up more memory there than we've used before.
> 
> While I agree that the full count implementation would be simpler
> and more obviously correct, I thought it was still going to involve
> a linked list of pages (but "parallel" rather than "serial": each
> of the pages assigned to one range of the base page).
> 
> Looking at what you propose below, maybe I'm not getting the details
> right, but it looks as if you're having to do an order 2 or order 3
> page allocation?  Attempted with GFP_ATOMIC?  I'd much rather stick
> with order 0 pages, even if we do have to chain them to the base.
> 
order-0 allocation per array entry.

   1st leve map     2nd level map
   
   map          ->  array[0] -> map => PAGE_SIZE map.
                         [1] -> map => PAGE_SIZE map.
                         ...
                         [7] -> map == NULL if not used.


> (Order 3 on 64-bit?  A side issue which deterred me from the full
> count approach, was the argumentation we'd get into over how big a
> full count needs to be.  I think, for so long as we have atomic_t
> page count and page mapcount, an int is big enough for swap count.
I see.

> But switching them to atomic_long_t may already be overdue.
> Anyway, I liked how the char continuations avoided that issue.)
> 
My concern is that small numbers of swap_map[] which has too much refcnt
can consume too much pages.

If an entry is shared by 65535, 65535/128 = 512 page will be used.
(I'm sorry if I don't undestand implementation correctly.)


> I'm reluctant to depart from what I have, now that it's tested;
> but yes, we could perfectly well replace it by a different design,
> it is very self-contained.  The demands on this code are unusually
> simple: it only has to manage counting up and counting down;
> so it is very easily tested.
> 
Okay, let's start with this.



Thanks,
-Kame

