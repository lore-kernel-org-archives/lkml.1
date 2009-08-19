Return-Path: <linux-kernel-owner+w=401wt.eu-S1751271AbZHSQEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751271AbZHSQEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbZHSQEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:04:41 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:56189 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbZHSQEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:04:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gWCnm8v481IqrnTA7/lDTjuD/iaeFDD1AK7E5OIhDMt3DZv8b6euWztZzcVCaYjeM7
         XdA1InLgnplXY0Og3zGA7gbadqIpZxRSjRn3aJ/6pAiohvEUEqzSiQZej5tAcfgu+e4d
         RqIHr1Rp0RsQVxXXhi0jQAwv20kFvwDAWKAHQ=
Date: Wed, 19 Aug 2009 18:04:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, James Morris <jmorris@namei.org>
Subject: Re: [PATCH 1/4] perf_counter: Default to higher paranoia level
Message-ID: <20090819160438.GC4972@nowhere>
References: <20090819091823.916851355@chello.nl> <20090819092023.728070630@chello.nl> <1250690853.8282.59.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250690853.8282.59.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 04:07:33PM +0200, Peter Zijlstra wrote:
> On Wed, 2009-08-19 at 11:18 +0200, Peter Zijlstra wrote:
> 
> > +static inline bool perf_paranoid_anon(void)
> > +{
> > +	return !capable(CAP_SYS_ADMIN) && sysctl_perf_counter_paranoid > 1;
> >  }
> >  
> >  static inline bool perf_paranoid_kernel(void)
> >  {
> > -	return sysctl_perf_counter_paranoid > 1;
> > +	return !capable(CAP_SYS_ADMIN) && sysctl_perf_counter_paranoid > 2;
> > +}
> 
> OK, this is buggy:
> 
>  - capable() uses current, which is unlikely to be counter->owner,
>  - but even security_real_capable(counter->owner, ...) wouldn't
>    work, since the ->capable() callback isn't NMI safe
>    (selinux takes locks and does allocations in that path).
> 
> This puts a severe strain on more complex anonymizers since its
> basically impossible to tell if counter->owner has permissions on
> current from NMI context.
> 
> I'll fix up this patch to pre-compute the perf_paranoid_anon_ip() per
> counter based on creation time state, unless somebody has a better idea.


Something I don't understand there: it's about wide per cpu profiling,
then the task that have been created before the counter can also be
profiled, then how is the creation time useful here?



> I could possibly only anonymize IRQ context (SoftIRQ context is
> difficult since in_softirq() means both in-softirq and
> softirq-disabled).


I don't understand why we need to set this paranoid level concerning
kernel RIPS.

