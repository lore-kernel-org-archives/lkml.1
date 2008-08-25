Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbYHYJ1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbYHYJ1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 05:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYHYJ13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 05:27:29 -0400
Received: from il.qumranet.com ([212.179.150.194]:10248 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbYHYJ12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 05:27:28 -0400
Message-ID: <48B27AFE.3080704@qumranet.com>
Date: Mon, 25 Aug 2008 12:27:26 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH] Fix emergency_restart (sysrq-b) with kvm loaded on	Intel
 hosts
References: <1219655506-27418-1-git-send-email-avi@qumranet.com> <20080825091508.GC9114@elte.hu>
In-Reply-To: <20080825091508.GC9114@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@qumranet.com> wrote:
>
>   
>> Enabling Intel VT has the curious side effect whereby the INIT signal 
>> is blocked.  Rather than comment on the wisdom of this side effect, 
>> this patch adds an emergency restart reboot notifier, and modifies the 
>> kvm reboot notifier to disable VT on emergency reboot.
>>     
>
> looks good to me - i was bitten by that problem on a testbox.
>   

I'm a little worried about making emergency restart more complex.

Another thing that worries me is that emergency_restart() doesn't reset 
the box -- it sends INIT.  We could do better by using the ACPI FADT 
reset register (hopefully that's connected to RESET).

The ACPI spec says:

> 4.7.3.6 Reset Register
>
> The optional ACPI reset mechanism specifies a standard mechanism that 
> provides a complete system reset.
> When implemented, this mechanism must reset the entire system. This 
> includes processors, core logic, all
> buses, and all peripherals. From an OSPM perspective, asserting the 
> reset mechanism is the logical
> equivalent to power cycling the machine. Upon gaining control after a 
> reset, OSPM will perform actions in
> like manner to a cold boot.
> The reset mechanism is implemented via an 8-bit register described by 
> RESET_REG in the FADT (always
> accessed via the natural alignment and size described in RESET_REG). 
> To reset the machine, software will
> write a value (indicated in RESET_VALUE in FADT) to the reset 
> register. The RESET_REG field in the
> FADT indicates the location of the reset register.
> The reset register may exist only in I/O space, Memory space, or in 
> PCI Configuration space on a function
> in bus 0. Therefore, the Address_Space_ID value in RESET_REG must be 
> set to I/O space, Memory space,
> or PCI Configuration space (with a bus number of 0). As the register 
> is only 8 bits, Register_Bit_Width
> must be 8 and Register_Bit_Offset must be 0.
> The system must reset immediately following the write to this 
> register. OSPM assumes that the processor
> will not execute beyond the write instruction. OSPM should execute 
> spin loops on the CPUs in the system
> following a write to this register.

Which seems to be what we want? Maybe we should just try acpi_reboot() 
before the other stuff.

>   Acked-by: Ingo Molnar <mingo@elte.hu>
>
> Seems best to merge this via the KVM tree, right?
>
>   

I'm happy to do that, if everyone feels the patch is fine.

-- 
error compiling committee.c: too many arguments to function

