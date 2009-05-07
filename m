Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbZEGITH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbZEGITH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 04:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbZEGISu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 04:18:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37731 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbZEGISt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 04:18:49 -0400
Date: Thu, 7 May 2009 10:17:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/3a] ptrace: add _ptrace_may_access()
Message-ID: <20090507081748.GB12285@elte.hu>
References: <20090505224729.GA965@redhat.com> <20090506080050.GF17457@elte.hu> <20090506203224.684C7FC39E@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506203224.684C7FC39E@magilla.sf.frob.com>
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


* Roland McGrath <roland@redhat.com> wrote:

> > Something like the patch below allows the reuse of the locked 
> > version of __ptrace_may_access and pushes the int->bool 
> > conversion into an inline.
> 
> I think it would be cleaner and safe/simple enough to invert the 
> public ptrace_may_access() to just return the int and invert the ! 
> on all the callers (all one in fs/proc/task_mmu.c and all four in 
> fs/proc/base.c).

hm, i considered that briefly and rejected the idea because 
something that says 'may' in its name is generally assumed to be a 
logic function-ish thing.

I.e. in such case: ptrace_may_access() or task_is_traced() people 
sub-consciously assume that 0 means "no", non-0 means "yes". So in 
that sense i liked the bool wrapper and preserved that in the 
inline.

We do have the retval==0-means-success convention in a number of 
APIs, but APIs that include a verb in their names assert some sort 
of property all have bool behavior.

(The underscore itself signals some special property - so there the 
deviation from the usual conventions isnt a big problem.)

This might sound like a nuance, but it really matters in the grand 
scheme of things. So IMHO inverting the logic is a step backwards - 
beyond the needless churn as well that it causes in various 
subsystems.

	Ingo
