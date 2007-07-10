Return-Path: <linux-kernel-owner+w=401wt.eu-S1763196AbXGJRVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763196AbXGJRVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 13:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762319AbXGJRU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 13:20:56 -0400
Received: from ms-smtp-05.texas.rr.com ([24.93.47.44]:33359 "EHLO
	ms-smtp-05.texas.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762293AbXGJRUx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 13:20:53 -0400
From: Dave McCracken <dave.mccracken@oracle.com>
Organization: Oracle Corp
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] include private data mappings in RLIMIT_DATA limit
Date: Tue, 10 Jul 2007 12:19:29 -0500
User-Agent: KMail/1.9.7
Cc: herbert.van.den.bergh@oracle.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <4692D616.4010004@oracle.com> <200707091954.10502.dave.mccracken@oracle.com> <Pine.LNX.4.64.0707101727510.4717@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0707101727510.4717@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707101219.29743.dave.mccracken@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 July 2007, Hugh Dickins wrote:
> On Mon, 9 Jul 2007, Dave McCracken wrote:
> > On Monday 09 July 2007, Herbert van den Bergh wrote:
> > > With this patch, not only memory in the data segment of a process, but
> > > also private data mappings, both file-based and anonymous, are counted
> > > toward the RLIMIT_DATA resource limit.  Executable mappings, such as
> > > text segments of shared objects, are not counted toward the private
> > > data limit.  The result is that malloc() will fail once the combined
> > > size of the data segment and private data mappings reaches this limit.
> > >
> > > This brings the Linux behavior in line with what is documented in the
> > > POSIX man page for setrlimit(3p).
>
> Which says malloc() can fail from it, but conspicuously not that mmap()
> can fail from it: unlike the RLIMIT_AS case.  Would we be better off?

True.  But keep in mind that when POSIX was written mmap() was new and shiny 
and pretty much only used for shared mappings, and definitely not used by 
malloc().

> > I believe this patch is a simple and obvious fix to a hole introduced
> > when libc malloc() began using mmap() instead of brk().
>
> But didn't libc start doing that many years ago?  Wouldn't that have
> been the time for such a patch rather than now: when it can only break
> apps that are currently working?

Yes, probably.  But it got missed.

> > We took away the ability
> > to control how much data space processes could soak up.  This patch
> > returns that control to the user.
>
> I remember thinking that the idea of data ulimit had become obsolete
> (just preserved for compatibility) back when mmap() got invented and
> used for dynamic libraries.  I think that's when they brought in
> RLIMIT_AS, something which could make sense in the mmap() world.
>
> This patch does give it more meaning.  But if we are prepared to
> take the risk of breaking things in this way (I think not but don't
> mind being corrected), it would be more accurate to take writability
> into account, and use that quantity (sadly not stored in mm_struct,
> would have to be added) which we do security_vm_enough_memory() upon,
> which totals up into /proc/meminfo's Committed_AS.

Given that RLIMIT_DATA is pretty much meaningless in current kernels, I would 
put forward the argument that this change is extremely unlikely to break 
anything because no one is currently setting it to anything other than 
unlimited.  Adding this feature would give administrators another tool, a way 
to control the private data size of a process without restricting its ability 
to attach to large shared mappings.

> That change to /proc/PID/status VmData:
> -	data = mm->total_vm - mm->shared_vm - mm->stack_vm;
> +	data = mm->total_vm - mm->shared_vm - mm->stack_vm - mm->exec_vm;
> looks plausible, but isn't exec_vm already counted as shared_vm,
> so now being doubly subtracted?  Besides which, we wouldn't want
> to change those numbers again without consulting Albert.

As I recall, this was added after Herbert discovered that exec_vm is not 
counted as shared_vm.  It's actually mapped as private/readonly.

> Hugh


