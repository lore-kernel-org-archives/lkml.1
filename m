Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752921AbYLRJ3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbYLRJ3d (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 04:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbYLRJ3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 04:29:16 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:46843 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbYLRJ3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 04:29:14 -0500
Date: Thu, 18 Dec 2008 01:27:44 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        swhiteho@redhat.com
Subject: Re: [PATCH] configfs: Silence lockdep on mkdir(), rmdir() and
	configfs_depend_item()
Message-ID: <20081218092744.GB30789@mail.oracle.com>
Mail-Followup-To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Andrew Morton <akpm@linux-foundation.org>,
	Louis Rilling <louis.rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
	swhiteho@redhat.com
References: <20081212100615.GD19128@hawkmoon.kerlabs.com> <1229095751-23984-1-git-send-email-louis.rilling@kerlabs.com> <20081217134020.42da55fc.akpm@linux-foundation.org> <1229585208.9487.112.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229585208.9487.112.camel@twins>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.494A17C6.013F:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 08:26:48AM +0100, Peter Zijlstra wrote:
> On Wed, 2008-12-17 at 13:40 -0800, Andrew Morton wrote:
> > On Fri, 12 Dec 2008 16:29:11 +0100
> > Louis Rilling <louis.rilling@kerlabs.com> wrote:
> > > >From inside configfs it is not possible to serialize those recursive
> > > locking with a top-level one, because mkdir() and rmdir() are already
> > > called with inodes locked by the VFS. So using some
> > > mutex_lock_nest_lock() is not an option.

<snip>

> > 
> > Oh dear, what an unpleasant patch.
> > 
> > Peter, can this be saved?
> 
> I'm still not sure why configfs is the only virtual filesystem that
> suffers this - something in its design is weird (and not so wonderfull).
> 
> Also, while I usually applaud fine grained locking, is configfs really
> in need of that?, I mean, its not like its meant to create and remove
> directories all day every day at breakneck speed, right? AFAIK you just
> stomp some data in to configure some kernel stuff and then let it sit
> for the duration of whatever that kernel thing does while it does it.

	It's not about breakneck speed, it's about living in the VFS.
But I think you get that later.

> See I'm not even clear on what configfs is.. and why its better than
> sysfs for example.. - /me goes read configfs.txt
> 
> Right, so basically we avoid syscalls by making vfs ops do stuff..
> lovely - still not seeing it though - regular filesystems seems to cope
> just fine and they get to create arbitrary tree structures too.

	It's about the default_groups and how they build up and tear
down small bits of tree.
	A simple creation of a config_item, a mkdir(2), is a normal VFS
lock set and doesn't make lockdep unhappy.  But if the new config_item
has a default_group or two, they need locking too.  Not so much on
mkdir(2), but on rmdir(2).

> Yes lockdep has 2 major weaknesses - 1) it doesn't support arbitrary
> lock depths (and I've tried, twice, to fix that, but its a _hard_
> problem) and 2) it can't deal with arbitrary recursion.

	I know it's hard, or I'd have sent you patches :-)  In fact,
Louis tried to use the subclass bits to make this work to a depth of N
(where N was probably deep enough in practice).  However, this creates
subclasses that don't get seen by the regular VFS locking - and the big
deal here is making sure configfs's use of i_mutex meshes with the VFS.
That is, his code made the warnings go away, but removed much of
lockdep's ability to see when we got the locking wrong.

> The thing is, in practise it turns out that reworking code to not run
> into these issues often makes the code better - if only for the fact
> that taking locks is expensive and doing less is better, and holding
> locks stifles concurrency, so holding less it better (yes, I said
> _often_, there likely are counter cases but I don't believe configfs is
> one of them).

	This isn't about concurrency or speed.  This is about safety
while configfs is attaching or (especially) detaching config_items from
the filesystem view it presents.  When the VFS travels down a path, it
unlocks the trailing directory.  We can't do that when tearing down
default groups, because we need to lock that small hunk and tear it out
atomically.

> Anyway - I'm against just turning lockdep off, that will make folks
> complacent and let the stuff rot to bits inside - and I for one will
> refuse to run anything using it (but since that only seems to be
> dlm/ocfs and I'm of the believe that centralized cluster stuff sucks
> rocks anyway that won't be a problem).

	Oh, be nice :-)
	You are absolutely right that turning off lockdep leaves the
possibility of complacency and bitrot.  That's precisely why I didn't
like Louis' subclass solution - again, bitrot might go unnoticed.
	Now, I know that I will be paying attention to the locking and
going over it with a fine-toothed comb.  But I'd much rather have an
actual working lockdep analysis.  Whether that means we find a way for
lockdep to describe what's happening here, or we find another way to
keep folks out of the tree we're removing, I don't care.

Joel

-- 

Life's Little Instruction Book #109

	"Know how to drive a stick shift."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
