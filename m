Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbZIKGHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbZIKGHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 02:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbZIKGHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 02:07:35 -0400
Received: from mail-yx0-f176.google.com ([209.85.210.176]:35126 "EHLO
	mail-yx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbZIKGHe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 02:07:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wTJlnsWCwnpoYa/R9a2YZLqJ0AkvWq1i25+9fq5V22MmBvLV9zyScBIz5bEB31ZFGx
         AX1L+4WTw9WjtZ4qaLTpNVTzcg2InIZZWVMvGQkFZwm7jXK1lJ0/y3iLI2nN2hlFTo/8
         J0H2PV94qptuI42Rrddcca/oabImj1rTfgozo=
MIME-Version: 1.0
In-Reply-To: <20090910225242.5c3f8ca1.akpm@linux-foundation.org>
References: <20090911013054.GA6567@sgi.com>
	 <20090910225242.5c3f8ca1.akpm@linux-foundation.org>
Date: Fri, 11 Sep 2009 15:01:16 +0900
Message-ID: <28c262360909102301v5d1c32b9lb3290a6a31f49d17@mail.gmail.com>
Subject: Re: [PATCH] Add memory mapped RTC driver for UV
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 2:52 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 10 Sep 2009 20:30:54 -0500 Dimitri Sivanich <sivanich@sgi.com> wrote:
>
>> This driver memory maps the UV Hub RTC.
>>
>> ...
>>
>> +/**
>> + * uv_mmtimer_ioctl - ioctl interface for /dev/uv_mmtimer
>> + * @file: file structure for the device
>> + * @cmd: command to execute
>> + * @arg: optional argument to command
>> + *
>> + * Executes the command specified by @cmd.  Returns 0 for success, < 0 for
>> + * failure.
>> + *
>> + * Valid commands:
>> + *
>> + * %MMTIMER_GETOFFSET - Should return the offset (relative to the start
>> + * of the page where the registers are mapped) for the counter in question.
>> + *
>> + * %MMTIMER_GETRES - Returns the resolution of the clock in femto (10^-15)
>> + * seconds
>> + *
>> + * %MMTIMER_GETFREQ - Copies the frequency of the clock in Hz to the address
>> + * specified by @arg
>> + *
>> + * %MMTIMER_GETBITS - Returns the number of bits in the clock's counter
>> + *
>> + * %MMTIMER_MMAPAVAIL - Returns 1 if registers can be mmap'd into userspace
>> + *
>> + * %MMTIMER_GETCOUNTER - Gets the current value in the counter and places it
>> + * in the address specified by @arg.
>
> Are these % thingies part of kerneldoc?
>
>> + */
>> +static long uv_mmtimer_ioctl(struct file *file, unsigned int cmd,
>> +                                             unsigned long arg)
>> +{
>> +     int ret = 0;
>> +
>> +     switch (cmd) {
>> +     case MMTIMER_GETOFFSET: /* offset of the counter */
>> +             /*
>> +              * UV RTC register is on it's own page
>
> "its" ;)
>
>> +              */
>> +             if (PAGE_SIZE <= (1 << 16))
>> +                     ret = ((UV_LOCAL_MMR_BASE | UVH_RTC) & (PAGE_SIZE-1))
>> +                             / 8;
>> +             else
>> +                     ret = -ENOSYS;
>> +             break;
>> +
>> +     case MMTIMER_GETRES: /* resolution of the clock in 10^-15 s */
>> +             if (copy_to_user((unsigned long __user *)arg,
>> +                             &uv_mmtimer_femtoperiod, sizeof(unsigned long)))
>> +                     ret = -EFAULT;
>> +             break;
>> +
>> +     case MMTIMER_GETFREQ: /* frequency in Hz */
>> +             if (copy_to_user((unsigned long __user *)arg,
>> +                             &sn_rtc_cycles_per_second,
>> +                             sizeof(unsigned long)))
>> +                     ret = -EFAULT;
>> +             break;
>> +
>> +     case MMTIMER_GETBITS: /* number of bits in the clock */
>> +             ret = hweight64(UVH_RTC_REAL_TIME_CLOCK_MASK);
>> +             break;
>> +
>> +     case MMTIMER_MMAPAVAIL: /* can we mmap the clock into userspace? */
>> +             ret = (PAGE_SIZE <= (1 << 16)) ? 1 : 0;
>> +             break;
>> +
>> +     case MMTIMER_GETCOUNTER:
>> +             if (copy_to_user((unsigned long __user *)arg,
>> +                             (unsigned long *)uv_local_mmr_address(UVH_RTC),
>> +                             sizeof(unsigned long)))
>> +                     ret = -EFAULT;
>> +             break;
>> +     default:
>> +             ret = -ENOTTY;
>> +             break;
>> +     }
>> +     return ret;
>> +}
>> +
>> +/**
>> + * uv_mmtimer_mmap - maps the clock's registers into userspace
>> + * @file: file structure for the device
>> + * @vma: VMA to map the registers into
>> + *
>> + * Calls remap_pfn_range() to map the clock's registers into
>> + * the calling process' address space.
>> + */
>> +static int uv_mmtimer_mmap(struct file *file, struct vm_area_struct *vma)
>> +{
>> +     unsigned long uv_mmtimer_addr;
>> +
>> +     if (vma->vm_end - vma->vm_start != PAGE_SIZE)
>> +             return -EINVAL;
>> +
>> +     if (vma->vm_flags & VM_WRITE)
>> +             return -EPERM;
>> +
>> +     if (PAGE_SIZE > (1 << 16))
>> +             return -ENOSYS;
>> +
>> +     vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>> +
>> +     uv_mmtimer_addr = UV_LOCAL_MMR_BASE | UVH_RTC;
>> +     uv_mmtimer_addr &= ~(PAGE_SIZE - 1);
>> +     uv_mmtimer_addr &= 0xfffffffffffffffUL;
>> +
>> +     if (remap_pfn_range(vma, vma->vm_start, uv_mmtimer_addr >> PAGE_SHIFT,
>> +                                     PAGE_SIZE, vma->vm_page_prot)) {
>> +             printk(KERN_ERR "remap_pfn_range failed in uv_mmtimer_mmap\n");
>> +             return -EAGAIN;
>> +     }
>> +
>> +     return 0;
>> +}
>
> Methinks we should be setting vma->vm_flags's VM_IO here and perhaps
> also VM_RESERVED.

remap_pfn_range already does it. :)

-- 
Kind regards,
Minchan Kim
