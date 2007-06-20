Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbXFTQAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbXFTQAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 12:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbXFTP7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 11:59:53 -0400
Received: from holomorphy.com ([66.93.40.71]:55812 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbXFTP7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 11:59:52 -0400
Date: Wed, 20 Jun 2007 09:01:16 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Albert Cahalan <acahalan@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: JIT emulator needs
Message-ID: <20070620160116.GI6909@holomorphy.com>
References: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com> <20070619150824.GH11781@holomorphy.com> <787b0d920706192016l660dd5b0mbf300581db81ac62@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <787b0d920706192016l660dd5b0mbf300581db81ac62@mail.gmail.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/19/07, William Lee Irwin III <wli@holomorphy.com> wrote:
>> If the policy forbidding self-modifying code lacks a method of
>> exempting programs such as JIT interpreters (which I doubt) then
>> it's a problem. I'm with Alan on this one.

On Tue, Jun 19, 2007 at 11:16:29PM -0400, Albert Cahalan wrote:
> It does and it doesn't. There is not a reasonable way for a
> user to mark an app as needing full self-modifying ability.
> It's not like the executable stack, which can be set via the
> ELF note markings on the executable. (ELF note markings are
> ideal because they can not be used via a ret-to-libc attack)
> With admin privs, one can change SE Linux settings. Mark the
> executable, disable the protection system-wide, generate a
> completely new SE Linux policy, or just turn SE Linux off.
> Normally we don't expect/require admin privs to install an
> executable in one's own ~/bin directory. This is broken.
> It ought to be easier to get a JIT working well without
> enabling arbitrary mprotect. This would allow a JIT to
> partially benefit from the recent security enhancements.
> (think of all the buggy browser-based JIT things!)

I presumed an ELF note or extended filesystem attributes were already
in place for this sort of affair. It may be that the model implemented
is so restrictive that users are forbidden to create new executables,
in which case using a different model is certainly in order. Otherwise
the ELF note or attributes need to be implemented.


On 6/19/07, William Lee Irwin III <wli@holomorphy.com> wrote:
>> This sort of logic might be appropriate for a sort of parametrized
>> and specialized vma allocator setting the policy in /proc/ along
>> with various sorts of limits. There are limits to such and at some
>> point things will have to manually manage their own process address
>> spaces in a platform-specific fashion. If kernel assistance here is
>> rejected they may have to do so in all cases.

On Tue, Jun 19, 2007 at 11:16:29PM -0400, Albert Cahalan wrote:
> I prefer ELF notes (for start-up allocations) and prctl,
> plus a mmap flag for per-allocation behavior.

Beware that the kernel (upstream of me) will likely refuse to support
to exotic mmap() placement policies. At that point userspace will have
to implement them itself with a front-end to mmap().

Userspace can actually live without kernel placement support for
everything but the executable itself, which is already implemented via
ELF loading standards. This is not to downplay the tremendous amounts
of pain involved for moving the stack, getting ld.so to land in the
right place, and so on. Actually I'm less sure about .interp placement.
In any event, exotic virtualspace allocation policies are largely yet
another "simple matter of programming" implementable entirely in
userspace.


On 6/19/07, William Lee Irwin III <wli@holomorphy.com> wrote:
>> This is a bad idea. The standard semantics are needed for programs
>> relying upon them.

On Tue, Jun 19, 2007 at 11:16:29PM -0400, Albert Cahalan wrote:
> I didn't mean that the default default :-) setting would change.
> I meant that people could change the behavior from a boot script.
> Things that break are really foul and nasty anyway, probably with
> serious problems that ought to get fixed.

It's actually not a good idea to make it the default even via sysctl.
People won't realize something will break until it does, and what will
break is likely to be a database responsible for data integrity. The
IPC_RMID creation flag should suffice.


On 6/19/07, William Lee Irwin III <wli@holomorphy.com> wrote:
>> You probably want a tmpfile(3) -like affair which never has a pathname
>> to begin with. It could be useful for security purposes more generally.

On Tue, Jun 19, 2007 at 11:16:29PM -0400, Albert Cahalan wrote:
> Yes, exactly. I think there are some possible optimizations
> available too, particularly with the cifs filesystem.

I doubt this will be controversial, but it's not clear to me that there
is any convenient way to obtain an anonymous inode on anything but tmpfs,
in which case it's not really anonymous, but not visible to userspace on
account of the default kern_mount(). Essentially it's possible to hoist
the tmpfile name generation in-kernel to where it's in a disconnected
namespace not visible to any userspace whatsoever, and kernel threads
can cooperatively ensure safety via access discipline. Alternatively,
one could kern_mount() a fresh tmpfs filesystem for some concurrency
domain, e.g. per-uid, per-process, or per-thread.


On 6/19/07, William Lee Irwin III <wli@holomorphy.com> wrote:
>> This sounds vaguely like another syscall, like mdup(). This is
>> particularly meaningful in the context of anonymous memory, for
>> which there is no method of replicating mappings within a single
>> process address space.

On Tue, Jun 19, 2007 at 11:16:29PM -0400, Albert Cahalan wrote:
> Yes, mdup() and probably mdup2(). It could be mremap flags or not.
> JIT emulators generally need a second mapping so that they can
> have both read/write and execute for the same physical memory.
> It is somewhat tolerable to have SE Linux enforce that the second
> mapping be randomized. (it helps security greatly, but slows the
> emulator by a tiny bit)

I think this may be doable via an mremap() flag barring needing to
break it up into multiple syscalls so it's implementable on all
architectures. That itself will be so difficult to get merged the
duplication may have to stand on its own as an mremap() flag.


On 6/19/07, William Lee Irwin III <wli@holomorphy.com> wrote:
>> Presumably to be used in conjunction with keeping the old mapping.
>> A composite mdup()/mremap() and mprotect(), presumably saving a TLB
>> flush or other sorts of overhead, may make some sort of sense here.
>> Odds are it'll get rejected as the sequence of syscalls is a rather
>> precise equivalent, though it would optimize things (as would other
>> composite syscalls, e.g. ones combining fork() and execve() etc.).

On Tue, Jun 19, 2007 at 11:16:29PM -0400, Albert Cahalan wrote:
> A few mremap flags ought to do the job I think.

mremap() already has so many arguments this is going to be difficult
to get merged. Breaking it up into multiple syscalls will not be easy
to get past people, and there are architectures that can't implement
syscalls with too many arguments.


On 6/19/07, William Lee Irwin III <wli@holomorphy.com> wrote:
>> This is MADV_REMOVE, though most filesystems don't support it. Do you
>> need it for more than tmpfs?

On Tue, Jun 19, 2007 at 11:16:29PM -0400, Albert Cahalan wrote:
> Yes and no. It's painful to be restricted to one backing store.
> Covering MAP_ANONYMOUS and SysV shared mem is most critical.
> I suppose that other filesystems may require multiple flags to
> deal with the desire to (not) punch a hole on disk and what to
> do if that isn't possible.

If those two are the bare necessities, they're already in place.


-- wli
