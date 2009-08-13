Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbZHMVe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbZHMVe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 17:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbZHMVe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 17:34:28 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4321 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbZHMVe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 17:34:28 -0400
Subject: Re: [PATCH] Use bool for boolean flag in printk_once()
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
In-Reply-To: <20090813142144.37509d52.akpm@linux-foundation.org>
References: <adak5174ezp.fsf@cisco.com>
	 <20090813142144.37509d52.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 14:33:47 -0700
Message-Id: <1250199227.28285.142.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 14:21 -0700, Andrew Morton wrote:
> On Thu, 13 Aug 2009 13:48:26 -0700
> Roland Dreier <rdreier@cisco.com> wrote:
> 
> > Using the type bool (instead of int) for the __print_once flag in the
> > printk_once() macro matches the intent of the code better, and allows
> > the compiler to generate smaller code; eg a typical callsite with gcc
> > 4.3.3 on i386:
> > 
> > add/remove: 0/0 grow/shrink: 0/2 up/down: 0/-6 (-6)
> > function                                     old     new   delta
> > static.__print_once                            4       1      -3
> > get_cpu_vendor                               146     143      -3
> > 
> > Saving 6 bytes of object size per callsite by slightly improving the
> > readability of the source seems like a win to me.
> > 
> > Signed-off-by: Roland Dreier <rolandd@cisco.com>
> > ---
> >  include/linux/kernel.h |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > index d6320a3..f828ce9 100644
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -249,10 +249,10 @@ extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
> >   * Print a one-time message (analogous to WARN_ONCE() et al):
> >   */
> >  #define printk_once(x...) ({			\
> > -	static int __print_once = 1;		\
> > +	static bool __print_once = true;	\
> >  						\
> >  	if (__print_once) {			\
> > -		__print_once = 0;		\
> > +		__print_once = false;		\
> >  		printk(x);			\
> >  	}					\
> >  })
> 
> hm, OK,  in trace_recursive_lock() we get:
> 
> 	cmpl	$0, __print_once.28104(%rip)	#, __print_once
> 	je	.L719	#,
> 
> changed to
> 
> 	cmpb	$0, __print_once.28104(%rip)	# __print_once
> 	je	.L719	#,

The test should be inverted so that it's not initialized.

I submitted this once:
http://lkml.indiana.edu/hypermail/linux/kernel/0905.2/02636.html

	static bool printed;
	if (!printed) {
		printed = true;
		printk...
	}


