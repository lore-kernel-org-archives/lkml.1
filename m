Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbYFFFDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbYFFFDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 01:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbYFFFDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 01:03:45 -0400
Received: from westnet.com ([216.187.52.2]:43864 "EHLO westnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbYFFFDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 01:03:44 -0400
Date: Fri, 6 Jun 2008 01:03:19 -0400 (EDT)
From: Greg Smith <gsmith@gregsmith.com>
X-X-Sender: gsmith@westnet.com
To: Mike Galbraith <efault@gmx.de>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] Re: PostgreSQL pgbench performance regression in 2.6.23+
In-Reply-To: <1211867950.5505.47.camel@marge.simson.net>
Message-ID: <Pine.GSO.4.64.0806060027290.8466@westnet.com>
References: <1211440207.5733.8.camel@marge.simson.net> 
 <20080522082814.GA4499@linux.vnet.ibm.com>  <1211447105.4823.7.camel@marge.simson.net>
  <1211452465.7606.8.camel@marge.simson.net>  <1211455553.4381.9.camel@marge.simson.net>
  <1211456659.29104.20.camel@twins>  <1211458176.5693.6.camel@marge.simson.net>
  <1211459081.29104.40.camel@twins>  <Pine.GSO.4.64.0805230232190.28654@westnet.com>
  <1211536814.5851.18.camel@marge.simson.net>  <20080523101000.GA13964@elte.hu>
  <1211537717.5851.22.camel@marge.simson.net>  <Pine.GSO.4.64.0805231907150.25273@westnet.com>
  <1211586407.4786.5.camel@marge.simson.net>  <Pine.GSO.4.64.0805260851510.24771@westnet.com>
 <1211867950.5505.47.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008, Mike Galbraith wrote:

> Care to give the below a whirl?  If fixes the over-enthusiastic affinity
> bug in a less restrictive way.  It doesn't attempt to addresss the needs
> of any particular load though, that needs more thought (tricky issue).
>
> With default features, I get the below...

Sorry I didn't get back to you until now, got distracted for a bit. 
Here's my table now updated with this patched version and with your 
numbers for comparision, since we have the same basic processor setup:

Clients	.22.19	.26.git	patch	Mike
1	7660	11043	11003	10122
2	17798	11452	16868	14360
3	29612	13231	20381	17049
4	25584	13053	22222	18749
6	25295	12263	23546	24913
8	24344	11748	23895	27976
10	23963	11612	22492	29347
15	23026	11414	21896	29157
20	22549	11332	21015	28392
30	22074	10743	18411	26590
40	21495	10406	17982	24422
50	20051	10534	17009	23306

So this is a huge win for this patch compared with the stock 2.6.26.git 
(I'm still using the daily snapshot from 2008-05-26) and a nice 
improvement over the earlier, smaller patches I tested in this thread 
(which peaked at 19537 for 10 clients for me with default features, vs. a 
peak of 23895 @ 8 here).

I think I might not be testing exactly the same thing you did, though, 
because the pattern doesn't match.  I think that my Q6600 system runs a 
little bit faster than yours, which is the case for small numbers of 
clients here.  But once we get above 8 clients your setup is way faster, 
with the difference at 15 clients being the largest.  Were you perhaps 
using batch mode when you generated these results?  Only thing I could 
think of that would produce this pattern.  If it's not something simple 
like that, I may have to dig into whether there was some change in the git 
snapshot between what you tested and what I did.

Regardless, clearly your patch reduces the regression with the default 
parameters to a mild one instead of the gigantic one we started with. 
Considering how generally incompatible this benchmark is with this 
scheduler, and that there are clear workarounds (feature disabling) I can 
document in PostgreSQL land to "fix" the problem defined for me now, I'd 
be happy if all that came from this investigation was this change.  I'd 
hope that being strengthened against this workload improves the 
scheduler's robustness for other tasks of this type, which I'm sure there 
are more of than just pgbench.

You get my vote for moving toward committing it+backport even if 
the improvement is only what I saw in my tests.  If I can figure out how 
to get closer to the results you got, all the better.

--
* Greg Smith gsmith@gregsmith.com http://www.gregsmith.com Baltimore, MD
