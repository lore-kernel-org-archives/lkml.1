Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbZE0BA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbZE0BA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 21:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbZE0BAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 21:00:20 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36215 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbZE0BAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 21:00:19 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matheus Izvekov <mizvekov@gmail.com>, linux-kernel@vger.kernel.org
References: <20090521202655.GA13944@izvekov>
	<20090526165416.9078d218.akpm@linux-foundation.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 26 May 2009 18:00:12 -0700
In-Reply-To: <20090526165416.9078d218.akpm@linux-foundation.org> (Andrew Morton's message of "Tue\, 26 May 2009 16\:54\:16 -0700")
Message-ID: <m1zlczbbs3.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mizvekov@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3315]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [BUG] parport issue on 2.6.29
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 21 May 2009 17:26:55 -0300
> Matheus Izvekov <mizvekov@gmail.com> wrote:
>
>> This warning happens whenever a specific parallel port control app is run 
>> without a device attached to it. After the first timeout, the app hangs,
>> and needs SIGKILL to exit.
>> 
>> WARNING: at kernel/sysctl.c:2021 unregister_sysctl_table+0xa3/0x110()
>
> I guess this is
>
> void unregister_sysctl_table(struct ctl_table_header * header)
> {
> 	might_sleep();
>
> 	if (header == NULL)
> 		return;
>
> 	spin_lock(&sysctl_lock);
> 	start_unregistering(header);
> 	if (!--header->parent->count) {
> 		WARN_ON(1);
>
>> Hardware name:         
>> Modules linked in:
>> Pid: 12161, comm: x-killer.exe Not tainted 2.6.29.4 #14
>> Call Trace:
>> [<ffffffff8024c910>] warn_slowpath+0xd0/0x130
>> [<ffffffff80269859>] ? sched_clock_cpu+0xb9/0x190
>> [<ffffffff802484b4>] ? try_to_wake_up+0x174/0x330
>> [<ffffffff80268554>] ? up+0x34/0x50
>> [<ffffffff8024d1cd>] ? release_console_sem+0x1bd/0x210
>> [<ffffffff80aaa4d4>] ? printk+0x67/0x69
>> [<ffffffff80254ec3>] unregister_sysctl_table+0xa3/0x110
>> [<ffffffff806b3128>] parport_device_proc_unregister+0x28/0x40
>> [<ffffffff806b05f5>] parport_unregister_device+0x15/0x180
>> [<ffffffff806a0acc>] pp_release+0xbc/0x1f0
>> [<ffffffff802d3883>] __fput+0xc3/0x1e0
>> [<ffffffff802d39bd>] fput+0x1d/0x30
>> [<ffffffff802d0220>] filp_close+0x50/0x80
>> [<ffffffff8024ec74>] put_files_struct+0x84/0xe0
>> [<ffffffff8024ed1e>] exit_files+0x4e/0x60
>> [<ffffffff80250696>] do_exit+0x196/0x930
>> [<ffffffff80250e6e>] do_group_exit+0x3e/0xb0
>> [<ffffffff8025bda4>] get_signal_to_deliver+0x2a4/0x420
>> [<ffffffff8020b7aa>] do_notify_resume+0xba/0x900
>> [<ffffffff8023c16e>] ? __wake_up+0x4e/0x70
>> [<ffffffff8026c4a9>] ? getnstimeofday+0x59/0xe0
>> [<ffffffff80267a09>] ? ktime_get_ts+0x59/0x60
>> [<ffffffff80274314>] ? compat_sys_futex+0xb4/0x140
>> [<ffffffff8020c8b5>] int_signal+0x12/0x17
>> --[ end trace ff1bd583c825c0c5 ]---
>> pdev0: unregistered pardevice
>
> <looks for explanatory code comments, gets disappointed>
>
> Eric, can you please help decode the reason for this kernel warning?

Looks like fallout from when Al changed the semantics of sysctl.  Requiring
sysctl tables to hang off of empty parent directories.

It looks the parent directory was already been unregistered by the
time we are unregistered.

I'm not current enough on the parport code to have a better clue.

As far as sysctl goes that condition should be essentially harmless, wrong
but harmless.

Eric
