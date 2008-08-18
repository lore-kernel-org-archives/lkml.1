Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbYHROEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbYHROEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYHROEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:04:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40171 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbYHROE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:04:28 -0400
Date: Mon, 18 Aug 2008 16:03:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: bugme-daemon@bugzilla.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 11219] KVM modules break emergency reboot
Message-ID: <20080818140355.GA30511@elte.hu>
References: <20080812091950.61E3911D109@picon.linux-foundation.org> <48A97B9A.1040800@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48A97B9A.1040800@qumranet.com>
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


* Avi Kivity <avi@qumranet.com> wrote:

> (copying mingo)
>
> (context: sysrq-B with kvm-intel.ko loaded doesn't work. on my machine,  
> it kills the sata interface, but the processor and network keeps working)
>
> Strangely, the specs say:
>
>> • The INIT signal is blocked whenever a logical processor is in VMX  
>> root operation.
>> It is not blocked in VMX non-root operation. Instead, INITs cause VM  
>> exits (see
>> Section 21.3, “Other Causes of VM Exits”).
>
> So INIT (which is wired to the triple-fault processor output, it seems,  
> rather than RESET) is blocked and the machine is not reset completely.
>
> So we need to disable vmx during native_machine_emergency_restart().  
> There are at least three ways of doing this:
>
> - add a vmxoff sequence (with an exception handler) to  
> native_machine_emergency_restart(). while simplest, this will not  
> unblock INIT for other cpus
>
> - add an emergency_restart notifier_block, and have kvm subscribe. This  
> has the disadvantage of being slightly complex, opening a tiny race  
> (emergency restart during kvm module initialization), and requiring IPIs  
> during emergency restart.
>
> - move vmxon/vmxoff management out of the kvm module and into x86 core.  
> Bloats the core but reduces complexity. IPIs still required.
>
> I think the notifier block is the way to go. Ingo, let me know what you  
> prefer.

notifier should be OK i think - sysrq-b is an emergency mechanism after 
all.

btw., "echo b > /proc/sysrq-trigger" never worked reliably for me with 
KVM also loaded.

	Ingo
