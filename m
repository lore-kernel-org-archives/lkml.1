Return-Path: <linux-kernel-owner+w=401wt.eu-S1755085AbZITRfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbZITRfE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 13:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbZITRfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 13:35:03 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:56130 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbZITRfA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 13:35:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DtHiqNL47/YstV5Ul1hSNpAfaXcaPPA0naCHpMwgdM0S2byqU+c/gtY7T1zqCQCL7H
         Xi6E+WuBjV9OWxRqEUvfFF/iKjwzej0wlS7M9zt84XnO2WQnhxRY6Ea09AhR6T+EpR9r
         ry0+VrC0uS7agQhoyjB9/qgdJEfXiTe9do7w0=
MIME-Version: 1.0
In-Reply-To: <20090920072210.GA23787@elte.hu>
References: <20090915080953.GA24958@elte.hu> <20090920072210.GA23787@elte.hu>
Date: Sun, 20 Sep 2009 19:35:03 +0200
Message-ID: <19f34abd0909201035t3157948amee532a3a5e96dbab@mail.gmail.com>
Subject: Re: shmem_fill_super(): WARNING: kmemcheck: Caught 32-bit read from 
	uninitialized memory
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/20 Ingo Molnar <mingo@elte.hu>:
>
> here's another one:
>
> [    0.337000] Total of 1 processors activated (3088.38 BogoMIPS).
> [    0.352000] CPU0 attaching NULL sched-domain.
> [    0.360000] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (9f8020fc)
> [    0.361000] a44240820000000041f6998100000000000000000000000000000000ff030000
> [    0.368000]  i i i i i i i i i i i i i i i i u u u u i i i i i i i i i i u u
> [    0.375000]                                                          ^
> [    0.376000]
> [    0.377000] Pid: 9, comm: khelper Not tainted (2.6.31-tip #206) P4DC6
> [    0.378000] EIP: 0060:[<810a3a95>] EFLAGS: 00010246 CPU: 0
> [    0.379000] EIP is at shmem_fill_super+0xb5/0x120
> [    0.380000] EAX: 00000000 EBX: 9f845400 ECX: 824042a4 EDX: 8199f641
> [    0.381000] ESI: 9f8020c0 EDI: 9f845400 EBP: 9f81af68 ESP: 81cd6eec

>
> Is this one known too?
>
>        Ingo
>

Thanks for the report.

AFAICT it's this line of mm/shmem.c:

2356         inode = shmem_get_inode(sb, S_IFDIR | sbinfo->mode, 0,
VM_NORESERVE     );

and the loading of sbinfo->mode. It fits with the offset 0x3c(%esi) ==
the address reported by kmemcheck and the offset of ->mode:

(gdb) p &((struct shmem_sb_info *) 0).mode
$1 = (mode_t *) 0x3c

Looking for the definition of mode_t, it seems to be defined in x86
sources as unsigned short:

arch/x86/include/asm/posix_types_32.h:11:typedef unsigned short __kernel_mode_t;
include/linux/types.h:typedef __kernel_mode_t           mode_t;

And the load was clearly 32-bit (kmemcheck said so) and in my assembly
dump it is also so.

As I said before, I really don't like the solution of sprinkling the
kmemcheck annotations all over the place to cover up field padding
inside structs, not in the least because they confuse more than they
help, and they are not maintainable -- when somebody changes the
struct definitions, anything may happen to the field layout, and then
the annotation may have to change too. And it's not exactly obvious.

I still vote for patching gcc as the long-term solution. There is
-fmudflap, there is -fstack-protector, why not a -fsacred-padding? Of
course it has to be implemented too...


Vegard
