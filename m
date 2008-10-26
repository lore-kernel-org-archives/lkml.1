Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYJZAXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYJZAXu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 20:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbYJZAXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 20:23:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43699 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbYJZAXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 20:23:42 -0400
Date: Sun, 26 Oct 2008 01:23:36 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data
	to userspace
Message-ID: <20081026002336.GM28946@ZenIV.linux.org.uk>
References: <19f34abd0810251014s7968557br38e43aa0b9cdcf09@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0810251014s7968557br38e43aa0b9cdcf09@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2008 at 07:14:21PM +0200, Vegard Nossum wrote:
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
> 
> (For the record: This didn't show up in 2.6.27-rc with the same
> version of LTP, so it seems to be a recent regression.)

Very odd.  Do you see that for any other processes?  Where does
/sbin/udevd live on your box?  BTW, .config might be useful here...

Can you reproduce that on e.g. amd64 and/or without kmemcheck?
