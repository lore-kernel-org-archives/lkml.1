Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbZFPWhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbZFPWhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 18:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756916AbZFPWhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 18:37:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:19590 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbZFPWhI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 18:37:08 -0400
MIME-Version: 1.0
In-Reply-To: <20090616215908.GA4390@kroah.com>
References: <f488382f0906161435w2559831cob8a5b8a78c22cf91@mail.gmail.com>
	 <20090616215908.GA4390@kroah.com>
Date: Tue, 16 Jun 2009 15:30:24 -0700
Message-ID: <f488382f0906161530u169616c4ra557c4f055d9cb13@mail.gmail.com>
Subject: Re: [BISECTED] uvesafb broken on 2.6.30 (v86d segfault)
From: Steven Noonan <steven@uplinklabs.net>
To: Greg KH <greg@kroah.com>
Cc: Michal Januszewski <spock@gentoo.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 2:59 PM, Greg KH<greg@kroah.com> wrote:
> On Tue, Jun 16, 2009 at 02:35:27PM -0700, Steven Noonan wrote:
>> I noticed that v86d segfaults on the final v2.6.30 release (breaking
>> uvesafb), but doesn't on the current master (v2.6.30-3392-g44b7532)
>> nor on v2.6.29.x. I originally tried to git-bisect v2.6.29 and
>> v2.6.30-rc1 (the first tag to contain the problem), but I ran into
>> multiple kernels that would either not compile or would simply panic
>> on boot.
>>
>> So instead, I did a 'git bisect' on commits between tags 'v2.6.30' and
>> commit-ish '44b7532' to find the commit that _corrected_ the problem
>> (reversing the 'good'/'bad' logic of git-bisect to do the task).
>>
>> First, here's the relevant dmesg output for broken kernels:
>>
>> [    1.770858] general protection fault: 0000 [#1] SMP
>> [    1.771080] last sysfs file:
>> [    1.771163] Modules linked in:
>> [    1.771287]
>> [    1.771287] Pid: 531, comm: v86d Not tainted (2.6.30 #1) HP
>> Pavilion dv5000 (ES933AS#ABA)
>> [    1.771287] EIP: 0060:[<c10c1377>] EFLAGS: 00013286 CPU: 0
>> [    1.771287] EIP is at lockdep_sys_exit+0x7/0xa0
>> [    1.771287] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: f73e0000
>> [    1.771287] ESI: c3d9e800 EDI: f73e1ed4 EBP: f73e1ec0 ESP: f73e1eac
>> [    1.771287]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
>> [    1.771287] Process v86d (pid: 531, ti=f73e0000 task=f73fe9c0
>> task.ti=f73e0000)
>> [    1.771287] Stack:
>> [    1.771287]  f73e1f00 674c2f57 f73e1fb4 f73fe9c0 00000000 f73e0000
>> c10334c4 f73e0000
>> [    1.771287]  00000000 00000000 00000000 00000000 00000000 00000000
>> 00000000 00000000
>> [    1.771287]  00004f00 00000000 00000000 00000000 00000000 00000000
>> 0000100a 0000c000
>> [    1.771287] Call Trace:
>> [    1.771287]  [<c10334c4>] ? resume_userspace+0x8/0x28
>> [    1.771287]  [<c1033644>] ? syscall_call+0x7/0xb
>> [    1.771287]  [<c109007b>] ? proc_taint+0xab/0x140
>> [    1.771287] Code: 04 24 00 4a b6 c1 e8 69 77 7e 00 85 f6 0f 8e 57
>> ff ff ff eb a5 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90 90 55 89 e5
>> 53 83 ec 10 <65> a1 14 00 00 00 89 45 f8 31 c0 64 8b 1d 20 20 ee c1 8b
>> 83 b0
>> [    1.771287] EIP: [<c10c1377>] lockdep_sys_exit+0x7/0xa0 SS:ESP 0068:f73e1eac
>> [    1.779083] ---[ end trace e93713a9d40cd06c ]---
>> [    6.777823] uvesafb: Getting VBE info block failed (eax=0x4f00, err=1)
>> [    6.777924] uvesafb: vbe_init() failed with -22
>> [    6.778031] uvesafb: probe of uvesafb.0 failed with error -22
>>
>>
>>
>> Michal (uvesafb creator) suggested that I try disabling lockdep to see
>> what happens. Doing so changes the dmesg output to this:
>>
>> [    1.648494] general protection fault: 0000 [#1] SMP
>> [    1.648695] last sysfs file:
>> [    1.648771] Modules linked in:
>> [    1.648903]
>> [    1.648979] Pid: 529, comm: v86d Not tainted (2.6.30 #1) HP
>> Pavilion dv5000 (ES933AS#ABA)
>> [    1.649086] EIP: 0060:[<c110943b>] EFLAGS: 00013082 CPU: 0
>> [    1.649176] EIP is at trace_hardirqs_off_caller+0xb/0x110
>> [    1.649261] EAX: c1033242 EBX: c1033242 ECX: 00000000 EDX: f684a000
>> [    1.649346] ESI: c2f54640 EDI: f684bed4 EBP: f684bebc ESP: f684be98
>> [    1.649381]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
>> [    1.649381] Process v86d (pid: 529, ti=f684a000 task=f7103ed0
>> task.ti=f684a000)
>> [    1.649381] Stack:
>> [    1.649381]  f684bed4 f684bec0 c1057457 f684bec0 f7103ed0 f684bf00
>> 00000000 f684bfb4
>> [    1.649381]  f7103ed0 f684a000 c148d5e4 f684a000 00000000 00000000
>> c1033242 00000000
>> [    1.649381]  00000000 00000000 00000000 00000000 00000000 00004f00
>> 00000000 00000000
>> [    1.649381] Call Trace:
>> [    1.649381]  [<c1057457>] ? do_sys_vm86+0x1b7/0x390
>> [    1.649381]  [<c148d5e4>] ? trace_hardirqs_off_thunk+0xc/0x18
>> [    1.649381]  [<c1033242>] ? resume_userspace+0x6/0x1c
>> [    1.649381]  [<c10333b0>] ? syscall_call+0x7/0xb
>> [    1.649381]  [<c109007b>] ? do_sysctl+0x2db/0x3a0
>> [    1.649381] Code: c0 a3 f4 d1 de c1 31 c0 8b 55 fc 65 33 15 14 00
>> 00 00 75 02 c9 c3 e8 05 8b f7 ff 90 8d 74 26 00 55 89 e5 83 ec 24 89
>> 5d f4 89 c3 <65> a1 14 00 00 00 89 45 f0 31 c0 f6 05 f8 d1 de c1 02 89
>> 75 f8
>> [    1.649381] EIP: [<c110943b>] trace_hardirqs_off_caller+0xb/0x110
>> SS:ESP 0068:f684be98
>> [    1.649381] ---[ end trace e93713a9d40cd06c ]---
>> [    6.655118] uvesafb: Getting VBE info block failed (eax=0x4f00, err=1)
>> [    6.655208] uvesafb: vbe_init() failed with -22
>> [    6.655299] uvesafb: probe of uvesafb.0 failed with error -22
>>
>>
>>
>> Here's the bisection log (remember to mentally reverse 'bad' and 'good'):
>>
>> # bad: [45e3e1935e2857c54783291107d33323b3ef33c8] Merge branch
>> 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-next
>> # good: [07a2039b8eb0af4ff464efd3dfd95de5c02648c6] Linux 2.6.30
>> git bisect start 'HEAD' 'v2.6.30'
>> # bad: [8a1ca8cedd108c8e76a6ab34079d0bbb4f244799] Merge branch
>> 'perfcounters-for-linus' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
>> git bisect bad 8a1ca8cedd108c8e76a6ab34079d0bbb4f244799
>> # bad: [6cd8e300b49332eb9eeda45816c711c198d31505] Merge branch
>> 'kvm-updates/2.6.31' of git://git.kernel.org/pub/scm/virt/kvm/kvm
>> git bisect bad 6cd8e300b49332eb9eeda45816c711c198d31505
>> # bad: [73fbad283cfbbcf02939bdbda31fc4a30e729cca] Merge branch 'next'
>> into for-linus
>> git bisect bad 73fbad283cfbbcf02939bdbda31fc4a30e729cca
>> # good: [bb7762961d3ce745688e9050e914c1d3f980268d] Merge branch
>> 'x86-mm-for-linus' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
>> git bisect good bb7762961d3ce745688e9050e914c1d3f980268d
>> # bad: [75063600fd7b27fe447112c27997f100b9e2f99b] Merge branch
>> 'futexes-for-linus' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
>> git bisect bad 75063600fd7b27fe447112c27997f100b9e2f99b
>> # good: [6b2e8523df148c15ea5abf13075026fb8bdb3f86] xen: reserve Xen
>> start_info rather than e820 reserving
>> git bisect good 6b2e8523df148c15ea5abf13075026fb8bdb3f86
>> # bad: [be15f9d63b97da0065187696962331de6cd9de9e] Merge branch
>> 'x86-xen-for-linus' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
>> git bisect bad be15f9d63b97da0065187696962331de6cd9de9e
>> # good: [bec706838ec2f9c8c2b99e88a1270d7cba159b06] Merge branch
>> 'x86-setup-for-linus' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
>> git bisect good bec706838ec2f9c8c2b99e88a1270d7cba159b06
>> # bad: [0b8c3d5ab000c22889af7f9409799a6cdc31a2b2] x86: Clear TS in
>> irq_ts_save() when in an atomic section
>> git bisect bad 0b8c3d5ab000c22889af7f9409799a6cdc31a2b2
>> # bad: [3aa6b186f86c5d06d6d92d14311ffed51f091f40] x86: Fix non-lazy GS
>> handling in sys_vm86()
>> git bisect bad 3aa6b186f86c5d06d6d92d14311ffed51f091f40
>> # good: [4a4aca641bc4598e77b866804f47c651ec4a764d] x86: Add quirk for
>> reboot stalls on a Dell Optiplex 360
>> git bisect good 4a4aca641bc4598e77b866804f47c651ec4a764d
>>
>>
>>
>> And here's the commit that fixes the problem:
>>
>> commit 3aa6b186f86c5d06d6d92d14311ffed51f091f40
>> Author: Lubomir Rintel <lkundrak@v3.sk>
>> Date:   Sun Jun 7 16:23:48 2009 +0200
>>
>>     x86: Fix non-lazy GS handling in sys_vm86()
>>
>>     This fixes a stack corruption panic or null dereference oops
>>     due to a bad GS in resume_userspace() when returning from
>>     sys_vm86() and calling lockdep_sys_exit().
>>
>>     Only a problem when CONFIG_LOCKDEP and CONFIG_CC_STACKPROTECTOR
>>     enabled.
>>
>>     Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
>>     Cc: H. Peter Anvin <hpa@zytor.com>
>>     LKML-Reference: <1244384628.2323.4.camel@bimbo>
>>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>
>>
>> The cherry-pick of the bisected commit seems to work when applied to
>> vanilla v2.6.30.
>>
>> Greg, for v2.6.30.1, could you please cherry-pick commit
>> 3aa6b186f86c5d06d6d92d14311ffed51f091f40?
>
> I don't see that commit id in Linus's tree.  Where did you get it from?
>
> thanks,
>
> greg k-h
>

(Whoops, forgot to do reply-to-all. Grr.)


That's bizarre. Indeed, it doesn't show up on gitweb for
git.kernel.org, but yet git claims Linus' branch contains it:

tycho@xerxes /usr/src/linux $ git branch -a --contains
3aa6b186f86c5d06d6d92d14311ffed51f091f40
* linus-master
 remotes/linus/HEAD -> linus/master
 remotes/linus/master


And my remotes appear to be fine:

tycho@xerxes /usr/src/linux $ git remote -v
linus   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
stable-2.6.28 git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.28.y.git
stable-2.6.29 git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.29.y.git
stable-2.6.30 git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.30.y.git


And if I do a fresh clone of Linus' repository on a different machine
it shows up...

steven@Alcarin ~ $ git clone --mirror
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
Initialized empty Git repository in /c/Users/steven/linux-2.6.git/
remote: Counting objects: 1228999, done.
remote: Compressing objects: 100% (202131/202131), done.
remote: Total 1228999 (delta 1025517), reused 1222853 (delta 1019520)
Receiving objects: 100% (1228999/1228999), 301.86 MiB | 1075 KiB/s, done.
Resolving deltas: 100% (1025517/1025517), done.

steven@Alcarin ~ $ cd linux-2.6.git/
steven@Alcarin ~/linux-2.6.git $ git branch -a --contains
3aa6b186f86c5d06d6d92d14311ffed51f091f40
* master


I guess gitweb isn't behaving nicely?

- Steven
