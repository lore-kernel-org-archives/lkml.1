Return-Path: <linux-kernel-owner+w=401wt.eu-S1752328AbZBNJNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbZBNJNQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 04:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbZBNJNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 04:13:04 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:13444 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbZBNJNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 04:13:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AfBUT5OR4q8yr2DKpc+qdlIIe7csT8aXa0MaDkaBBxeDyWRngbTh8YdpcyY9GBigkQ
         nQ56giky92GGs0uWoGoute0asQw+73NMFPS2PpHLvTdcO0MBDhSa7BwP3qRJtLTnbDDs
         L8/wKqqNDUw/BD8QSDFGOP/lv5uVaNfWsQYDg=
MIME-Version: 1.0
In-Reply-To: <49965768.7040102@goop.org>
References: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
	 <3c7db30686056c9b86cc61ef50dd5572de868512.1234573847.git.jeremy.fitzhardinge@citrix.com>
	 <3e46dae897fd5620f50b4cca9272969f5546aa88.1234573847.git.jeremy.fitzhardinge@citrix.com>
	 <4996280B.6000104@kernel.org> <49965768.7040102@goop.org>
Date: Sat, 14 Feb 2009 14:42:59 +0530
Message-ID: <c4d259900902140112x2521eabn34e4dfd25ac51bb4@mail.gmail.com>
Subject: Re: [Xen-devel] Re: [PATCH 2/9] xen: hook io_apic read/write 
	operations
From: venkatesh k <venkatesh7venkatesh@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i am currently studying in m.a.m college of engg in trichy sir. i have
used in xen 3.3.1  source code using in final year project. The
xen3.3.1 learn in readme file  and make file compiling there are
following errors are identified.
select-repository: Searching `.:..' for linux-2.6.18-xen.hg
select-repository: Ignoring `.'
Unable to determine path to Linux source tree.
Falling back to linux-2.6.18-xen Mercurial repository.
Cloning http://xenbits.xensource.com/linux-2.6.18-xen.hg to linux-2.6.18-xen.hg.
/bin/sh: hg: not found
make[2]: *** [linux-2.6.18-xen.hg/.valid-src] Error 127
make[2]: Leaving directory `/home/mamce/Desktop/Missel/xen-3.3.1'
make[1]: *** [linux-2.6-xen-install] Error 2
make[1]: Leaving directory `/home/mamce/Desktop/Missel/xen-3.3.1'
make: *** [install-kernels] Error 1

On 2/14/09, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Yinghai Lu wrote:
>> Jeremy Fitzhardinge wrote:
>>
>>> In Xen, writes to the IO APIC are paravirtualized via hypercalls, so
>>> implement the appropriate operations.
>>>
>>> This version of the patch just hooks the io_apic read/write functions
>>> directly, rather than introducing another layer of indirection.  The
>>> xen_initial_domain() tests compile to 0 if CONFIG_XEN_DOM0 isn't set,
>>> and are cheap if it is.
>>>
>>> (An alternative would be to add io_apic_ops, and point them to the Xen
>>> implementation as needed.  HPA deemed this extra level of indirection to
>>> be excessive.)
>>>
>>
>> that will be more clean.
>>
>
> That was my thought too.
>
>
>>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>> ---
>>>  arch/x86/include/asm/io_apic.h |    6 ++++
>>>  arch/x86/kernel/io_apic.c      |   32 ++++++++++++++++++++--
>>>  arch/x86/xen/Makefile          |    3 +-
>>>  arch/x86/xen/apic.c            |   57
>>> ++++++++++++++++++++++++++++++++++++++++
>>>  arch/x86/xen/enlighten.c       |    2 +
>>>  arch/x86/xen/xen-ops.h         |    6 ++++
>>>  6 files changed, 102 insertions(+), 4 deletions(-)
>>>  create mode 100644 arch/x86/xen/apic.c
>>>
>>> diff --git a/arch/x86/include/asm/io_apic.h
>>> b/arch/x86/include/asm/io_apic.h
>>> index 59cb4a1..20b543a 100644
>>> --- a/arch/x86/include/asm/io_apic.h
>>> +++ b/arch/x86/include/asm/io_apic.h
>>> @@ -183,4 +183,10 @@ static inline void ioapic_init_mappings(void)	{ }
>>>  static inline void probe_nr_irqs_gsi(void)	{ }
>>>  #endif
>>>
>>> +void xen_io_apic_init(void);
>>> +unsigned int xen_io_apic_read(unsigned apic, unsigned reg);
>>> +void xen_io_apic_write(unsigned int apic,
>>> +		       unsigned int reg, unsigned int value);
>>> +
>>> +
>>>  #endif /* _ASM_X86_IO_APIC_H */
>>> diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
>>> index 7248ca1..de0368a 100644
>>> --- a/arch/x86/kernel/io_apic.c
>>> +++ b/arch/x86/kernel/io_apic.c
>>> @@ -62,6 +62,8 @@
>>>  #include <asm/uv/uv_hub.h>
>>>  #include <asm/uv/uv_irq.h>
>>>
>>> +#include <asm/xen/hypervisor.h>
>>> +
>>>  #include <asm/genapic.h>
>>>
>>>  #define __apicdebuginit(type) static type __init
>>> @@ -399,14 +401,26 @@ static __attribute_const__ struct io_apic __iomem
>>> *io_apic_base(int idx)
>>>
>>>  static inline unsigned int io_apic_read(unsigned int apic, unsigned int
>>> reg)
>>>  {
>>> -	struct io_apic __iomem *io_apic = io_apic_base(apic);
>>> +	struct io_apic __iomem *io_apic;
>>> +
>>> +	if (xen_initial_domain())
>>> +		return xen_io_apic_read(apic, reg);
>>>
>>
>> you may have _xen_io_apic_read(apic, reg);
>> and xen_io_apic_read(apic, reg) will call xen_initial_domain internally.
>>
>
> How would that work?  What would it return in the xen/non-xen states to
> indicate that the normal read operation should be performed?  I don't
> think it would be any clearer.
>
>> or sth like
>> extra if (io_apic_ops)
>> 	io_apic->read()...
>>
>
> I think if there were an _ops structure, it should just go though it
> unconditionally.
>
>     J
>
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
>
