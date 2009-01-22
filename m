Return-Path: <linux-kernel-owner+w=401wt.eu-S1759475AbZAVWor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475AbZAVWor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbZAVWoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:44:38 -0500
Received: from gw.goop.org ([64.81.55.164]:47191 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbZAVWoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:44:37 -0500
Message-ID: <4978F6C6.3090003@goop.org>
Date: Thu, 22 Jan 2009 14:44:22 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Nick Piggin <npiggin@suse.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "jeremy@xensource.com" <jeremy@xensource.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
References: <20090120110542.GE19505@wotan.suse.de>	 <20090120112634.GA20858@elte.hu> <20090120140324.GA26424@elte.hu>	 <49763806.5090009@goop.org> <20090120205653.GA19710@elte.hu>	 <20090121072718.GN24891@wotan.suse.de>  <4977A051.8050203@goop.org> <1232663311.16317.176.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1232663311.16317.176.camel@bodhitayantram.eng.vmware.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> These fragments, from native_pgd_val, certainly don't help:
>
> c0120f60:       55                      push   %ebp
> c0120f61:       89 e5                   mov    %esp,%ebp
> c0120f63:       5d                      pop    %ebp
> c0120f64:       c3                      ret
> c0120f65:       8d 74 26 00             lea    0x0(%esi,%eiz,1),%esi
> c0120f69:       8d bc 27 00 00 00 00    lea    0x0(%edi,%eiz,1),%edi
>   

Yes, that's a rather awful noop; compiling without frame pointers 
reduces this to a single "ret".

> That is really disgusting.  We absolutely should be patching away the
> function calls here in the native case.. not sure we do that today.
>   

I did have some patches to do that at one point.  If you set pgd_val = 
paravirt_nop, then the patching machinery will completely nop out the 
call site.  The problem is that it depends on the calling convention 
using the same regs for the first arg and return - true for 32-bit, but 
not 64.  We could fix that with identity functions which the patcher 
recognizes and can replace with either pure nops or inline appropriate 
register moves.

Also, I just posted patches to get rid of all pvops calls when fetching 
or setting flags in a pte, which I hope will help.

    J
