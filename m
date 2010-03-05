Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab0CENDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 08:03:01 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36293 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab0CENC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 08:02:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ccf5POy9uh64kCUx4RUgCb7LB21u5qkZf1cQlOeHVdEosuGkQIiia0Nv0o2XoRE1sI
         m3zQz5Vgk+fflh4BmvcZTbsKJAU4+Negkcu7GjxYIfSdVqXqMCY7l+mIniM/EDVT1E4d
         CkBzW5txV/FjMpN0Ni5PjZ0gEeq4bONMQIk68=
Message-ID: <4B9100FB.9040103@gmail.com>
Date: Sat, 06 Mar 2010 00:02:51 +1100
From: Graeme Russ <graeme.russ@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: x86 embedded - Problem getting past 'move compressed kernel 
 before decompression'
References: <4B80946D.1030503@gmail.com> <4B80C892.9000303@zytor.com>	 <4B80CA55.3040402@zytor.com> <d66caabb1002211451s5a68565fue6096e17b99402f7@mail.gmail.com> <4B88A865.2080009@gmail.com> <4B8BAB5C.5030707@gmail.com> <4B8BEF71.5040105@zytor.com> <4B8C184E.2000400@gmail.com> <4B8C18D0.2050208@zytor.com> <4B8C1CBA.5050007@gmail.com>
In-Reply-To: <4B8C1CBA.5050007@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Graeme Russ wrote:
> H. Peter Anvin wrote:
>> On 03/01/2010 11:41 AM, Graeme Russ wrote:
>>> H. Peter Anvin wrote:
>>>> On 03/01/2010 03:56 AM, Graeme Russ wrote:
>>>>> I have done a little more digging. By adding an ascii string before
>>>>> relocated: label, I am able to determine that the int3 after the relocated:
>>>>> label exists in bzImage at offset 0x1C3FD7
>>>>>
>>>>> EAX holds (for the jump) 0x5379d0 (different bzImage of course). The
>>>>> contents of memory at this address is in bzImage at offset 0x1C09D7 - A
>>>>> difference of 0x3600 (seems too even to be random)
>>>>>

I've had a close look at the memory dumps and it looks like U-Boot is not
loading in the .text section which is _after_ the compressed vmlinux. This
is what contains the code after the relocated: label. Looks like the
bzImage anatomy information on the net is a little out of date - They
appear to have all the decompression code before the compressed kernel...

I've taken a slightly different tack now - I am tftp'ing the entire bzImage
to 0xfca00 (0x100000 - 0x3600) and adjusting the setup_header pointer to
0xfca00 + 0x1f1 and jumping to 0x10000. After a few false starts, I am able
to get an lzo compressed bzImage up to startup_32 in arch/x86/kernel/head_32.S

My next problem is at Enable Paging:

/*
 * Enable paging
 */
	movl $pa(swapper_pg_dir),%eax
	movl %eax,%cr3		/* set the page table pointer.. */
	movl %cr0,%eax
	orl  $X86_CR0_PG,%eax
	movl %eax,%cr0		/* ..and set paging (PG) bit */
	ljmp $__BOOT_CS,$1f	/* Clear prefetch and normalize %eip */


The kernel crashes at:
	movl %eax,%cr0		/* ..and set paging (PG) bit */

Argh, so close, yet so far :(

regards.

Graeme
