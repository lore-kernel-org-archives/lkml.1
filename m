Return-Path: <linux-kernel-owner+w=401wt.eu-S967303AbXJSWL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967303AbXJSWL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 18:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765077AbXJSWLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 18:11:49 -0400
Received: from smtp-out.google.com ([216.239.33.17]:63258 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbXJSWLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 18:11:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=QyUHrbFkQiC0+ozfwkHU2V5igjxcFPEncYcFJB2hYberGHVnTyUkxoXtXQJPtSr1/
	NsWdP+awx3Kr76zRRH/Mw==
Message-ID: <6599ad830710191511k20744898oeede19ec8fc5d92@mail.gmail.com>
Date: Fri, 19 Oct 2007 15:11:38 -0700
From: "Paul Menage" <menage@google.com>
To: "Cedric Le Goater" <clg@fr.ibm.com>
Subject: Re: 2.6.23-mm1 - list_add corruption in cgroup
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <4716303C.8020009@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	 <4716303C.8020009@fr.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/07, Cedric Le Goater <clg@fr.ibm.com> wrote:
> Hello !
>
> While polling the contents of a cgroup task file, I caught the
> following corruption. Is there a known race (and a fix) or should
> I start digging ?
>
>  list_add corruption. next->prev should be prev (ffffffff80a3f338), but was 0000000000200200. (next=ffff810103dcbe90).
> ------------[ cut here ]------------
> kernel BUG at /home/legoater/linux/2.6.23-mm1/lib/list_debug.c:27!
> invalid opcode: 0000 [1] SMP
> last sysfs file: /devices/pci0000:00/0000:00:1e.0/0000:01:01.0/local_cpus
> CPU 3
> Modules linked in: ipt_REJECT iptable_filter autofs4 nfs lockd sunrpc tg3 sg joydev ext3 jbd ehci_hcd ohci_hcd uhci_hcd
> Pid: 2441, comm: bash Not tainted 2.6.23-mm1 #4
> RIP: 0010:[<ffffffff80308cda>]  [<ffffffff80308cda>] __list_add+0x27/0x5b
> RSP: 0018:ffff810103d87dd8  EFLAGS: 00010296
> RAX: 0000000000000079 RBX: ffff810105033040 RCX: 0000000000000079
> RDX: ffff810103d960c0 RSI: 0000000000000001 RDI: 0000000000000096
> RBP: ffff810103d87dd8 R08: 0000000000000002 R09: ffff810008123780
> R10: 0000000000000000 R11: ffff810103d87a98 R12: 0000000000000000
> R13: ffff810105033040 R14: ffff810104c11ac0 R15: 0000000000000000
> FS:  00007f4e273556f0(0000) GS:ffff81010011a840(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00000000006ca2f8 CR3: 0000000103d82000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process bash (pid: 2441, threadinfo ffff810103d86000, task ffff810103d960c0)
> last branch before last exception/interrupt
>  from  [<ffffffff80235885>] printk+0x68/0x69
>  to  [<ffffffff80308cda>] __list_add+0x27/0x5b
> Stack:  ffff810103d87de8 ffffffff80308d1a ffff810103d87e08 ffffffff802606bf
>  ffff810103d87e08 0000000000000000 ffff810103d87ea8 ffffffff80233dca
>  ffff810103ddf340 00007f4e27355780 0000000000000000 ffff810103d87f58
> Call Trace:
>  [<ffffffff80308d1a>] list_add+0xc/0xe
>  [<ffffffff802606bf>] cgroup_post_fork+0x41/0x52
>  [<ffffffff80233dca>] copy_process+0x12d0/0x143a
>  [<ffffffff8020b9b5>] tracesys+0xdc/0xe1
>  [<ffffffff80234095>] do_fork+0x76/0x203
>  [<ffffffff802679cc>] audit_syscall_entry+0x148/0x17e
>  [<ffffffff8020b9b5>] tracesys+0xdc/0xe1
>  [<ffffffff80209dd5>] sys_clone+0x23/0x25
>  [<ffffffff8020bb67>] ptregscall_common+0x67/0xb0

This is a crash on

    list_add(&child->cg_list, &child->cgroups->tasks);

in cgroup_post_fork(). So it looks like child->cgroups->tasks.next is
a deleted list element. But there are no places that modify that list
outside of write_lock(&css_set_lock) as far as I can see, so I'm a bit
confused as to what the problem could be. I'll try to reproduce this.

Paul
