Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbYKXSW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbYKXSW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 13:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYKXSWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 13:22:20 -0500
Received: from gw.goop.org ([64.81.55.164]:54194 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbYKXSWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 13:22:20 -0500
Message-ID: <492AF0DA.3060702@goop.org>
Date: Mon, 24 Nov 2008 10:22:18 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Eric Lacombe <goretux@gmail.com>
CC: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [x86] do_arch_prctl
References: <200811181835.07360.goretux@gmail.com> <4924AA4E.4090001@goop.org> <200811200122.07694.goretux@gmail.com> <200811241324.54606.goretux@gmail.com>
In-Reply-To: <200811241324.54606.goretux@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Lacombe wrote:
> Hello,
>
> Does the "doit case" (line 822 in ARCH_GET_FS, function do_arch_prctl) exist 
> for performance reasons? Else, why "task->thread.fs" (line 824) does not 
> contain the fs base in the "doit case"?
>   

"doit" gets set when you're operating on yourself.  If you're operating 
on another process, then you need to use their task structure values 
rather than the current process's values.  If you're doing it to 
yourself, then the task structure may be out of date because its only 
updated on a context switch.

> Can someone explain _precisely_ the lines 835 through 838 (ARCH_GET_GS)?
> (I thought that just the line 836 was sufficient, but I 
> obviously miss the case where MSR_KERNEL_GS_BASE does not reflect the value 
> requested)
>   

gsindex and gs store the same information in two ways.  gsindex is the 
GDT selector number which contains the (32-bit) base address, and gs is 
the raw 64-bit base address.  If gsindex != 0 then it prevails, 
otherwise gs contains the right value.

When you load %gs with a selector, the MSR is updated with the value 
from the GDT.  Rather than parsing the GDT entry manually to get the 
encoded base address, the code in 836 fetches it out of the MSR.  On the 
other hand, if you're using a raw gs base (ie gsindex==0), then you can 
simply read the base directly from the task structure.  rdmsr would work 
as well, but be less efficient.

    J

> Thanks again for all your previous answers.
>
> 	Eric
>
> 828 case ARCH_GET_GS: {
> 829                 unsigned long base;
> 830                 unsigned gsindex;
> 831                 if (task->thread.gsindex == GS_TLS_SEL)
> 832                         base = read_32bit_tls(task, GS_TLS);
> 833                 else if (doit) {
> 834                         asm("movl %%gs,%0" : "=r" (gsindex));
> 835                         if (gsindex)
> 836                                 rdmsrl(MSR_KERNEL_GS_BASE, base);
> 837                         else
> 838                                 base = task->thread.gs;
> 839                 }
> 840                 else
> 841                         base = task->thread.gs;
> 842                 ret = put_user(base, (unsigned long __user *)addr);
> 843                 break;
> 844         }
>
> ---
>
> 817         case ARCH_GET_FS: {
> 818                 unsigned long base;
> 819                 if (task->thread.fsindex == FS_TLS_SEL)
> 820                         base = read_32bit_tls(task, FS_TLS);
> 821                 else if (doit)
> 822                         rdmsrl(MSR_FS_BASE, base);
> 823                 else
> 824                         base = task->thread.fs;
> 825                 ret = put_user(base, (unsigned long __user *)addr);
> 826                 break;
> 827         }
>
>   

