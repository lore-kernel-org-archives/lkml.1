Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbYKDJjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbYKDJjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 04:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYKDJjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 04:39:22 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:52269 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbYKDJjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 04:39:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WzhVmfT0lepXFUn1yGBpYq8fX4nY6Icdxq3m6wGID45du0jw6+Isbq6nTUXiTzrnvu
         Fj6MLf9QCK82tvglDxXFFMfvwEG9+YDd4Emcx4eZUnB5fJykHs5jE3Gc9wcVDz4qgdDz
         O/1syeucim2PTRGns/ZhdxTjqntNZu4vqTPh8=
Message-ID: <19f34abd0811040139t8334502i7a5d8501c5fe95ac@mail.gmail.com>
Date: Tue, 4 Nov 2008 10:39:19 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data to userspace
Cc: "Koyama, Yoshiya" <Yoshiya.Koyama@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>,
       "Kay Sievers" <kay.sievers@vrfy.org>, linux-fsdevel@vger.kernel.org
In-Reply-To: <19f34abd0810261408w61b1e2dbvb9a0e16ce5a10022@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0810251014s7968557br38e43aa0b9cdcf09@mail.gmail.com>
	 <200810252241.53601.rjw@sisk.pl> <m163nggvhq.fsf@frodo.ebiederm.org>
	 <19f34abd0810261408w61b1e2dbvb9a0e16ce5a10022@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2008 at 10:08 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> [Combined result for Eric & Viro]
>
> On Sat, Oct 25, 2008 at 11:28 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>> On Saturday, 25 of October 2008, Vegard Nossum wrote:
>>>> Hi,
>>>>
>>>> When I run readlink on the /proc/*/exe-file for udevd, the kernel
>>>> returns some unitialized data to userspace:
>>>>
>>>> # strace -e trace=readlink readlink /proc/4762/exe
>>>> readlink("/proc/4762/exe", "/sbin/udevd", 1025) = 30
>>>>
>>>> You can see it because the kernel thinks that the string is 30 bytes
>>>> long, but in fact it is only 12 (including the '\0').
> ...
>
>> Weird.  The dentry for "udevd" has an incorrect length.
>> Is something stomping the length somewhere?
>>
>> What filesystem does /sbin/udevd reside on?
>
> Ext3 on a USB flash-disk.
>
> On Sun, Oct 26, 2008 at 1:23 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>> (For the record: This didn't show up in 2.6.27-rc with the same
>>> version of LTP, so it seems to be a recent regression.)
>>
>> Very odd.  Do you see that for any other processes?  Where does
>> /sbin/udevd live on your box?  BTW, .config might be useful here...
>>
>> Can you reproduce that on e.g. amd64 and/or without kmemcheck?
>
> IIRC, it did show up for other processes, but udevd was the only one
> which exhibited the problem reliably.
>
> Now, I've been trying to reproduce the problem (with exact same setup)
> since I first saw it, but can't :-/ At the time that the machine
> started showing the problem, it had been running LTP, scrashme, etc.
> for hours, so it seems that it might have had something to do with it.
> I couldn't reproduce it after rebooting.
>
> This was my setup:
>  - root filesystem (ext3) on USB flash disk
>  - mounted LVM2/ext3 from harddisk on /mnt
>  - bind-mounted /proc onto /mnt/proc
>
> I noticed the problem from chroot /mnt, but it reproduced afterwards
> on the outside as well. I also remember having remounted (with -o
> remount) both /mnt (adding user_xattr to options) and /mnt/proc from
> within the chroot (so with /mnt prefix removed). This could of course
> all be unrelated since it didn't reproduce the problem, but at least
> it is what I did.
>
> Cosmic rays may have been involved. Will keep trying to reproduce.
> Thanks for attention so far.

Hello,

I received an e-mail from Yoshiya Koyama today with a reproducible
test case (see bottom of e-mail).

Here's with linux-next from October 31:

# uname -a
Linux ubuntu 2.6.28-rc2-next-20081031 #60 SMP Sat Nov 1 13:19:49 CET
2008 i686 GNU/Linux
# prelink -mRf /sbin/udevd
# ./a.out /proc/4764/exe
warning: /proc/4764/exe: got return value 38, expected 11
2f7362696e2f756465766400fffffffffdfffffffffffff7ffffbfff202864656c6574656429
/sbin/udevd                  (deleted)

...and in system log:

WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f61c26c0)
fffffdfffffffffffff7ffffbfffffffffffffefefffffafefffffffffeffffb
 u u u u u u u u u u u u u u u u u u u u u u u u u u u u a a a a
 ^

Pid: 8118, comm: a.out Not tainted (2.6.28-rc2-next-20081031 #60) 945P-A
EIP: 0060:[<c04fb8ed>] EFLAGS: 00000292 CPU: 0
EIP is at __d_path+0x8d/0x1c0
EAX: 00000016 EBX: f2f92fdf ECX: 00000003 EDX: f60aa280
ESI: f61c26c0 EDI: f2f92fe7 EBP: f3115f28 ESP: c24a0308
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: f6629704 CR3: 331ab000 CR4: 00000650
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff4ff0 DR7: 00000400
 [<c04fc510>] d_path+0xb0/0xd0
 [<c052f4bc>] proc_pid_readlink+0x6c/0xc0
 [<c04ef794>] sys_readlinkat+0x94/0xa0
 [<c04ef7c7>] sys_readlink+0x27/0x30
 [<c0424fb3>] sysenter_do_call+0x12/0x3f
 [<ffffffff>] 0xffffffff
WARNING: kmemcheck: Caught 8-bit read from uninitialized memory (f61c26cc)
fffffdfffffffffffff7ffffbfffffffffffffefefffffafefffffffffeffffb
 u u u u u u u u u u u u u u u u u u u u u u u u u u u u a a a a
                         ^

Pid: 8118, comm: a.out Not tainted (2.6.28-rc2-next-20081031 #60) 945P-A
EIP: 0060:[<c04fb8f5>] EFLAGS: 00010202 CPU: 0
EIP is at __d_path+0x95/0x1c0
EAX: 00000016 EBX: f2f92fdf ECX: 00000002 EDX: f60aa280
ESI: f61c26cc EDI: f2f92ff3 EBP: f3115f28 ESP: c24a0428
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: f6629704 CR3: 331ab000 CR4: 00000650
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff4ff0 DR7: 00000400
 [<c04fc510>] d_path+0xb0/0xd0
 [<c052f4bc>] proc_pid_readlink+0x6c/0xc0
 [<c04ef794>] sys_readlinkat+0x94/0xa0
 [<c04ef7c7>] sys_readlink+0x27/0x30
 [<c0424fb3>] sysenter_do_call+0x12/0x3f
 [<ffffffff>] 0xffffffff
WARNING: kmemcheck: Caught 8-bit read from uninitialized memory (f61c26cd)
fffffdfffffffffffff7ffffbfffffffffffffefefffffafefffffffffeffffb
 u u u u u u u u u u u u u u u u u u u u u u u u u u u u a a a a
                           ^

Pid: 8118, comm: a.out Not tainted (2.6.28-rc2-next-20081031 #60) 945P-A
EIP: 0060:[<c04fb8f6>] EFLAGS: 00000202 CPU: 0
EIP is at __d_path+0x96/0x1c0
EAX: 00000016 EBX: f2f92fdf ECX: 00000001 EDX: f60aa280
ESI: f61c26cd EDI: f2f92ff4 EBP: f3115f28 ESP: c24a0548
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: f6629704 CR3: 331ab000 CR4: 00000650
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff4ff0 DR7: 00000400
 [<c04fc510>] d_path+0xb0/0xd0
 [<c052f4bc>] proc_pid_readlink+0x6c/0xc0
 [<c04ef794>] sys_readlinkat+0x94/0xa0
 [<c04ef7c7>] sys_readlink+0x27/0x30
 [<c0424fb3>] sysenter_do_call+0x12/0x3f
 [<ffffffff>] 0xffffffff

Here's Fedora 9 (no kmemcheck):

# uname -a
Linux localhost.localdomain 2.6.25.11-97.fc9.i686 #1 SMP Mon Jul 21
01:31:09 EDT 2008 i686 i686 i386 GNU/Linux
# prelink -mRf /sbin/udevd
# ./a.out /proc/564/exe
warning: /proc/564/exe: got return value 38, expected 11
2f7362696e2f7564657664005f47387942426e5952446e566f306868202864656c6574656429
/sbin/udevd _G8yBBnYRDnVo0hh (deleted)

Yoshiya Koyama reports that the problem exists on RHEL 2.6.9-42.ELsmp too.

I don't think it's exactly the same problem as originally reported,
because I definitely wasn't using prelinking (the prelink binary
wasn't even installed on the machine until today). But finding the
root cause of this may solve both problems.


Vegard


---------- Forwarded message ----------
From: Koyama, Yoshiya <Yoshiya.Koyama@hp.com>
Date: Tue, Nov 4, 2008 at 5:00 AM
Subject: Re: v2.6.28-rc1: readlink /proc/*/exe returns uninitialized
data to userspace
To: "vegard.nossum@gmail.com" <vegard.nossum@gmail.com>


Hello Vegard,

I'm Yoshiya Koyama

I happen to encounter the same readlink problem you reported to the LKML.
I don't know my case is exactly the same one as yours, but I can reproduce it.
How to reproduce:
# prelink -mRf /sbin/udevd
After prelinking the binary, you can see garbages returned from readlink.
When you restart udevd, the problem will disappear.
I'm running RHEL 2.6.9-42.ELsmp.

Hope this help
---
Yoshiya Koyama / Hewlett-Packard Japan, Ltd. 03-5349-7320 (FAX 7464)
mailto:Yoshiya.Koyama@hp.com
