Return-Path: <linux-kernel-owner+w=401wt.eu-S932141AbZABTdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbZABTdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 14:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758133AbZABTd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 14:33:27 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:38848 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757984AbZABTd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 14:33:26 -0500
Subject: Re: Btrfs for mainline
From: Chris Mason <chris.mason@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>
In-Reply-To: <87r63ljzox.fsf@basil.nowhere.org>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <20081231104533.abfb1cf9.akpm@linux-foundation.org>
	 <1230765549.7538.8.camel@think.oraclecorp.com>
	 <87r63ljzox.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Fri, 02 Jan 2009 14:32:29 -0500
Message-Id: <1230924749.7538.35.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.495E6BD4.00E5:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-02 at 20:05 +0100, Andi Kleen wrote:
> Chris Mason <chris.mason@oracle.com> writes:
> 
> > On Wed, 2008-12-31 at 10:45 -0800, Andrew Morton wrote:
> >> On Wed, 31 Dec 2008 06:28:55 -0500 Chris Mason <chris.mason@oracle.com> wrote:
> >> 
> >> > Hello everyone,
> >> 
> >> Hi!
> >> 
> >> > I've done some testing against Linus' git tree from last night and the
> >> > current btrfs trees still work well.
> >> 
> >> what's btrfs?  I think I've heard the name before, but I've never
> >> seen the patches :)
> >
> > The source is up to around 38k loc, I thought it better to use that http
> > thing for people who were interested in the code.
> >
> > There is also a standalone git repo:
> >
> > http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable-standalone.git;a=summary
> 
> Some items I remember from my last look at the code that should
> be cleaned up before mainline merge (that wasn't a full in depth review):
> 

Hi Andi, thanks for looking at things.

> - locking.c needs a lot of cleanup.

Grin, lots of the code needs to be cleaned, but locking.c is really just
a few wrappers around the mutex calls.  I don't think I had it at the
top of my to-be-cleaned list ;)


> If combination spinlocks/mutexes are really a win they should be 
> in the generic mutex framework. And I'm still dubious on the hardcoded 
> numbers.

Sure, I'm happy to use a generic framework there (or help create one).
They are definitely a win for btrfs, and show up in most benchmarks.

> - compat.h needs to go

Projects that are out of mainline have a difficult task of making sure
development can continue until they are in mainline and being clean
enough to merge.  I'd rather get rid of the small amount of compat code
that I have left after btrfs is in (compat.h is 32 lines).  

It isn't hurting anything, and taking it out makes it much more
difficult for our current users.

> - there's various copy'n'pasted code from the VFS (like may_create) 
> that needs to be cleaned up.

Yes, I tried to mark those as I did them (a very small number of
functions).  In general they were copied to avoid adding exports, and
that is easily fixed.

> - there should be manpages for all the ioctls and other interfaces.
> - ioctl.c was not explicitely root protected. security issues?

Christoph added a CAP_SYS_ADMIN check to the trans start ioctl, but I do
need to add one to the device add/remove/balance code as well.

The subvol/snapshot creation is meant to be user callable (controlled by
something similar to quotas later on).

> - some code was severly undercommented.
> e.g. each file should at least have a one liner
> describing what it does (ideally at least a paragraph). Bad examples
> are export.c or free-space-cache.c, but also others.
> - ENOMEM checks are still missing all over (e.g. with most of the 
> btrfs_alloc_path callers). If you keep it that way you would need
> at least XFS style "loop for ever" alloc wrappers, but better just
> fix all the callers.

Yes, there's quite some work to do in the error handling paths.

>  Also there used to be a lot of BUG_ON()s on
> memory allocation failure even.
> - In general BUG_ONs need review I think. Lots of externally triggerable
> ones.
> - various checkpath.pl level problems I think (e.g. printk levels) 
> - the printks should all include which file system they refer to
> 
> In general I think the whole thing needs more review.

I don't disagree, please do keep in mind that I'm not suggesting anyone
use this in production yet.

-chris


