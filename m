Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbZEIPlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbZEIPlL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 11:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbZEIPk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 11:40:57 -0400
Received: from gw.goop.org ([64.81.55.164]:56741 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbZEIPk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 11:40:56 -0400
Message-ID: <4A05A408.3020006@goop.org>
Date: Sat, 09 May 2009 08:40:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 02/18] xen: hook io_apic read/write operations
References: <1241730883-4917-1-git-send-email-jeremy@goop.org> <1241730883-4917-3-git-send-email-jeremy@goop.org> <20090509084201.GF3656@elte.hu> <20090509084324.GA5158@elte.hu>
In-Reply-To: <20090509084324.GA5158@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>
>>     
>>> --- a/arch/x86/kernel/apic/io_apic.c
>>> +++ b/arch/x86/kernel/apic/io_apic.c
>>> @@ -62,8 +62,10 @@
>>>  #include <asm/uv/uv_hub.h>
>>>  #include <asm/uv/uv_irq.h>
>>>  
>>> +#include <asm/xen/hypervisor.h>
>>>  #include <asm/apic.h>
>>>  
>>> +
>>>  #define __apicdebuginit(type) static type __init
>>>  
>>>  /*
>>> @@ -407,14 +409,26 @@ static inline void io_apic_eoi(unsigned int apic, unsigned int vector)
>>>  
>>>  static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
>>>  {
>>> -	struct io_apic __iomem *io_apic = io_apic_base(apic);
>>> +	struct io_apic __iomem *io_apic;
>>> +
>>> +	if (xen_initial_domain())
>>> +		return xen_io_apic_read(apic, reg);
>>>       
>> hm, any reason why we dont want to create a 'struct io_apic' 
>> driver abstraction instead of spreading xen_initial_domain() 
>> checks all around the code?
>>     

My initial patch did that, and I'm happy to revive it.  But HPA 
preferred this approach, arguing against introducing another layer of 
abstraction for the sake of one user.

> And on a higher level, i still dont see why you dont do the whole 
> Xen thing under an irqchip. There should be no extra crappy checks 
> in native code.
>   

Hm, every time you see this code, you always have this quasi-Pavlovian 
response.  You say "use an irqchip".  I say:

    * We already use irqchip
    * but most of the interesting IO apic accesses (routing) are not
      done via the irqchip interface
    * so irqchip doesn't help

And then you don't reply.  And then you raise it again.

I would *always* prefer to hook into an interface like irqchip rather 
than gouge into the code, but I really think that irqchip isn't that 
interface.  If you have a more specific suggestion or proposal I'll 
happily follow it up, but repeating "you should use an irqchip" isn't 
getting anywhere.

To reiterate:

    * irq_chip is all about interrupt delivery, masking, acking, etc
    * these Xen dom0 apic changes are all about interrupt routing
    * irq_chip doesn't cover routing


    J
