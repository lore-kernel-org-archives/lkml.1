Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbYGIUKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbYGIUKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYGIUJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:09:56 -0400
Received: from gw.goop.org ([64.81.55.164]:60411 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087AbYGIUJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:09:55 -0400
Message-ID: <48751B01.2010709@goop.org>
Date: Wed, 09 Jul 2008 13:09:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Christoph Lameter <cl@linux-foundation.org>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <4874FFC4.7050505@linux-foundation.org> <487502BD.2020206@goop.org> <487504A8.5040000@linux-foundation.org> <487507E7.6010102@goop.org> <48750945.8000201@linux-foundation.org> <48750C6C.5090606@goop.org> <48750D96.7030407@linux-foundation.org> <4875123F.1070504@goop.org> <20080709194136.GD4804@elte.hu> <4875170C.4090500@linux-foundation.org> <20080709200057.GA14009@elte.hu>
In-Reply-To: <20080709200057.GA14009@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Christoph Lameter <cl@linux-foundation.org> wrote:
>
>   
>> Ingo Molnar wrote:
>>
>>     
>>> that makes sense. Does everyone agree on #1-#2-#3 and then gradual 
>>> elimination of most pda members (without going through an 
>>> intermediate renaming of pda members) being the way to go?
>>>       
>> I think we all agree on 1-2-3.
>>
>> The rest is TBD. Hope Jeremy can add his wisdom there to get the pda.X 
>> replaced by the proper percpu names for 32 bit.
>>
>> With Jeremy's approach we would be doing two steps at once (getting 
>> rid of pda ops plus unifying the variable names between 32 and 64 
>> bit). Maybe more difficult to verify correctness. The removal of the 
>> pda ops is a pretty straighforward conversion.
>>     
>
> Yes, but there's nothing magic about pda variables versus percpu 
> variables. We should be able to do the pda -> unified step just as much 
> as we can do a percpu -> unified step. We can think of pda as a funky, 
> pre-percpu-era relic.
>
> The only thing that percpu really offers over pda is its familarity. 
> read_pda() has the per-cpu-ness embedded in it, which is nasty with 
> regard to tracking preemption properties, etc.
>
> So converting to percpu would bring us CONFIG_PREEMPT_DEBUG=y checking 
> to those ex-pda variables. Today if a read_pda() (or anything but 
> pcurrent) is done in a non-preempt region that's likely a bug - but 
> nothing warns about it.
>
> So in that light 4-15 might make some sense in standardizing all these 
> accesses and making sure it all fits into an existing, familar API 
> world, with no register level assumptions and assembly (and ABI) ties, 
> which is instrumented as well, with explicit smp_processor_id() 
> dependencies, etc.
>   

Yeah, but doing

#define read_pda(x)      x86_read_percpu(x)

gives you all that anyway.   Though because x86_X_percpu and X_pda are 
guaranteed to be atomic with respect to preemption, it's actually 
reasonable to use them with preemption enabled.

    J
