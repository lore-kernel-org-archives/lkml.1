Return-Path: <linux-kernel-owner+w=401wt.eu-S932886AbYF3WIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886AbYF3WIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 18:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933260AbYF3WH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 18:07:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58595 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933242AbYF3WH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 18:07:58 -0400
Message-ID: <48695871.8000805@zytor.com>
Date: Mon, 30 Jun 2008 15:04:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Sean Young <sean@mess.org>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org
Subject: Re: Regression: boot failure on AMD Elan TS-5500
References: <20080616121138.GA51097@atlantis.8hz.com> <200806162327.34912.rusty@rustcorp.com.au> <48566C88.6000702@goop.org> <20080616161944.GA53539@atlantis.8hz.com> <20080630214347.GA57988@atlantis.8hz.com> <4869558A.9020907@goop.org>
In-Reply-To: <4869558A.9020907@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>
>> Looking at the beginning of startup_32, it seems ds is used before it 
>> is set:
>>
>> startup_32:
>>         cld
>>         /* test KEEP_SEGMENTS flag to see if the bootloader is asking
>>          * us to not reload segments */
>>         testb $(1<<6), BP_loadflags(%esi)
>>         jnz 1f
>>
>>         cli
>>         movl $(__BOOT_DS),%eax
>>         movl %eax,%ds
>>         movl %eax,%es
>>         movl %eax,%fs
>>         movl %eax,%gs
>>         movl %eax,%ss
>> 1:
>>
>> Since the testb instruction is a dereference, ds is implicitly used. If
>> I move the testb to after "movl %eax,%ds" it seems to work (not that it
>> would make any sense there, but just to prove the point).
>>
>> 1) Am I barking up the wrong tree?
>>
>> 2) If I'm right I have no idea what the correct solution is; it seems 
>> that
>>    a chicken & egg issue is introduced.
>>
>> Please advise. I am very new to all of this.
> 
> It's a bit odd that the boot loader neglected to set up ds properly, but 
> changing the testb line to
> 
>     testb $(1<<6), %cs:BP_loadflags(%esi)
> 
> should work.  (Or perhaps a %ss: override would be better?)
> 
> I'm assuming that the GDT setup isn't completely mad and that the 
> segments have the same base at least.
> 

This should have been set up by the *boot code* (specifically lines 
57-61 of arch/x86/boot/pmjump.S) since he's using a conventional boot 
loader (syslinux) so something is utterly fuggled up.  Using %cs: here 
should be safe, though (and *is* more conservative, after all, why 
otherwise bother reloading these segments at all?), but it still 
concerns me a great deal if this is broken in this way.  It's definitely 
better than %ss:.

In particular, I'm wondering if the Elan CPU has any strange ordering 
requirements with regards to the protected mode transition that we're 
not obeying.

It would be interesting to put in a heavyweight "brutally synchronizing" 
instruction like WBINVD at various places in arch/x86/boot/pmjump.S and 
see if it helps.

	-hpa
