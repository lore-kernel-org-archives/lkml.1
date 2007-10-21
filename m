Return-Path: <linux-kernel-owner+w=401wt.eu-S1751520AbXJUVXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbXJUVXR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 17:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbXJUVXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 17:23:01 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:57177 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbXJUVXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 17:23:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ELL/Lid+kddFUNs0QwmUlMaK0sNLNc2DNTPupsa7MfXA347FoYWlpAOrl0817HqW/5pMljg+yfoy6GQQMwuugXszDIryLnzQiCYPNXbwawN0OBA0nECY/Rx1eTOBHAwtR3XWglDYNkwkSd4nTeDp/ji0V2EgGk+yyzP1PmtOYhg=
Message-ID: <471BC326.50400@googlemail.com>
Date: Sun, 21 Oct 2007 23:22:46 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Gabriel C <crazy@pimpmylinux.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: some kernel headers broken in current git ?
References: <4719174A.7020004@googlemail.com> <471AD5AD.9030000@zytor.com> <471B2918.5090502@googlemail.com> <471B487C.5080209@googlemail.com> <471BA564.3040305@zytor.com> <20071021200214.GA6250@uranus.ravnborg.org>
In-Reply-To: <20071021200214.GA6250@uranus.ravnborg.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Sun, Oct 21, 2007 at 12:15:48PM -0700, H. Peter Anvin wrote:
>> Gabriel C wrote:
>>>>> BITS_PER_LONG was originally set in <asm/types.h>:
>>>>>
>>>>>     39  #ifdef CONFIG_X86_32
>>>>>     40  # define BITS_PER_LONG 32
>>>>>     41  #else
>>>>>     42  # define BITS_PER_LONG 64
>>>>>     43  #endif
>>>> User land does not know anything about 'CONFIG_X86_32' right ?
>> Wait... this is *user mode* code at this point?
> No - it is a kernel module.
> But what a messy codebase to look at...
> 
>> Linux kernel headers aren't includable from user space without 
>> processing them through "make headers_install".
>>
>> However, from looking at the filenames in your list, it doesn't look 
>> like userspace code at all (although they're wrappered to the degree 
>> that it's somewhat hard to tell.)  Thus, you're building a kernel 
>> module, not userland.
>>
>>> That is the problem. I've changed the headers virtualbox need from 
>>>
>>> #ifdef CONFIG_X86_32 to #ifdef __i386__ and all compiled fine. 
>>>
>>> ( subarch headers includes are changed manually still but I think it is 
>>> the same problem )
>>>
>>> Also all the headers got these defines with CONFIG_X86_32 does not work.
>>>
>>> ...
>>>
>>> #ifdef CONFIG_X86_32
>>> # include "foo_32.h"
>>> #else
>>> # include "foo_64.h"
>>> #endif
>>>
>>> ...
>>>
>>> results in including both header files on my i686 box.
>>>
>>> I don't know what the right way is to fix that , define some who 
>>> CONFIG_X86_32 to __i386__ ? or just s/CONFIG_X86_32/__i386__/ ?
>> It sounds like something is seriously broken in your setup, or in the 
>> VirtualBox makefiles.  From the looks of it, I would say the latter.
> 
>>From the file "the-linux-kernel.h":
> /*
>  * Include iprt/types.h to install the bool wrappers.
>  * Then use the linux bool type for all the stuff include here.
>  */
> #include <iprt/types.h>
> #define bool linux_bool
> 
> And that file named "types.h" is not a kernel types.h - so we miss that
> file. I guess it was pulled in by some other headerfile in the past.
> 
> But I also notice that it latest source from VirtualBox the
> line number for include of spinlock-h does not match.
> 
> 
> This is most likely a combination of VirtualBox doing strange strange things
> and some deep dependency missing in one of the headerfiles.
> 
> Add a #include <linux/types.h> to the-linux-kernel.h and let us know if it helps.

Does not help , now I get on top the other errors :

/work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/include/iprt/types.h:121: error: redefinition of typedef 'bool'
/lib/modules/2.6.23-gcfa76f02/build/include/linux/types.h:33: error: previous declaration of 'bool' was here

...

/*
 * C doesn't have bool.
 */
#ifndef __cplusplus
# if defined(__GNUC__)
#  if defined(RT_OS_LINUX) && __GNUC__ < 3
typedef uint8_t bool;
#  else
#   if defined(RT_OS_DARWIN) && defined(_STDBOOL_H)
#    undef bool
#   endif
typedef _Bool bool; <- line 121
#  endif
# else
typedef unsigned char bool;
# endif
# ifndef true
#  define true  (1)
# endif
# ifndef false
#  define false (0)
# endif
#endif


Looking at include/iprt/types.h that has already #include <linux/types.h>.

> 
> 	Sam
> 


Gabriel
