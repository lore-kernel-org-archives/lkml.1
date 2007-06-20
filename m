Return-Path: <linux-kernel-owner+w=401wt.eu-S1761128AbXFTDQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761128AbXFTDQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 23:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758457AbXFTDQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 23:16:31 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:56748 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758355AbXFTDQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 23:16:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O6q6BbplM6caWJVeNrWQg1PzMENRxRbZOfSLmImN1boga6AZEarN9b6LCAAKP1FABf5//VgZDDbu/lJNjKgjlibuyEZAZCpOpAA2JE1Yhac7MmXkEmNq5AX24r4LedD9UGu0X7iIB9Y6lDgXq7qjQHUnBdxx0LBIe415IHkIdcU=
Message-ID: <787b0d920706192016l660dd5b0mbf300581db81ac62@mail.gmail.com>
Date: Tue, 19 Jun 2007 23:16:29 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "William Lee Irwin III" <wli@holomorphy.com>
Subject: Re: JIT emulator needs
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070619150824.GH11781@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>
	 <20070619150824.GH11781@holomorphy.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/19/07, William Lee Irwin III <wli@holomorphy.com> wrote:
> On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:

>> Right now, Linux isn't all that friendly to JIT emulators.
>> Here are the problems and suggestions to improve the situation.
>> There is an SE Linux execmem restriction that enforces W^X.
>> Assuming you don't wish to just disable SE Linux, there are
>> two ugly ways around the problem. You can mmap a file twice,
>> or you can abuse SysV shared memory. The mmap method requires
>> that you know of a filesystem mounted rw,exec where you can
>> write a very large temporary file. This arbitrary filesystem,
>> rather than swap space, will be the backing store. The SysV
>> shared memory method requires an undocumented flag and is
>> subject to some annoying size limits. Both methods create
>> objects that will fail to be deleted if the program dies
>> before marking the objects for deletion.
>
> If the policy forbidding self-modifying code lacks a method of
> exempting programs such as JIT interpreters (which I doubt) then
> it's a problem. I'm with Alan on this one.

It does and it doesn't. There is not a reasonable way for a
user to mark an app as needing full self-modifying ability.
It's not like the executable stack, which can be set via the
ELF note markings on the executable. (ELF note markings are
ideal because they can not be used via a ret-to-libc attack)

With admin privs, one can change SE Linux settings. Mark the
executable, disable the protection system-wide, generate a
completely new SE Linux policy, or just turn SE Linux off.

Normally we don't expect/require admin privs to install an
executable in one's own ~/bin directory. This is broken.

It ought to be easier to get a JIT working well without
enabling arbitrary mprotect. This would allow a JIT to
partially benefit from the recent security enhancements.
(think of all the buggy browser-based JIT things!)

> On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:
>> Processors often have annoying limits on the immediate values
>> in instructions. An x86 or x86_64 JIT can go a bit faster if
>> all allocations are kept to the low 2 GB of address space.
>> There are also reasons for a 32bit-to-x86_64 JIT to chose
>> a nearly arbitrary 2 GB region that lies above 4 GB.
>> Other archs have other limits, such as 32 MB or 256 MB.
>
> This sort of logic might be appropriate for a sort of parametrized
> and specialized vma allocator setting the policy in /proc/ along
> with various sorts of limits. There are limits to such and at some
> point things will have to manually manage their own process address
> spaces in a platform-specific fashion. If kernel assistance here is
> rejected they may have to do so in all cases.

I prefer ELF notes (for start-up allocations) and prctl,
plus a mmap flag for per-allocation behavior.

> On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:
>> Additions to better support JIT emulators:
>> a. sysctl to set IPC_RMID by default
>
> This is a bad idea. The standard semantics are needed for programs
> relying upon them.

I didn't mean that the default default :-) setting would change.
I meant that people could change the behavior from a boot script.
Things that break are really foul and nasty anyway, probably with
serious problems that ought to get fixed.

> On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:
>> c. open() flag to unlink a file before returning the fd
>
> You probably want a tmpfile(3) -like affair which never has a pathname
> to begin with. It could be useful for security purposes more generally.

Yes, exactly. I think there are some possible optimizations
available too, particularly with the cifs filesystem.

> On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:
>> d. mremap() flag to always keep the old mapping
>
> This sounds vaguely like another syscall, like mdup(). This is
> particularly meaningful in the context of anonymous memory, for
> which there is no method of replicating mappings within a single
> process address space.

Yes, mdup() and probably mdup2(). It could be mremap flags or not.

JIT emulators generally need a second mapping so that they can
have both read/write and execute for the same physical memory.

It is somewhat tolerable to have SE Linux enforce that the second
mapping be randomized. (it helps security greatly, but slows the
emulator by a tiny bit)

> On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:
>> e. mremap() flag to get a read/write mapping of a read/exec one
>> f. mremap() flag to get a read/exec mapping of a read/write one
>
> Presumably to be used in conjunction with keeping the old mapping.
> A composite mdup()/mremap() and mprotect(), presumably saving a TLB
> flush or other sorts of overhead, may make some sort of sense here.
> Odds are it'll get rejected as the sequence of syscalls is a rather
> precise equivalent, though it would optimize things (as would other
> composite syscalls, e.g. ones combining fork() and execve() etc.).

A few mremap flags ought to do the job I think.

> On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:
>> g. mremap() flag to make the 5th arg (new addr) be the upper limit
>> h. 6-bit wide mremap() "flag" to set the upper limit above given base
>
> Essentially more placement support for mremap()/mdup(). It's not clear
> to me those particular semantics are the ideal ones. A target range
> for placement should do, if not manual address space management.

Yes. I'm looking for the change that will help JIT emulators
the most while hurting security the least.

> On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:
>> i. support the prot argument to remap_file_pages
>
> This is probably going to happen anyway.

Great.

> On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:
>> j. a documented way (madvise?) to punch same-VMA zero-page holes
>
> This is MADV_REMOVE, though most filesystems don't support it. Do you
> need it for more than tmpfs?

Yes and no. It's painful to be restricted to one backing store.
Covering MAP_ANONYMOUS and SysV shared mem is most critical.
I suppose that other filesystems may require multiple flags to
deal with the desire to (not) punch a hole on disk and what to
do if that isn't possible.
