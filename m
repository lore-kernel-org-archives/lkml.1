Return-Path: <linux-kernel-owner+w=401wt.eu-S1761248AbXEKCPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761248AbXEKCPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 22:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbXEKCPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 22:15:30 -0400
Received: from ns1.suse.de ([195.135.220.2]:53530 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916AbXEKCP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 22:15:29 -0400
From: Neil Brown <neilb@suse.de>
To: Ulrich Drepper <drepper@redhat.com>
Date: Fri, 11 May 2007 12:14:45 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17987.53653.111396.778502@notabene.brown>
Cc: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utimensat implementation
In-Reply-To: message from Ulrich Drepper on Thursday May 10
References: <200704262249.l3QMn5C2021588@devserv.devel.redhat.com>
	<17969.22692.855242.359680@notabene.brown>
	<46315C61.30001@redhat.com>
	<464363DC.7060607@redhat.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday May 10, drepper@redhat.com wrote:
> Ulrich Drepper wrote:
> > Neil Brown wrote:
> >> Does it also specify how to find out what granularity is used by the
> >> filesystem?  I had a need for this just recently and couldn't see any
> >> way to extract it.
> > 
> > That's still on the table.  We might end up with an fpathconf() solution.
> 
> OK, the pathconf()-based solution will most probably be in the next 
> POSIX spec.
> 
> Now, somebody has to provide a way to get to this information.  The 
> kernel does not export it so far.  Is it finally time to break down and 
> allow pathconf() and fpathconf() syscalls into the kernel?

Maybe... certainly we want some way to get at this information.

It has occurred to me a number of times that there is no easy way to
export information about filesystems from the kernel.

One specific example is request statistics for an NFS filesystem.  We
can get system-wide statistics, but to get stats for a single
filesystem isn't possible, and a big reason for this is that there is
no-where to put that information.

Filesystems also have a variety of mount options and they are only
available through "/proc/mounts" and can only be change by "remount"
which is a bit of a clunky interface.

Just about every other kernel object is, or can be, exposed through
sysfs.  But filesystems cannot.  This is presumably because there is
no unique handle for them (what with name spaces and bind mounts and
so forth).
Each filesystem still have a unique device number (->s_dev) so that
could be used. e.g. we could create
  /sysfs/filesystem/00:03/....

which would contain info about the filesystem with device number 0:3.
We could then put time-granularity and other fs-specific info in
there.

I feel that would be more flexible than a specific fpathconfat system
call.  But would it be enough?
The pathconf values can apparently be different for different files in
a filesystem.  Is that important?  If it is, we really would want
some new syscall rather than just sysfs attributes.

So that makes two questions for anyone with opinions:
 1/ Does pathconf have to be per-file, or is per-filesystem OK
 2/ Can we have a way to put attributes for filesystems in sysfs?

NeilBrown
