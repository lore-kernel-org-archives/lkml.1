Return-Path: <linux-kernel-owner+w=401wt.eu-S1761554AbYEXT5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761554AbYEXT5T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 15:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbYEXT5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 15:57:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:56524 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbYEXT5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 15:57:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UiaZNPKNpOTP3hO/RNoM1iK+RYhlE1r/op+xkB3ZKU/QDG5zRcUEftbuSvpA87FTvhCUO5xL+8Xabdkm+souODnjCM3mcv/q9GnStVn36cBK5kOqaUE2FFXm7zlRWCQOPsnk9qo7li5YAT28TWvpVbS+A7F7p9Wrt0RJ9moYJzE=
Message-ID: <86802c440805241257x46aff297i8ddfecbc64d868e7@mail.gmail.com>
Date: Sat, 24 May 2008 12:57:11 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] x86: extend e820 ealy_res support 32bit - fix v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4837D7DD.7000204@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805110030.15510.yhlu.kernel@gmail.com>
	 <200805180118.57863.yhlu.kernel@gmail.com>
	 <200805211840.18619.yhlu.kernel@gmail.com>
	 <200805221520.19259.yhlu.kernel@gmail.com> <4837D7DD.7000204@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 1:54 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Yinghai Lu wrote:
>>
>> [PATCH] x86: extend e820 ealy_res support 32bit - fix v2
>>
>> use find_e820_area to find addess for new RAMDISK, instead of using ram
>> blindly
>>
>> also print out low ram and bootmap info
>>
>> v2: remove extra -1 in reaseve_early calling
>>    panic if can not find space for new RAMDISK
>>
>
> OK, I've fixed earlyprintk=xen, so I can finally get some useful debugging
> information.
>
> With this patch it still crashes, but outputs:
>
> (early) Reserving virtual address space above 0xf57fe000
> (early) Linux version 2.6.26-rc3-sched-devel.git (jeremy@victim.goop.org)
> (gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)) #466 SMP PREEMPT Sat May 24
> 01:05:41 PDT 2008
> (early) ACPI in unprivileged domain disabled
> (early) BIOS-provided physical RAM map:
> (early)  Xen: 0000000000000000 - 000000000009f000 (usable)
> (early)  Xen: 0000000000100000 - 0000000010000000 (usable)
> (early) console [xenboot0] enabled
> (early) debug: ignoring loglevel setting.
> (early)  limit_regions start: 0000000000000000 - 000000000009f000 (early)
> (usable)
> (early)  limit_regions start: 0000000000100000 - 0000000010000000 (early)
> (usable)
> (early)  limit_regions endfunc: 0000000000000000 - 000000000009f000 (early)
> (usable)
> (early)  limit_regions endfunc: 0000000000100000 - 0000000010000000 (early)
> (usable)
> (early) user-defined physical RAM map:
> (early)  user: 0000000000000000 - 000000000009f000 (early) (usable)
> (early)  user: 0000000000100000 - 0000000010000000 (early) (usable)
> (early) 0MB HIGHMEM available.
> (early) 256MB LOWMEM available.
> (early)   low ram: 0102c000 - 10000000
> (early)   bootmap 0102c000 - 0102e000
> (early)   early res: 0 [0-fff] BIOS data page
> (early)   early res: 1 [1000-1fff] EX TRAMPOLINE
> (early)   early res: 2 [6000-6fff] TRAMPOLINE
> (early)   early res: 3 [102c000-102dfff] BOOTMAP
> (early) Scan SMP from c0000000 for 1024 bytes.
> (early) Scan SMP from c009fc00 for 1024 bytes.
> (early) Scan SMP from c00f0000 for 65536 bytes.
> (early) Scan SMP from c00c2c20 for 1024 bytes.
> (early) NX (Execute Disable) protection: active
> [crash]
>
>
> Hm, I think this is the problem:
>
>                /*
>                 * don't need to reserve again, already reserved early
>                 * in i386_start_kernel
>                 */
>
> A Xen pv boot doesn't presently go via i386_start_kernel; it goes directly
> from xen_start_kernel to start_kernel (you can see that the "early res"
> lines are missing important things like the kernel code and pagetables).
>
> I tried making xen_start_kernel directly call i386_start_kernel, and it
> nearly works.  The problem is that the initial address space layout for a
> Xen domain is:
>
>   kernel
>   ramdisk
>   init pagetable
>
> which means that in
>
>        reserve_early(__pa_symbol(&_text), __pa_symbol(&_end), "TEXT DATA
> BSS");
>
> #ifdef CONFIG_BLK_DEV_INITRD
>        /* Reserve INITRD */
>        if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image)
> {
>                u64 ramdisk_image = boot_params.hdr.ramdisk_image;
>                u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
>                u64 ramdisk_end   = ramdisk_image + ramdisk_size;
>                reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
>        }
> #endif
>        reserve_early(__pa_symbol(&_end), init_pg_tables_end,
> "INIT_PG_TABLE");
>
> the INIT_PG_TABLE reserve_early() will panic because it partially overlaps
> with the RAMDISK reservation.

great. i guess 64bit XEN pv will call x86_64_start_kernel.

INIT_PG_TABLE is right after "TEXT DATA BSS".

So you bootloader will don't leave space between kernel and ramdisk?

or need to put INIT_PG_TABLE before end of BSS like 64bit did....

YH
