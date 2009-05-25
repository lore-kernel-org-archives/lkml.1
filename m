Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbZEYDwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbZEYDwk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 23:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbZEYDwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 23:52:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33323 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbZEYDwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 23:52:31 -0400
Date: Mon, 25 May 2009 05:51:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] Xen APIC hooks (with io_apic_ops)
Message-ID: <20090525035158.GB9396@elte.hu>
References: <1242170724-13349-1-git-send-email-jeremy@goop.org> <20090519123548.GA26439@elte.hu> <4A19A9A4.8010002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A19A9A4.8010002@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Avi Kivity <avi@redhat.com> wrote:

> Ingo Molnar wrote:
>>> IO APIC operations are not even slightly performance critical? Are  
>>> they ever used on the interrupt delivery path?
>>>     
>>
>> Since they are not performance critical, then why doesnt Xen catch the 
>> IO-APIC accesses, and virtualizes the device?
>>
>> If you want to hook into the IO-APIC code at such a low level, why  
>> dont you hook into the _hardware_ API - i.e. catch those setup/routing 
>> modifications to the IO-APIC space. No Linux changes are needed in that 
>> case.
>>   
>
> When x2apic is enabled, and EOI broadcast is disabled, then the io 
> apic does become a hot path - it needs to be written for each 
> level-triggered interrupt EOI.  In this case I might want to 
> paravirtualize the EOI write to exit only if an interrupt is 
> pending; otherwise communicate via shared memory.
>
> We do something similar for Windows (by patching it) very 
> successfully; Windows likes to touch the APIC TPR ~ 100,000 times 
> per second, usually without triggering an interrupt.  We hijack 
> these writes, do the checks in guest context, and only exit if the 
> TPR write would trigger an interrupt.

I suspect you aware of that this is about the io-apic not the local 
APIC. The local apic methods are already driver-ized - and they sit 
closer to the CPU so they matter more to performance.

> (kvm will likely gain x2apic support in 2.6.32; patches have 
> already been posted)

ok. This points in the direction of the io-apic driver abstraction 
from Jeremy being the right long-term approach. We already have a 
few quirks that could be cleaned up by using a proper driver 
interface.

	Ingo
