Return-Path: <linux-kernel-owner+w=401wt.eu-S1760580AbYACBFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760580AbYACBFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 20:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYACBFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 20:05:22 -0500
Received: from relay2.sgi.com ([192.48.171.30]:38671 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753382AbYACBFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 20:05:21 -0500
From: Jonathan Lim <jlim@sgi.com>
Message-Id: <200801030106.m03162PL052329@sabah.engr.sgi.com>
Subject: Re: [PATCH] Provide u64 version of jiffies_to_usecs() in kernel/tsacct.c
To: hpa@zytor.com (H. Peter Anvin)
Date: Wed, 2 Jan 2008 17:06:01 -0800 (PST)
Cc: akpm@linux-foundation.org (Andrew Morton), linux-kernel@vger.kernel.org,
       jlan@sgi.com
In-Reply-To: <477C2E1F.2040307@zytor.com> from "H. Peter Anvin" at Jan 02, 2008 04:36:47 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed Jan  2 16:36:47 2008, hpa@zytor.com wrote:
> 
> Andrew Morton wrote:
> > On Fri, 28 Dec 2007 13:26:07 -0800 (PST) Jonathan Lim <jlim@sgi.com> wrote:
> > 
> >> It's possible that the values used in and returned from jiffies_to_usecs()
> >> are incorrect because of truncation when variables of type u64 are
> >> involved.  So a function specific to that type is used instead.
> >>
> >> Diff'd against: linux/kernel/git/stable/linux-2.6.23.y.git
> >>
> >> Signed-off-by: Jonathan Lim <jlim@sgi.com>
> >>
> >> --- a/kernel/tsacct.c	2007-12-28 11:58:05.182065029 -0800
> >> +++ b/kernel/tsacct.c	2007-12-28 11:57:37.949013675 -0800
> >> @@ -71,6 +71,17 @@ void bacct_add_tsk(struct taskstats *sta
> >>  
> >>  #ifdef CONFIG_TASK_XACCT
> >>  
> >> +static inline u64 jiffies_to_usecs_u64(const u64 j)
> >> +{
> >> +#if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
> >> +	return (USEC_PER_SEC / HZ) * j;
> >> +#elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
> >> +	return (j + (HZ / USEC_PER_SEC) - 1)/(HZ / USEC_PER_SEC);
> >> +#else
> >> +	return (j * USEC_PER_SEC) / HZ;
> >> +#endif
> >> +}
> >> +
> >>  #define KB 1024
> >>  #define MB (1024*KB)
> >>  /*
> >> @@ -81,8 +92,8 @@ void xacct_add_tsk(struct taskstats *sta
> >>  	struct mm_struct *mm;
> >>  
> >>  	/* convert pages-jiffies to Mbyte-usec */
> >> -	stats->coremem = jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
> >> -	stats->virtmem = jiffies_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
> >> +	stats->coremem = jiffies_to_usecs_u64(p->acct_rss_mem1) * PAGE_SIZE / MB;
> >> +	stats->virtmem = jiffies_to_usecs_u64(p->acct_vm_mem1) * PAGE_SIZE / MB;
> >>  	mm = get_task_mm(p);
> >>  	if (mm) {
> >>  		/* adjust to KB unit */
> > 
> > Fair enough.  But I guess that new function should be a kernel-wide thing
> > because surely other users will turn up.
> > 
> > Peter has been working on the accuracy of some of these conversion
> > functions and might need to know about this change?
> 
> Yes, the function should be coded using the new #defines produced by 
> timeconst.h; that way you end up avoiding a possible overflow in the 
> multiplication.
> 
> I believe all three cases can be folded, then, to:
> 
> 	return (j*HZ_TO_USEC_NUM + HZ_TO_USEC_DEN-1) / HZ_TO_USEC_DEN;
> 
> I would also like to observe that the roundoff behaviour of the function 
>   above is inconsistent; in case 2 it will round up, but in case 3 it 
> will round down.  The line proposed above has round up behaviour.
> 
> 	-hpa

Peter,

Would you be willing to include the u64 function as part of your patch to make
it available kernel-wide?  It just needs:

  u64 inline jiffies_to_usecs_u64(const u64 j)

and for the symbol to be exported.  Thanks.

Jonathan
