Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbYGVWMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbYGVWMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 18:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbYGVWMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 18:12:10 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:42926 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753328AbYGVWMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 18:12:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgFADD2hUhMRKxB/2dsb2JhbACBWrA3
Date: Tue, 22 Jul 2008 18:12:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Avi Kivity <avi@qumranet.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org
Subject: Re: [patch 0/4] Port KVM-trace to tracepoints -> LTTng ?
Message-ID: <20080722221204.GA14661@Krystal>
References: <20080717155724.897537670@polymtl.ca> <48862A30.7050701@qumranet.com> <y0mabg991c3.fsf@ton.toronto.redhat.com> <488635A7.2030609@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <488635A7.2030609@qumranet.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:03:46 up 48 days,  2:44,  4 users,  load average: 0.31, 0.46,
	0.55
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity (avi@qumranet.com) wrote:
> Frank Ch. Eigler wrote:
>> Avi Kivity <avi@qumranet.com> writes:
>>
>>   
>>> [...]
>>> kvm tracepoints are heavily tied into the implementation; and making
>>> them harder to write means we will have less information.  In fact, I
>>> am contemplating moving in another direction (when looking at the
>>> pgprintk()s scattered around arch/x86/kvm/mmu.c:
>>>
>>>   kvm_trace("pfentry", "page_fault entry addr %lx error code %x\n",
>>> cr2, error_code);
>>>
>>> Unlike printk()s, no actual formatting would occur during runtime.
>>>     
>>
>> Have you considered using trace_mark() directly - eliminating the
>> KVM_TRACEN() middlemen?
>>
>>   
>
> Eliminating KVM_TRACEN -- yes.  There are too many of them, they aren't 
> type-aware, and they're in uppercase.
>
> Using trace_mark() directly -- looking at it, seems to fit the requirements 
> exactly.  Should have looked at it earlier.  Is there a way to get a list 
> of all markers?
>
> Perhaps the kvmtrace marker->relay integration should be made a marker 
> feature, since there is nothing specific to kvm in it.
>
>>> Instead, at initialization time all the strings would be parsed into
>>> a data structure that describes the data types, and the runtime
>>> would simply consult this structure and copy the arguments into
>>> trace records.  User space would also be able to pull this structure
>>> and so recreate the formatted string.
>>>     
>>
>> If one really wanted to, one could build such a mechanism on top of
>> marker-based callbacks.
>>
>>   
>
> One does want to.
>
>>>  - no need to have a formats file in userspace (which is tied to the
>>> kernel version)
>>>     
>>
>> OTOH, you'd have the kernel collecting compact binary records
>> containing just the parameters, which are at least as tied to kernel
>> version.
>>
>>   
>
> Yes, but the userspace side would collect the format strings as well (just 
> once) and could put them in the same file.  The aggregation is portable 
> across kernel versions.
>

Yes,

LTTng does exactly all that.

Please have a look at the current LTTng patchset :

http://ltt.polymtl.ca/lttng/patch-2.6.26-0.11.tar.bz2

The interface to list markers is currently found in /proc/ltt

Commands like :

cat /proc/ltt (list markers)
And echo -n "connect marker_name default dynamic channel_name"

See the script ltt-armall.sh in the package :

http://ltt.polymtl.ca/lttng/ltt-control-0.50-17072008.tar.gz

To see how to arm all markers listed.

General information (compatibility list and quickstart guide are
available at http://ltt.polymtl.ca). Packages also useful : lttv (trace
analyser, including text dump, filtering, gui...) and a userspace marker
package (only supports x86 32/64 currently).

All these packages support any kind of custom markers, because the
marker names/types are listed in the "facilities_*" control tracefile at
trace start, so the traces are self-described. I also list other stuff
(memory maps, irq handler names, system call handler names) at trace
start so we can dynamically have these mapping, independently of the
architecture.

See :
http://ltt.polymtl.ca/packages/lttv-0.10.0-pre14-17072008.tar.gz
http://ltt.polymtl.ca/packages/markers-userspace-0.5.tar.bz2

I'll be more than happy to answer your questions.

Mathieu


> -- 
> I have a truly marvellous patch that fixes the bug which this
> signature is too narrow to contain.
>

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
