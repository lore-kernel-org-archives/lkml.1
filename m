Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbXKDXaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbXKDXaT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 18:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbXKDXaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 18:30:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47701 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbXKDXaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 18:30:03 -0500
Message-ID: <472E551E.2010507@zytor.com>
Date: Sun, 04 Nov 2007 15:26:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>,
       Eric Biederman <ebiederm@xmission.com>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486DX4
References: <200711042259.lA4Mxa0n025210@tazenda.hos.anvin.org> <alpine.LFD.0.999.0711041512530.15101@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0711041512530.15101@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sun, 4 Nov 2007, H. Peter Anvin wrote:
>>     
>>     Apparently, the 486DX4 does not correctly serialize a mov to %cr0, so
>>     we really do need the far jump immediately afterwards.
> 
> Hmm. I'm not sure I agree with the commit message.
> 
> This is documented behaviour on i386 and i486: instruction decoding is 
> decoupled from execution, so things that change processor mode have to do 
> a jump to make sure that %cr0 changes take effect.
> 

It's not an instruction-decoding issue at all (that's a 16- vs 32-bit 
issue, which can only be changed by a ljmp).  Apparently the 486DX4 
mis-executes the load to segment register, which is an EU function in 
that context.  (And yes, it's sort-of-documented behaviour in the sense 
that the documentation says "do things this way", but the Intel docs are 
unfortunately full of "do things this way" which don't make sense and 
occasionally are actively harmful, too.)

> I'm not entirely sure that it needs to be a long-jump, btw. I think any
> regular branch is sufficient. You obviously *do* need to make the long 
> jump later (to reload %cs in protected mode), but I'm not sure it's needed 
> in that place. I forget the exact rules (but they definitely were 
> documented).

That's exactly the issue here.  The code without this patch deferred the 
long jump until after the segment loads, this worked on all processors 
except, apparently, the 486DX4.  Hence, move the ljmp up to the earliest 
possible location.

	-hpa
