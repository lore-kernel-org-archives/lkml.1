Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbZDUORV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbZDUORV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZDUORH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:17:07 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:58466 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbZDUORG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:17:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LtUiO0Lev7ebxQNbe1oPFECpVaH61KqkwTfo7yFssHxYJZU7ntyTK/V2mKPcvShZQI
         ZBFeuPi9uXjlAxKp+xKTvnUGg2bgLarZG/jJixndLQkHU1KBVpR0OaU8RbWwc1Ul1lV0
         RmpLHJZPTWimBUSeUxg45QbIf5FfizS2SKdMU=
Date: Tue, 21 Apr 2009 16:17:00 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       randy.dunlap@oracle.com, Paul Menage <menage@google.com>,
       Carl Henrik Lunde <chlunde@ping.uio.no>, eric.rannaud@gmail.com,
       paolo.valente@unimore.it, fernando@oss.ntt.co.jp, dradford@bluehost.com,
       fchecconi@gmail.com, agk@sourceware.org, subrata@linux.vnet.ibm.com,
       axboe@kernel.dk, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, matt@bluehost.com, roberto@unbit.it,
       ngupta@google.com
Subject: Re: [PATCH 2/7] res_counter: introduce ratelimiting attributes
Message-ID: <20090421141658.GA21655@linux>
References: <1240090712-1058-1-git-send-email-righi.andrea@gmail.com> <1240090712-1058-3-git-send-email-righi.andrea@gmail.com> <20090421091534.971f676f.kamezawa.hiroyu@jp.fujitsu.com> <20090421095525.GA13699@linux> <20090421101659.GF19637@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421101659.GF19637@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 03:46:59PM +0530, Balbir Singh wrote:
> * Andrea Righi <righi.andrea@gmail.com> [2009-04-21 11:55:26]:
> 
> > On Tue, Apr 21, 2009 at 09:15:34AM +0900, KAMEZAWA Hiroyuki wrote:
> > > On Sat, 18 Apr 2009 23:38:27 +0200
> > > Andrea Righi <righi.andrea@gmail.com> wrote:
> > > 
> > > > Introduce attributes and functions in res_counter to implement throttling-based
> > > > cgroup subsystems.
> > > > 
> > > > The following attributes have been added to struct res_counter:
> > > >  * @policy:     the limiting policy / algorithm
> > > >  * @capacity:   the maximum capacity of the resource
> > > >  * @timestamp:  timestamp of the last accounted resource request
> > > > 
> > > > Currently the available policies are: token-bucket and leaky-bucket and the
> > > > attribute @capacity is only used by token-bucket policy (to represent the
> > > > bucket size).
> > > > 
> > > > The following function has been implemented to return the amount of time a
> > > > cgroup should sleep to remain within the defined resource limits.
> > > > 
> > > >   unsigned long long
> > > >   res_counter_ratelimit_sleep(struct res_counter *res, ssize_t val);
> > > > 
> > > > [ Note: only the interfaces needed by the cgroup IO controller are implemented
> > > > right now ]
> > > > 
> > > > Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
> > > > ---
> > > >  include/linux/res_counter.h |   69 +++++++++++++++++++++++++++++++----------
> > > >  kernel/res_counter.c        |   72 +++++++++++++++++++++++++++++++++++++++++++
> > > >  2 files changed, 124 insertions(+), 17 deletions(-)
> > > > 
> > > > diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
> > > > index 4c5bcf6..9bed6af 100644
> > > > --- a/include/linux/res_counter.h
> > > > +++ b/include/linux/res_counter.h
> > > > @@ -14,30 +14,36 @@
> > > >   */
> > > >  
> > > >  #include <linux/cgroup.h>
> > > > +#include <linux/jiffies.h>
> > > >  
> > > > -/*
> > > > - * The core object. the cgroup that wishes to account for some
> > > > - * resource may include this counter into its structures and use
> > > > - * the helpers described beyond
> > > > - */
> > > > +/* The various policies that can be used for ratelimiting resources */
> > > > +#define	RATELIMIT_LEAKY_BUCKET	0
> > > > +#define	RATELIMIT_TOKEN_BUCKET	1
> > > >  
> > > > +/**
> > > > + * struct res_counter - the core object to account cgroup resources
> > > > + *
> > > > + * @usage:	the current resource consumption level
> > > > + * @max_usage:	the maximal value of the usage from the counter creation
> > > > + * @limit:	the limit that usage cannot be exceeded
> > > > + * @failcnt:	the number of unsuccessful attempts to consume the resource
> > > > + * @policy:	the limiting policy / algorithm
> > > > + * @capacity:	the maximum capacity of the resource
> > > > + * @timestamp:	timestamp of the last accounted resource request
> > > > + * @lock:	the lock to protect all of the above.
> > > > + *		The routines below consider this to be IRQ-safe
> > > > + *
> > > > + * The cgroup that wishes to account for some resource may include this counter
> > > > + * into its structures and use the helpers described beyond.
> > > > + */
> > > >  struct res_counter {
> > > > -	/*
> > > > -	 * the current resource consumption level
> > > > -	 */
> > > >  	unsigned long long usage;
> > > > -	/*
> > > > -	 * the maximal value of the usage from the counter creation
> > > > -	 */
> > > >  	unsigned long long max_usage;
> > > > -	/*
> > > > -	 * the limit that usage cannot exceed
> > > > -	 */
> > > >  	unsigned long long limit;
> > > > -	/*
> > > > -	 * the number of unsuccessful attempts to consume the resource
> > > > -	 */
> > > >  	unsigned long long failcnt;
> > > > +	unsigned long long policy;
> > > > +	unsigned long long capacity;
> > > > +	unsigned long long timestamp;
> > > >  
> > > Andrea, sizeof(struct res_counter) is getting close to 128bytes. (maybe someone adds more)
> > > Then, could you check "unsigned long or unsigned int" is allowed or not, again ?
> > > 
> > > It's very bad if cacheline of spinlock is different from data field, in future.
> > 
> > Regarding the new attributes, policy can be surely an unsigned int or
> > even less (now only 1 bit is used!), maybe we can just add an unsigned
> > int flags, and encode also potential future informations there.
> > 
> > Moreover, are we sure we really need an unsigned long long for failcnt?
> >
> 
> No we don't. But having it helps the members align well on a 8 byte
> boundary. For all you know the compiler might do that anyway, unless
> we pack the structure.
> 
> Why does policy need to be unsigned long long? Can't it be a boolean
> for now? Token or leaky? We can consider unioning of some fields like
> soft_limit when added along with the proposed fields.

Adding an unsigned int flags to encode policy and other potential future
stuff seems much better. Also agreed by Kame.

Maybe the difference between a soft_limit and hard_limit can be also
encoded in the flags.

Moreover, max_usage is not used in ratelimited resources. And capacity
is not used in all the other cases (it has been introduced only for
token-bucket ratelimited resources).

I think we can easily union max_usage and capacity at least.

-Andrea
