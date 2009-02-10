Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbZBJMiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbZBJMiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 07:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbZBJMiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 07:38:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44580 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbZBJMiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 07:38:08 -0500
Date: Tue, 10 Feb 2009 13:37:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Cheng Renquan <crquan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] kprobes: check CONFIG_FREEZER instead of CONFIG_PM
Message-ID: <20090210123734.GB21531@elte.hu>
References: <200901062112.29227.rjw@sisk.pl> <200901062115.33286.rjw@sisk.pl> <20090107121659.GA16268@elte.hu> <alpine.LFD.2.00.0901091530090.16697@localhost.localdomain> <20090210010546.GA28129@elte.hu> <49909764.3020303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49909764.3020303@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Ingo Molnar wrote:
>> * Len Brown <lenb@kernel.org> wrote:
>>
>>>>> Check CONFIG_FREEZER instead of CONFIG_PM because kprobe booster
>>>>> depends on freeze_processes() and thaw_processes() when CONFIG_PREEMPT=y.
>>>>>
>>>>> This fixes a linkage error which occurs when CONFIG_PREEMPT=y, CONFIG_PM=y
>>>>> and CONFIG_FREEZER=n.
>>>>>
>>>>> Reported-by: Cheng Renquan <crquan@gmail.com>
>>>>> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>>>>> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>>>>> ---
>>>>>  arch/ia64/kernel/kprobes.c |    2 +-
>>>>>  arch/x86/kernel/kprobes.c  |    2 +-
>>>>>  kernel/kprobes.c           |    2 +-
>>>>>  3 files changed, 3 insertions(+), 3 deletions(-)
>>>> looks good, the x86 bits:
>>>>
>>>> Acked-by: Ingo Molnar <mingo@elte.hu>
>>> man, we have too many config options:-)
>>
>> the non-x86 bits (kernel/kprobes.c) are crappy though, and broke -rc4
>> allnoconfig:
>>
>> kernel/built-in.o: In function `collect_garbage_slots':
>> kprobes.c:(.kprobes.text+0x16e4): undefined reference to `freeze_processes'
>> kprobes.c:(.kprobes.text+0x16f2): undefined reference to `thaw_processes'
>> kprobes.c:(.kprobes.text+0x176b): undefined reference to `thaw_processes'
>
> Hmm, it seems that kernel/power/built-in.o was not linked to .tmp_vmlinux1.
>
>   ld -m elf_i386 --build-id -o .tmp_vmlinux1 -T arch/x86/kernel/vmlinux.lds
> arch/x86/kernel/head_32.o arch/x86/kernel/head32.o arch/x86/kernel/head.o
> arch/x86/kernel/init_task.o  init/built-in.o --start-group  usr/built-in.o
> arch/x86/kernel/built-in.o  arch/x86/mm/built-in.o  arch/x86/mach-default/built-in.o
> arch/x86/crypto/built-in.o  arch/x86/vdso/built-in.o  kernel/built-in.o
> mm/built-in.o  fs/built-in.o  ipc/built-in.o  security/built-in.o  crypto/built-in.o
> block/built-in.o  lib/lib.a  arch/x86/lib/lib.a  lib/built-in.o
> arch/x86/lib/built-in.o  drivers/built-in.o  sound/built-in.o  firmware/built-in.o
> arch/x86/pci/built-in.o  net/built-in.o --end-group
> kernel/built-in.o: In function `collect_garbage_slots':
> kprobes.c:(.kprobes.text+0x16e4): undefined reference to `freeze_processes'
> kprobes.c:(.kprobes.text+0x16f2): undefined reference to `thaw_processes'
> kprobes.c:(.kprobes.text+0x176b): undefined reference to `thaw_processes'
>
> At kernel/Makefile:53, I can see
>
> obj-$(CONFIG_PM) += power/
>
> but CONFIG_PM was not set in config

Sounds plausible. We need a fix for this - it's broken upstream.

	Ingo
