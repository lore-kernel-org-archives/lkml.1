Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbYEWRdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbYEWRdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 13:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbYEWRcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 13:32:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:9898 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbYEWRcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 13:32:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TAZJjGqQoUQoSIOr5MTbjfXHNm77JspFIbDhWCc9c18/ZCRqoBddGcMJOR3RazTJNzQcVOiaZAWGpJvBooo19Hi81KiirxqpOC8FtYMd0ZBxZfKPKreyAOG5pG8bc7/nBkN1bEQpOZr/7YnzW78r7YOUHOGCyODVCaOQkouy5mw=
Message-ID: <19f34abd0805231032h2055c092h6423638cb69ca5c9@mail.gmail.com>
Date: Fri, 23 May 2008 19:32:52 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Jan Kiszka" <jan.kiszka@web.de>
Subject: Re: [PATCH] kmemcheck: SMP support
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
In-Reply-To: <4836FB0B.9020906@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080523141759.GA1833@damson.getinternet.no>
	 <4836E55C.5000304@goop.org>
	 <19f34abd0805230851w59a5972dk593900cf3ea8c14a@mail.gmail.com>
	 <4836FB0B.9020906@web.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 7:12 PM, Jan Kiszka <jan.kiszka@web.de> wrote:
> Vegard Nossum wrote:
>> On Fri, May 23, 2008 at 5:40 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>> Vegard Nossum wrote:
>>>> This works on real hw, but not on qemu. It seems to get stuck waiting for
>>>> one
>>>> of the atomic values to change. Don't know why yet, it might just be yet
>>>> another bug in qemu... (we've hit at least two of them so far. And they
>>>> were
>>>> real bugs too.)
>>>>
>>> I've noticed that qemu mis-reports the eip of cmpxchg if it faults (it
>>> reports the eip of the start of the basic block, I think).  Does that match
>>> what you're seeing?
>>
>> You mean the EIP that gets pushed on the stack for the page fault?
>> (That would be bad news for kmemcheck. I suppose the rest of the
>> kernel never page faults on cmpxchg addresses?)
>>
>> Or do you mean the EIP that shows up in gdb?
>>
>> But no, it seems to be unrelated. What I hit so far were (in 0.9.0):
>>
>> 1. qemu doesn't set the single-stepping flag of DR6 on single-step
>> debug exceptions.
>> 2. qemu triggers int 0 (divide error) instead of int 2 on NMI IPIs.
>>
>> But both of these were fixed in the latest 0.9.1.
>
> I guess you mean trunk - NMI IPIs didn't came with "old" 0.9.1.

Are you sure? It does in fact deliver the NMI IPI as far as I can see
and I am running from a qemu-0.9.1.tar.gz... E.g. for "-smp 3" on this
0.9.1 qemu:

(first number is smp_processor_id())

[0 pause all] <-- in page fault handler
[1 paused] <-- in nmi handler
[2 paused]
[0 resume all] <-- in debug exception handler
[2 resuming, paused = 1] <-- still in nmi handler, now exiting
[1 resuming, paused = 0]

But maybe I should try the trunk and see if that fixes the problem I was seeing!

>
>>
>> I don't yet know if what I'm hitting now is really an error with qemu.
>> But I usually trust the real hardware more :-)
>
> Try KVM as well. It is, of course, must faster than QEMU, and it comes
> with true SMP (given you have a SMP host). With in-kernel irqchip
> (that's default), KVM now also supports NMI IPIs. And debug registers
> should be fine with my latest patch.
>
> I'm currently trying to get debug support straight for upstream KVM and,
> where also required, QEMU. SMP debugging is a common issue, but already
> usable with KVM. So testers are welcome, an overview on required patches
> can be provided.
>

Hm. Doesn't KVM require special hardware? I have just a cheap laptop
(Pentium Dual-Core) and I doubt I will be able to run it... :-(

Thanks for the tip, though!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
