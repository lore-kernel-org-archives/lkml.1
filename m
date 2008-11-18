Return-Path: <linux-kernel-owner+w=401wt.eu-S1752971AbYKROH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbYKROH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 09:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYKROGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 09:06:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42813 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068AbYKROGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 09:06:44 -0500
Date: Tue, 18 Nov 2008 15:06:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: rostedt@goodmis.org, akpm@linux-foundation.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix writing to trace/trace_options
Message-ID: <20081118140626.GD23479@elte.hu>
References: <1226831883-26362-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081116104604.GA25788@skywalker> <20081117111747.GN28786@elte.hu> <20081117131152.GA9345@skywalker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117131152.GA9345@skywalker>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com> wrote:

> On Mon, Nov 17, 2008 at 12:17:47PM +0100, Ingo Molnar wrote:
> > 
> > * Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > 
> > > On Sun, Nov 16, 2008 at 04:07:58PM +0530, Aneesh Kumar K.V wrote:
> > > > writing to trace/trace_options use the index of the array
> > > > to find the value of the flag. With branch tracer flag
> > > > defined conditionally, this breaks writing to trace_options
> > > > with branch tracer disabled.
> > > > 
> > > > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > > 
> > > tg export didn't add numbering to the patch based on dependency.
> > > So the series is in the below order
> > > 
> > > [PATCH] ftrace: add proper bin iterator support
> > > [PATCH] ftrace: Add dump iteator
> > > [PATCH] ftrace: Add debug_print trace to print data from kernel to userspace
> > > [PATCH] ftrace: Add new entry type TRACE_BIN_DUMP
> > > [PATCH] ftrace: Add debug_dump trace to dump binary data from kernel to userspace
> > > [PATCH] Fix writing to trace/trace_options
> > > 
> > > The patches are against -tip with HEAD
> > > 7195b6707adcd00f413ce07e6b9954b4c597495c
> > 
> > hm, i'm not sure about this. We already do binary dumping, but only 
> > for the cases where we actually know the structure of the data (i.e. 
> > binary dumping is just an output format, not a tracing type). And that 
> > is good so.
> 
> Why do we need to limit to know structures. debug_dump can be looked at
> as a debugging helper which allows the user to send more data in binary
> format. Later user space can decide to look at the values. I had the
> below test case done to check the patches.
> 
>  	int err;
> +	struct data {
> +		char i;
> +		int k;
> +	};
> +	struct data mydata = {.i = 'c', .k = 10};
>  
>  	/*
>  	 * If we have encountered a bitmap-format file, the size limit
>  	 * is smaller than s_maxbytes, which is for extent-mapped files.
>  	 */
> +	dp_printk("%s with value %d\n", __func__, pos);
> +	debug_dump(&mydata, sizeof(mydata));
> 
> 
> > 
> > In your patchset right now nothing uses debug_dump(ptr, len) so 
> > it's hard to see exactly how we should shape it. What specific 
> > usages do you have in mind?
> 
> If you are not convinced about debug_dump you may want to pick the 
> first three patches that include a bug fix and support for 
> dp_printk.

i'm still wondering about the specific usecase you have in mind. Where 
do we want to dump unstructured data to user-space? If you look at all 
the existing ftrace plugins we know the structure of the logged data 
very well, and most of the plugins have semantic dependencies on that 
data content as well.

and having binary log data that _only_ user-space can process 
meaningfully, while it's opaque to the tracer plugin, sounds like a 
poor concept to me.

	Ingo
