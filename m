Return-Path: <linux-kernel-owner+w=401wt.eu-S1758556AbXFSPHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbXFSPHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 11:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbXFSPHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 11:07:06 -0400
Received: from holomorphy.com ([66.93.40.71]:33189 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbXFSPHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 11:07:04 -0400
Date: Tue, 19 Jun 2007 08:08:24 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Albert Cahalan <acahalan@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: JIT emulator needs
Message-ID: <20070619150824.GH11781@holomorphy.com>
References: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:
> Right now, Linux isn't all that friendly to JIT emulators.
> Here are the problems and suggestions to improve the situation.
> There is an SE Linux execmem restriction that enforces W^X.
> Assuming you don't wish to just disable SE Linux, there are
> two ugly ways around the problem. You can mmap a file twice,
> or you can abuse SysV shared memory. The mmap method requires
> that you know of a filesystem mounted rw,exec where you can
> write a very large temporary file. This arbitrary filesystem,
> rather than swap space, will be the backing store. The SysV
> shared memory method requires an undocumented flag and is
> subject to some annoying size limits. Both methods create
> objects that will fail to be deleted if the program dies
> before marking the objects for deletion.

If the policy forbidding self-modifying code lacks a method of
exempting programs such as JIT interpreters (which I doubt) then
it's a problem. I'm with Alan on this one.


On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:
> Processors often have annoying limits on the immediate values
> in instructions. An x86 or x86_64 JIT can go a bit faster if
> all allocations are kept to the low 2 GB of address space.
> There are also reasons for a 32bit-to-x86_64 JIT to chose
> a nearly arbitrary 2 GB region that lies above 4 GB.
> Other archs have other limits, such as 32 MB or 256 MB.

This sort of logic might be appropriate for a sort of parametrized
and specialized vma allocator setting the policy in /proc/ along
with various sorts of limits. There are limits to such and at some
point things will have to manually manage their own process address
spaces in a platform-specific fashion. If kernel assistance here is
rejected they may have to do so in all cases.


On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:
> Sometimes it is very helpful to have the read/write mapping
> be a fixed offset from the read/exec mapping. A power of 2
> can be especially desirable.

As far as the kernel is concerned they're unrelated, so this will
likely need MAP_FIXED barring a staggering array of fresh system
calls to act on tuples of memory ranges in lockstep.


On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:
> Emulators often need a cheap way to change page permissions.
> One VMA per page is no good. Besides taking up space and making
> many things generally slower, having one VMA per page causes
> a huge performance loss for snapshot roll-back operations.
> Just tearing down all those VMAs takes a good while.

remap_file_pages_prot() is reputedly waiting in the wings somewhere
for this.


On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:
> Additions to better support JIT emulators:
> a. sysctl to set IPC_RMID by default

This is a bad idea. The standard semantics are needed for programs
relying upon them.


On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:
> b. shmget() flag to set IPC_RMID by default

This is relatively innocuous.


On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:
> c. open() flag to unlink a file before returning the fd

You probably want a tmpfile(3) -like affair which never has a pathname
to begin with. It could be useful for security purposes more generally.


On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:
> d. mremap() flag to always keep the old mapping

This sounds vaguely like another syscall, like mdup(). This is
particularly meaningful in the context of anonymous memory, for
which there is no method of replicating mappings within a single
process address space.


On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:
> e. mremap() flag to get a read/write mapping of a read/exec one
> f. mremap() flag to get a read/exec mapping of a read/write one

Presumably to be used in conjunction with keeping the old mapping.
A composite mdup()/mremap() and mprotect(), presumably saving a TLB
flush or other sorts of overhead, may make some sort of sense here.
Odds are it'll get rejected as the sequence of syscalls is a rather
precise equivalent, though it would optimize things (as would other
composite syscalls, e.g. ones combining fork() and execve() etc.).


On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:
> g. mremap() flag to make the 5th arg (new addr) be the upper limit
> h. 6-bit wide mremap() "flag" to set the upper limit above given base

Essentially more placement support for mremap()/mdup(). It's not clear
to me those particular semantics are the ideal ones. A target range
for placement should do, if not manual address space management.


On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:
> i. support the prot argument to remap_file_pages

This is probably going to happen anyway.


On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:
> j. a documented way (madvise?) to punch same-VMA zero-page holes

This is MADV_REMOVE, though most filesystems don't support it. Do you
need it for more than tmpfs?


-- wli
