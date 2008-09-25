Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbYIYC2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbYIYC2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYIYC2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:28:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:19003 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYIYC2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:28:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WttQH74hVtynkD0N7cwVZo+g1AtFzGydLCwybK1Q8bDmwTsx44lBSyxEXGnEfN3TBI
         GmQqtbulyb559ilji9FgWXFj5TArOJsft1R5spn+fihIQQ78Ox+l7NW6KwlotMylstCR
         ugj+Pc/9+V4t8mOwGKG7dQB/ywV4PqBFYQd1M=
Message-ID: <35f686220809241928k3669e30bi8a98b440443c4bff@mail.gmail.com>
Date: Wed, 24 Sep 2008 19:28:38 -0700
From: "Alok kataria" <alokkataria1@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
Cc: "Yan Li" <elliot.li.tech@gmail.com>, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com, rjmaomao@gmail.com,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, akataria@vmware.com,
       "Daniel Hecht" <dhecht@vmware.com>, "Zachary Amsden" <zach@vmware.com>
In-Reply-To: <20080908140423.GG11993@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080221115452.GB13948@elte.hu>
	 <20080907234510.GA24133@yantp.cn.ibm.com>
	 <20080908140423.GG11993@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for joining the discussion this late. But i only noticed this
after somebody pointed me to it.

On Mon, Sep 8, 2008 at 7:04 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yan Li <elliot.li.tech@gmail.com> wrote:
>
>> +/* Backdoor def from open-vm-tools/lib/include/backdoor_def.h */
>> +#define BDOOR_MAGIC          0x564D5868
>> +/* Low-bandwidth backdoor port. --hpreg */
>> +#define BDOOR_PORT           0x5658
>> +#define BDOOR_CMD_GETVERSION 10
>> +#define VERSION_MAGIC        0x6
>> +
>> +/*
>> + *  getVersion  -  Read VM version & product code through backdoor
>> + */
>> +void getVersion(u32 *version)
>> +{
>> +     u32 eax, ebx, ecx, edx;
>> +
>> +     asm volatile("inl (%%dx)" :
>> +                  "=a"(eax), "=c"(ecx), "=d"(edx), "=b"(ebx) :
>> +                  "0"(BDOOR_MAGIC), "1"(BDOOR_CMD_GETVERSION),
>> +                  "2"(BDOOR_PORT) : "memory");
>
> hm, i know it's not your fault as you just took this vmware code, but
> this is really not an acceptable method of detection. The above is
> totally unsafe to do on native hardware - we dont know whether there's
> anything on that port.

Even if there is anything on that port on native hardware it would
work perfectly well and is _safe_.
First let me post the code to access this backdoor port (the way it
should really be done )
-------------------------------------------------------------------------------
#define VMWARE_BDOOR_MAGIC     0x564D5868
#define VMWARE_BDOOR_PORT      0x5658

#define VMWARE_BDOOR_CMD_GETVERSION         10
#define VMWARE_BDOOR_CMD_GETHZ              45
#define VMWARE_BDOOR_CMD_LAZYTIMEREMULATION 49

#define VMWARE_BDOOR(cmd, eax, ebx, ecx, edx)                         \
        __asm__("inl (%%dx)" :                                        \
                "=a"(eax), "=c"(ecx), "=d"(edx), "=b"(ebx) :          \
                "0"(VMWARE_BDOOR_MAGIC), "1"(VMWARE_BDOOR_CMD_##cmd), \
                "2"(VMWARE_BDOOR_PORT), "3"(0) :                      \
                "memory");


static inline int vmware_platform(void)
{
        uint32_t eax, ebx, ecx, edx;
        VMWARE_BDOOR(GETVERSION, eax, ebx, ecx, edx);
        return eax != (uint32_t)-1 && ebx == VMWARE_BDOOR_MAGIC;
}
------------------------------------------------------------------------------------------------------

So whenever we query port  0x5658 , with the GETVERSION command (which
is the first thing we do with this port), we expect that  eax !=
0xFFFFFFFF   and ebx has a  VMWARE specific MAGIC value.  Please note
that ebx has been initialized to zero in the code above.

Now  consider the 2 possible cases on Native hardware
1. Nothing on port 0x5658
In this case the hardware will write a value == 0xFFFFFFFF which will
result in vmware_platform returning zero.
2. Device on port 0x5658
In this case the hardware may return a legitimate value in register
eax, but won't update register ebx. Whereas we check for a MAGIC value
in ebx for this port access. The result is vmware_platform returning
zero.

Also note that, only broken hardware behaves differently when queried
with IN during _initialization_, or all device driver probing would be
fundamentally broken.  (Initialized hardware might break due to races,
but during kernel start-up the hardware isn't initialized.)


Maybe the ebx write was overlooked here which resulted in all the
confusion, but its not unsafe for native hardware.

>
> vmware could have used one of the following methods to communicate to
> the guest kernel:
>
>  - a CPUID and an MSR range - like a good virtual CPU should. That way
>   even bootloaders could detect the presence of vmware.
>  - or a PCI ID and a PCI driver like KVM does
>  - or a system call hypercall gateway like Xen and KVM does
>  - or it could even have used a DMI signature of some sort
>
> but no, vmware had to use 30 year old unsafe ISA port magic...

I agree that the backdoor port may not be the perfect way to
communicate to the hypervisor, but IMO its not unsafe/broken with this
implementation.

We too are using CPUID to detect VMware, but that is available only in
newer products.
>
>
> is there really no vmware PCI ID to query? Could you post the lspci -v
> output of your vmware guest? We could add an early-quirk for one of the
> core vmware PCI devices (in case there are any - i bet there are).

Using PCI id or DMI  is not the right way to go further, since that (
pci id or dmi string) can change in future, apart from that it also
puts unnecessary dependency of detecting VMware only after
initializing PCI or the DMI tables.

Please note that this is not the only usecase where we would want to
know if we are running on a hypervisor, there can be other use cases
too. So i would want to generalize this rather than solve it for a
particular case.

To summarize I don't see the backdoor port approach generating any
false positives and it should work perfectly well in all conditions,
having said that I do agree cpuid is the right way further for all the
hypervisors to communicate with any guest OS. So i will send a patch
out soon  (am waiting for some legal signoffs on the patches and
should be done in a day or 2) which will help both the newer and older
VMware products,  and try to be as generic as possible.

Thanks,
Alok
>
>        Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
