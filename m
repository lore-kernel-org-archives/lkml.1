Return-Path: <linux-kernel-owner+w=401wt.eu-S1761131AbXGJSwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761131AbXGJSwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbXGJSwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:52:09 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:60868 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbXGJSwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:52:07 -0400
Date: Tue, 10 Jul 2007 19:06:15 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Dave McCracken <dave.mccracken@oracle.com>
cc: herbert.van.den.bergh@oracle.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] include private data mappings in RLIMIT_DATA limit
In-Reply-To: <200707101219.29743.dave.mccracken@oracle.com>
Message-ID: <Pine.LNX.4.64.0707101857310.20758@blonde.wat.veritas.com>
References: <4692D616.4010004@oracle.com> <200707091954.10502.dave.mccracken@oracle.com>
 <Pine.LNX.4.64.0707101727510.4717@blonde.wat.veritas.com>
 <200707101219.29743.dave.mccracken@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABWluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAZGF2ZS5tY2NyYWNrZW5Ab3JhY2xlLmNvbQBoZXJiZXJ0LnZhbi5kZW4uYmVyZ2hAb3JhY2xlLmNvbQBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnAGxpbnV4LW1tQGt2YWNrLm9yZwA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Dave McCracken wrote:
> On Tuesday 10 July 2007, Hugh Dickins wrote:
> > > >
> > > > This brings the Linux behavior in line with what is documented in the
> > > > POSIX man page for setrlimit(3p).
> >
> > Which says malloc() can fail from it, but conspicuously not that mmap()
> > can fail from it: unlike the RLIMIT_AS case.  Would we be better off?
> 
> True.  But keep in mind that when POSIX was written mmap() was new and shiny 
> and pretty much only used for shared mappings, and definitely not used by 
> malloc().

Well, my bookmark is to SUSv3, which I think is equivalent these days?
And that specifically says malloc() or mmap() in the RLIMIT_AS case,
but only malloc() in the RLIMIT_DATA case.  We're wrong either way.

> Given that RLIMIT_DATA is pretty much meaningless in current kernels, I would 
> put forward the argument that this change is extremely unlikely to break 
> anything because no one is currently setting it to anything other than 
> unlimited.  Adding this feature would give administrators another tool, a way 
> to control the private data size of a process without restricting its ability 
> to attach to large shared mappings.

That may be a good argument (though "extremely unlikely to break"s
have a nasty habit of biting).  I'd still say that the contribution
to Committed_AS is more appropriate and more useful here.

> > That change to /proc/PID/status VmData:
> > -	data = mm->total_vm - mm->shared_vm - mm->stack_vm;
> > +	data = mm->total_vm - mm->shared_vm - mm->stack_vm - mm->exec_vm;
> > looks plausible, but isn't exec_vm already counted as shared_vm,
> > so now being doubly subtracted?  Besides which, we wouldn't want
> > to change those numbers again without consulting Albert.
> 
> As I recall, this was added after Herbert discovered that exec_vm is not 
> counted as shared_vm.  It's actually mapped as private/readonly.

Mapped private readonly yes, but vm_stat_account() says
	if (file) {
		mm->shared_vm += pages;
		if ((flags & (VM_EXEC|VM_WRITE)) == VM_EXEC)
			mm->exec_vm += pages;

Hugh
