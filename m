Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbZEOT7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbZEOT7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 15:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbZEOT7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 15:59:18 -0400
Received: from gw.goop.org ([64.81.55.164]:56564 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756588AbZEOT7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 15:59:17 -0400
Message-ID: <4A0DC987.2050306@goop.org>
Date: Fri, 15 May 2009 12:59:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Olaf Kirch <okir@suse.de>
Subject: Re: Where do we stand with the Xen patches?
References: <4A0C770E.2030305@goop.org> <20090515183550.GA20833@elte.hu>
In-Reply-To: <20090515183550.GA20833@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> These look fine but i still need to go over them one last time 
> before pulling them.
>
>   
> Yes. Here too i still need to go over them once more before pulling 
> them.
>   

I've been posting these patches in fundamentally the same form for about 
6 months now.  I don't think you'll find anything surprising.

>> for-ingo/xen/dom0/mtrr
>>
>>    You queried the value of "extending" this interface, given that its
>>    considered to be deprecated.  These changes in no way extend the
>>    interface, but just make the existing interface functional under
>>    Xen.  And while we don't have PAT support, there's no other way of
>>    setting cachability attributes on memory, so not supporting it has a
>>    fairly severe performance impact on things like X.
>>     
>
> Latest Xorg doesnt need /proc/mtrr. By the time this kernel (.31 or 
> later) hits any distribution, /proc/mtrr using Xorg will be a 
> distant memory. So i see no reason why to apply those bits at all, 
> and i see a lot of reasons to not apply them.
>   

In general we don't break usermode ABIs, even when using new kernels 
with old distros, so I don't see why this case is any different.

Besides, these changes are not only for /proc/mtrr, but also to 
implement the internal mtrr_add() APIs that DRM uses to set the MTRR 
inside the kernel, so failing to implement them will cause performance 
regressions on new X servers.

Given that we're talking about 120 lines of code with no runtime impact 
and tiny kernel size impact (when configured), I'm at a loss for what 
your "lot of reasons" might be.  Perhaps you could be more specific.

> As in the past, my main worry is performance overhead of paravirt in 
> general.
>
> The patches that dont affect any native kernel fast path are 
> probably OK (but still pending final review).
>   

These changes don't have anything much to do with paravirt_ops, per se, 
and are all specifically about Xen dom0 support.  Aside from that, none 
of the changes are on performance-critical paths.

> Regarding patches that do change the fastpath i'll do a round of 
> measurements of CONFIG_PARAVIRT against !CONFIG_PARAVIRT kernels, 
> and make up my mind based on that.
>
> You could accelerate this by sending some "perf stat" hard numbers 
> to give us an idea about where we stand today.

I posted them the other day; those perf stat measurements pointing out 
the pv-spinlock problem also showed that paravirt_ops in general has a 
sub-1% performance hit (and possible performance benefit) when running 
mmap-perf.  You added them into the commit log for the patch, so I 
presume you read it.

    J
