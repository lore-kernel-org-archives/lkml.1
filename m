Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbZBJByd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbZBJByd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 20:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbZBJByU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 20:54:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58828 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206AbZBJByR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 20:54:17 -0500
Message-ID: <49909764.3020303@redhat.com>
Date: Mon, 09 Feb 2009 15:51:48 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Cheng Renquan <crquan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] kprobes: check CONFIG_FREEZER instead of CONFIG_PM
References: <200901062112.29227.rjw@sisk.pl> <200901062115.33286.rjw@sisk.pl> <20090107121659.GA16268@elte.hu> <alpine.LFD.2.00.0901091530090.16697@localhost.localdomain> <20090210010546.GA28129@elte.hu>
In-Reply-To: <20090210010546.GA28129@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Len Brown <lenb@kernel.org> wrote:
> 
>>>> Check CONFIG_FREEZER instead of CONFIG_PM because kprobe booster
>>>> depends on freeze_processes() and thaw_processes() when CONFIG_PREEMPT=y.
>>>>
>>>> This fixes a linkage error which occurs when CONFIG_PREEMPT=y, CONFIG_PM=y
>>>> and CONFIG_FREEZER=n.
>>>>
>>>> Reported-by: Cheng Renquan <crquan@gmail.com>
>>>> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>>>> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>>>> ---
>>>>  arch/ia64/kernel/kprobes.c |    2 +-
>>>>  arch/x86/kernel/kprobes.c  |    2 +-
>>>>  kernel/kprobes.c           |    2 +-
>>>>  3 files changed, 3 insertions(+), 3 deletions(-)
>>> looks good, the x86 bits:
>>>
>>> Acked-by: Ingo Molnar <mingo@elte.hu>
>> man, we have too many config options:-)
> 
> the non-x86 bits (kernel/kprobes.c) are crappy though, and broke -rc4
> allnoconfig:
> 
> kernel/built-in.o: In function `collect_garbage_slots':
> kprobes.c:(.kprobes.text+0x16e4): undefined reference to `freeze_processes'
> kprobes.c:(.kprobes.text+0x16f2): undefined reference to `thaw_processes'
> kprobes.c:(.kprobes.text+0x176b): undefined reference to `thaw_processes'

Hmm, it seems that kernel/power/built-in.o was not linked to .tmp_vmlinux1.

   ld -m elf_i386 --build-id -o .tmp_vmlinux1 -T arch/x86/kernel/vmlinux.lds
arch/x86/kernel/head_32.o arch/x86/kernel/head32.o arch/x86/kernel/head.o
arch/x86/kernel/init_task.o  init/built-in.o --start-group  usr/built-in.o
arch/x86/kernel/built-in.o  arch/x86/mm/built-in.o  arch/x86/mach-default/built-in.o
arch/x86/crypto/built-in.o  arch/x86/vdso/built-in.o  kernel/built-in.o
mm/built-in.o  fs/built-in.o  ipc/built-in.o  security/built-in.o  crypto/built-in.o
block/built-in.o  lib/lib.a  arch/x86/lib/lib.a  lib/built-in.o
arch/x86/lib/built-in.o  drivers/built-in.o  sound/built-in.o  firmware/built-in.o
arch/x86/pci/built-in.o  net/built-in.o --end-group
kernel/built-in.o: In function `collect_garbage_slots':
kprobes.c:(.kprobes.text+0x16e4): undefined reference to `freeze_processes'
kprobes.c:(.kprobes.text+0x16f2): undefined reference to `thaw_processes'
kprobes.c:(.kprobes.text+0x176b): undefined reference to `thaw_processes'

At kernel/Makefile:53, I can see

obj-$(CONFIG_PM) += power/

but CONFIG_PM was not set in config

> 
> Could someone please fix all of this without #ifdefs?
> 
> 	Ingo
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

