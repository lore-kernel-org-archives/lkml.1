Return-Path: <linux-kernel-owner+w=401wt.eu-S1757077AbZDUQ5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbZDUQ5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZDUQ5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:57:10 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47828 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbZDUQ5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:57:08 -0400
Subject: Re: Large Pages - Linux Foundation HPC
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Vivek Kashyap <vivk@us.ibm.com>, Mel Gorman <mel@linux.vnet.ibm.com>,
       Balbir Singh1 <balbir.singh@in.ibm.com>,
       Robert MacFarlan <Robert_MacFarlan@us.ibm.com>
In-Reply-To: <1240331533.32731.2.camel@badari-desktop>
References: <1240331533.32731.2.camel@badari-desktop>
Content-Type: text/plain
Date: Tue, 21 Apr 2009 09:57:05 -0700
Message-Id: <1240333025.32604.392.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-21 at 09:32 -0700, Badari Pulavarty wrote:
> Hi Dave,
> 
> On the Linux foundation HPC track summary, I saw:
> 
> -- Memory and interface to it - mapping memory into apps
>      - large pages important - current state not good enough

I'm not sure exactly what this means.  But, there was continuing concern
about large page interfaces.  hugetlbfs is fine, but it still requires
special tools, planning, and requires some modification of the app.  We
can modify it with linker tricks or with LD_PRELOAD, but those certainly
don't work everywhere.  I was told over and over again that hugetlbfs
isn't a sufficient interface for large pages, no matter how much
userspace we try to stick in front of it.

Some of their apps get a 6-7x speedup from large pages!

Fragmentation also isn't an issue for a big chunk of the users since
they reboot between each job.

> nodes going down due to memory exhaustion

Virtually all the apps in an HPC environment start up try to use all the
memory they can get their hands on.  With strict overcommit on, that
probably means brk() or mmap() until they fail.  They also usually
mlock() anything they're able to allocate.  Swapping is the devil to
them. :)

Basically, what all the apps do is a recipe for stressing the VM and
triggering the OOM killer.  Most of the users simply hack the kernel and
replace the OOM killer with one that fits their needs.  Some have an
attitude that "the user's app should never die" and others "the user
caused this, so kill their app".  Basically, there's no way to make
everyone happy since they have conflicting requirements.  But, this is
true of the kernel in general... nothing special here.

The split LRU should help things.  It will at least make our memory
scanning more efficient and ensure we're making more efficient reclaim
progress.  I'm not sure that anyone there knew about the oom_adjust and
oom_score knobs in /proc.  They do now. :)

One of my suggestions was to use the memory resource controller.  They
could give each app 95% (or whatever) of the system.  This should let
them keep their current "consume all memory" behavior, but stop them at
sane limits.

That leads into another issue, which is the "wedding cake" software
stack.  There are a lot of software dependencies both in and out of the
kernel.  It is hard to change individual components, especially in the
lower levels.  This leads many of the users to use old (think 2.6.9)
kernels.  Nobody runs mainline, of course.

Then, there's Lustre.  Everybody uses it, it's definitely a big hunk of
the "wedding cake".  I haven't seen any LKML postings on it in years and
I really wonder how it interacts with the VM.  No idea.

There's a "Hyperion cluster" which is for testing new HPC software on a
decently sized cluster.  One suggestion of ours was to try and get
mainline tested on this every so often to look for regressions since
we're not able to glean feedback from 2.6.9 kernel users.  We'll see
where that goes. 

> checkpoint/restart

Many of the MPI implementations have mechanisms in userspace for
checkpointing of user jobs.  Most cluster administrators instruct their
users to use these mechanisms.  Some do.  Most don't.

-- Dave

