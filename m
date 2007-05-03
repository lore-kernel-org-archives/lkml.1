Return-Path: <linux-kernel-owner+w=401wt.eu-S1767222AbXECVPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767222AbXECVPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 17:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031350AbXECVPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 17:15:01 -0400
Received: from mga06.intel.com ([134.134.136.21]:21463 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767222AbXECVOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 17:14:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,487,1170662400"; 
   d="scan'208";a="238877390"
Date: Thu, 3 May 2007 14:14:52 -0700
From: Valerie Henson <val_henson@linux.intel.com>
To: David Chinner <dgc@sgi.com>
Cc: "Cabot, Mason B" <mason.b.cabot@intel.com>, linux-kernel@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: Ext3 vs NTFS performance
Message-ID: <20070503211450.GA3869@nifty>
References: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com> <20070502154414.GB77450368@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502154414.GB77450368@melbourne.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
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

In terms of what piece of code we can swap out and get good
performance, the problem is indeed in ext3 - it's clear that the cause
of the bad performance is the 1-byte writes resulting in ext3
fragmenting the on-disk layout of the file, and replacing it with XFS
results in nice, clean, unfragmented files.

But in terms of what we should do to fix it, there is the possibility
of some debate.  In general, I think there is a lot of code stuck down
in individual file systems - especially in XFS - that could be
usefully hoisted up to a higher level as generic helper functions.
For example, we've got at least two implementations of reservations,
one in XFS and one in ext3/4.  At least some of the code could be
generic - both file systems want to reserve long contiguous extents -
with the actual mechanics of looking up and reserving free blocks
implemented in per-fs code.

I'd really like to see a generic VFS-level detection of
read()/write()/creat()/mkdir()/etc. patterns which could detect things
like "Oh, this file is likely to be deleted immediately, wait and see
if it goes away and don't bother sending it on to the FS immediately"
or "Looks like this file will grow pretty big, let's go pre-allocate
some space for it."  This is probably best done as a set of helper
functions in the usual way.

For this particular case, Ted is probably right and the only place
we'll ever see this insane poor man's pre-allocate pattern is from the
Windows CIFS client, in which case fixing this in Samba makes sense -
although I'm a bit horrified by the idea of writing 128K of zeroes to
pre-allocate... oh well, it's temporary, and what we care about here
is the read performance, more than the write performance.

-VAL
