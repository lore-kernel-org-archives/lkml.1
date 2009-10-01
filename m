Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbZJACQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbZJACQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 22:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbZJACQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 22:16:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:58835 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755433AbZJACQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 22:16:53 -0400
Date: Thu, 1 Oct 2009 04:16:57 +0200
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 03/33] fs: scale files_lock
Message-ID: <20091001021657.GO6327@wotan.suse.de>
References: <20090904065142.114706411@nick.local0.net> <20090904065534.303326352@nick.local0.net> <1254144248.15795.6.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254144248.15795.6.camel@laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 03:24:08PM +0200, Peter Zijlstra wrote:
> On Fri, 2009-09-04 at 16:51 +1000, npiggin@suse.de wrote:
> > Improve scalability of files_lock by adding per-cpu, per-sb files lists,
> > protected with per-cpu locking. Effectively turning it into a big-writer
> > lock.
> 
> What I did was fine-grain locking the double linked list so that you can
> delete items without hitting a global lock.
> 
> For addition I added per-cpu list-heads that would be spliced onto the
> global list once in a while.
> 
> Granted, the code was a tad involved... and hch wanted to get rid of
> these lists, which is of course a much better solution.

I did see that of course, and I sent you a critique of it... I
didn't think it was appropriate for reasons I can't remember off
hand (either overly complex for the same task, or had a scalability
problem).

files_lock I would love to see go away completely, and in fact
depending on progress of work to that end, these patches may never
need to be merged. The problem I have is:

1. I don't want to significantly change data structures or cause
   avoidable reductions in potential expressiveness of the data
   structures we have. (I don't want someone to complain that my
   patches suck because they want to be able to traverse files).

2. I need to take out this lock otherwise it become the choke
   point and hides the rest of the progress on the rest of the
   scalability work.

Again, I think brlock is not such a terrible thing for contention
especially if we're looking at umount slowpath... For this guy
actually though, the read side can probably be turned into RCU
traversal quite easily, I _think_.

