Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbXKER46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbXKER46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbXKER4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:56:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53499 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbXKER4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:56:49 -0500
Message-ID: <472F5941.2060507@zytor.com>
Date: Mon, 05 Nov 2007 09:56:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>,
       Eric Biederman <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486 (revised)
References: <200711050358.lA53wlho003349@tazenda.hos.anvin.org> <alpine.LFD.0.999.0711050842360.15101@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0711050842360.15101@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sun, 4 Nov 2007, H. Peter Anvin wrote:
>> H. Peter Anvin (2):
>>       x86 setup: add a near jump to serialize %cr0 on 386/486
>>       x86 setup: set %ebx == %ebp == %edi == 0 on protected mode entry
> 
> Ok, I'm obviously happier, but I have to admit that the original code was 
> safer than the new code. It did both the short jump and the far jump 
> before reloading any segments.
> 
> So I suspect the new code _works_ fine, but it's simply not as 
> fundamentally safe as the old code was.
> 
> The old code did do some instructions in between the short jump and the 
> far jump, but they were all the kind of instructions that didn't care 
> about the PE bit: there was a _read_ of the segment descriptor value, but 
> that's mode-independent (it's only the writes that matter), and the other 
> instructions were bog-standard integer instructions.
> 
> So I would actually prefer some additional safety, with something like 
> the appended..
> 
> This is TOTALLY UNTESTED! I checked with objdump that the result looks 
> roughly ok, but I didn't really think through the segment base address in 
> that long jump thing. Do we have the difference between flat mode and the 
> 16-bit bootup mode in some better way?
> 
> Hmm?
> 

Well, we *could* do a 16-bit PM segment (and do two far jumps), but that 
seems rather silly.  We'd have to patch the GDT for the base in that 
case, anyway.

This is more or less the same code I had for the first version of the 
patch, modulo moving the short jump of course.  I do like making the 
32-bit code a separate function, but it really should be "movl %ecx,..." 
in the 32-bit code.

I have to admit I agree with Eric that this is probably overkill, but 
hey, there is nothing like a bit of overkill to make sure something is 
really and truly dead.

Cooking up a tree now.

	-hpa
