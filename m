Return-Path: <linux-kernel-owner+w=401wt.eu-S1766993AbXEBUgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766993AbXEBUgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766996AbXEBUgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:36:44 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:52232 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766993AbXEBUgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:36:43 -0400
Date: Wed, 2 May 2007 15:46:21 -0400
From: Chris Mason <chris.mason@oracle.com>
To: David Chinner <dgc@sgi.com>
Cc: "Cabot, Mason B" <mason.b.cabot@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: Ext3 vs NTFS performance
Message-ID: <20070502194621.GY1518@think.oraclecorp.com>
References: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com> <20070502154414.GB77450368@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502154414.GB77450368@melbourne.sgi.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 01:44:14AM +1000, David Chinner wrote:
> On Tue, May 01, 2007 at 01:43:18PM -0700, Cabot, Mason B wrote:
> > Hello all,
> > 
> > I've been testing the NAS performance of ext3/Openfiler 2.2 against
> > NTFS/WinXP and have found that NTFS significantly outperforms ext3 for
> > video workloads. The Windows CIFS client will attempt a poor-man's
> > pre-allocation of the file on the server by sending 1-byte writes at
> > 128K-byte strides, breaking block allocation on ext3 and leading to
> > fragmentation and poor performance. This will happen for many
> > applications (including iTunes) as the CIFS client issues these
> > pre-allocates under the application layer.
> > 
> > I've posted a brief paper on Intel's OSS website
> > (http://softwarecommunity.intel.com/articles/eng/1259.htm). Please give
> > it a read and let me know what you think. In particular, I'd like to
> > arrive at the right place to fix this problem: is it in the filesystem,
> > VFS, or Samba?
> 
> As I commented on IRC to Val Henson - the XFS performance indicates
> that it is not a VFS or Samba problem.
> 
> I'd say it's probably delayed allocation that is making the
> difference here - no allocation occurs on the single byte writes, it
> occurs when the larger data writes are flushed to disk. Hence no
> adverse fragmentation will occur and there wil be no extra
> allocations being done.
> 
> Hence I think it's probably a filesystm problem - it would be
> interesting to see how ext4 performs on this workload....

If we rely on delalloc for this, what happens if another proc on the
same fs is doing synchronous writes to other files? (say for mail
delivery).  Will random FS commits force delayed allocations to become
real?

Also, I'd expect a sufficiently loaded server to break down eventually
as load/users increase.  The cost of a bad delalloc decision gets much
higher if we're using it as a crutch for this kind of bad userland
coding.

-chris

