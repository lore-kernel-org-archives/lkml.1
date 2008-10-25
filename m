Return-Path: <linux-kernel-owner+w=401wt.eu-S1752527AbYJYUhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbYJYUhk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 16:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYJYUhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 16:37:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51567 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbYJYUha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 16:37:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data to userspace
Date: Sat, 25 Oct 2008 22:41:52 +0200
User-Agent: KMail/1.9.9
Cc: "Al Viro" <viro@zeniv.linux.org.uk>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <19f34abd0810251014s7968557br38e43aa0b9cdcf09@mail.gmail.com>
In-Reply-To: <19f34abd0810251014s7968557br38e43aa0b9cdcf09@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810252241.53601.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 25 of October 2008, Vegard Nossum wrote:
> Hi,
> 
> When I run readlink on the /proc/*/exe-file for udevd, the kernel
> returns some unitialized data to userspace:
> 
> # strace -e trace=readlink readlink /proc/4762/exe
> readlink("/proc/4762/exe", "/sbin/udevd", 1025) = 30
> 
> You can see it because the kernel thinks that the string is 30 bytes
> long, but in fact it is only 12 (including the '\0').
> 
> If we explicitly clear the buffer before calling readlink, we can also
> see that some garbage has been filled in there, after the string:
> 
> # ./readlink /proc/4762/exe
> readlink(/proc/4762/exe) = 30
> 2f7362696e2f7564657664000000ffffffad4effffffadffffffdeffffffffffffffff202864656c657465642900000000000000000000000000000
> 
> (Output is from following simple program:)
> 
> #include <stdio.h>
> #include <string.h>
> #include <unistd.h>
> 
> int main(int argc, char *argv[])
> {
>         char buf[1024];
>         int i;
>         ssize_t n;
> 
>         memset(buf, 0, sizeof(buf));
>         n = readlink(argv[1], buf, sizeof(buf));
> 
>         printf("readlink(%s) = %d\n", argv[1], n);
> 
>         for (i = 0; i < sizeof(buf); ++i)
>                 printf("%02x", buf[i]);
>         printf("\n");
> 
>         return 0;
> }
> 
> It was discovered by kmemcheck:
> 
> WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f6a109e4)
> 64000000ad4eaddeffffffffffffffff000000000200000000000000c0838ff8
>  i i u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u
>          ^
> 
> Pid: 21511, comm: readlink Not tainted (2.6.28-rc1 #58) 945P-A
> EIP: 0060:[<c04f988d>] EFLAGS: 00000296 CPU: 0
> EIP is at __d_path+0x8d/0x1c0
> EAX: 0000000e EBX: d7ba0fe7 ECX: 00000001 EDX: f68b0b40
> ESI: f6a109e4 EDI: d7ba0fef EBP: e58c3f28 ESP: c2569c08
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> CR0: 8005003b CR2: f6c1d704 CR3: 31fc7000 CR4: 00000650
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> DR6: ffff4ff0 DR7: 00000400
>  [<c04fa4b0>] d_path+0xb0/0xd0
>  [<c052c37c>] proc_pid_readlink+0x6c/0xc0
>  [<c04eda34>] sys_readlinkat+0x94/0xa0
>  [<c04eda67>] sys_readlink+0x27/0x30
>  [<c0422f83>] sysenter_do_call+0x12/0x3f
>  [<ffffffff>] 0xffffffff
> 
> Line numbers are these (as of commit
> e013e13bf605b9e6b702adffbe2853cfc60e7806 in Linus's tree):
> 
> $ addr2line -e vmlinux -i c04f988d c04fa4b0 c052c37c c04eda34 c04eda67
> fs/dcache.c:1895
> fs/dcache.c:1901
> fs/dcache.c:1957
> fs/dcache.c:2016
> fs/proc/base.c:1347
> fs/proc/base.c:1374
> fs/stat.c:312
> fs/stat.c:325
> 
> I couldn't immediately figure out who/what to blame, please Cc in
> right direction if you think you know it :-)

Well, I only can say who may be interested (CCs added).

Thanks,
Rafael
