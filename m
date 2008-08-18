Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbYHRNjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbYHRNjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 09:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbYHRNjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 09:39:40 -0400
Received: from il.qumranet.com ([212.179.150.194]:38023 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbYHRNjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 09:39:40 -0400
Message-ID: <48A97B9A.1040800@qumranet.com>
Date: Mon, 18 Aug 2008 16:39:38 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: bugme-daemon@bugzilla.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 11219] KVM modules break emergency reboot
References: <20080812091950.61E3911D109@picon.linux-foundation.org>
In-Reply-To: <20080812091950.61E3911D109@picon.linux-foundation.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(copying mingo)

(context: sysrq-B with kvm-intel.ko loaded doesn't work. on my machine, 
it kills the sata interface, but the processor and network keeps working)

Strangely, the specs say:

> • The INIT signal is blocked whenever a logical processor is in VMX 
> root operation.
> It is not blocked in VMX non-root operation. Instead, INITs cause VM 
> exits (see
> Section 21.3, “Other Causes of VM Exits”).

So INIT (which is wired to the triple-fault processor output, it seems, 
rather than RESET) is blocked and the machine is not reset completely.

So we need to disable vmx during native_machine_emergency_restart(). 
There are at least three ways of doing this:

- add a vmxoff sequence (with an exception handler) to 
native_machine_emergency_restart(). while simplest, this will not 
unblock INIT for other cpus

- add an emergency_restart notifier_block, and have kvm subscribe. This 
has the disadvantage of being slightly complex, opening a tiny race 
(emergency restart during kvm module initialization), and requiring IPIs 
during emergency restart.

- move vmxon/vmxoff management out of the kvm module and into x86 core. 
Bloats the core but reduces complexity. IPIs still required.

I think the notifier block is the way to go. Ingo, let me know what you 
prefer.

-- 
error compiling committee.c: too many arguments to function

