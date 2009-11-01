Return-Path: <linux-kernel-owner+w=401wt.eu-S1751843AbZKAKol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbZKAKol (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 05:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZKAKoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 05:44:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:49932 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbZKAKoi (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 05:44:38 -0500
Message-ID: <4AED66D0.20704@kernel.org>
Date: Sun, 01 Nov 2009 11:45:36 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Andrew Theurer <habanero@linux.vnet.ibm.com>, kvm@vger.kernel.org,
       Linux-kernel@vger.kernel.org
Subject: Re: kernel bug in kvm_intel
References: <4ACF9745.3050902@linux.vnet.ibm.com> <4AD16ACE.6040903@redhat.com> <1255372957.4883.49.camel@twinturbo.austin.ibm.com> <4AD4231F.6040608@redhat.com> <1255442640.4883.56.camel@twinturbo.austin.ibm.com> <4AD6061D.5070306@redhat.com> <1255637909.4883.129.camel@twinturbo.austin.ibm.com> <1256926052.4883.203.camel@twinturbo.austin.ibm.com> <4AEC5C24.9080506@redhat.com> <4AEC64FC.7070908@linux.vnet.ibm.com> <4AEC6699.6000202@redhat.com> <4AEC6821.7010801@redhat.com> <4AED5C3F.9050506@kernel.org> <4AED6100.6040804@redhat.com>
In-Reply-To: <4AED6100.6040804@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Avi Kivity wrote:
> We get a page fault immediately (next instruction) after returning from
> the guest when running with oprofile.  The page fault address does not
> match anything the instruction does, so presumably it is one of the
> accesses the processor performs in order to service an NMI (ordinary
> interrupts are masked; and the fact that it happens with oprofile
> strengthens this assumption).

Ah... okay, that's tricky but IIRC faults like that can be
distinguished from regular ones via processor state, right?

> If this is correct, the fault is not in the NMI handler itself, but in
> one of the memory areas the cpu looks in to vector the NMI, which can be:
> 
> - the IDT
> - the GDT
> - the TSS
> - the NMI stack
> 
> Except for the IDT these are per-cpu structure, though I don't know
> whether they are allocated with the percpu infrastructure.

Don't know where NMI stack is but all else are percpu.

> Here is the code in question:
> 
>>     3ae7:       75 05                   jne    3aee<vmx_vcpu_run+0x26a>
>>       3ae9:       0f 01 c2                vmlaunch
>>       3aec:       eb 03                   jmp    3af1<vmx_vcpu_run+0x26d>
>>       3aee:       0f 01 c3                vmresume
>>       3af1:       48 87 0c 24             xchg   %rcx,(%rsp)
> 
> ^^^ fault, but not at (%rsp)

Can you please post the full oops (including kernel debug messages
during boot) or give me a pointer to the original message?  Also, does
the faulting address coincide with any symbol?

Thanks.

-- 
tejun
