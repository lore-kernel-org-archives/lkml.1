Return-Path: <linux-kernel-owner+w=401wt.eu-S2992953AbXEBJ36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992953AbXEBJ36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 05:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992954AbXEBJ36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 05:29:58 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53902 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992953AbXEBJ35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 05:29:57 -0400
Message-ID: <46385A18.30804@vmware.com>
Date: Wed, 02 May 2007 02:30:00 -0700
From: Petr Vandrovec <petr@vmware.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.3) Gecko/20070217 Iceape/1.1.1 (Debian-1.1.1-2)
MIME-Version: 1.0
To: nigel@nigel.suspend2.net
CC: Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: VMware, x86_64 and 2.6.21.
References: <1177998147.8981.16.camel@nigel.suspend2.net>	 <1178031475.3448.0.camel@laptopd505.fenrus.org> <1178032456.13953.12.camel@nigel.suspend2.net>
In-Reply-To: <1178032456.13953.12.camel@nigel.suspend2.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham wrote:
> Hi Arjan.
> 
> On Tue, 2007-05-01 at 07:57 -0700, Arjan van de Ven wrote:
>> On Tue, 2007-05-01 at 15:42 +1000, Nigel Cunningham wrote:
>>> Hi.
>>>
>>> Does anyone have VMware working on x86_64 with 2.6.21? It's working fine
>>> for me with 2.6.20, but freezes the whole computer with 2.6.21. Before I
>>> start a git-bisect, I thought I might ask if anyone knew of some
>>> compilation option I might have missed.
>>
>> if you want to ask questions about proprietary kernel stuff you're
>> better off asking the vendor directly, not lkml
> 
> I did, but given that it the failure only appeared with a change of
> vanilla kernel version, I didn't think it was out of place to ask here
> too.

I thought I already talked about that on VMware's forums, but apparently 
I just discussed it in email only.  Culprit (if I can say that) is 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=610142927b5bc149da92b03c7ab08b8b5f205b74

It changed interrupt layout - before that change IRQ 0-15 were using 
vectors 0x20-0x2F, after change they use interrupts 0x30-0x3F.  Which 
has unfortunate effect that when hardware IRQ 8 arrives while VM is 
running, vmm believes that it internally used 'INT 0x38' to call some 
hypervisor service - and (1) hardware interrupt is never acknowledged, 
and (2) hypervisor issues random operation depending on contents of 
registers at the time interrupt arrived.  Both are quite bad, and usual 
result is that VMware panics, and while writing core dump kernel hangs 
as IOAPIC believes that there is IRQ 8 in service, and so it does not 
ever deliver IRQs 14/15 for legacy IDE harddisks (which are at same level).

One of possible fixes (if you need to run older products than VMware 
Workstation 6 on 64bit 2.6.21+) is replacing

#define IRQ0_VECTOR            FIRST_EXTERNAL_VECTOR + 0x10

with

#define IRQ0_VECTOR            FIRST_EXTERNAL_VECTOR + 0x08

Then IRQ 0x38 will be skipped.  Other option is move only IRQ8_VECTOR 
somewhere else (into 0x21-0x2F range).
							Petr Vandrovec

P.S.: Well, and obviously this has nothing to do with vmmon...
