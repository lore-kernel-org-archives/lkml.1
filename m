Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbXGBPSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbXGBPSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 11:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbXGBPRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 11:17:53 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37494 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbXGBPRw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 11:17:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Chris Snook <csnook@redhat.com>
Cc: Krzysztof Oledzki <olel@ans.pl>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: IRQ handling difference between i386 and x86_64
References: <Pine.LNX.4.64.0706301617240.16011@bizon.gios.gov.pl>
	<1183218035.2894.13.camel@laptopd505.fenrus.org>
	<Pine.LNX.4.64.0707010045040.9268@bizon.gios.gov.pl>
	<46882518.5050906@redhat.com>
Date: Mon, 02 Jul 2007 09:16:55 -0600
In-Reply-To: <46882518.5050906@redhat.com> (Chris Snook's message of "Sun, 01
	Jul 2007 18:05:12 -0400")
Message-ID: <m1hcomkf88.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-4
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook <csnook@redhat.com> writes:

> Krzysztof Oledzki wrote:
>>
>>
>> On Sat, 30 Jun 2007, Arjan van de Ven wrote:
>>
>>> On Sat, 2007-06-30 at 16:55 +0200, Krzysztof Oledzki wrote:
>>>> Hello,
>>>>
>>>> It seems that IRQ handling is somehow different between i386 and x86_64.
>>>>
>>>> In my Dell PowerEdge 1950 is it possible to enable interrupts spreading
>>>> over all CPUs. This a single CPU, four CORE system (Quad-Core E5335 Xeon)
>>>> so I think that interrupts migration may be useful. Unfortunately, it
>>>> works only with 32-bit kernel. Booting it with x86_64 leads to situation,
>>>> when all interrupts goes only to the first cpu matching a smp_affinity
>>>> mask.
>>>
>>> arguably that is the most efficient behavior... round robin of
>>> interrupts is the worst possible case in terms of performance
>>
>> Even on dual/quadro core CPUs with shared cache? So why it is possible to
>> enable such behaviuor in BIOS, which works only on i386 BTW. :(
>>
>>> are you using irqbalance ? (www.irqbalance.org)
>>
>> Yes, I'm aware about this useful tool, but in some situations (routing for
>> example) it cannot help much as it keeps three cpus idle. :(
>>
>> Best regards,
>>
>>                 Krzysztof Olêdzki
>
> Interleaving interrupt delivery will completely break TCP header prediction, and
> cost you far more CPU time than it will save.  In fact, because of the locking,
> it will probably scale negatively with the number of CPUs, if your workload is
> mostly TCP/IP processing.  The way around this is to ensure that the packets for
> any given TCP socket are all delivered to the same processor.  If you have
> multiple NICs and use 802.3ad bonding with layer3+4 hashing, header prediction
> will work fine, and you don't have to disable irqbalance, because it will do the
> right thing.

Regardless mostly this appears to be a case of running in a different
ioapic mode, or possibly the software irq balance logic (as arch/x86_64)
does not have irqbalance in the kernel.

Hardware does automatic balancing in lowest-priority logical delivery mode.
All balancing must be done in software in flat physical delivery mode.

I'm guessing do to compile options etc.  You are using flat physical delivery
mode on x86_64.

If the BIOS has an option to mess with this you are probably playing with
as system that has known ioapic related hardware bugs and enabling it in
the BIOS likely is enabling hardware problems.

Eric
