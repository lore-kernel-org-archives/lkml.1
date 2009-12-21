Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZLUNBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZLUNBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 08:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZLUNBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 08:01:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38870 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbZLUNBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 08:01:23 -0500
Subject: Re: [patch 1/2] sched: Change the nohz ilb logic from pull to push
 model
From: Peter Zijlstra <peterz@infradead.org>
To: venkatesh.pallipadi@intel.com
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <1261397595.4314.72.camel@laptop>
References: <20091211012748.267627000@intel.com>
	 <20091211013056.305998000@intel.com>  <1261397595.4314.72.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Dec 2009 14:00:36 +0100
Message-ID: <1261400436.4314.125.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-21 at 13:13 +0100, Peter Zijlstra wrote:
> 
> > +     ret = atomic_cmpxchg(&nohz.first_pick_cpu, -1, cpu);
> > +     if (ret == -1 || ret == cpu) {
> > +             atomic_cmpxchg(&nohz.second_pick_cpu, cpu, -1);
> > +             if (rq->nr_running > 1)
> > +                     return 1;
> > +     } else {
> > +             ret = atomic_cmpxchg(&nohz.second_pick_cpu, -1, cpu);
> > +             if (ret == -1 || ret == cpu) {
> > +                     if (rq->nr_running)
> > +                             return 1;
> >               }
> >       }
> 
> Looked very funny, and took a while to understand why you're doing that,
> but yeah, I can't see a better way of doing it either. 

That is, the sanest way to write that is to do something like:

 weight(~nohz & online) == 1 && nr_running == 1

except that with the recent cpumask blowout that's a very expensive op.

