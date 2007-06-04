Return-Path: <linux-kernel-owner+w=401wt.eu-S1761371AbXFDV3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761371AbXFDV3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbXFDV32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:29:28 -0400
Received: from gw.goop.org ([64.81.55.164]:52563 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbXFDV31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:29:27 -0400
Message-ID: <4664841A.8040802@goop.org>
Date: Mon, 04 Jun 2007 14:28:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH] xen: use iret directly where possible
References: <46646662.9020707@goop.org> <200706042145.30339.ak@suse.de> <4664772A.20602@goop.org> <200706042305.05340.ak@suse.de>
In-Reply-To: <200706042305.05340.ak@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> If you stay cli you don't need that. Why is it that it has to enable 
> interrupts?
>   

Bear in mind we're talking about running paravirt under Xen in ring 1.

The cli/sti instructions don't control the event mask, so they're
effectively expensive no-ops (they trap into the hypervisor, are
emulated as no-ops). But if you mean cli as a general term for
"events/interrupts masked", then they can't remain masked when you
return to usermode.   iret normally sets the current eflags IF state
from the on-stack IF, but that's irrelevent to Xen; we need to extract
eflags.IF from the on-stack eflags, and put that into the vcpu's event
mask.  That's inherently non-atomic with respect to iret.

>> In your sequence, the event may become pending after "check again", even
>> though it won't be delivered. 
>>     
>
> sti only takes affect one instruction after it. So if you can make 
> it that small it would also work. But that might not help you.

No, it doesn't.  sti can't be run directly in ring1, and trapping into
Xen is exactly what this patch is trying to avoid.  Even if it did, Xen
treats it as a no-op, and it has no effect on the event mask state. 
Even if Xen did use it to control the event mask state, it would lose
the 1-instruction shadow because it trapped into the hypervisor, and a
new event may be pending as it comes out.


    J
