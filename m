Return-Path: <linux-kernel-owner+w=401wt.eu-S934587AbXLMXA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934587AbXLMXA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 18:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934218AbXLMXAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 18:00:43 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:55722 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934535AbXLMXAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 18:00:41 -0500
Date: Fri, 14 Dec 2007 00:00:43 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: RFC: remove __read_mostly
Message-ID: <20071213230043.GJ21616@stusta.de>
References: <20071213222044.GH21616@stusta.de> <4761B6BB.1070504@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4761B6BB.1070504@cosmosbay.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 11:48:27PM +0100, Eric Dumazet wrote:
> Adrian Bunk a écrit :
>> I tried the following patch with a full x86 .config [1]:
>>
>> --- a/include/asm-x86/cache.h
>> +++ b/include/asm-x86/cache.h
>> -#define __read_mostly __attribute__((__section__(".data.read_mostly")))
>> +/* #define __read_mostly __attribute__((__section__(".data.read_mostly"))) */
>>
>> The result [2,3] was:
>>
>> -rwxrwxr-x 1 bunk bunk 46607243 2007-12-13 19:50 vmlinux.old
>> -rwxrwxr-x 1 bunk bunk 46598691 2007-12-13 21:55 vmlinux
>>
>> It's not a surprise that the kernel can become bigger when __read_mostly 
>> gets used, especially in cases where __read_mostly prevents gcc 
>> optimizations.
>>
>> My question is:
>> Is there anywhere in the kernel a case where __read_mostly brings a 
>> measurable improvement or can it be removed?
>
> Yes, there are many cases where read_mostly brings huge improvements.
>
> I did test your idea on a 4 CPUS server, and system time was roughly 
> doubled, from 11% to 20%

Thanks, that answered my question.

> Of course, you noticed that puting a __read_mostly attribute force the 
> linker to reserve space for the variable. So a null variable previously in 
> bss section (no space in vmlinux file) is now in .data.read_mostly. Not a 
> big deal.
>
> If you want, you could play some .lds games to create sort of a 
> "bss.read_mostly" section to save 10000 bytes in vmlinux.

No, what I was thinking of kernel code like

static int fooxxxvar = 0;
static int __read_mostly fooyyyvar = 0;

void mytest()
{
        if (fooxxxvar)
                printk("fooxxx");

        if (fooyyyvar)
                printk("fooyyy");
}

If you run "strings file.c | grep foo" on the file it will only return
"fooyyy" but not "fooxxx".

It's not a big deal, but it's an area where __read_mostly affects gcc 
and not ld.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

