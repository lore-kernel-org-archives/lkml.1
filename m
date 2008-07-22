Return-Path: <linux-kernel-owner+w=401wt.eu-S1757772AbYGVTcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbYGVTcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757482AbYGVTb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:31:56 -0400
Received: from il.qumranet.com ([212.179.150.194]:14232 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756727AbYGVTbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:31:55 -0400
Message-ID: <488635A7.2030609@qumranet.com>
Date: Tue, 22 Jul 2008 22:31:51 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       kvm@vger.kernel.org
Subject: Re: [patch 0/4] Port KVM-trace to tracepoints
References: <20080717155724.897537670@polymtl.ca>	<48862A30.7050701@qumranet.com> <y0mabg991c3.fsf@ton.toronto.redhat.com>
In-Reply-To: <y0mabg991c3.fsf@ton.toronto.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Ch. Eigler wrote:
> Avi Kivity <avi@qumranet.com> writes:
>
>   
>> [...]
>> kvm tracepoints are heavily tied into the implementation; and making
>> them harder to write means we will have less information.  In fact, I
>> am contemplating moving in another direction (when looking at the
>> pgprintk()s scattered around arch/x86/kvm/mmu.c:
>>
>>   kvm_trace("pfentry", "page_fault entry addr %lx error code %x\n",
>> cr2, error_code);
>>
>> Unlike printk()s, no actual formatting would occur during runtime.
>>     
>
> Have you considered using trace_mark() directly - eliminating the
> KVM_TRACEN() middlemen?
>
>   

Eliminating KVM_TRACEN -- yes.  There are too many of them, they aren't 
type-aware, and they're in uppercase.

Using trace_mark() directly -- looking at it, seems to fit the 
requirements exactly.  Should have looked at it earlier.  Is there a way 
to get a list of all markers?

Perhaps the kvmtrace marker->relay integration should be made a marker 
feature, since there is nothing specific to kvm in it.

>> Instead, at initialization time all the strings would be parsed into
>> a data structure that describes the data types, and the runtime
>> would simply consult this structure and copy the arguments into
>> trace records.  User space would also be able to pull this structure
>> and so recreate the formatted string.
>>     
>
> If one really wanted to, one could build such a mechanism on top of
> marker-based callbacks.
>
>   

One does want to.

>>  - no need to have a formats file in userspace (which is tied to the
>> kernel version)
>>     
>
> OTOH, you'd have the kernel collecting compact binary records
> containing just the parameters, which are at least as tied to kernel
> version.
>
>   

Yes, but the userspace side would collect the format strings as well 
(just once) and could put them in the same file.  The aggregation is 
portable across kernel versions.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

