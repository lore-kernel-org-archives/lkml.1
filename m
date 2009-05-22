Return-Path: <linux-kernel-owner+w=401wt.eu-S1758358AbZEVWoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbZEVWoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 18:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757773AbZEVWor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 18:44:47 -0400
Received: from claw.goop.org ([74.207.240.146]:54481 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757529AbZEVWor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 18:44:47 -0400
Message-ID: <4A172ADE.3010702@goop.org>
Date: Fri, 22 May 2009 15:44:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Xin, Xiaohui" <xiaohui.xin@intel.com>, Chuck Ebbert <cebbert@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, "Li, Xin" <xin.li@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: Performance overhead of paravirt_ops on native identified
References: <4A0B62F7.5030802@goop.org> <20090521184233.3c3e97ad@dhcp-100-2-144.bos.redhat.com> <4A15DA4E.2090505@goop.org> <C85CEDA13AB1CF4D9D597824A86D2B9005760A96DA@PDSMSX501.ccr.corp.intel.com> <4A1629BA.9070309@goop.org> <C85CEDA13AB1CF4D9D597824A86D2B9005760A9940@PDSMSX501.ccr.corp.intel.com> <4A16D3DF.5000600@zytor.com>
In-Reply-To: <4A16D3DF.5000600@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> That's an indirect jump, though.  I don't think anyone was suggesting
> using an indirect jump; the final patched version should be a direct
> jump (instead of a direct call.)
>
> I can see how indirect jumps might be slower, since they are probably
> not optimized as aggressively in hardware as indirect calls -- indirect
> jumps are generally used for switch tables, which often have low
> predictability, whereas indirect calls are generally used for method
> calls, which are (a) incredibly important for OOP languages, and (b)
> generally highly predictable on the dynamic scale.
>
> However, direct jumps and calls don't need prediction at all (although
> of course rets do.)

I did a quick experiment to see how many sites this optimisation could 
actually affect.  Firstly, it does absolutely nothing with frame 
pointers enabled.  Arranging for no frame pointers is quite tricky, 
since it means disabling all debugging, tracing and other things.

With no frame pointers, its about 26 of 5400 indirect calls are 
immediately followed by ret (not all of those sites are pvops calls).  
With preempt disabled, this goes up to 45 sites.

I haven't done any actual runtime tests, but a quick survey of the 
affected sites shows that only a couple are performance-sensitive; 
_spin_lock and _spin_lock_irq and _spin_lock_irqsave are the most obvious.

    J
