Return-Path: <linux-kernel-owner+w=401wt.eu-S1751451AbXCPEDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbXCPEDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 00:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbXCPEDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 00:03:12 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:57578 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750696AbXCPEDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 00:03:11 -0400
Message-ID: <45FA16FE.7010805@vmware.com>
Date: Thu, 15 Mar 2007 20:03:10 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jan Beulich <jbeulich@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [RFC, PATCH] Fixup COMPAT_VDSO to work with CONFIG_PARAVIRT
References: <45FA054F.6020107@vmware.com> <45FA0D13.6080601@goop.org>
In-Reply-To: <45FA0D13.6080601@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Zachary Amsden wrote:
>   
>> Invoke black magic to relocate the VDSO even when COMPAT_VDSO is enabled
>> by fixing up the ELF object.
>>   
>>     
>
> So does it actually work?  Can you boot the broken distros with this in
> place?
>   

Well testing that is not so fun.  I installed SUSE Pro 9.0, and strings 
on ld.so contains the magic at_sysinfo assert!  But it doesn't install 
TLS libraries, so I'll have to install them by hand.

In works - in theory.  Look, a puppy!

Scratchbox is rumored to produce the fabled assertion even on modern 
distros by installing its own toolchain which includes the dreaded glibc.

> Using sections is wrong; you should be going through the phdrs, and
> looking for PT_DYNAMIC for relocation.
>   

Will do.

> Does anyone expect the symbolic info to be correct?  It might be better
> to just stomp it so nobody gets any ideas.
>
> On the other hand, we don't want to break compatibility with anything...
>   

I'm playing safe.  Binary identical relocation to 0xffffe000 was my goal.

>> +		} else if (strcmp(secstrings+sechdrs[i].sh_name, ".dynamic") == 0) {
>> +			Elf32_Dyn *dyn = (void *)hdr + sechdrs[i].sh_offset;
>> +			int tag;
>> +			while ((tag = (++dyn)->d_tag) != DT_NULL)
>>   
>>     
>
> Um, no.
>   

Walk based on size instead?

>> +		} else if (strcmp(secstrings+sechdrs[i].sh_name, ".useless") == 0) {
>> +			/* This is demonic; see vsyscall.lds.S; it puts the
>> +			 * .got in a section named .useless */
>> +			uint32_t *got = (void *)hdr + sechdrs[i].sh_offset;
>> +			*got += VDSO_HIGH_BASE;
>> +		}
>>   
>>     
>
> This won't get relocated with one of the other relocations?  It's in the
> text phdr.
>   

Hmm, I can try that.  Thanks for the suggestions / fixes.

Zach
