Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbXIEULh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbXIEULh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 16:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756755AbXIEULO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 16:11:14 -0400
Received: from gw.goop.org ([64.81.55.164]:55799 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756594AbXIEULN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 16:11:13 -0400
Message-ID: <46DF0D44.2010201@goop.org>
Date: Wed, 05 Sep 2007 21:10:44 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Zachary Amsden <zach@vmware.com>, Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Chris Wright <chrisw@sous-sol.org>,
       stable@kernel.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Andi Kleen <ak@suse.de>, Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [PATCH] Fix preemptible lazy mode bug
References: <46CE70C8.2030005@vmware.com> <46CE8069.9070404@goop.org>	 <46CE81DC.90103@vmware.com>  <46D9D517.6010201@goop.org>	 <1188850468.10802.66.camel@localhost.localdomain>	 <46DD60A9.8080203@goop.org> <1189010022.10802.161.camel@localhost.localdomain>
In-Reply-To: <1189010022.10802.161.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tue, 2007-09-04 at 14:42 +0100, Jeremy Fitzhardinge wrote:
>   
>> Rusty Russell wrote:
>>     
>>>  static inline void arch_flush_lazy_mmu_mode(void)
>>>  {
>>> -	PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_FLUSH);
>>> +	if (unlikely(__get_cpu_var(paravirt_lazy_mode) == PARAVIRT_LAZY_MMU))
>>> +		arch_leave_lazy_mmu_mode();
>>>  }
>>>   
>>>       
>> This changes the semantics a bit; previously "flush" would flush
>> anything pending but leave us in lazy mode.  This just drops lazymode
>> altogether?
>>
>> I guess if we assume that flushing is a rare event then its OK, but I
>> think the name's a bit misleading.  How does it differ from plain
>> arch_leave_lazy_mmu_mode()?
>>     
>
> Whether it's likely or unlikely to be in lazy mode, basically.  But
> you're right, this should be folded, since we don't want to "leave" lazy
> mode twice.
>   

Hm, I think there's still a problem here.  In the current code, you can
legitimately flush lazy mode with preemption enabled (ie, there's no
lazy mode currently active), but it's always a bug to enable/disable
lazy mode with preemption enabled.   Certainly enabling lazy mode with
preemption enabled is always a bug, but you could make disable
preempt-safe (and the bug checking should be in the common code).

    J
