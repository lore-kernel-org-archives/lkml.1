Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbYISVqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbYISVqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 17:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbYISVq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 17:46:27 -0400
Received: from gw.goop.org ([64.81.55.164]:50657 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbYISVqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 17:46:25 -0400
Message-ID: <48D41DAF.6020804@goop.org>
Date: Fri, 19 Sep 2008 14:46:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v3)
References: <48D21BA3.76E4.0078.0@novell.com> <20080918071852.GA7639@elte.hu> <20080918091003.GA3751@elte.hu> <48D23BF6.76E4.0078.0@novell.com> <20080918095710.GA11633@elte.hu> <20080918112018.GA456@elte.hu> <48D25E87.76E4.0078.0@novell.com> <48D29741.4070404@goop.org> <48D37FDA.76E4.0078.0@novell.com>
In-Reply-To: <48D37FDA.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>> I would say the simplest thing to do here is be explicit:
>>
>> 	if (sizeof(addr) == sizeof(u64))
>> 		return !(addr >> boot_cpu_data.x86_phys_bits);
>> 	else
>> 		return 1; 
>>
>> That's not ideal, but I guess its good enough.  I assume x86_phys_bits
>> can never be less than 32?
>>     
>
> Yes, one could do it that way. But what's the point of having RESOURCES_64BIT
> set and resource_size_t nevertheless being a 32-bit quantity?

CONFIG_RESOURCES_64BIT was removed, so testing for it makes no sense. 
(Not being able to distinguish between non-existent and unset config
variables is an outstanding Kconfig problem.)

Directly testing the size of the type is the most robust approach,
though it would be simpler if shifting a variable by more bits than its
size had a guaranteed 0 result.

>  And why,
> independent of that, was ioremap() not changed to use phys_addr_t?

Well, ioremap is supposed to be used for IO mappings, so taking a
resource_size_t still makes sense.

The question of whether resource_size_t should be the same as a
phys_addr_t is still a bit undecided. Andrew's of the opinion that they
should be separate, and that it could make sense to have 32-bit resource
addresses in an otherwise 64-bit system.  I think that's a pretty narrow
special case (32-bit PAE system with no 64-bit IO devices), and its not
worth having the extra definition complexity for it.

    J
