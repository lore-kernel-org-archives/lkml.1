Return-Path: <linux-kernel-owner+w=401wt.eu-S1767278AbXECAP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767278AbXECAP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 20:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767282AbXECAP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 20:15:26 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35463 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767278AbXECAPY (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 20:15:24 -0400
Date: Thu, 3 May 2007 10:15:11 +1000
From: David Chinner <dgc@sgi.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: David Chinner <dgc@sgi.com>, "Cabot, Mason B" <mason.b.cabot@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Ext3 vs NTFS performance
Message-ID: <20070503001511.GD77450368@melbourne.sgi.com>
References: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com> <20070502154414.GB77450368@melbourne.sgi.com> <20070502194621.GY1518@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502194621.GY1518@think.oraclecorp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 03:46:21PM -0400, Chris Mason wrote:
> On Thu, May 03, 2007 at 01:44:14AM +1000, David Chinner wrote:
> > On Tue, May 01, 2007 at 01:43:18PM -0700, Cabot, Mason B wrote:
> > > Hello all,
> > > 
> > > I've been testing the NAS performance of ext3/Openfiler 2.2 against
> > > NTFS/WinXP and have found that NTFS significantly outperforms ext3 for
> > > video workloads. The Windows CIFS client will attempt a poor-man's
> > > pre-allocation of the file on the server by sending 1-byte writes at
> > > 128K-byte strides, breaking block allocation on ext3 and leading to
> > > fragmentation and poor performance. This will happen for many
> > > applications (including iTunes) as the CIFS client issues these
> > > pre-allocates under the application layer.
> > > 
> > > I've posted a brief paper on Intel's OSS website
> > > (http://softwarecommunity.intel.com/articles/eng/1259.htm). Please give
> > > it a read and let me know what you think. In particular, I'd like to
> > > arrive at the right place to fix this problem: is it in the filesystem,
> > > VFS, or Samba?
> > 
> > As I commented on IRC to Val Henson - the XFS performance indicates
> > that it is not a VFS or Samba problem.
> > 
> > I'd say it's probably delayed allocation that is making the
> > difference here - no allocation occurs on the single byte writes, it
> > occurs when the larger data writes are flushed to disk. Hence no
> > adverse fragmentation will occur and there wil be no extra
> > allocations being done.
> > 
> > Hence I think it's probably a filesystm problem - it would be
> > interesting to see how ext4 performs on this workload....
> 
> If we rely on delalloc for this, what happens if another proc on the
> same fs is doing synchronous writes to other files? (say for mail
> delivery).  Will random FS commits force delayed allocations to become
> real?

Not on XFS.

> Also, I'd expect a sufficiently loaded server to break down eventually
> as load/users increase.  The cost of a bad delalloc decision gets much
> higher if we're using it as a crutch for this kind of bad userland
> coding.

This only becomes a problem if the system has enough pages dirty to
be triggering throttling so that the 1byte writes are converted before
the data actually hits the server.

Even then, if you are on an XFS filesystem with a sunit/swidth set,
the alocation alignments and speculative allocations will go a long
way to preventing fragmentations.

If that doesn't work, then set the extent allocation size hint on the
XFS inode to 128k or 256k to set the minimum all ocation size for the
file to span the distance between the 1 byte writes. This attribute
can be inherited from the parent directory on create, so it's a
set and forget type of thing...

i.e. XFS has lots of ways to prevent perfromance from degrading
on these sorts of issues.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
