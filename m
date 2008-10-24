Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbYJXNLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbYJXNLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 09:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbYJXNK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 09:10:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:60699 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbYJXNK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 09:10:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=acRpFj9gDJuS1pqQW/Z+C+jWNgQ0CN88i5N2R88T0vl3lQJcF0kmkhijfX6xAjrzFa
         RoE5bVRy+X9u/FbWzStTbq7cNRBM/20hWcdauTy5CVhHjOyqyqrlpfcua+ezI0Qmrvs1
         V5/5gELnh3uBWKDfBV74HBF5qcCZIu0xIDfJA=
Message-ID: <4901D8CD.7000405@gmail.com>
Date: Fri, 24 Oct 2008 16:16:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing: fix a build error on alpha and m68k
References: <20081023213637.eff9b414.sfr@canb.auug.org.au> <20081023121145.GB27984@x200.localdomain> <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com> <c62985530810230615s3252a54ao6488e763d72dc939@mail.gmail.com> <49008D12.5090204@gmail.com> <Pine.LNX.4.64.0810231635440.18978@anakin> <c62985530810230757r411b4e3dj4ecec649cf8cf0b3@mail.gmail.com> <Pine.LNX.4.64.0810231727430.18978@anakin> <4900B414.7090002@gmail.com> <20081023163433.GA3160@x200.localdomain> <20081023163850.GB16591@elte.hu>
In-Reply-To: <20081023163850.GB16591@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
>> On Thu, Oct 23, 2008 at 07:27:48PM +0200, Frederic Weisbecker wrote:
>>> When tracing is enabled, some arch have included <linux/irqflags.h>
>>> on their <asm/system.h> but others like alpha or m68k don't.
>>>
>>> Build error on alpha:
>>>
>>> kernel/trace/trace.c: In function 'tracing_generic_entry_update':
>>> kernel/trace/trace.c:658: error: implicit declaration of function 'irqs_disabled_flags'
>>> kernel/trace/trace.c: In function 'tracing_cpumask_write':
>>> kernel/trace/trace.c:2145: error: implicit declaration of function 'raw_local_irq_disable'
>>> kernel/trace/trace.c:2162: error: implicit declaration of function 'raw_local_irq_enable'
>>> kernel/trace/trace.c: In function 'trace_die_handler':
>>> kernel/trace/trace.c:3039: error: 'DIE_OOPS' undeclared (first use in this function)
>>>
>>> Build error on m68k:
>>> http://kisskb.ellerman.id.au/kisskb/buildresult/50641/
>>>
>>>
>>> Include it on kernel/trace/trace.c
>>>
>>> Reported-by: Alexey Dobriyan <adobriyan@gmail.com>
>>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>>> ---
>>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>>> index 78d5661..deb9684 100644
>>> --- a/kernel/trace/trace.c
>>> +++ b/kernel/trace/trace.c
>>> @@ -34,6 +34,7 @@
>>>  
>>>  #include <linux/stacktrace.h>
>>>  #include <linux/ring_buffer.h>
>>> +#include <linux/irqflags.h>
>> Sure, except it doesn't fix anything.
> 
> hm, zapped the commit then.
> 
> the problem is most likely that none of these architectures is lockdep 
> enabled, hence they have no irqtrace wrappers, hence not all of the 
> tracers can be built on them?
> 
> 	Ingo
> 

I just testes my patch by building with a cross compiler on Alpha.
Before the patch:

kernel/trace/trace.c: In function 'tracing_generic_entry_update':
kernel/trace/trace.c:664: error: implicit declaration of function 'irqs_disabled_flags'
kernel/trace/trace.c: In function 'tracing_cpumask_write':
kernel/trace/trace.c:2150: error: implicit declaration of function 'raw_local_irq_disable'
kernel/trace/trace.c:2167: error: implicit declaration of function 'raw_local_irq_enable'
kernel/trace/trace.c: In function 'trace_die_handler':
kernel/trace/trace.c:3044: error: 'DIE_OOPS' undeclared (first use in this function)
kernel/trace/trace.c:3044: error: (Each undeclared identifier is reported only once
kernel/trace/trace.c:3044: error: for each function it appears in.)

After the patch:

kernel/trace/trace.c: In function 'tracing_generic_entry_update':
kernel/trace/trace.c:664: error: implicit declaration of function 'irqs_disabled_flags'
kernel/trace/trace.c: In function 'trace_die_handler':
kernel/trace/trace.c:3044: error: 'DIE_OOPS' undeclared (first use in this function)
kernel/trace/trace.c:3044: error: (Each undeclared identifier is reported only once
kernel/trace/trace.c:3044: error: for each function it appears in.)

So the raw_local_irq_* functions are defined in linux/irqflags.h, even for arch that doesn't have CONFIG_TRACE_IRQFLAGS_SUPPORT. They just do a local_irq_save/restore.
That's what we wanted. And we have to include it on trace.c for archs like alpha.

So this patch fixes it.

The DIE_OOPS should be fixed by a recent patch from Steven (ftrace: move nmi die handler to arch specific).

The last issue is irqs_disabled_flags. But it's one other problem which is in discussion.
