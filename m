Return-Path: <linux-kernel-owner+w=401wt.eu-S1756961AbZBUBTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961AbZBUBTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 20:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbZBUBS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 20:18:58 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37626 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742AbZBUBS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 20:18:57 -0500
Date: Fri, 20 Feb 2009 17:18:56 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: ltt-dev@lists.casi.polymtl.ca, bert.wesarg@googlemail.com,
       bob@watson.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH URCU formal] Add liveness checks to user-level RCU
	model.
Message-ID: <20090221011856.GA21167@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090220181835.GA4092@Krystal> <20090220192824.GP6960@linux.vnet.ibm.com> <20090220194621.GA7349@Krystal> <20090220200929.GR6960@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220200929.GR6960@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 12:09:29PM -0800, Paul E. McKenney wrote:
> On Fri, Feb 20, 2009 at 02:46:21PM -0500, Mathieu Desnoyers wrote:

[ . . . ]

> > I'll first get the translation of asserts into LTL formulaes, and try to
> > see what should be fixed in the model. I have noticed that we would need
> > to do this :
> > 
> > urcu_gp_ctr = (urcu_gp_ctr + RCU_GP_CTR_BIT) % (RCU_GP_CTR_BIT + 1);
> > 
> > Otherwise the overflow does not do what we expect (spin -f on the trail
> > told me that it was overflowing to 1, which is not exactly what we want
> > I guess). More to come on that side. When this will be settled, I'll dig
> > further.
> 
> Hmmm...  The two legal values for urcu_gp_ctr are 1 and 129, so isn't
> this in fact the desired behavior?  This is with your optimization that
> cuts a half-cycle from rcu_read_lock() by making the initial value of
> urcu_gp_ctr be 1 rather than 0.
> 
> One way of getting rid of the warning would be something like the
> following:
> 
> 	atomic {
> 		if
> 		:: urcu_gp_ctr == 1 -> urcu_gp_ctr = 129;
> 		:: urcu_gp_ctr == 129 -> urcu_gp_ctr = 1;
> 		fi;
> 	}
> 
> On converting the assert() to LTL, better you than me!  :-)

Perhaps I should explain myself here...

Promela usually handles asserts() much more efficiently than it does LTL
or hand-code "never" clauses.  One reason is that "never" clauses act as
a separate Promela process that runs one step interleaved between every
step from any other process.  This obviously increases the run time, but
more importantly blows up the state space.

In addition, adding additional assert()s to a Promela program is easy to
do and has predictable consequences.  Combining a pair of LTL statements
is another thing altogether.

Of course, it is entirely possible that I would appreciate LTL more if
I were to use it more heavily.  ;-)

							Thanx, Paul
