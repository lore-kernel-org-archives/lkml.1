Return-Path: <linux-kernel-owner+w=401wt.eu-S1751403AbZAZOTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbZAZOTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 09:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbZAZOTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 09:19:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37882 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbZAZOTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 09:19:34 -0500
Subject: Re: [PATCH] configfs: Silence lockdep on mkdir(), rmdir() and
 configfs_depend_item()
From: Peter Zijlstra <peterz@infradead.org>
To: Louis.Rilling@kerlabs.com
Cc: Joel Becker <Joel.Becker@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com, swhiteho <swhiteho@redhat.com>
In-Reply-To: <20090126140032.GE7532@hawkmoon.kerlabs.com>
References: <1229095751-23984-1-git-send-email-louis.rilling@kerlabs.com>
	 <20081217134020.42da55fc.akpm@linux-foundation.org>
	 <1229585208.9487.112.camel@twins> <20081218092744.GB30789@mail.oracle.com>
	 <1229601399.9487.218.camel@twins> <1229603308.9487.227.camel@twins>
	 <20081218225837.GB21870@mail.oracle.com> <1232973009.4863.76.camel@laptop>
	 <20090126132453.GD7532@hawkmoon.kerlabs.com>
	 <1232977283.4863.79.camel@laptop>
	 <20090126140032.GE7532@hawkmoon.kerlabs.com>
Content-Type: text/plain
Date: Mon, 26 Jan 2009 15:19:22 +0100
Message-Id: <1232979562.4863.101.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-26 at 15:00 +0100, Louis Rilling wrote:

> > Its not a locking correctness thing, but simply not being able to do it
> > from the vfs calls because those assume locks held?
> > 
> > Can't you simply punt the work to a worklet once you've created/removed
> > the non-default group, which can be done from within the vfs callback ?
> 
> I'm not sure to understand your suggestion. Is this:
> 1) for mkdir(), create the non-default group, but without its default groups,
> and defer their creation to a worker which won't have constraints on locks held
> by any caller;
> 2) for rmdir(), unlink the non-default group, but without unlinking its default
> groups, and defer the recursive work to a lock-free context?
> 
> For mkdir(), this may work. Maybe a bit confusing for userspace, since mkdir(A)
> returns as soon as A is created, but A may be populated later and userspace may
> rely on A being populated as soon as it is created (current behavior). As a
> configfs user, this makes my life harder...

Right, so that is the whole crux of the matter?

Initially I understood the whole recursive locking issue to be about
having to serialize mkdir vs rmdir so that you would know the default
groups to be empty etc.

You could create the subtree before you link it in. i_op->mkdir() only
has the parent i_mutex held, so you should be able to create your inode,
and all default groups (some of who will have the non-default group as
parent, but that's ok, as we don't have that locked yet).

Once you've constructed this, you could connect the non-default group to
its parent.

Also, you don't _need_ to have any i_mutex's locked here, because non of
these inodes are reachable.

> For rmdir(), is this safe to unlink a non-empty directory, and to empty it
> afterwards? This looks like going back to the unmount problem.

Dunno :-), I think it should be safe. The only guarantee you need is
that there are no refs to inodes in the decoupled sub-tree (other than
your own of course.)

So you'd only need to punt the rmdir cleanup to eventd or something.

