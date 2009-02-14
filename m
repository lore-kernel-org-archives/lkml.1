Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbZBNFcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbZBNFcg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 00:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750727AbZBNFc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 00:32:27 -0500
Received: from gw.goop.org ([64.81.55.164]:35723 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbZBNFc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 00:32:26 -0500
Message-ID: <49965768.7040102@goop.org>
Date: Fri, 13 Feb 2009 21:32:24 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 2/9] xen: hook io_apic read/write operations
References: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com> <cover.1234573847.git.jeremy.fitzhardinge@citrix.com> <3c7db30686056c9b86cc61ef50dd5572de868512.1234573847.git.jeremy.fitzhardinge@citrix.com> <3e46dae897fd5620f50b4cca9272969f5546aa88.1234573847.git.jeremy.fitzhardinge@citrix.com> <4996280B.6000104@kernel.org>
In-Reply-To: <4996280B.6000104@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Jeremy Fitzhardinge wrote:
>   
>> In Xen, writes to the IO APIC are paravirtualized via hypercalls, so
>> implement the appropriate operations.
>>
>> This version of the patch just hooks the io_apic read/write functions
>> directly, rather than introducing another layer of indirection.  The
>> xen_initial_domain() tests compile to 0 if CONFIG_XEN_DOM0 isn't set,
>> and are cheap if it is.
>>
>> (An alternative would be to add io_apic_ops, and point them to the Xen
>> implementation as needed.  HPA deemed this extra level of indirection to
>> be excessive.)
>>     
>
> that will be more clean.
>   

That was my thought too.


>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>> ---
>>  arch/x86/include/asm/io_apic.h |    6 ++++
>>  arch/x86/kernel/io_apic.c      |   32 ++++++++++++++++++++--
>>  arch/x86/xen/Makefile          |    3 +-
>>  arch/x86/xen/apic.c            |   57 ++++++++++++++++++++++++++++++++++++++++
>>  arch/x86/xen/enlighten.c       |    2 +
>>  arch/x86/xen/xen-ops.h         |    6 ++++
>>  6 files changed, 102 insertions(+), 4 deletions(-)
>>  create mode 100644 arch/x86/xen/apic.c
>>
>> diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
>> index 59cb4a1..20b543a 100644
>> --- a/arch/x86/include/asm/io_apic.h
>> +++ b/arch/x86/include/asm/io_apic.h
>> @@ -183,4 +183,10 @@ static inline void ioapic_init_mappings(void)	{ }
>>  static inline void probe_nr_irqs_gsi(void)	{ }
>>  #endif
>>  
>> +void xen_io_apic_init(void);
>> +unsigned int xen_io_apic_read(unsigned apic, unsigned reg);
>> +void xen_io_apic_write(unsigned int apic,
>> +		       unsigned int reg, unsigned int value);
>> +
>> +
>>  #endif /* _ASM_X86_IO_APIC_H */
>> diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
>> index 7248ca1..de0368a 100644
>> --- a/arch/x86/kernel/io_apic.c
>> +++ b/arch/x86/kernel/io_apic.c
>> @@ -62,6 +62,8 @@
>>  #include <asm/uv/uv_hub.h>
>>  #include <asm/uv/uv_irq.h>
>>  
>> +#include <asm/xen/hypervisor.h>
>> +
>>  #include <asm/genapic.h>
>>  
>>  #define __apicdebuginit(type) static type __init
>> @@ -399,14 +401,26 @@ static __attribute_const__ struct io_apic __iomem *io_apic_base(int idx)
>>  
>>  static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
>>  {
>> -	struct io_apic __iomem *io_apic = io_apic_base(apic);
>> +	struct io_apic __iomem *io_apic;
>> +
>> +	if (xen_initial_domain())
>> +		return xen_io_apic_read(apic, reg);
>>     
>
> you may have _xen_io_apic_read(apic, reg);
> and xen_io_apic_read(apic, reg) will call xen_initial_domain internally.
>   

How would that work?  What would it return in the xen/non-xen states to 
indicate that the normal read operation should be performed?  I don't 
think it would be any clearer.

> or sth like
> extra if (io_apic_ops)
> 	io_apic->read()...
>   

I think if there were an _ops structure, it should just go though it 
unconditionally.

    J

