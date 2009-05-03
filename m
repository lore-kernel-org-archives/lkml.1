Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbZECG20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbZECG20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 02:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZECG2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 02:28:18 -0400
Received: from [212.69.161.110] ([212.69.161.110]:51192 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbZECG2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 02:28:17 -0400
Date: Sun, 3 May 2009 08:27:20 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 02/16] DRBD: lru_cache
Message-ID: <20090503062720.GA31340@racke>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-2-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-3-git-send-email-philipp.reisner@linbit.com> <f73f7ab80905021651y54db1e69y87f0487bc06f0522@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f73f7ab80905021651y54db1e69y87f0487bc06f0522@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 02, 2009 at 07:51:36PM -0400, Kyle Moffett wrote:
> After digging through this a bit, I would recommend rewriting this
> whole part.  The part that definitely needs to go is the vmalloc() of
> your whole LRU at once.
> 
> Here's some code I've been fiddling around with for a while.  It uses
> a kmem_cache and a shrinker callback (although it does need a small
> patch to the shrinker code) to provide a dynamically sized LRU list
> for fixed-size objects.

Thanks.

When we created our lru_cache stuff, we considered embedding callbacks
and internal locking, but decided against it.  Conceptually it should be
more like the "list.h" list handling infrastructure.

The user will have their own locking in place anyways, and in general
their critical section will be a few lines of code larger than the
"lru cache" manipulation itself.

And, the specific use of our implementation is that there is a
pre-selected maximum count of in-use objects, and the user gets
feedback about changes to this "active" set of objects.

Think of a small room with N seats, and one entrance.
Any number of people outside.
Only N fit in the room.
Seats are numbered (index), people have id (element number).

Our lru_cache implementation is the man at the door,
keepeing track of which seats are empty,
and seeing to it that if one needs to go in,
either there is an empty seat available,
or first the "most dispensable" one gets out.

That is where the focus is:
make the set of active objects easily trackable.
So one can easily keep track of who is in, and who is not,
by writing a log of just this "diff":
seat index was occupied by element_nr A, but now is by element_nr B.

The lru part is to make it more easy to determine
who the "most dispensable" is.

So from looking at your code, it may be fine for the "lru" part,
but it is not suitable for our purposes.

	Lars
