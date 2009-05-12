Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbZELNfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbZELNfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 09:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbZELNfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 09:35:05 -0400
Received: from ozlabs.org ([203.10.76.45]:53839 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbZELNfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 09:35:03 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC PATCH 2/2] kernel/sched.c: VLA in middle of struct
Date: Tue, 12 May 2009 23:04:51 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Travis <travis@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       viro@zeniv.linux.org.uk, Andrew Morton <akpm@linux-foundation.org>,
       roland@redhat.com
References: <20090508184838.GA11157@havoc.gtf.org> <200905101819.41765.rusty@rustcorp.com.au> <20090510150954.GA21561@havoc.gtf.org>
In-Reply-To: <20090510150954.GA21561@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905122304.52395.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 12:39:54 am Jeff Garzik wrote:
> On Sun, May 10, 2009 at 06:19:40PM +0930, Rusty Russell wrote:
> > Yeah, it's kinda nasty.  Generally, sched_group is dynamically allocated,
> > so we just allocate sizeof(struct sched_group) + size of nr_cpu_ids bits.
> >
> > These ones are static, and it was easier to put this hack in than make
> > them dynamic.  There's nothing wrong with it, until we really want
> > NR_CPUS == bignum, or we want to get rid of NR_CPUS altogether for
> > CONFIG_CPUMASKS_OFFSTACK (which would be very clean, but not clearly
> > worthwhile).
>
> Nothing wrong with it, except
>
> - C99 only defines variable-length automatic arrays
> - VLA in the middle of a struct are difficult to optimize
> - gcc's VLA handling WILL change, as gcc docs state
> - other compilers -- and sparse -- puke all over VLAs, making
>   static analysis impossible for all code with this weirdism

Jeff, you seem confused.  In my copy of the standard, you'd know this is called 
a "flexible array member"; it's not a variable length array.  The only GCC 
specific issue I can find here is that you're not normally allowed to embed 
structs with them in another struct (according to the gcc docs; I can't 
actually find this clearly stated in the standard).

> > But more importantly, my comment is obviously unclear, since your patch
> > shows you didn't understand the purpose of the field: The cpus bitmap
> > *is* the sg-
> >
> > >cpumask[] array.
>
> I guess you missed the
> (1) "this patch is only intended to spark discussion",
> (2) a reference to the comment, and
> (3) "NOT-signed-off-by" portions of my email.

Terribly sorry, I was too polite.  Your patch was so broken it didn't make any 
sense.  At all.

Anyway, since [] is C99, I thought it preferable to [0] which is a gcc 
extension.  However, if C99 is really so braindead as to disallow this fairly 
standard trick, so I'm happy to go with the gcc extension.[1]

Thanks,
Rusty.
[1] Well, not happy.  But y'know...
