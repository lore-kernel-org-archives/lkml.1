Return-Path: <linux-kernel-owner+w=401wt.eu-S966501AbXJPWRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966501AbXJPWRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966302AbXJPWR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:17:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:34766 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966263AbXJPWRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:17:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=owM4F4lVchbcWSbqY40Nm2vDXMsHiEUTb02uMcgXpLwfn7t+W/uW0SDw8xI2NDk7rqGLucbPh0XUlvby6X094wD8E+ceMkKdOLbvJGDTRH2tMrprTnT5TO26Re3cU1iyplduze6/yW0Nt9o+UrNLfuS8ENKwYKJwL7vbUMxxYaU=
Message-ID: <4715378A.4050806@googlemail.com>
Date: Wed, 17 Oct 2007 00:13:30 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] scheduler updates for v2.6.24
References: <20071015141723.GA29486@elte.hu> <20071015113527.6bf91baf.akpm@linux-foundation.org> <20071015185307.GA26763@elte.hu>
In-Reply-To: <20071015185307.GA26763@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> On Mon, 15 Oct 2007 16:17:23 +0200
>> Ingo Molnar <mingo@elte.hu> wrote:
>>
>>> Linus, please pull the latest scheduler git tree from:
>>>
>>>    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
>> Did Paul Jackson's crash get fixed?
> 
> yes - that crash was a showstopper that was holding up the pull request 
> for 2 days. Paul bisected it down to the culprit and the fix was to do 
> this in wake_up_new_task():
> 
> -       if (!p->sched_class->task_new || !current->se.on_rq) {
> +       if (!p->sched_class->task_new || !current->se.on_rq || !rq->cfs.curr) {
> 
> (during early bootup the cfs_rq has no curr pointer yet.) It's not clear 
> why this race did not trigger earlier. (and the two checks can probably 
> be consolidated into a single "!rq->cfs.curr" condition.)

Maybe not related to that but now my box is killed after this merge.

When I do not much on the box I get maybe 6h uptime , by doing some work ( compiling etc ) is random freeze.

I was able to capture the OOps finally :

...

[15692.917111] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000044
[15692.917159]  printing eip:
[15692.917174] c0111f90
[15692.917185] *pde = 00000000
[15692.917200] Oops: 0000 [#1]
[15692.917208] PREEMPT SMP
[15692.917240] Modules linked in: fuse netconsole configfs pc87360 hwmon_vid eeprom adm1021 uhci_hcd sr_mod shpchp pci_hotplug ohci_hcd iTCO_wdt iTCO_vendor_support intel_agp i82860_edac i2c_i801 ehci_hcd usbcore edac_core cdrom agpgart 3c59x mii ext4dev jbd2 capability commoncap loop lp parport_pc parport evdev
[15692.917623] CPU:    0
[15692.917625] EIP:    0060:[<c0111f90>]    Not tainted VLI
[15692.917629] EFLAGS: 00010046   (2.6.23-g65a6ec0d #330)
[15692.917661] EIP is at pick_next_task_fair+0x1f/0x2d
[15692.917672] eax: c150a7b8   ebx: 00000000   ecx: 00000000   edx: 00000000
[15692.917689] esi: c1507a48   edi: 00000000   ebp: 00eaaf7a   esp: cb1fdf14
[15692.917701] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[15692.917715] Process sed (pid: 28999, ti=cb1fc000 task=cfdc3500 task.ti=cb1fc000)
[15692.917725] Stack: c02f8268 c02ef7b5 00000002 cb1fdf58 cb1fdf50 00000000 c0400f38 c0403780
[15692.917833]        cfdc3500 cfdc3634 c150a780 00000000 c011a8e7 00000000 c1077aa0 000000ff
[15692.917942]        00000000 00000000 00000000 cb1fdf8c 00000010 cfdc3500 cb1fdf8c c011ace5
[15692.918048] Call Trace:
[15692.918072]  [<c02ef7b5>] schedule+0x321/0x58f
[15692.918109]  [<c011a8e7>] do_exit+0x293/0x6c6
[15692.918143]  [<c011ace5>] do_exit+0x691/0x6c6
[15692.918169]  [<c011ad87>] sys_exit_group+0x0/0xd
[15692.918195]  [<c01026e6>] sysenter_past_esp+0x5f/0x85
[15692.918232]  =======================
[15692.918244] Code: 8b 53 28 89 43 34 89 53 38 5b 5e c3 53 31 d2 83 78 40 00 74 20 83 c0 38 8b 50 20 31 db 85 d2 74 0a 8d 5a f8 89 da e8 a9 ff ff ff <8b> 43 44 85 c0 75 e6 8d 53 d0 89 d0 5b c3 57 56 53 89 c6 89 d7
[15692.918981] EIP: [<c0111f90>] pick_next_task_fair+0x1f/0x2d SS:ESP 0068:cb1fdf14

...

After that the box is death need to hard reset it.

Interesting thing is when I compile the kernel with debug I don't get that ( or maybe its need longer to triggers it ? )

Config , lspci , dmesg , hardware specs , Oops message , and the top output when it Oops'ed there :


http://194.231.229.228/lara/

> 
> 	Ingo

Regards,

Gabriel
