Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbZJUQOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbZJUQOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 12:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbZJUQOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 12:14:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42909 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbZJUQOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 12:14:54 -0400
Subject: Re: [PATCH -v4 9/9] tracing: add function graph tracer support for
 MIPS
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: wuzhangjin@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>
In-Reply-To: <1256138506.11274.13.camel@falcon>
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>
	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>
	 <3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>
	 <ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>
	 <96110ea5dd4d3d54eb97d0bb708a5bd81c7a50b5.1256135456.git.wuzhangjin@gmail.com>
	 <5dda13e8e3a9c9dba4bb7179183941bda502604f.1256135456.git.wuzhangjin@gmail.com>
	 <af3ec1b5cd06b6f6a461c9fa7d09a51fabccb08d.1256135456.git.wuzhangjin@gmail.com>
	 <a6f2959a69b6a77dd32cc36a5c8202f97d524f1e.1256135456.git.wuzhangjin@gmail.com>
	 <53bdfdd95ec4fa00d4cc505bb5972cf21243a14d.1256135456.git.wuzhangjin@gmail.com>
	 <1256138506.11274.13.camel@falcon>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 21 Oct 2009 12:14:57 -0400
Message-Id: <1256141697.18347.3124.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-21 at 23:21 +0800, Wu Zhangjin wrote:

> > +unsigned long ftrace_get_parent_addr(unsigned long self_addr,
> > +				     unsigned long parent,
> > +				     unsigned long parent_addr,
> > +				     unsigned long fp)
> > +{
> > +	unsigned long sp, ip, ra;
> > +	unsigned int code;
> > +
> > +	/* move to the instruction "move ra, at" */
> > +	ip = self_addr - 8;
> > +
> > +	/* search the text until finding the "move s8, sp" instruction or
> > +	 * "s{d,w} ra, offset(sp)" instruction */
> > +	do {
> > +		ip -= 4;
> > +		/* read the text we want to match */
> > +		if (probe_kernel_read(&code, (void *)ip, 4)) {
> > +			WARN_ON(1);
> > +			panic("read the text failure\n");
> > +		}
> > +
> > +		/* if the first instruction above "move at, ra" is "move
> > +		 * s8(fp), sp", means the function is a leaf */
> > +		if ((code & MOV_FP_SP) == MOV_FP_SP)
> > +			return parent_addr;
> > +	} while (((code & S_RA) != S_RA));
> > +
> > +	sp = fp + (code & STACK_OFFSET_MASK);
> > +	ra = *(unsigned long *)sp;
> > +
> 
> Seems missed the fault protection here? is there a need? never met fault
> in this place and also the following two places, so, are we safe to
> remove all of the fault protection?

Is that "sp" basically already been check by the above
probe_kernel_read? If so, then it should be fine not to do the check
again.

-- Steve

> 
> Regards
> 	Wu Zhangjin
> 
> > +	if (ra == parent)
> > +		return sp;
> > +	else
> > +		panic
> > +		    ("failed on getting stack address of ra\n: addr: 0x%lx, code: 0x%x\n",
> > +		     ip, code);
> > +}
> > +

