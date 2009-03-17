Return-Path: <linux-kernel-owner+w=401wt.eu-S1763146AbZCQNWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763146AbZCQNWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 09:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbZCQNWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 09:22:36 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:40579 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914AbZCQNWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 09:22:35 -0400
Subject: Re: [PATCH 2/7] writeback: switch to per-bdi threads for flushing
 data
From: Chris Mason <chris.mason@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, npiggin@suse.de
In-Reply-To: <20090316233835.GM26138@disturbed>
References: <1236868428-20408-1-git-send-email-jens.axboe@oracle.com>
	 <1236868428-20408-3-git-send-email-jens.axboe@oracle.com>
	 <20090312223321.ccfe51b2.akpm@linux-foundation.org>
	 <20090313105446.GO27476@kernel.dk> <20090315225215.GA26138@disturbed>
	 <20090316073321.GJ27476@kernel.dk>  <20090316233835.GM26138@disturbed>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 09:21:14 -0400
Message-Id: <1237296074.31273.19.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.49BFA3D0.011A:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-17 at 10:38 +1100, Dave Chinner wrote:
> On Mon, Mar 16, 2009 at 08:33:21AM +0100, Jens Axboe wrote:
> > On Mon, Mar 16 2009, Dave Chinner wrote:
> > > On Fri, Mar 13, 2009 at 11:54:46AM +0100, Jens Axboe wrote:
> > > > On Thu, Mar 12 2009, Andrew Morton wrote:
> > > > > On Thu, 12 Mar 2009 15:33:43 +0100 Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > > Bear in mind that the XFS guys found that one thread per fs had
> > > > > insufficient CPU power to keep up with fast devices.
> > > > 
> > > > Yes, I definitely want to experiment with > 1 thread per device in the
> > > > near future.
> > > 
> > > The question here is how to do this efficiently. Even if XFS is
> > > operating on a single device, it is not optimal just to throw
> > > multiple threads at the bdi. Ideally we want a thread per region
> > > (allocation group) of the filesystem as each allocation group has
> > > it's own inode cache (radix tree) to traverse. These traversals can
> > > be done completely in parallel and won't contend either at the
> > > traversal level or in the IO hardware....
> > > 
> > > i.e. what I'd like to see is the ability so any new flushing
> > > mechanism to be able to offload responsibility of tracking,
> > > traversing and flushing of dirty inodes to the filesystem.
> > > Filesystems that don't do such things could use a generic
> > > bdi-based implementation.
> > > 
> > > FWIW, we also want to avoid the current pattern of flushing
> > > data, then the inode, then data, then the inode, ....
> > > By offloading into the filesystem, this writeback ordering can
> > > be done as efficiently as possible for each given filesystem.
> > > XFs already has all the hooks to be able to do this
> > > effectively....
> > > 
> > > I know that Christoph was doing some work towards this end;
> > > perhaps he can throw his 2c worth in here...
> > 
> > This is very useful feedback, thanks Dave. So on the filesystem vs bdi
> > side, XFS could register a bdi per allocation group.
> 
> How do multiple bdis on a single block device interact?

The main difference is that dirty page tracking for balance_dirty_pages
and friends is done per-bdi.  So, you'll end up with uneven memory
pressure on ags that don't have much dirty data, but hopefully that's a
good thing.

-chris


