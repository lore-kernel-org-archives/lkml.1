Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbZGCUQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbZGCUQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 16:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbZGCUQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 16:16:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:53979 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150AbZGCUQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 16:16:30 -0400
Message-ID: <4A4E671C.2090201@suse.cz>
Date: Fri, 03 Jul 2009 22:16:28 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, tony.luck@intel.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, hpa@zytor.com,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-modules@vger.kernel.org
Subject: Re: [PATCH] reduce export symbol CRC table size on 64-bit archs
References: <4A4A18780200007800008345@vpn.id2.novell.com>
In-Reply-To: <4A4A18780200007800008345@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich napsal(a):
> Since these CRCs are really only 32-bit quantities, there's no need to
> store them in 64-bit slots. Since, however, gcc doesn't allow
> respective initializations, asm() constructs get used to create the CRC
> tables (and its for that reason that the patch only makes x86-64 and
> ia64 utilize that functionality, as I can't verify this doesn't break
> in some subtle way elsewhere).
> 
...
>  struct modversion_info
>  {
> -	unsigned long crc;
> +	ksym_crc_t crc;
>  	char name[MODULE_NAME_LEN];
>  };

This change breaks module-init-tools:
Before:
$ /sbin/modprobe --dump-modversions _build/drivers/usb/core/usbcore.ko
| head
0xb49b735a      module_layout
0xdb7e6a70      bus_register
0xe3a25bcc      device_remove_file
0x1fedf0f4      __request_region
0x37429b3b      device_remove_bin_file
0x27ac237c      cdev_del
0xf3be63b3      per_cpu__current_task
0x26b76a45      kmalloc_caches
0x5a34a45c      __kmalloc
0x1c820358      cdev_init

After:
$ /sbin/modprobe --dump-modversions
_build-crc-int/drivers/usb/core/usbcore.ko  | head
0x75646f6d91ea7b5c      le_layout
0x5f7375623e215f43      register
0x69766564848c67e2      ce_remove_file
0x65725f5f1fedf0f4      quest_region
0x69766564a0c29c25      ce_remove_bin_file
0x766564633ce98bc2      _del
0x5f72657012c9615b      cpu__current_task
0x6c616d6b6ea6c464      loc_caches
0x6d6b5f5f5a34a45c      alloc
0x766564631e5d885b      _init

It also breaks the newly added depmod -E option (check symbol versions),
which also reads the struct modversion_info array (*). Is it possible
name the section differently (__versions2?) on those architectures where
the size changes, so that it is possible to fix m-i-t in a
backwards-compatible manner?

Michal


(*) dump_modvers() and load_symbols() in
http://git.kernel.org/?p=utils/kernel/module-init-tools/module-init-tools.git;a=blob;f=elfops_core.c;hb=HEAD
