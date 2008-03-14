Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbYCNG7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbYCNG7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 02:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYCNG7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 02:59:39 -0400
Received: from nijmegen.renzel.net ([195.243.213.130]:52244 "EHLO
	nijmegen.renzel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbYCNG7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 02:59:38 -0400
X-Greylist: delayed 713 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Mar 2008 02:59:37 EDT
Message-ID: <47DA1F8B.7040400@twisted-brains.org>
Date: Fri, 14 Mar 2008 07:47:39 +0100
From: mws@twisted-brains.org
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: whose job is it to include various header files?
References: <alpine.LFD.1.00.0803131802020.20317@localhost.localdomain> <9a8748490803131653n7f1c2bd0m12e30d82bf936d03@mail.gmail.com>
In-Reply-To: <9a8748490803131653n7f1c2bd0m12e30d82bf936d03@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl schrieb:
> On 13/03/2008, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
>>   more a philosophy question than anything but, while poking around
>>  the percpu stuff today, i noticed in the header file linux/percpu.h
>>  the opening snippet:
>>
>>   #include <linux/preempt.h>
>>   #include <linux/slab.h> /* For kmalloc() */
>>   #include <linux/smp.h>
>>   #include <linux/string.h> /* For memset() */
>>   #include <linux/cpumask.h>
>>   ...
>>
>>  hmmm, i thought to myself (because that's how i refer to myself), i
>>  wonder why this header file is including headers for kmalloc() and
>>  memset() when this header file makes no reference to those routines.
>>  let's see what happens if i remove them and:
>>
>>   $ make distclean
>>   $ make defconfig    [x86]
>>   $ make
>>
>>  ... chug chug chug ...
>>
>>   CC      arch/x86/kernel/nmi_32.o
>>  arch/x86/kernel/nmi_32.c: In function 'check_nmi_watchdog':
>>  arch/x86/kernel/nmi_32.c:81: error: implicit declaration of function 'kmalloc'
>>  arch/x86/kernel/nmi_32.c:81: error: 'GFP_KERNEL' undeclared (first use in this function)
>>  arch/x86/kernel/nmi_32.c:81: error: (Each undeclared identifier is reported only once
>>  arch/x86/kernel/nmi_32.c:81: error: for each function it appears in.)
>>  arch/x86/kernel/nmi_32.c:81: warning: assignment makes pointer from integer without a cast
>>  arch/x86/kernel/nmi_32.c:118: error: implicit declaration of function 'kfree'
>>  make[1]: *** [arch/x86/kernel/nmi_32.o] Error 1
>>  make: *** [arch/x86/kernel] Error 2
>>  $
>>
>>   ok, now i know.  but that means, of course, that nmi_32.c is
>>  invoking kmalloc() without ever having included the necessary header
>>  file for it -- it's just inheriting that from linux/percpu.h.
>>
>>   doesn't that (sort of) violate the kernel coding style?  if a file
>>  somewhere needs the contents of some header file, isn't it that file's
>>  responsibility to explicitly include it, and not quietly realize it's
>>  getting it from elsewhere?
>>
> I agree with you completely. A file should explicitly include headers
> for the stuff it uses and not rely on implicit includes done
> elsewhere. Cleaning that up is going to touch a lot of files though
> for no real short term gain (there is a long term gain of
> maintainability though), so it's going to be a loveless job :(
> 

i do not. the question we must discuss is imho not the situation as is, but how
a header cleanup is done if functions are reworked or moved.

you will _never_ get a clear include situation, even if you remove all of the includes
and try to compile the kernel by adding neccessary header includes back.

when you include the first headers again, you will re-generate the current situation, 
because you'll never notice through compile test if there is again an implicit include
due to hierachical reasons. 
preventing this could only be done if you really do analyse each source/header file to
check what is needed. this will cause much more time for the preprocessor of your compiler,
thus there is no really advantage.

what i said in my first sentence is the imho proper way:
if you alter sources and includes get obsolete, remove them and fix compiling again for
files that formerly depended (implicit or explicit) on this altered sources.
not to much work for the developer himself and also not exhausting the compile times.

regards
marcel
