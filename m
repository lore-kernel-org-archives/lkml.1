Return-Path: <linux-kernel-owner+w=401wt.eu-S1751571AbZALHtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbZALHtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 02:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZALHsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 02:48:54 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:65178 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370AbZALHsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 02:48:52 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAEOEakl5LDnl/2dsb2JhbADSLoVv
X-IronPort-AV: E=Sophos;i="4.37,252,1231075800"; 
   d="scan'208";a="291820495"
Date: Mon, 12 Jan 2009 18:48:46 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Grissiom <chaos.proton@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] async: Don't call async_synchronize_full_special()
	while holding sb_lock
Message-ID: <20090112074846.GJ8071@disturbed>
Mail-Followup-To: Jamie Lokier <jamie@shareable.org>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Grissiom <chaos.proton@gmail.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <a0adeea50901080007q5a3ed5c8y5a744ce37e677325@mail.gmail.com> <1231425472.21528.13.camel@norville.austin.ibm.com> <20090108072111.1ebadebd@infradead.org> <1231429591.27353.14.camel@norville.austin.ibm.com> <20090108225050.GL9448@disturbed> <49668388.708@linux.intel.com> <20090109014054.GN9448@disturbed> <4966D652.4070105@linux.intel.com> <20090112023138.GD6428@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112023138.GD6428@shareable.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 02:31:38AM +0000, Jamie Lokier wrote:
> Arjan van de Ven wrote:
> > >	- removing a million files and queuing all of the
> > >	  deletes in the async queues....
> > 
> > the async code throttles at 32k outstanding.
> > Yes 32K is arbitrary, but if you delete  a million files fast, all but the 
> > first few thousand are
> > synchronous.
> 
> Hmm.
> 
> If I call unlink() a thousand times and then call fsync() on the
> parent directories covering files I've unlinked... I expect the
> deletes to be committed to disk when the last fsync() has returned.  I
> require that a crash and restart will not see the files.  Several
> kinds of transactional software and even some shell scripts expect this.
> 
> Will these asynchronous deletes break the guaranteed
> commit-of-the-delete provided by fsync() on the parent directory?

It depends on the implementation of the filesystem you are running
on.

On XFS, it won't break anything because it uses a two-phase unlink.
The unlink() syscall removes the inode from the namespace
transactionally which means that even if you crash after the
directory fsync then they will never, ever appear in the directory
after recovery. In fact, recovery will see all those inodes as
existing on the unlinked lists and hence the execute the second
phase of the unlink during recovery.

I have no idea what the behaviour of other filesystems will
be but it needs to be evaluated on a filesystem-by-filesystem
basis.

Hmmmm. That introduces another interesting question w.r.t async
unlink in XFS - it's going to hammer the on-disk unlinked list hash
tables in XFS. The hashes are only 64 chains wide (per AG) so
pumping thousands of inodes into them is going to increase the
minimum memory footprint of XFS during rm -rf operations
substantially.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
