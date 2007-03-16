Return-Path: <linux-kernel-owner+w=401wt.eu-S965771AbXCPRgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965771AbXCPRgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965774AbXCPRgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:36:21 -0400
Received: from gw.goop.org ([64.81.55.164]:53615 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965771AbXCPRgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:36:19 -0400
Message-ID: <45FAD592.9010105@goop.org>
Date: Fri, 16 Mar 2007 10:36:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
References: <20070301232443.195603797@goop.org> <20070301232527.956565107@goop.org> <20070316092445.GM23174@elte.hu>
In-Reply-To: <20070316092445.GM23174@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Wrap a set of interesting paravirt_ops calls in a wrapper which makes 
>> the callsites available for patching.  Unfortunately this is pretty 
>> ugly because there's no way to get gcc to generate a function call, 
>> but also wrap just the callsite itself with the necessary labels.
>>
>> This patch supports functions with 0-4 arguments, and either void or 
>> returning a value.  64-bit arguments must be split into a pair of 
>> 32-bit arguments (lower word first).  Small structures are returned in 
>> registers.
>>     
>
> ugh. This is beyond ugly!

Yes.  I can't say I'm proud of this, but I really couldn't come up with
a cleaner approach.

>  Why dont we just compile two images, one for 
> Xen and one for native, do two passes to get those two images and 
> 'merge' them into a single vmlinuz (so that we still have a 'single' 
> kernel unit to deal with on the distro side). This way we avoid all this 
> crazy, limited, fragile patchery business...

Well, one thing to make clear is this is absolutely not a Xen-specific
patch or piece of code.  This is part of the paravirt_ops infrastructure
designed to remove the overhead of all the indirect calls which are
scattered all over the place.  (Perhaps I should post the general
paravirt and Xen specific patches in separate patch series to make this
clear...).

The idea is to wrap the callsite itself with in the same manner as the
other altinstructions so that the general patcher can, at the very
least, convert the indirect call to a direct one, or nop it out if its
an indirect call.  This means that a pv_ops implementation can get about
90% of the benefit of patching without any extra effort.

So, I disagree with your characterisation that its "limited"; this is a
pretty general mechanism.  The fragile part is in using the PVOP_*
macros properly to match the ABI's calling convention, particularly with
tricky cases like passed and returned structures and 64-bit args.  But
that just needs to be done once in one place, and is otherwise
self-contained.

I would love a better mechanism.  I played with using things like gcc's
builtin_apply stuff, and so on, but I could find no way to get gcc to
set up the args and then be able to just emit the call itself under asm
control.


I haven't looked at Dave's reply in detail, but I saw some mention of
using relocs.  The idea is intriguing , but I don't quite see how it
would all fit together.


    J
