Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbZBQQso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbZBQQso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 11:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZBQQsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 11:48:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46591 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbZBQQsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 11:48:35 -0500
Message-ID: <499AEA72.9090702@redhat.com>
Date: Tue, 17 Feb 2009 11:48:50 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <peterz@infradead.org>, akpm <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: irq-disabled vs vmap vs text_poke
References: <20090213141839.GA31922@Krystal> <4995A0B7.1030705@redhat.com> <20090213165555.GA4684@Krystal> <4995B88C.2090900@redhat.com> <20090213185725.GC7124@Krystal> <4995E925.3080506@redhat.com> <4999808B.5080505@redhat.com> <20090216153145.GB19182@wotan.suse.de> <20090216172441.GA12576@Krystal> <499A1A43.6000009@redhat.com> <20090217030353.GA31504@wotan.suse.de>
In-Reply-To: <20090217030353.GA31504@wotan.suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Mon, Feb 16, 2009 at 09:00:35PM -0500, Masami Hiramatsu wrote:
>> Mathieu Desnoyers wrote:
>>> * Nick Piggin (npiggin@suse.de) wrote:
>>>> On Mon, Feb 16, 2009 at 10:04:43AM -0500, Masami Hiramatsu wrote:
>>>>>>>>>> BTW, what about using map_vm_area() in text_poke() instead of 
>>>>>>>>>> vmap()?
>>>>>>>>>> Since text_poke() just maps text pages to alias pages temporarily,
>>>>>>>>>> I think we don't need to use delayed vunmap().
>>>> [...] 
>>>>
>>>>> Here is the patch which replace v(un)map with (un)map_vm_area.
>>>> I don't quite understand the point of this... delayed vunmap() is
>>>> just an implementation detail of vmap subsystem. Callers should not
>>>> have to care.
>>>>
>>> AFAIK, map_vm_area/unmap_vm_area is faster than vmap/vunmap.  This is
>>> the point of this patch. Masami, could you provide a quick benchmark of
>>> text_poke()/seconds before and after this optimization is applied to
>>> confirm this ?
>> Sure, here is the result of calling text_poke() 2^14 times.
>>
>> <Without this patch>
>> Total: 3634133356(cycles), 221809(cycles/text_poke)
>> Total: 3699532690(cycles), 225801(cycles/text_poke)
>> Total: 3249855588(cycles), 198355(cycles/text_poke)
>>
>> <With this patch>
>> Total: 483467579(cycles), 29508(cycles/text_poke)
>> Total: 497441301(cycles), 30361(cycles/text_poke)
>> Total: 497604548(cycles), 30371(cycles/text_poke)
> 
> Hmm, on bigger SMP systems, I think the global TLB flush required
> for unmap_kernel_range will reverse these numbers.

Sure, that's possible. unfortunately, I don't have that bigger machine...
It's just the result on 4-core smp machine.


>> BTW, this is not only for performance, but also simplicity and its need.
>> Vmap may allocate new vm_area. However, since text_poke() just needs to
>> map pages temporarily (yeah, very short time), we don't want to call
>> kmalloc or any other memory allocators.
>> And since text_poke() makes WRITABLE aliases of READ-ONLY pages, we
>> want to purge these pages ASAP.
>> So, I think just reserving a small vm_area for text_poke() and
>> reusing it is enough.
> 
> It is not a bad idea, but I don't think it quite goes far enough.
> IMO we should reserve 2 pages of virtual memory for each CPU, and
> then do the mapping/unmapping without locking, and with another
> variant of unmap_kernel_range that does not do the global TLB
> flush.
> 
> Unless performance doesn't really matter much, in which case, I
> guess your patch is nice because it avoids doing the allocations.

Thanks, I think text_poke() doesn't need high performance currently,
because it's not called so frequently, nor from the normal operation.

However, Would dynamic ftrace need performance?

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

