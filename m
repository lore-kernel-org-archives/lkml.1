Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbYGSNQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbYGSNQR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 09:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbYGSNQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 09:16:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:16313 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbYGSNQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 09:16:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ruHj6t1eG+yyDFTVI01b/4MrZn80Klq/bQj0b/n4qkrlynH9a4SOlGxXqkH9w8HKTd
         WV5CLjbLNgVmzedf0nqVMBI7lTufZHDc9KWCTuBz2sY8g7lkPTEsItb1M69LOHrq3zxe
         NgjwckH/oxNl47CEIGfzyxnUJAj2mMhbKpuGs=
Message-ID: <19f34abd0807190616p47e7b0c8wf2f1004f09e6a592@mail.gmail.com>
Date: Sat, 19 Jul 2008 15:16:03 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Eric Sandeen" <sandeen@redhat.com>,
       "Tim Shimmin" <xfs-masters@oss.sgi.com>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org, "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: latest -git: kernel BUG at fs/xfs/support/debug.c:54!
In-Reply-To: <20080717224012.GH29319@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807171046j425bebc6m8d8eb80a641e0e5b@mail.gmail.com>
	 <487F980F.7070708@redhat.com>
	 <19f34abd0807171218u3de86ddbt506b0b4fa0548406@mail.gmail.com>
	 <19f34abd0807171229p724cc44ese3cb064a65fbd2c0@mail.gmail.com>
	 <20080717224012.GH29319@disturbed>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 12:40 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Jul 17, 2008 at 09:29:39PM +0200, Vegard Nossum wrote:
>> On Thu, Jul 17, 2008 at 9:18 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> > Thanks, you are right. I have adjusted my configuration, but I am
>> > still able to produce this:
>> >
>> > BUG: unable to handle kernel paging request at b62a66e0
>> > IP: [<c030ef88>] xfs_alloc_fix_freelist+0x28/0x490
>>
>> FWIW, this is fs/xfs/xfs_alloc.c:1817:
>>
>>         if (!pag->pagf_init) {
>
> Which kind of implies that we've got a bogus fsbno
> that we're using as the basis of allocation.....
>
> What is the corruption you are inducing? Can you produce
> a xfs_metadump image of the filesystem and put it up somewhere
> that we can access it?
>
> I suspect that we are not validating the block numbers coming
> out of the various btrees as landing inside the filesystem....

The method of corruption is quite crude (but efficient); just flip a
number of bits at random before mounting.

I got a different crash (NULL pointer) now, and I have a reproducible
case with a full disk image (it's only about 11M compressed, no
private/sensitive data). See
http://userweb.kernel.org/~vegard/bugs/20080719-xfs/

The way to reproduce:

    mount -o loop disk.xfs_idestroy_fork.bin /mnt
    rm -rf /mnt/*

And it should give something like this:

BUG: unable to handle kernel NULL pointer dereference at 00000008
IP: [<c0340ebf>] xfs_idestroy_fork+0x1f/0xe0
*pde = 00000000
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 3966, comm: rm Not tainted (2.6.26-03421-g253a722 #49)
EIP: 0060:[<c0340ebf>] EFLAGS: 00210202 CPU: 1
EIP is at xfs_idestroy_fork+0x1f/0xe0
EAX: f5402a00 EBX: 00000000 ECX: f5ff0da0 EDX: 00000001
ESI: 00000001 EDI: f5402a00 EBP: f5fe5e7c ESP: f5fe5e70
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process rm (pid: 3966, ti=f5fe4000 task=f5f1cfb0 task.ti=f5fe4000)
Stack: f5402a00 00000000 f5fe5ecc f5fe5ea4 c035f729 00000000 00000004 00000002
       f79e4180 f5ff0cd0 f5402a00 f5ff0520 00000001 f5fe5ee0 c035f91e 00000000
       00000000 00000000 00000001 f79e4180 f5f1cfb0 00000000 c01590ae f5ff0a40
Call Trace:
 [<c035f729>] ? xfs_inactive_attrs+0xe9/0x100
 [<c035f91e>] ? xfs_inactive+0x1de/0x4e0
 [<c01590ae>] ? get_lock_stats+0x1e/0x50
 [<c01590ed>] ? put_lock_stats+0xd/0x30
 [<c036b94a>] ? xfs_fs_clear_inode+0x8a/0xe0
 [<c01b964c>] ? clear_inode+0x7c/0x160
 [<c01b9c4e>] ? generic_delete_inode+0x10e/0x120
 [<c01b9d87>] ? generic_drop_inode+0x127/0x180
 [<c01b8c07>] ? iput+0x47/0x50
 [<c01af1dc>] ? do_unlinkat+0xec/0x170
 [<c0430a08>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c015ad96>] ? trace_hardirqs_on_caller+0x116/0x170
 [<c01af3a3>] ? sys_unlinkat+0x23/0x50
 [<c010407f>] ? sysenter_past_esp+0x78/0xc5
 =======================
Code: c9 c3 8d 76 00 8d bc 27 00 00 00 00 55 89 e5 83 ec 0c 85 d2 89
1c 24 8d 58 38 89 74 24 04 89 d6 89 7c 24 08 89 c7 74 03 8b 58 34 <8b>
43 08 85 c0 74 10 0f bf 53 0c e8 c1 11 02 00 c7 43 08 00 00
EIP: [<c0340ebf>] xfs_idestroy_fork+0x1f/0xe0 SS:ESP 0068:f5fe5e70
---[ end trace 9a7a5b8ebfdbeebf ]---


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
