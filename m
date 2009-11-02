Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbZKBVnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbZKBVnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 16:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756770AbZKBVnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 16:43:52 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:59631 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313AbZKBVnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 16:43:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F6wh4sZinmOFvy2YheS+kAVAzANDnMjvIFqg10SQatyZDqepDolyEHYTCCY8efeG7d
         GqQfspsrpK+biSmcbcm0Sf5amsIJq08/i+rzoFaah8/ViTMi7dFXnu6VGIEVQh0EGjPp
         kL3OVI476Xboa19AjxzX2zHkfJ3D1orJOd3ls=
Date: Mon, 2 Nov 2009 22:43:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
Subject: Re: [PATCH -v5 08/11] tracing: not trace mips_timecounter_init()
	in MIPS
Message-ID: <20091102214351.GI4880@nowhere>
References: <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256483735.git.wuzhangjin@gmail.com> <3e0c2d7d8b8f196a8153beb41ea7f3cbf42b3d84.1256483735.git.wuzhangjin@gmail.com> <54c417629e91f40b2bbb4e08cda2a4e6527824c0.1256483735.git.wuzhangjin@gmail.com> <29bccff04932e993ecd9f516d8b6dcf84e2ceecf.1256483735.git.wuzhangjin@gmail.com> <72f2270f7b6e01ca7a4cdf4ac8c21778e5d9652f.1256483735.git.wuzhangjin@gmail.com> <cover.1256483735.git.wuzhangjin@gmail.com> <6140dd8f4e1783e5ac30977cf008bb98e4698322.1256483735.git.wuzhangjin@gmail.com> <49b3c441a57f4db423732f81432a3450ccb3240e.1256483735.git.wuzhangjin@gmail.com> <c62985530910251727o23beafcco539870e4b2f84637@mail.gmail.com> <1256550156.5642.148.camel@falcon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256550156.5642.148.camel@falcon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 05:42:36PM +0800, Wu Zhangjin wrote:
> On Mon, 2009-10-26 at 01:27 +0100, Frederic Weisbecker wrote:
> > 2009/10/25 Wu Zhangjin <wuzhangjin@gmail.com>:
> > > -static inline u64 mips_timecounter_read(void)
> > > +static inline u64 notrace mips_timecounter_read(void)
> > 
> > 
> > You don't need to set notrace functions, unless their addresses
> > are referenced somewhere, which unfortunately might happen
> > for some functions but this is rare.
> > 
> 
> Okay, Will remove it.



Oops, a word has escaped from my above sentence. I wanted to say:

"You don't need to set notrace to inline functions" :)


> > Hmm yeah this is not very nice to do that in core functions because
> > of a specific arch problem.
> > At least you have __notrace_funcgraph, this is a notrace
> > that only applies if CONFIG_FUNCTION_GRAPH_TRACER
> > so that it's still traceable by the function tracer in this case.
> > 
> > But I would rather see a __mips_notrace on these two core functions.
> 
> What about this: __arch_notrace? If the arch need this, define it,
> otherwise, ignore it! if only graph tracer need it, define it in "#ifdef
> CONFIG_FUNCTION_GRAPH_TRACER ... #endif".



The problem is that archs may want to disable tracing on different
places.
For example mips wants to disable tracing in timecounter_read_delta,
but another arch may want to disable tracing somewhere else.

We'll then have several unrelated __arch_notrace. One that is relevant
for mips, another that is relevant for arch_foo, but all of them will
apply for all arch that have defined a __arch_notrace.

It's true that __mips_notrace is not very elegant as it looks like
a specific arch annotation intruder.

But at least that gives us a per arch filter granularity.

If only static ftrace could disappear, we could keep only dynamic
ftrace and we would then be able to filter dynamically.
But I'm not sure it's a good idea for archs integration.

