Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab0BUFp7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 00:45:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43832 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab0BUFp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 00:45:58 -0500
Message-ID: <4B80C892.9000303@zytor.com>
Date: Sat, 20 Feb 2010 21:45:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Graeme Russ <graeme.russ@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: x86 embedded - Problem getting past 'move compressed kernel before
 decompression'
References: <4B80946D.1030503@gmail.com>
In-Reply-To: <4B80946D.1030503@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2010 06:03 PM, Graeme Russ wrote:
> 
> The following is something I have hacked together to jump into the 32-bit
> start address of the Linux Kernel:
> 
> struct boot_params boot_params __attribute__((aligned(16)));
> struct setup_header *hdr = (struct setup_header *)(0x90000 + 0x1f1);
> 
> void boot_zimage(void *setup_base)
> {
> 	memset(&boot_params, 0x00, sizeof boot_params);
> 	memcpy(&boot_params.hdr, hdr, sizeof (*hdr));
> 
> 	boot_params.alt_mem_k = 128 * 1024;
> 	boot_params.e820_entries = 1;
> 	boot_params.e820_map[0].addr = 0x00000000;
> 	boot_params.e820_map[0].size = 128 * 1024;
> 	boot_params.e820_map[0].type = 1;
> 
> 	asm(	"movw	$0x18, %%cx\n" \
> 		"movl	%%ecx, %%ds\n" \
> 		"movl	%%ecx, %%es\n" \
> 		"movl	%%ecx, %%fs\n" \
> 		"movl	%%ecx, %%gs\n" \
> 		"movl	%%ecx, %%ss\n" \
> 		"xorl	%%ebp, %%ebp\n" \
> 		"xorl	%%edi, %%edi\n" \
> 		"xorl	%%ebx, %%ebx\n" \
> 		"movl	%0, %%esi\n"
                        ^^
> 		"movl   $0x100000, %%eax\n" \
> 		"jmpl	*%%eax" : : "r"(&boot_params));
                                     ^

At this point you have probably clobbered the register that you have
your boot_params in.

Instead, do something like:

	asm volatile(
 		"movl	%0, %%ds\n" \
 		"movl	%0, %%es\n" \
 		"movl	%0, %%fs\n" \
 		"movl	%0, %%gs\n" \
		"movl	%0, %%ss\n" \
		"xorl	%ebp, %ebp\n" \
		"xorl	%ebx, %ebx\n" \
 		"movl   $0x100000, %%eax\n" \
 		"ljmpl	$0x10,$0x100000"
	 : : "S" (&boot_params), "D" (0), "c" (0x18));

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

