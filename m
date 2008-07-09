Return-Path: <linux-kernel-owner+w=401wt.eu-S1757073AbYGIVYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbYGIVYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYGIVYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:24:20 -0400
Received: from gw.goop.org ([64.81.55.164]:46796 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598AbYGIVYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:24:19 -0400
Message-ID: <48752C6E.2020709@goop.org>
Date: Wed, 09 Jul 2008 14:23:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F30C.8020800@zytor.com> <4874F909.7060503@goop.org> <4874FEDF.90404@sgi.com> <20080709193404.GC4804@elte.hu>
In-Reply-To: <20080709193404.GC4804@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
>
>   
>>> This fragility makes me very nervous.  It seems hard enough to get 
>>> this stuff working with current tools; making it work over the whole 
>>> range of supported tools looks like its going to be hard.
>>>       
>> (me too ;-)
>>
>> Once I get a solid version working with (at least) gcc-4.2.4, then 
>> regression testing with older tools will be easier, or at least a 
>> table of results can be produced.
>>     
>
> the problem is, we cannot just put it even into tip/master if there's no 
> short-term hope of fixing a problem it triggers. gcc-4.2.3 is solid for 
> me otherwise, for series of thousands of randomly built kernels.
>
> can we just leave out the zero-based percpu stuff safely and could i 
> test the rest of your series - or are there dependencies? I think 
> zero-based percpu, while nice in theory, is probably just a very small 
> positive effect so it's not a life or death issue. (or is there any 
> deeper, semantic reason why we'd want it?)
>   

I'm looking forward to using it, because I can make the Xen vcpu 
structure a percpu variable shared with the hypervisor.  This means 
something like a disable interrupt becomes a simple "movb  
$1,%gs:per_cpu__xen_vcpu_event_mask".  If access to percpu variables is 
indirect (ie, two instructions) I need to disable preemption which makes 
the whole thing much more complex, and too big to inline.  There are 
other cases where preemption-safe access to percpu variables is useful 
as well.

My view, which is admittedly very one-sided, is that all this brokenness 
is forced on us by gcc's stack-protector brokenness.  My preferred 
approach would be to fix -fstack-protector by eliminating the 
requirement for small offsets from %gs.  With that in place we could 
support it without needing a pda.  In the meantime, we could either 
support stack-protector or direct access to percpu variables.  Either 
way, we don't need to worry about making zero-based percpu work.

    J
