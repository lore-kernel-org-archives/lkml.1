Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbZA0RKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbZA0RKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 12:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbZA0RJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 12:09:24 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:38992 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887AbZA0RJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 12:09:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eOpBKnvDPqq4Yzl0FBp0AsjHrk4MrMuKGWghOlqX6YpjiyMgwbIS9NH919JzytYhoU
         shiHHJ9jyvcKRtkGeRAaIOb5C0tZsaWNv7cu1s9qTcy8Lq4wfT0TVVp1LMomcZQD8NX7
         lig7RKJmVYNgBbjz8qHDPjuvw9OtHe7+OpNAg=
MIME-Version: 1.0
Date: Tue, 27 Jan 2009 12:09:19 -0500
Message-ID: <170fa0d20901270909v45bec3bao38944a9aca6347d9@mail.gmail.com>
Subject: BISECTED: Re: source line numbers with x86_64 modules?
From: Mike Snitzer <snitzer@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Dave Anderson <anderson@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Bernhard Walle <bwalle@suse.de>, Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       crash-utility@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[I've trimmed the wide cc distribution that was inherited when I
forked a different thread]

On Mon, Jan 12, 2009 at 10:19 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> "Mike Snitzer" <snitzer@gmail.com> writes:
>>
>> Now if only I could fix line numbers when debugging crashes in x86_64
>> modules with the crash utility! :)
>
> It's a userspace problem...
>
> All of the little usability things are userspace problems.
>
> I won't claim that it is trivial because it is a userspace problem, at the same
> time there is no reason to wait for any kernel features to merge etc.  Someone
> just has to scratch an itch and go fix it.

Yes, the crash utility (userspace) is clearly having problems getting
line number for symbols in x86_64 modules.  But I finally took some
time to bisect the point in the kernel where the crash utility first
started to fail, it appears to be:

commit 7460ed2844ffad7141e30271c0c3da8336e66014
Author: john stultz <johnstul@us.ibm.com>
Date:   Fri Feb 16 01:28:21 2007 -0800

    [PATCH] time: x86_64: re-enable vsyscall support for x86_64

    Cleanup and re-enable vsyscall gettimeofday using the generic clocksource
    infrastructure.

    [akpm@osdl.org: cleanup]
    Signed-off-by: John Stultz <johnstul@us.ibm.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Andi Kleen <ak@muc.de>
    Cc: Roman Zippel <zippel@linux-m68k.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

 arch/x86_64/Kconfig              |    4 +
 arch/x86_64/kernel/hpet.c        |    6 ++
 arch/x86_64/kernel/time.c        |    6 --
 arch/x86_64/kernel/tsc.c         |    7 ++
 arch/x86_64/kernel/vmlinux.lds.S |   28 ++++------
 arch/x86_64/kernel/vsyscall.c    |  119 ++++++++++++++++++++++---------------
 include/asm-x86_64/proto.h       |    2 -
 include/asm-x86_64/timex.h       |    1 -
 include/asm-x86_64/vsyscall.h    |   29 ++--------
 9 files changed, 104 insertions(+), 98 deletions(-)

Here is the full bisect log:

git-bisect start
# good: [62d0cfcb27cf755cebdc93ca95dabc83608007cd] Linux 2.6.20
git-bisect good 62d0cfcb27cf755cebdc93ca95dabc83608007cd
# bad: [c8f71b01a50597e298dc3214a2f2be7b8d31170c] Linux 2.6.21-rc1
git-bisect bad c8f71b01a50597e298dc3214a2f2be7b8d31170c
# good: [574009c1a895aeeb85eaab29c235d75852b09eb8] Merge branch
'upstream' of git://ftp.linux-mips.org/pub/scm/upstream-linus
git-bisect good 574009c1a895aeeb85eaab29c235d75852b09eb8
# good: [087d7ecd5273b480d13f4309a159842700afe276] [POWERPC] mpic: set
IPIs to be per-CPU
git-bisect good 087d7ecd5273b480d13f4309a159842700afe276
# bad: [920841d8d1d61bc12b43f95a579a5374f6d98f81] Merge branch
'for-linus' of ssh://master.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6
git-bisect bad 920841d8d1d61bc12b43f95a579a5374f6d98f81
# bad: [892705a1e1b4d0f9f6c5ac57f777b8055525bf68] USB: kernel-doc fixes
git-bisect bad 892705a1e1b4d0f9f6c5ac57f777b8055525bf68
# good: [741673473a5b26497d5390f38d478362e27e22ad] i386 prepare for dyntick
git-bisect good 741673473a5b26497d5390f38d478362e27e22ad
# bad: [ef29498655b18d2bfd69048e20835d19333981ab] Merge
master.kernel.org:/pub/scm/linux/kernel/git/davej/cpufreq
git-bisect bad ef29498655b18d2bfd69048e20835d19333981ab
# bad: [bec50c47aaf6f1f9247f1860547ab394a0802a4c] knfsd: nfsd4: acls:
avoid unnecessary denies
git-bisect bad bec50c47aaf6f1f9247f1860547ab394a0802a4c
# bad: [7460ed2844ffad7141e30271c0c3da8336e66014] time: x86_64:
re-enable vsyscall support for x86_64
git-bisect bad 7460ed2844ffad7141e30271c0c3da8336e66014
# good: [289f480af87e45f7a6de6ba9b4c061c2e259fe98] Add debugging
feature /proc/timer_list
git-bisect good 289f480af87e45f7a6de6ba9b4c061c2e259fe98
# good: [2d0c87c3bc49c60ab5bbac401fb1ef37ff10bbe2] time: x86_64:
hpet_address cleanup
git-bisect good 2d0c87c3bc49c60ab5bbac401fb1ef37ff10bbe2
# good: [1489939f0ab64b96998e04068c516c39afe29654] time: x86_64:
convert x86_64 to use GENERIC_TIME
git-bisect good 1489939f0ab64b96998e04068c516c39afe29654

I used version 4.0-7.6 of the crash utility to test if each commit was
good or bad.  I simply checked if ext3's module had correct line
number info for the ext3_get_blocks_handle symbol with: sym
ext3_get_blocks_handle

I tried to revert 7460ed2844ffad7141e30271c0c3da8336e66014 from
v2.6.21 but it had conflicts that I've not yet been able to put
adequate time to resolving.

That aside, I'd be very interested to know how/where this commit is
impacting the crash utility.  Has alignment of some module metadata
structure been altered and that is the problem?  This isn't my area of
expertise but I have to believe others may have useful insight.

Thanks,
Mike
