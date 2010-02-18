Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653Ab0BRRIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 12:08:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51571 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758521Ab0BRRIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 12:08:39 -0500
Subject: Re: [PATCHv4 2/2] powerpc: implement arch_scale_smt_power for
 Power7
From: Peter Zijlstra <peterz@infradead.org>
To: Joel Schopp <jschopp@austin.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       ego@in.ibm.com
In-Reply-To: <4B7D6AAB.5080602@austin.ibm.com>
References: <1264017638.5717.121.camel@jschopp-laptop>
	 <1264017847.5717.132.camel@jschopp-laptop>
	 <1264548495.12239.56.camel@jschopp-laptop>
	 <1264720855.9660.22.camel@jschopp-laptop>
	 <1264721088.10385.1.camel@jschopp-laptop>
	 <1265403478.6089.41.camel@jschopp-laptop>
	 <1266142340.5273.418.camel@laptop>  <25851.1266445258@neuling.org>
	 <1266499023.26719.597.camel@laptop>  <4B7D6AAB.5080602@austin.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 18:08:04 +0100
Message-ID: <1266512884.26719.869.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-18 at 10:28 -0600, Joel Schopp wrote:
> > There's one fundamental assumption, and one weakness in the
> > implementation.
> >   
> I'm going to guess the weakness is that it doesn't adjust the cpu power 
> so tasks running in SMT1 mode actually get more than they account for?  

No, but you're right, if these SMTx modes are running at different
frequencies then yes that needs to happen as well.

The weakness is failing to do the right thing in the presence of a
'strategically' placed RT task.

Suppose:

Sibling0, Sibling1, Sibling2, Sibling3
idle      OTHER     OTHER     FIFO

it might not manage to migrate a task to 0 because it ends up selecting
3 as busiest. It doesn't at all influence RT placement, but it does look
at nr_running (which does include RT tasks)

> What's the assumption? 

That cpu_of(Sibling n) < cpu_of(Sibling n+1)

