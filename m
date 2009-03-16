Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZCPDDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZCPDDe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 23:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZCPDD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 23:03:26 -0400
Received: from ozlabs.org ([203.10.76.45]:38597 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbZCPDDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 23:03:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PULL] x86 cpumask work
Date: Mon, 16 Mar 2009 13:33:16 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Mike Travis <travis@sgi.com>
References: <200903121453.45163.rusty@rustcorp.com.au> <200903151326.34114.rusty@rustcorp.com.au> <20090315060044.GE20949@elte.hu>
In-Reply-To: <20090315060044.GE20949@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903161333.16632.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 March 2009 16:30:44 Ingo Molnar wrote:
> 
> >  	} else if (check_c1e_idle(c)) {
> >  		printk(KERN_INFO "using C1E aware idle routine\n");
> > -		alloc_cpumask_var(&c1e_mask, GFP_KERNEL);
> > -		cpumask_clear(c1e_mask);
> > +		/* c1e_mask can only be NULL during boot of first cpu. */
> > +		if (c1e_mask == NULL) {
> > +			alloc_cpumask_var(&c1e_mask, GFP_KERNEL);
> 
> Sigh, there are two bugs here:
> 
>    1) what if the GFP_KERNEL allocation fails?

As the comments says, it can only be NULL during boot of the first CPU.

start_kernel -> check_bugs -> identify_boot_cpu -> identify_cpu
  -> select_idle_routine.

Did you want me to panic if it fails?

>    2) this code is called with interrupts disabled, so a 
>       GFP_KERNEL allocation can be lethal.

I don't see that in my analysis of the code.

> c1e_mask should stay a static cpumask...
> 
> Why do we convert static, standalone masks to cpumask_var?

Because we can't undefine struct cpumask while there are any left.  If we
really want to we can make it a bitmap, but that's not a good thing to
encourage.

Hope that clarifies,
Rusty.
