Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbXFTSuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbXFTSuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763398AbXFTSn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:43:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:37573 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762757AbXFTSny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:43:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rDpmr0geUe967P2oHMFw4vkd6hfPXkujF3RHcc6DJshkWwXH8lQDD7KZ6svhvCuicKi7Q4EkK1kNiTOKhadh/xPosWDdz6XF4KM+TXIorpKv5jljp3hFJKsbBZt1fnwPliFK0ET+3JTXcodPTYumycglBvPblxMqbXNRia6BEcY=
Message-ID: <787b0d920706201143w3c36ed59ic5c09558dbc020ab@mail.gmail.com>
Date: Wed, 20 Jun 2007 14:43:52 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "William Lee Irwin III" <wli@holomorphy.com>
Subject: Re: JIT emulator needs
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070620160116.GI6909@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>
	 <20070619150824.GH11781@holomorphy.com>
	 <787b0d920706192016l660dd5b0mbf300581db81ac62@mail.gmail.com>
	 <20070620160116.GI6909@holomorphy.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/07, William Lee Irwin III <wli@holomorphy.com> wrote:
> On 6/19/07, William Lee Irwin III <wli@holomorphy.com> wrote:
>>> If the policy forbidding self-modifying code lacks a method of
>>> exempting programs such as JIT interpreters (which I doubt) then
>>> it's a problem. I'm with Alan on this one.
>
> On Tue, Jun 19, 2007 at 11:16:29PM -0400, Albert Cahalan wrote:
>> It does and it doesn't. There is not a reasonable way for a
>> user to mark an app as needing full self-modifying ability.
>> It's not like the executable stack, which can be set via the
>> ELF note markings on the executable. (ELF note markings are
>> ideal because they can not be used via a ret-to-libc attack)
>> With admin privs, one can change SE Linux settings. Mark the
>> executable, disable the protection system-wide, generate a
>> completely new SE Linux policy, or just turn SE Linux off.
>> Normally we don't expect/require admin privs to install an
>> executable in one's own ~/bin directory. This is broken.
>> It ought to be easier to get a JIT working well without
>> enabling arbitrary mprotect. This would allow a JIT to
>> partially benefit from the recent security enhancements.
>> (think of all the buggy browser-based JIT things!)
>
> I presumed an ELF note or extended filesystem attributes were already
> in place for this sort of affair. It may be that the model implemented
> is so restrictive that users are forbidden to create new executables,
> in which case using a different model is certainly in order. Otherwise
> the ELF note or attributes need to be implemented.

Users can create executables. Some will be non-functional
unless specially marked by an admin.

What is the goal here? I see no reasonable goal that would
result in such a policy.

> On 6/19/07, William Lee Irwin III <wli@holomorphy.com> wrote:
>>> This sort of logic might be appropriate for a sort of parametrized
>>> and specialized vma allocator setting the policy in /proc/ along
>>> with various sorts of limits. There are limits to such and at some
>>> point things will have to manually manage their own process address
>>> spaces in a platform-specific fashion. If kernel assistance here is
>>> rejected they may have to do so in all cases.
>
> On Tue, Jun 19, 2007 at 11:16:29PM -0400, Albert Cahalan wrote:
>> I prefer ELF notes (for start-up allocations) and prctl,
>> plus a mmap flag for per-allocation behavior.
>
> Beware that the kernel (upstream of me) will likely refuse to support
> to exotic mmap() placement policies. At that point userspace will have
> to implement them itself with a front-end to mmap().
>
> Userspace can actually live without kernel placement support for
> everything but the executable itself, which is already implemented via
> ELF loading standards. This is not to downplay the tremendous amounts
> of pain involved for moving the stack, getting ld.so to land in the
> right place, and so on. Actually I'm less sure about .interp placement.
> In any event, exotic virtualspace allocation policies are largely yet
> another "simple matter of programming" implementable entirely in
> userspace.

When you go that route, you may need to abandon libc. I've done exactly
that for one emulator. It was not easy. Nearly nobody will want to go
down that path.

Things improve a bit if MAP_ANONYMOUS and SysV shared mem allocations
can be made to ignore the available memory checking. If I could allocate
a 2 GB chunk on a system with 1 GB total swap+RAM, then I could use
that as an area in which to perform MAP_FIXED allocations. As of now
this would require either adding the swap space or disabling the
available memory checking system-wide via sysctl.

> On 6/19/07, William Lee Irwin III <wli@holomorphy.com> wrote:
>>> This is a bad idea. The standard semantics are needed for programs
>>> relying upon them.
>
> On Tue, Jun 19, 2007 at 11:16:29PM -0400, Albert Cahalan wrote:
>> I didn't mean that the default default :-) setting would change.
>> I meant that people could change the behavior from a boot script.
>> Things that break are really foul and nasty anyway, probably with
>> serious problems that ought to get fixed.
>
> It's actually not a good idea to make it the default even via sysctl.
> People won't realize something will break until it does, and what will
> break is likely to be a database responsible for data integrity. The
> IPC_RMID creation flag should suffice.

It's highly unlikely that such breakage would cause corruption.
Most likely it would cause the database to exit with an error
about failing to attach to a SysV shared memory segment.

I believe that a major cause of reboots is that admins are
unaware of SysV shared memory cruft left behind by apps that
crashed at the wrong moment or had other bugs. If something
is eating memory and you don't know what it is, you reboot.

> On 6/19/07, William Lee Irwin III <wli@holomorphy.com> wrote:
>>> This is MADV_REMOVE, though most filesystems don't support it. Do you
>>> need it for more than tmpfs?
>
> On Tue, Jun 19, 2007 at 11:16:29PM -0400, Albert Cahalan wrote:
>> Yes and no. It's painful to be restricted to one backing store.
>> Covering MAP_ANONYMOUS and SysV shared mem is most critical.
>> I suppose that other filesystems may require multiple flags to
>> deal with the desire to (not) punch a hole on disk and what to
>> do if that isn't possible.
>
> If those two are the bare necessities, they're already in place.

Well NONE of this stuff is absolutely required to run a JIT,
and one doesn't even need a JIT if one likes pure emulation.
All of this is about optimization and failure clean-up.

MAP_ANONYMOUS and SysV shared mem are good for transient things.
Sometimes a JIT author wants to keep a persistent image on disk.
In this case, it is much better to use the disk as backing store.
Also, sometimes one prefers to use a specific filesystem because
swap may be slower, smaller, or of unknown quality.

BTW, a mdup2 is great for DSP algorithms as well. It can allow
for wrap-around arrays, greatly simplifying and speeding up
things like filters.
