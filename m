Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbXJBU6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbXJBU6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 16:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbXJBU6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 16:58:03 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59224 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753718AbXJBU6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 16:58:01 -0400
Date: Tue, 2 Oct 2007 13:57:56 -0700
From: Paul Jackson <pj@sgi.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, nickpiggin@yahoo.com.au, menage@google.com,
       linux-kernel@vger.kernel.org, dino@in.ibm.com, cpw@sgi.com,
       mingo@elte.hu
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Message-Id: <20071002135756.6eca39e0.pj@sgi.com>
In-Reply-To: <20071002132214.330ae2ca.randy.dunlap@oracle.com>
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com>
	<20071002132214.330ae2ca.randy.dunlap@oracle.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review, Randy.  Good comments.

> > Acked-by: Paul Jackson <pj@sgi.com>
> 
> Are there some attributions missing, else S-O-B ?

Yup - I should have written this line as:

	Signed-off-by: Paul Jackson <pj@sgi.com>

> > +static int cpusets_overlap(struct cpuset *a, struct cpuset *b)
> 
> inline ?

It makes no difference to the code generated.  I tend to leave
out 'compiler optimization' hint words if I don't need them to
get the compiler to optimize.  In this case, of a single use
file static routine, the compiler inlines anyway.

> > +	q = NULL; csa = NULL; doms = NULL;
> 
> That's not kernel style.  Use either (Andrew would say the second one):
> 
> 	q = csa = doms = NULL;
> 
> or
> 	q = NULL;
> 	csa = NULL;
> 	doms = NULL;

You're right - and Andrew would be right as well, since the form:

	q = csa = doms = NULL;

generates a compiler warning, as not all three pointers are the
same type.

So three lines of code it must be.

> > +	if (q && !IS_ERR(q))
> > +		kfree(q);
> > +	if (csa)
> 
> Don't need the conditional: kfree(NULL) is OK.

Yup - you're right - about the 'csa' check.

However the if(q ...) check is needed, because I have another bug
here.  I allocated 'q' using kfifo_alloc(), so must free using
kfifo_free (or else leak the kfifo buffer memory.)  Calls to
kfifo_free() have to guard against NULL pointers before the call.

Thanks, Randy!

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
