Return-Path: <linux-kernel-owner+w=401wt.eu-S1763767AbZDANhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763767AbZDANhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbZDANhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:37:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54773 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224AbZDANhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:37:35 -0400
Date: Wed, 1 Apr 2009 15:36:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip 0/4 V3] tracing: kprobe-based event tracer
Message-ID: <20090401133654.GB18677@elte.hu>
References: <49CC08A2.5030602@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CC08A2.5030602@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Hi,
> 
> Here are the patches of kprobe-based event tracer for x86, version 
> 3. Since this feature seems to attract some developers, I'd like 
> to push these basic patches into -tip tree so that they can easily 
> play it.
> 
> This version supports only x86(-32/-64) (If someone is interested 
> in porting this to other architectures, I'd happy to help :)), and 
> no respawn-able probe support (this would be better to push -mm 
> tree.)
> 
> This can be applied on the linux-2.6-tip tree.

This bit:

> Future items:
> - Check insertion point safety by using instruction decoder.

is i believe a must-fix-before-merge item.

The functionality is genuinely useful, and if used dynamically on 
the host it can be a lot more versatile and a lot more accessible 
than a KGDB session - but code patching safety is a must-have.

It does not have to be a full decoder, just a simplified decoding 
run that starts from a known function-symbol address, and works its 
way down in the function looking at instruction boundaries, and 
figuring out whether the code patching is safe. If it sees anything 
it cannot deal with it bails out.

I suspect you could get very good practical results by supporting 
just a small fraction of the x86 instruction set architecture. If 
failures to insert a probe safely are printed out in clear terms:

   Could not insert probe at address 0xc01231234 due to:
   Unknown instruction: 48 8d 15 db ff ff ff 00 00 00

People will fill in the missing ISA bits quickly :-)

And people doing:

  asm(" .byte 0x00, 0x01, 0x02, 0x03;"); /* hehe, I broke the decoder! */

... in kernel .text functions will be talked to in private :)

So please lets do this now, it needs to happen.

Not having this was the main design failure of original kprobes, 
this fragility is what isolated kprobes from the rest of the 
instrumentation world and made it essentially a SystemTap-only 
special. And this problem is fixable.

It does not have to be a full solution, but it has to be a pretty 
safe one. If it's safe and there are no showstopper objections from 
others we can apply it to -tip

Can you see any fundamental reason why this couldnt be done?

Thanks,

	Ingo
