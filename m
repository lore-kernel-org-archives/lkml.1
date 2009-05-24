Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZEXULZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZEXULZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 16:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZEXULR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 16:11:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42432 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbZEXULQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 16:11:16 -0400
Message-ID: <4A19A9A4.8010002@redhat.com>
Date: Sun, 24 May 2009 23:10:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] Xen APIC hooks (with io_apic_ops)
References: <1242170724-13349-1-git-send-email-jeremy@goop.org> <20090519123548.GA26439@elte.hu>
In-Reply-To: <20090519123548.GA26439@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> IO APIC operations are not even slightly performance critical? Are 
>> they ever used on the interrupt delivery path?
>>     
>
> Since they are not performance critical, then why doesnt Xen catch 
> the IO-APIC accesses, and virtualizes the device?
>
> If you want to hook into the IO-APIC code at such a low level, why 
> dont you hook into the _hardware_ API - i.e. catch those 
> setup/routing modifications to the IO-APIC space. No Linux changes 
> are needed in that case.
>   

When x2apic is enabled, and EOI broadcast is disabled, then the io apic 
does become a hot path - it needs to be written for each level-triggered 
interrupt EOI.  In this case I might want to paravirtualize  the EOI 
write to exit only if an interrupt is pending; otherwise communicate via 
shared memory.

We do something similar for Windows (by patching it) very successfully; 
Windows likes to touch the APIC TPR ~ 100,000 times per second, usually 
without triggering an interrupt.  We hijack these writes, do the checks 
in guest context, and only exit if the TPR write would trigger an interrupt.

(kvm will likely gain x2apic support in 2.6.32; patches have already 
been posted)

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

