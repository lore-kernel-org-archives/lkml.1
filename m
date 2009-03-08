Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbZCHTUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbZCHTUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 15:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbZCHTUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 15:20:25 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57122 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbZCHTUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 15:20:25 -0400
Date: Sun, 8 Mar 2009 12:20:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, manfred@colorfullife.com,
       Nadia.Derbey@bull.net, miltonm@austin.ibm.com,
       akpm@linux-foundation.org, peterz@infradead.org,
       lnxninja@linux.vnet.ibm.com, efault@gmx.de, riel@redhat.com
Subject: Re: [PATCH] make idr_remove_all() do removal -before- free_layer()
Message-ID: <20090308192024.GQ10625@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090307222511.GA10727@linux.vnet.ibm.com> <20090308153336.GA19658@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090308153336.GA19658@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 08, 2009 at 04:33:36PM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > The following patch fixes a problem in the IDR system, where 
> > an idr_remove_all() hands a data element to call_rcu() (via 
> > free_layer()) before making that data element inaccessible to 
> > new readers.  This is very bad, and results in readers still 
> > having a reference to this data element at the end of the 
> > grace period.  Tests on large machines that concurrently map 
> > and unmap user-space memory within the same multithreaded 
> > process result in crashes within about five minutes.  Applying 
> > this patch increases the kernel's longevity to the 
> > three-to-eight-hour range.
> > 
> > There appear to be other similar problems in 
> > idr_get_empty_slot() and sub_remove(), but I fixed the easy 
> > one in idr_remove_all() first.  It is therefore no surprise 
> > that failures still occur.
> > 
> > (Yes, and I did look at the relevant patch last year without 
> > spotting this one.  Goes to show the value of testing as well 
> > as code review, I guess...)
> > 
> > Nadia, Manfred, any thoughts?
> > 
> > Located-by: Milton Miller II <miltonm@austin.ibm.com>
> > Tested-by: Milton Miller II <miltonm@austin.ibm.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Hm, looks like something we really want to see fixed in 
> 2.6.29-final, right?

This was located in real testing, so I agree that it is pretty high
priority.  So this patch should go into 2.6.29.

The priority of the remaining yet-as-unknown fixes depends on their
complexity and risk.

							Thanx, Paul
