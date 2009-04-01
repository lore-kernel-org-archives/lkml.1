Return-Path: <linux-kernel-owner+w=401wt.eu-S933005AbZDAOSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005AbZDAOSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765683AbZDAOJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:09:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37119 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932597AbZDAOJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:09:57 -0400
Message-ID: <49D37584.50208@redhat.com>
Date: Wed, 01 Apr 2009 10:09:08 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH -tip 0/4 V3] tracing: kprobe-based event tracer
References: <49CC08A2.5030602@redhat.com> <20090401133654.GB18677@elte.hu>
In-Reply-To: <20090401133654.GB18677@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> Hi,
>>
>> Here are the patches of kprobe-based event tracer for x86, version 
>> 3. Since this feature seems to attract some developers, I'd like 
>> to push these basic patches into -tip tree so that they can easily 
>> play it.
>>
>> This version supports only x86(-32/-64) (If someone is interested 
>> in porting this to other architectures, I'd happy to help :)), and 
>> no respawn-able probe support (this would be better to push -mm 
>> tree.)
>>
>> This can be applied on the linux-2.6-tip tree.
> 
> This bit:
> 
>> Future items:
>> - Check insertion point safety by using instruction decoder.
> 
> is i believe a must-fix-before-merge item.

Hi Ingo,

I agreed. Fortunately, Jim Keniston and I wrote an x86 instruction
decoder :-) which has been made originally for uprobe andd kprobes
jump-optimizer.

https://www.redhat.com/archives/utrace-devel/2009-March/msg00031.html

> The functionality is genuinely useful, and if used dynamically on 
> the host it can be a lot more versatile and a lot more accessible 
> than a KGDB session - but code patching safety is a must-have.
> 
> It does not have to be a full decoder, just a simplified decoding 
> run that starts from a known function-symbol address, and works its 
> way down in the function looking at instruction boundaries, and 
> figuring out whether the code patching is safe. If it sees anything 
> it cannot deal with it bails out.

Yeah, that is what I'll do.

> I suspect you could get very good practical results by supporting 
> just a small fraction of the x86 instruction set architecture. If 
> failures to insert a probe safely are printed out in clear terms:
> 
>    Could not insert probe at address 0xc01231234 due to:
>    Unknown instruction: 48 8d 15 db ff ff ff 00 00 00
> 
> People will fill in the missing ISA bits quickly :-)
> 
> And people doing:
> 
>   asm(" .byte 0x00, 0x01, 0x02, 0x03;"); /* hehe, I broke the decoder! */
> 
> ... in kernel .text functions will be talked to in private :)

Aha, that function will get illegal instruction exception :-) even
without kprobe.

> 
> So please lets do this now, it needs to happen.

Sure.

> Not having this was the main design failure of original kprobes, 
> this fragility is what isolated kprobes from the rest of the 
> instrumentation world and made it essentially a SystemTap-only 
> special. And this problem is fixable.
> 
> It does not have to be a full solution, but it has to be a pretty 
> safe one. If it's safe and there are no showstopper objections from 
> others we can apply it to -tip
> 
> Can you see any fundamental reason why this couldnt be done?

Nope, because we've done :-)

Thanks!

> 
> Thanks,
> 
> 	Ingo

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

