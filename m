Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab0BKTON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 14:14:13 -0500
Received: from cs-studio.ru ([195.178.208.66]:49606 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756795Ab0BKTOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 14:14:11 -0500
Date: Thu, 11 Feb 2010 22:13:50 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [WTF] ... is going on with current->fs->{root,mnt} accesses in pohmelfs
Message-ID: <20100211191350.GA32369@ioremap.net>
References: <20100210104515.GA6207@ioremap.net> <20100210110011.GN30031@ZenIV.linux.org.uk> <20100210111115.GA8376@ioremap.net> <20100210115938.GO30031@ZenIV.linux.org.uk> <20100210133007.GA17744@ioremap.net> <20100210210248.GP30031@ZenIV.linux.org.uk> <20100210212933.GA19919@ioremap.net> <20100211030253.GQ30031@ZenIV.linux.org.uk> <20100211150805.GA18705@ioremap.net> <20100211171018.GR30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100211171018.GR30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 05:10:18PM +0000, Al Viro (viro@ZenIV.linux.org.uk) wrote:
> > No, it happens with my lock held. It is not a lock, but kind of
> > IO delegation, i.e. it is not dropped when rename or other protected
> > operation completed. Instead another client sends request to grab it and
> > server asks current holder to drop cache, perform writeback or whatever
> > else is needed.
> 
> And should such a request come between return from ->rename() and call
> of d_move() that follows it?

We mark inode dirty (including parent) and it has to be written back thus
there will be no ack until writeback completed, which in turn messes
with i_mutex, so will be postponed until rename and d_move() completed.

> > It can be a problem though if d_move() is called outside of path
> > protected by the VFS dir operations like rename/created/unlink and so
> > on, i.e. on behalf of some entity in the kernel which decides to move
> > dentries on itself. In this case POHMELFS is not protected.
> 
> Not an issue; there's no such fs-independent callers.
> 
> Fundamentally, how do you deal with MOESI when the mapping from strings you
> are using as object IDs to actual objects can change as the result of
> operations?  What's more, operation on one object can change that mapping
> for a huge number of other objects (rename() close to fs root changing
> pathnames of all files anywhere in the subtree being moved).

MOESI is actually a crap in a clustered filesystem. It does not scale
well since number of messages grows exponentially with nodes and
interconnects. Plus without PAXOS it does not provide needed redundancy
level.

Basic idea currently is to delegate every operation and ask server if it
is allowed or not. Thus server-side locking must be serialized to that
level. I believe that i_mutex is enough there - its the only lock used
actually except in some helpers like d_path().

-- 
	Evgeniy Polyakov
