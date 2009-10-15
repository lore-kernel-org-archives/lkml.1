Return-Path: <linux-kernel-owner+w=401wt.eu-S933401AbZJODpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933401AbZJODpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 23:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbZJODpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 23:45:45 -0400
Received: from mail-iw0-f180.google.com ([209.85.223.180]:57966 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZJODpo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 23:45:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l3C+KVQvHVloL8npZNPP3JalinL/wnMqvCVqOUEIdT5bEvfHOwAvuM59O8cCWXudoW
         ztEY1rCCUJAaFG8htuYNdkAuQ+T4CnejxmMlDym9gYbujZmyMZBTY17llDf86wwkvjDs
         9DWblb2dnZoCsCvpn2RMu+NG8QstRK5hhxGIk=
MIME-Version: 1.0
In-Reply-To: <7d86d44a0910141921j28ddc50cxb2d9386c5ad99db9@mail.gmail.com>
References: <1255516134-4838-1-git-send-email-graff.yang@gmail.com>
	 <18475.1255529305@redhat.com>
	 <7d86d44a0910141921j28ddc50cxb2d9386c5ad99db9@mail.gmail.com>
Date: Thu, 15 Oct 2009 11:45:07 +0800
Message-ID: <7d86d44a0910142045n585c099l50b1efec12c1db3e@mail.gmail.com>
Subject: Re: [PATCH] mm/nommu.c: Fix improperly call of security API in mmap
From: graff yang <graff.yang@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, gyang@blackfin.uclinux.org,
       akpm@linux-foundation.org, uclinux-dist-devel@blackfin.uclinux.org,
       Graff Yang <graf.yang@analog.com>,
       linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David,

Your patch works both with SELINUX enabled or disabled.
But, how to prevent the address that attempting to be mapped to be lower
than CONFIG_LSM_MMAP_MIN_ADDR/CONFIG_DEFAULT_MMAP_MIN_ADDR?
This is what the security_file_mmap() is doing and mmu's
do_mmap_pgoff() has implemented.

On Thu, Oct 15, 2009 at 10:21 AM, graff yang <graff.yang@gmail.com> wrote:
> Hi, David,
> Thanks your patch, I will test it.
>
>
> On Wed, Oct 14, 2009 at 10:08 PM, David Howells <dhowells@redhat.com> wrote:
>> <graff.yang@gmail.com> wrote:
>>
>>> The original code calling security_file_mmap() use user's hint address
>>> as it's 5th argument(addr). This is improper, as the hint address may be
>>> NULL.
>>> In this case, the security_file_mmap() may incorrectly return -EPERM.
>>>
>>> This patch moved the calling of security_file_mmap() out of
>>> validate_mmap_request() to do_mmap_pgoff(), and call this
>>> security API with the address that attempting to mmap.
>>
>> I think this is the wrong approach.  Firstly, the hint is cleared in NOMMU
>> mode, and secondly, I think that the check against the minimum LSM address is
>> pointless in NOMMU mode too.
>>
>> So I think the attached patch is a better approach.
>>
>> David
>> ---
>> From: David Howells <dhowells@redhat.com>
>>
>> NOMMU: Ignore the address parameter in the file_mmap() security check
>>
>> Ignore the address parameter in the various file_mmap() security checks when
>> CONFIG_MMU=n as the address hint is ignored under those circumstances, and in
>> any case the minimum mapping address check is pointless in NOMMU mode.
>>
>> Signed-off-by: David Howells <dhowells@redhat.com>
>> ---
>>
>>  include/linux/security.h |    1 +
>>  mm/nommu.c               |    2 +-
>>  security/commoncap.c     |    2 ++
>>  security/selinux/hooks.c |    2 ++
>>  4 files changed, 6 insertions(+), 1 deletions(-)
>>
>>
>> diff --git a/include/linux/security.h b/include/linux/security.h
>> index 239e40d..0583f16 100644
>> --- a/include/linux/security.h
>> +++ b/include/linux/security.h
>> @@ -593,6 +593,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
>>  *     @reqprot contains the protection requested by the application.
>>  *     @prot contains the protection that will be applied by the kernel.
>>  *     @flags contains the operational flags.
>> + *     @addr contains the mapping address, and should be ignored in NOMMU mode.
>>  *     Return 0 if permission is granted.
>>  * @file_mprotect:
>>  *     Check permissions before changing memory access permissions.
>> diff --git a/mm/nommu.c b/mm/nommu.c
>> index 3c3b4b2..cfea46c 100644
>> --- a/mm/nommu.c
>> +++ b/mm/nommu.c
>> @@ -974,7 +974,7 @@ static int validate_mmap_request(struct file *file,
>>        }
>>
>>        /* allow the security API to have its say */
>> -       ret = security_file_mmap(file, reqprot, prot, flags, addr, 0);
>> +       ret = security_file_mmap(file, reqprot, prot, flags, 0, 0);
>>        if (ret < 0)
>>                return ret;
>>
>> diff --git a/security/commoncap.c b/security/commoncap.c
>> index fe30751..ac1f745 100644
>> --- a/security/commoncap.c
>> +++ b/security/commoncap.c
>> @@ -1005,6 +1005,7 @@ int cap_file_mmap(struct file *file, unsigned long reqprot,
>>  {
>>        int ret = 0;
>>
>> +#ifdef CONFIG_MMU
>>        if (addr < dac_mmap_min_addr) {
>>                ret = cap_capable(current, current_cred(), CAP_SYS_RAWIO,
>>                                  SECURITY_CAP_AUDIT);
>> @@ -1012,5 +1013,6 @@ int cap_file_mmap(struct file *file, unsigned long reqprot,
>>                if (ret == 0)
>>                        current->flags |= PF_SUPERPRIV;
>>        }
>> +#endif
>>        return ret;
>>  }
>> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>> index bb230d5..93d61f8 100644
>> --- a/security/selinux/hooks.c
>> +++ b/security/selinux/hooks.c
>> @@ -3046,6 +3046,7 @@ static int selinux_file_mmap(struct file *file, unsigned long reqprot,
>>                             unsigned long addr, unsigned long addr_only)
>>  {
>>        int rc = 0;
>> +#ifdef CONFIG_MMU
>>        u32 sid = current_sid();
>>
>>        /*
>> @@ -3060,6 +3061,7 @@ static int selinux_file_mmap(struct file *file, unsigned long reqprot,
>>                if (rc)
>>                        return rc;
>>        }
>> +#endif
>>
>>        /* do DAC check on address space usage */
>>        rc = cap_file_mmap(file, reqprot, prot, flags, addr, addr_only);
>>
>
>
>
> --
> -Graff
>



-- 
-Graff
