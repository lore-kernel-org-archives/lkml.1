Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbZCUOIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbZCUOIk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 10:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbZCUOI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 10:08:29 -0400
Received: from leb.cs.unibo.it ([130.136.1.102]:53948 "EHLO leb.cs.unibo.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbZCUOI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 10:08:28 -0400
Date: Sat, 21 Mar 2009 15:08:22 +0100
From: Renzo Davoli <renzo@cs.unibo.it>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] utrace core
Message-ID: <20090321140822.GE18690@cs.unibo.it>
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com> <20090321014140.AA4F5FC3AB@magilla.sf.frob.com> <20090321014909.6b654f55.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321014909.6b654f55.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tracing does not mean only debug. Some tracing facilities can be used for virtualization.
For example User-Mode Linux is based on ptrace.

I have a prototype of kernel module for virtualization (kmview) based on utrace.
Using kmview (module+VMM) it is possible for a user (not root) to mount a filesystem just for 
a process (or a hierarchy of processes), or it is possible for some processes to
use different networking stacks or virtual devices. It is something like user-mode containers.
kmview provides the same features of umview, based on ptrace, in a (very) faster way.
(umview is in Debian lenny,squeeze,sid if you want to test it)

*Utrace is really what I wanted* to support kmview (apart from
some minor issues about the support of nested virtualizations).
Other virtualizations now based on ptrace could move part of their implementation
at kernel level by utrace and several speedups become possible.
For example kmview is a partial virtual machine monitor: some system calls are forwarded
to the kernel, some others virtualized.
When a user mounts a filesystem, all the system calls which use pathnames inside the mountpoint 
subtree get virtualized while the others are forwarded to the kernel.
With utrace the kmview kernel module handles many system calls at kernel level.
I mean, if an "open" system call was sent to the kernel because the path is outside
the virtualized part of the file system, all the system calls on the same file descriptors 
can be forwarded to the kernel without any request to the VMM at user level.
This is just one example of speedup, several others are possible.

Other virtualizations like user-mode linux or fakeroot-ng could use utrace to
speedup their virtualization, too.

As far as I have seen, systemtap is a wonderful tool for debugging, expecially for 
kernel debugging but it has not been designed for virtualization.
Ptrace provide a standard set of features and all the implementations of VMM must be 
in userland. Utrace provides the flexibility to split a VMM and move part of it to a 
kernel module.

Utrace provides a unified interface to kernel modules for tracing/virtualization.
kmview can be implemented as a client of utrace or by spreading code around the kernel and
like kmview other virtualizations based on ptrace could need to move some of their
logic to the kernel to speedup their execution.
These VMMs will use utrace based modules instead of kernel patches.

renzo

On Sat, Mar 21, 2009 at 01:49:09AM -0700, Andrew Morton wrote:
> I'd be interested in seeing a bit of discussion regarding the overall value
> of utrace - it has been quite a while since it floated past.
> 
> I assume that redoing ptrace to be a client of utrace _will_ happen, and
> that this is merely a cleanup exercise with no new user-visible features?
> 
> The "prototype utrace-ftrace interface" seems to be more a cool toy rather
> than a serious new kernel feature (yes?)
> 
> If so, what are the new killer utrace clients which would justify all these
> changes?
> 
> Also, is it still the case that RH are shipping utrace?  If so, for what
> reasons and what benefits are users seeing from it?
> 
> And I recall that there were real problems wiring up the Feb 2007 version
> of utrace to the ARM architecture.  Have those issues been resolved?  Are
> any problems expected for any architectures?
