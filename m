Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbYFLWzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbYFLWzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbYFLWyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:54:53 -0400
Received: from relay1.sgi.com ([192.48.171.29]:47740 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753727AbYFLWyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:54:47 -0400
Message-ID: <4851A935.3010705@sgi.com>
Date: Thu, 12 Jun 2008 15:54:45 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Add config option to setup early serial console
References: <20080612223802.528617000@polaris-admin.engr.sgi.com> <20080612223802.673729000@polaris-admin.engr.sgi.com> <4851A639.6040405@zytor.com>
In-Reply-To: <4851A639.6040405@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Mike Travis wrote:
>>  * Add config option EARLY_SERIAL_CONSOLE to enable early
>>    printk's to be directed to the serial console.
>>
>> Based on linux-next
>>
>> Signed-off-by: Mike Travis <travis@sgi.com>
> 
> Is there any reason this can't be done dynamically, via a command-line
> option instead?
> 
> We can get to the command line extremely early if need be.
> 
>     -hpa

We could.  My current debugging is in x86_64_start_kernel() almost at
the start of the function (before the "Kernel alive" message).  The
code is below.  (cut and pasted so no tabs)

One benefit of a startup option instead of a config option  is we rely
on the standard distribution for the kernel and unless they set this
option it won't do us much good.

(Maybe the failed attempts was trying to tell me something? ;-)

Thanks,
Mike

        /* Cleanup the over mapped high alias */
        cleanup_highmap();

... my debugging is here ...

        for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
#ifdef CONFIG_EARLY_PRINTK
                set_intr_gate(i, &early_idt_handlers[i]);
#else
                set_intr_gate(i, early_idt_handler);
#endif
        }
        load_idt((const struct desc_ptr *)&idt_descr);

        early_printk("Kernel alive\n");

        for (i = 0; i < NR_CPUS; i++)
                cpu_pda(i) = &boot_cpu_pda[i];

        pda_init(0);
        copy_bootdata(__va(real_mode_data));

... startup params available here ...

        reserve_early(__pa_symbol(&_text), __pa_symbol(&_end), "TEXT DATA BSS");

#ifdef CONFIG_BLK_DEV_INITRD
        /* Reserve INITRD */
        if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
                unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
                unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
                unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
                reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
        }
#endif





