Return-Path: <linux-kernel-owner+w=401wt.eu-S1761988AbYBZP2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761988AbYBZP2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 10:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYBZP2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 10:28:22 -0500
Received: from mail2.shareable.org ([80.68.89.115]:44754 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbYBZP2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 10:28:21 -0500
Date: Tue, 26 Feb 2008 15:28:10 +0000
From: Jamie Lokier <jamie@shareable.org>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Chris Wedgwood <cw@f00f.org>
Subject: Re: Proposal for "proper" durable fsync() and fdatasync()
Message-ID: <20080226152810.GB18118@shareable.org>
References: <20080226072649.GB30238@shareable.org> <20080225234319.f4589ae4.akpm@linux-foundation.org> <20080226075921.GG30238@shareable.org> <200802262016.11297.nickpiggin@yahoo.com.au> <20080226140925.GB20428@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080226140925.GB20428@lazybastard.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> On Tue, 26 February 2008 20:16:11 +1100, Nick Piggin wrote:
> > Yeah, sync_file_range has slightly unusual semantics and introduce
> > the new concept, "writeout", to userspace (does "writeout" include
> > "in drive cache"? the kernel doesn't think so, but the only way to
> > make sync_file_range "safe" is if you do consider it writeout).
> 
> If sync_file_range isn't safe, it should get replaced by a noop
> implementation.  There really is no point in promising "a little"
> safety.

Sometimes there is a point in "a little" safety.

There's a spectrum of durability (meaning how safely stored the data
is).  In the cases we're imagining, it's application -> main memory
cache -> disk cache -> disk surface.  There are others.

_None_ of those provide perfect safety for your data.  They are a
spectrum, and how far along you want data to be committed before you
say "fine, the data is safe enough for me" depends on your application.

For example, there are users who like to turn _off_ fdatasync() with
their SQL database of choice.  They prefer speed over safety, and they
don't mind losing an hour's data and doing regular backups (we assume
;-) Some blogs fall into this category; who cares if a rare crash
costs you a comment or two and a restore from backup; it's acceptable
for the speed.

There's users who would really like fdatasync() to commit data to the
drive platters, so after their database says "done", they are very
confident that a power failure won't cause committed data to be lost.
Accepting credit cards is more at this end.  So should be anyone using
a virtual machine of any kind without a journalling fs in the guest!

And there's users who like it where it is right now: a compromise,
where a system crash won't lose committed data; but a power failure
might.  (I'm making assumptions about drive behaviour on reset here.)

My problem with fdatasync() at the moment is, I can't choose what I
want from it, and there's no mechanism to give me the safest option.
Most annoyingly, in-kernel filesystems _do_ have a mechanism; it just
isn't exported to userspace.

(A quick aside: fdatasync() et al. are actually used for two
_different_ things.  1: A program says "I've written it", it can say
so with confidence, e.g. announcing email receipt.  2: It's used for
write ordering with write-ahead logging: write, fdatasync, write.
When you tease at the details, efficient implementations of them are
different...  Think SCSI tagged commands versus cache flushes.)

> One interesting aspect of this comes with COW filesystems like btrfs or
> logfs.  Writing out data pages is not sufficient, because those will get
> lost unless their referencing metadata is written as well.  So either we
> have to call fsync for those filesystems or add another callback and let
> filesystems override the default implementation.

Doesn't the ->fsync callback get called in the sys_fdatasync() case,
with appropriate arguments?

With barriers/flushes it certainly makes those a bit more complicated.
You have to flush not just the disks with data pages, but the _other_
disks in a software RAID with data pointer metadata pages, but ideally
not all of them (think database journal commit).

That can be implemented with per-buffer pending-barrier/flush flags
(like I described for pages in the first mail), which are equally
useful when a database-like application uses a block device.

-- Jamie
