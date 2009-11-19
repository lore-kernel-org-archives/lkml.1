Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbZKSUC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbZKSUC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 15:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbZKSUC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 15:02:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47788 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbZKSUC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 15:02:26 -0500
Subject: Re: commit b00bc0b237055b breaking perf subsystem
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20091119115020.7bd8896b@infradead.org>
References: <20091119115020.7bd8896b@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Nov 2009 21:02:22 +0100
Message-ID: <1258660942.11284.107.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-19 at 11:50 -0800, Arjan van de Ven wrote:
> commit b00bc0b237055b4c45816325ee14f0bd83e6f590
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Mon Nov 2 13:01:56 2009 +0100
> 
>     uids: Prevent tear down race
> 
> has been bisected to break the perf system between -rc5 and -rc7;
> and reverting this patch in rc7 also fixes the issue.
> 
> now this patch is.... fun and seemingly unrelated to perf, so I
> am pretty sure something else is going on.
> 
> the symptom of the breakage is that a userland client of perf
> (in my case, powertop) does not get to see new events if there
> is only, say, one or two of them. The data_head pointer just does
> not get updated.
> 
> Based on the patch, I have a suspicion that this pointer gets updated
> from synchronize RCU context, and this patch just makes that happen
> more.
> 
> If that is the case, what we really need is a new ioctl to perf that
> will cause all pending buffer state to be flushed to the ring buffer,
> that applications using perf can then just always call before looking
> at the ring. As a concept, that sounds like a good idea to me anyway...
> 
> comments/suggestions/saying-I'm-full-of-sh*t ?

We should be updating the data_head pointer after every writen event
(with the exception of nested writes, where we delay publishing until
the last writer is done, so as to not expose incomplete data).

  perf_output_begin(); /* reserve space */
  perf_output_copy();  /* write bits to space */
  perf_output_end();   /* commit and publish */
    perf_output_unlock();
      /* complicated stuff to publish data_head */
      
Colour me puzzled on how this particular commit can have any effect on
data_head.

