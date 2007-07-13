Return-Path: <linux-kernel-owner+w=401wt.eu-S932248AbXGMTTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbXGMTTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762845AbXGMTTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:19:12 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:32806 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762592AbXGMTTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:19:10 -0400
Date: Fri, 13 Jul 2007 20:18:30 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Herbert van den Bergh <Herbert.van.den.Bergh@oracle.com>
cc: Dave McCracken <dave.mccracken@oracle.com>,
       Albert Cahalan <acahalan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] include private data mappings in RLIMIT_DATA limit
In-Reply-To: <4693E77D.2020706@oracle.com>
Message-ID: <Pine.LNX.4.64.0707131917180.22167@blonde.wat.veritas.com>
References: <4692D616.4010004@oracle.com> <200707101219.29743.dave.mccracken@oracle.com>
 <Pine.LNX.4.64.0707101857310.20758@blonde.wat.veritas.com>
 <200707101412.19785.dave.mccracken@oracle.com>
 <Pine.LNX.4.64.0707102030150.2063@blonde.wat.veritas.com> <4693E77D.2020706@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABmluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcASGVyYmVydC52YW4uZGVuLkJlcmdoQG9yYWNsZS5jb20AZGF2ZS5tY2NyYWNrZW5Ab3JhY2xlLmNvbQBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnAGxpbnV4LW1tQGt2YWNrLm9yZwBhY2FoYWxhbkBnbWFpbC5jb20A
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Herbert van den Bergh wrote:
> Hugh Dickins wrote:
> > On Tue, 10 Jul 2007, Dave McCracken wrote:
> >> On Tuesday 10 July 2007, Hugh Dickins wrote:
> >>> Mapped private readonly yes, but vm_stat_account() says
> >>> 	if (file) {
> >>> 		mm->shared_vm += pages;
> >>> 		if ((flags & (VM_EXEC|VM_WRITE)) == VM_EXEC)
> >>> 			mm->exec_vm += pages;
> >> In that code shared_vm includes everything that's mmap()ed, including private 
> >> mappings.  But if you look at Herbert's patch he has the following change:
> >>
> >>         if (file) {
> >> -               mm->shared_vm += pages;
> >> +               if (flags & VM_SHARED)
> >> +                       mm->shared_vm += pages;
> >>                 if ((flags & (VM_EXEC|VM_WRITE)) == VM_EXEC)
> >>                         mm->exec_vm += pages;
> >>
> >> This means that shared_vm now is truly only memory that's mapped VM_SHARED and 
> >> does not include VM_EXEC memory.  That necessitates the separate subtraction 
> >> of exec_vm in the data calculations.

Actually, that wasn't quite right, was it?  Though it's normally the
case that a VM_EXEC mapping is not VM_SHARED, that cannot be relied upon.

> The result of counting only VM_SHARED file mappings in shared_vm is that
> it no longer includes MAP_PRIVATE file mappings.  These file mappings are
> shared until they are written to, at which point they become private.
> The vm doesn't currently track this change from shared to private,

Well, it doesn't track the change at that instant, but VM_ACCOUNT does
track those private mappings which may be written to (or have been
written to earlier).  So it's the size of those mappings I believe
you'd best be counting for your DATA checks: the size that we keep
checking in calls to security_vm_enough_memory() also.

When I "cat /proc/self/maps" I see a lot of little readonly mappings:
you'll be counting those towards RLIMIT_DATA, whereas VM_ACCOUNT won't.

> so either way the accounting is off by a bit.  But the intention of the
> private mapping is to not share the page with other processes, so I think
> the right thing to do is to charge the process with this memory usage as
> private memory.  I am continuing to make the assumption that the code
> already made that all VM_EXEC mappings are also shared.  But one thing

I don't recall such an assumption; and I haven't worked out how your
version of vm_stat_account() can still increment exec_vm depending on
VM_EXEC only within its "if (file)" block, yet your VM_EXEC tests when
checking RLIM_DATA not consider file at all.

> that has changed is that when a mapping is no longer VM_EXEC, it is also
> no longer counted as shared, but as private, and charged to the data size.
> 
> This has generally little effect on /proc/pid/stats VmData.

Your instincts are good: you want to put existing fields of mm_struct
to better use without adding more clutter; and you want RLIMIT_DATA
to be a limit on the number shown as "VmData" in /proc/pid/status.
I applaud both choices.  But two pieces of history make me uneasy.

shared_vm and exec_vm, which you're depending upon in your tests,
were hacked up (no disrespect to wli) for 2.6.9, to give plausible
numbers in those /proc/pid/status fields, without the horribly
intensive and cache-destroying page scan which was used to calculate
them before.  They've served their purpose well, but the kernel has
never used them for decisions before - our main concern has been
that the numbers shown don't ever get to wrap negative.

Whereas userspace may have grown used to the values shown there,
and be alarmed by changes: Albert Cahalan (procps maintainer) has
protested in the past at the way we change these things around:
I don't think we can unilaterally change them again without his
consent.

> 
> One of the motivations for this change was to make it easier for a
> system administrator to manage processes that could allocate large
> amounts of private memory, either through malloc() or through mmap(),
> possibly due to programming errors.  As Dave also pointed out, if these
> processes need to be able to attach to large shared memory segments, such
> as a database buffer cache, then attempting to control the memory usage of
> these processes with RLIMIT_AS becomes very tricky.  The sysadmin may set
> the RLIMIT_AS to the current buffer cache shared memory segment size of
> say 8GB plus 200M for process private allocations, but the next day the
> DBA decides to increase the shared memory segment to 10GB, and wonders
> why his processes won't start.  Now, with RLIMIT_DATA being effective again,
> all that is needed is to set RLIMIT_DATA to a reasonable value for the 
> application.

Fair enough.

> 
> I don't anticipate that a lot of people need to be concerned about the 
> effect of this resource limit change.  By default RLIMIT_DATA is set to
> unlimited.  For those who do want to set it, they will need to understand 
> what it does, just like any other resource limit.

Yes, I think Dave persuaded me that the existing RLIMIT_DATA
is too old-fashioned to be useful to people, and that therefore
few will be inconvenienced by this change - though it will need
documenting in "release notes", and we need to make this possibility
of breakage very clear to Andrew and to Linus, who may veto it.

> 
> Perhaps an update of the man page is in order as well.

Surely (though it's going to be hard to explain it exactly
in a few words, whichever metric is used).

I don't want to keep on going back and forth in discussion.  I think
I need to prepare a patch using that vm_enough_memory charge as the
RLIMIT_DATA target, but showing old and your and my VmData in
/proc/pid/status, to see what those numbers look like across a
range of processes.  We could always display an additional VmAcct
or some such, but it would be a shame not to have it named VmData,
and it would be tiresome explaining the difference to people ever after.

Hugh
