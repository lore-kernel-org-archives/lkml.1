Return-Path: <linux-kernel-owner+w=401wt.eu-S1758525AbXENTTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525AbXENTTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbXENTSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:18:55 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754761AbXENTSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:18:54 -0400
Date: Mon, 14 May 2007 12:18:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, randy.dunlap@oracle.com, paulus@samba.org,
       benh@kernel.crashing.org, David Miller <davem@davemloft.net>,
       Andi Kleen <ak@suse.de>
Subject: Re: [patch] Let smp_call_function_single return -EBUSY.
Message-Id: <20070514121818.00dfc679.akpm@linux-foundation.org>
In-Reply-To: <20070514121137.ddcc3f5a.akpm@linux-foundation.org>
References: <20070514092317.GB8968@osiris.boeblingen.de.ibm.com>
	<20070514121137.ddcc3f5a.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 12:11:37 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > This of course raises another question: it is not clear in which context
> > the smp_call_function* functions are supposed to be called. Should it be
> > with preemption disabled or is preemption enabled allowed as well?
> > If calling with preemption enabled is allowed then the powerpc implementation
> > is broken, since smp_processor_id() as well as num_online_cpus() may change
> > while they are accessed.
> 
> These are all excellent questions.  And important ones.

erk, I see your point.  If a caller is calling this with preemption enabled
then the current thread might at any time migrate onto the target CPU,
causing the smp_call_function_single() attempt to fail.  So the effects of
that call are basically a random crapshoot.

Often but not always, any code which is hanging onto a variable called
"cpu" while preemption enabled is buggy.

So yes, I'd say that from a sanity-of-implementation POV and for general
defensiveness, we should require that the called of
smp_call_function_single() has disabled preemption.

What a crock.
