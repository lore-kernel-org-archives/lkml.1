Return-Path: <linux-kernel-owner+w=401wt.eu-S1759156AbXEaDTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759156AbXEaDTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 23:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756171AbXEaDS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 23:18:56 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:60015 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164AbXEaDSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 23:18:55 -0400
Date: Thu, 31 May 2007 08:56:57 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Peter Williams <pwil3058@bigpond.net.au>,
       Nick Piggin <nickpiggin@yahoo.com.au>, ckrm-tech@lists.sourceforge.net,
       Balbir Singh <balbir@in.ibm.com>, efault@gmx.de,
       linux-kernel@vger.kernel.org, tingy@cs.umass.edu,
       Kirill Korotaev <dev@sw.ru>, kernel@kolivas.org, tong.n.li@intel.com,
       containers@lists.osdl.org, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Guillaume Chazarain <guichaz@yahoo.fr>
Subject: Re: [ckrm-tech] [RFC] [PATCH 0/3] Add group fairness to CFS
Message-ID: <20070531032657.GA823@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070525074500.GD6157@in.ibm.com> <20070525082951.GA25280@elte.hu> <4656DF0C.9090306@sw.ru> <20070525153450.GA4679@in.ibm.com> <46570C70.4050209@sw.ru> <20070525180850.GA26884@in.ibm.com> <46577CA6.8000807@bigpond.net.au> <20070526154112.GA31925@holomorphy.com> <20070530171405.GA21062@in.ibm.com> <20070530201359.GD6909@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530201359.GD6909@holomorphy.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 01:13:59PM -0700, William Lee Irwin III wrote:
> On Wed, May 30, 2007 at 10:44:05PM +0530, Srivatsa Vaddagiri wrote:
> > Hmm ..so do you think this weight decomposition can be used to flatten
> > the tree all the way to a single level in case of cfs? That would mean we can 
> > achieve group fairness with single level scheduling in cfs ..I am
> > somewhat skeptical that we can achieve group fairness with a single
> > level rb-tree (and w/o substantial changes to pick_next_task logic in cfs
> > that is), but if it can be accomplished would definitely be a great win.
> 
> Yes, the hierarchy can be flattened completely and global task weights
> computed and used to achieve group fairness.

ok, lets say we are are considering a hierarchy of user->process->thread as 
below:

Users = {U1, U2, U3}

where process in a user are:

U1 = {P0, P1, P2, P3, P4}
U2 = {P5, P6}
U3 = {P7}

and where threads/tasks in a process are:

P0 = {T0, T1}
P1 = {T2}
P2 = {T3, T4, T5}
P3 = {T6}
P4 = {T8}
P5 = {T9, T10}
P6 = {T11}
P7 = {T14, T15, T16}


If we need to achieve group fairness given single-level hierarchy,
then tasks need to be spread out in rb-tree like something below?

	     U1         U2         U3     U1         U2        U3
	|---------|---------|---------|---------|---------|---------|--- // ---
       t0	 t1	   t2	     t3	       t4	 t5        t6

[ t0, t1 ..tN are equally spaced points in time. t1 = t0 + K, t2 = t1 + K .. ]

Viewed at the top hierarchy level (users) tasks are spread such that each user
gets "equal" execution over some interval (lets say b/n t0-t3).

When viewed at the next lower hierarchy level (processes), it should look like:

        |     U1    |    U2    |    U3    |     U1    |    U2    |    U3   |
	|	    |          |          |           |          |         |
	| P0  P1  P2| P5    P6 |    P7    | P3  P4 P0 | P5    P6 |    P7   |
	|---|---|---|----|-----|----------|---|---|---|----|-----|---------|-//-
	t0	   t1	      t2	 t3	t3'  t4	        t5        t6


[contd below ..]

        |     U1    |    U2    |    U3    |     U1    |    U2    |    U3   |
	|	    |          |          |           |          |         |
	| P1  P2  P3| P5    P6 |    P7    | P4  P0  P1| P5    P6 |    P7   |
  --//  |---|---|---|----|-----|----------|---|---|---|----|-----|---------|-//-
       t6	   t7	      t8	 t9	    t10	       t11       t12


The available bandwidth to a user is dividided "equally" between various 
processes of the user over some time (say between t0 - t3').

When viewed at the next lower hierarchy level (threads), it should look like:



        |     U1    |    U2    |    U3    |     U1    |    U2    |    U3    |
	|	    |          |          |           |          |          |
	| P0| P1| P2| P5 |  P6 |    P7    | P3| P4| P0| P5 |  P6 |    P7    |
        |   |   |   |    |     |    |     |   |   |   |    |     |    |     |  
	| T0| T2| T3| T9 | T11 | T14| T15 | T6| T8| T1| T10| T11 | T16| T14 |
        |---|---|---|----|-----|----|-----|---|---|---|----|-----|----|-----|-//
	t0	   t1	      t2	 t3	     t4	        t5         t6

(continuting below)

        |     U1    |    U2    |    U3    |     U1    |    U2    |    U3    |
	|	    |          |          |           |          |          |
	| P1| P2| P3| P5 |  P6 |    P7    | P4| P0| P1| P5 |  P6 |    P7    |
        |   |   |   |    |     |    |     |   |   |   |    |     |    |     |  
	| T2| T4| T6| T9 | T11 | T15| T16 | T8| T0|T2 | T10| T11 | T14| T14 |
   --// |---|---|---|----|-----|----|-----|---|---|---|----|-----|----|-----|-//
       t6	   t7	      t8	 t9	    t10	       t11        t12

Available bandwidth to a process is divided "equally" between threads of
the process.

Although I have been using "equally" everywhere above, it needs to take
into account relative importance of tasks/processes/users.

> The changes aren't to pick_next_task() but rather to the ->fair_key 
> computations.

Thats the $$ question I guess :) What computation of ->fair_key can we use
such that task execution sequence is (from the above example):

	T0, T2, T3, T9, T11, T14, T15, T6, T8, T1, T10, T11, T16, T14 ...

?

Of course, this ->fair_key computation should default to what it is
today when hierarchical res mgmt is disabled?

> In fact, I went a step beyond that.
> 
> 
> On Sat, May 26, 2007 at 08:41:12AM -0700, William Lee Irwin III wrote:
> >> In such a manner nice numbers obey the principle of least surprise.
> 
> The step beyond was to show how nice numbers can be done with all that
> hierarchical task grouping so they have global effects instead of
> effects limited to the scope of the narrowest grouping hierarchy
> containing the task. I had actually assumed the weighting and
> flattening bits were already in your plans from some other post you
> made and was building upon that.

I would definitely be willing to try out any experiments you think of,
esp those that allow the hierarchy to be flattened. atm fair_key
calculation (in the context of cfs) seem to be the biggest challenge to 
surmount for this to work.

-- 
Regards,
vatsa
