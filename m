Return-Path: <linux-kernel-owner+w=401wt.eu-S1752015AbYL2O47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbYL2O47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 09:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbYL2O4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 09:56:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41066 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbYL2O4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 09:56:50 -0500
Date: Mon, 29 Dec 2008 15:56:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] RCU: Move some definitions to minimal headers.
Message-ID: <20081229145630.GB16205@elte.hu>
References: <cover.1230499486.git.eduard.munteanu@linux360.ro> <01504e3763e57759f34045051e86cb35c17b43b5.1230499486.git.eduard.munteanu@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01504e3763e57759f34045051e86cb35c17b43b5.1230499486.git.eduard.munteanu@linux360.ro>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:

> linux/rcupdate.h used to include SLAB headers, which got in the way of 
> switching kmemtrace to use tracepoints instead of markers. The circular 
> header inclusion pattern that appeared was making it impossible to use 
> tracepoints in SLAB allocator inlines.
> 
> This moves some header code into separate files. As an added bonus, 
> preprocessing is faster if care is taken to use these minimal headers, 
> since no effort is spent on including SLAB headers.
> 
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> ---
>  include/linux/rcuclassic.h     |   40 +--------
>  include/linux/rcuclassic_min.h |   77 +++++++++++++++
>  include/linux/rcupdate.h       |  160 +-------------------------------
>  include/linux/rcupdate_min.h   |  205 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/rcupreempt.h     |   32 +------
>  include/linux/rcupreempt_min.h |   68 +++++++++++++
>  6 files changed, 353 insertions(+), 229 deletions(-)
>  create mode 100644 include/linux/rcuclassic_min.h
>  create mode 100644 include/linux/rcupdate_min.h
>  create mode 100644 include/linux/rcupreempt_min.h

ok, i like the idea - i'm just not sure this is the best approach. If we 
want to do a splitup, it should be along the lines of spinlock.h and 
spinlock_types.h.

The principle there is that the type declarations and inline function 
definitions kept separate. The 'type' headers are lightweight with minimal 
dependencies - the 'inline function' headers are more heavyweight.

For RCU ... cannot we get away much simpler, by removing the headers from 
rcupdate.h that cause the SLAB dependency hell? Does rcupdate.h really 
need to include all of:

 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/threads.h>
 #include <linux/percpu.h>
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 #include <linux/lockdep.h>
 #include <linux/completion.h>

AFAICS it should be able to get away with spinlock_types.h and i'm not 
sure it needs cache.h. The other headers are 'data type' headers mostly.

Which one is causing the trouble for you - cache.h ? If you do a patch 
that removes that trouble include file i can make wide build coverage 
tests to make sure it's OK to remove it.

but rcu_types.h would be nice to have too - i'm just not sure it's really 
what you need. (you seem to need certain RCU functions too, right?)

	Ingo
