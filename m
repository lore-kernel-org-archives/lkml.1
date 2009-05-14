Return-Path: <linux-kernel-owner+w=401wt.eu-S1760609AbZENRvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609AbZENRvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 13:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbZENRvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 13:51:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43020 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbZENRvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 13:51:22 -0400
Message-ID: <4A0C59FE.3060702@zytor.com>
Date: Thu, 14 May 2009 10:50:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, "Xin, Xiaohui" <xiaohui.xin@intel.com>,
       "Li, Xin" <xin.li@intel.com>, "Nakajima, Jun" <jun.nakajima@intel.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: Performance overhead of paravirt_ops on native identified
References: <4A0B62F7.5030802@goop.org> <4A0B6F9C.4060405@zytor.com> <4A0C568B.7070907@goop.org>
In-Reply-To: <4A0C568B.7070907@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> We did consider something like this at the outset.  As I remember, there 
> were a few concerns:
> 
>     * There was no relocation data available in the kernel.  I played
>       around with ways to make it work, but they ended up being fairly
>       complex and brittle, with a tendency (of course) to trigger
>       binutils bugs.  Maybe that has changed.

We already do this pass (in fact, we do something like three passes of
it.)  It's basically the vmlinux.o pass.

>     * We didn't really want to implement two separate mechanisms for the
>       same thing.  Given that we wanted to inline things like
>       cli/sti/pushf/popf, we needed to have something capable of full
>       patching.  Having a separate mechanisms for patching calls is
>       harder to justify.  Now that pvops is well settled, perhaps it
>       makes sense to consider adding another more general patching
>       mechanism to avoid the indirect calls (a dynamic linker, essentially).

Full patching is understandable (although I think sometimes the code
generated was worse than out-of-line... I believe you have fixed that.)

> I won't make any great claims about the beauty of the PV_CALL* gunk, but 
> at the very least it is contained within paravirt.h.

There is still massive spillover into other code, though, at least some
of which could possibly be avoided.  I don't know.

>> (*) if patching code on SMP was cheaper, we could actually do this
>> lazily, and wouldn't have to store a list of patch sites.  I don't feel
>> brave enough to go down that route.
>>   
> The problem that the tracepoints people were trying to solve was harder, 
> where they wanted to replace an arbitrary set of instructions with some 
> other arbitrary instructions (or a call) - that would need some kind SMP 
> synchronization, both for general sanity and to keep the Intel rules happy.
> 
> In theory relinking a call should just be a single word write into the 
> instruction, but I don't know if that gets into undefined territory or 
> not.  On older P4 systems it would end up blowing away the trace cache 
> on all cpus when you write to code like that, so you'd want to be sure 
> that your references are getting resolved fairly quickly.  But its hard 
> to see how patching the offset in a call instruction would end up 
> calling something other than the old or new function.

The problem is that since the call offset field can be arbitrarily
aligned -- it could even cross page boundaries -- you still have
absolutely no SMP atomicity guarantees.  So you still have all the same
problems.  Without

	-hpa
