Return-Path: <linux-kernel-owner+w=401wt.eu-S967182AbXEGXPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967182AbXEGXPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 19:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967111AbXEGXOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 19:14:55 -0400
Received: from THUNK.ORG ([69.25.196.29]:53328 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755148AbXEGXOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 19:14:54 -0400
Date: Mon, 7 May 2007 19:14:42 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger@clusterfs.com>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com,
       cmm@us.ibm.com
Subject: Re: [PATCH 4/5] ext4: fallocate support in ext4
Message-ID: <20070507231442.GA29907@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@clusterfs.com>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com,
	cmm@us.ibm.com
References: <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426181332.GD7209@amitarora.in.ibm.com> <20070503213133.d1559f52.akpm@linux-foundation.org> <20070507113753.GA5439@schatzie.adilger.int> <20070507135825.f8545a65.akpm@linux-foundation.org> <20070507222103.GJ8181@schatzie.adilger.int> <20070507153856.d56a5133.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070507153856.d56a5133.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 03:38:56PM -0700, Andrew Morton wrote:
> > Actually, this is a non-issue.  The reason that it is handled for extent-only
> > is that this is the only way to allocate space in the filesystem without
> > doing the explicit zeroing.  For other filesystems (including ext3 and
> > ext4 with block-mapped files) the filesystem should return an error (e.g.
> > -EOPNOTSUPP) and glibc will do manual zero-filling of the file in userspace.
> 
> It can be a bit suboptimal from the layout POV.  The reservations code will
> largely save us here, but kernel support might make it a bit better.

Actually, the reservations code won't matter, since glibc will fall
back to its current behavior, which is it will do the preallocation by
explicitly writing zeros to the file.  This wlil result in the same
layout as if we had done the persistent preallocation, but of course
it will mean the posix_fallocate() could potentially take a long time
if you're a PVR and you're reserving a gig or two for a two hour movie
at high quality.  That seems suboptimal, granted, and ideally the
application should be warned about this before it calls
posix_fallocate().  On the other hand, it's what happens today, all
the time, so applications won't be too badly surprised.  

If we think applications programmers badly need to know in advance if
posix_fallocate() will be fast or slow, probably the right thing is to
define a new fpathconf() configuration option so they can query to see
whether a particular file will support a fast posix_fallocate().  I'm
not 100% convinced such complexity is really needed, but I'm willing
to be convinced....  what do folks think?

						- Ted
