Return-Path: <linux-kernel-owner+w=401wt.eu-S1761706AbZDBVPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761706AbZDBVPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 17:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbZDBVO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 17:14:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56995 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbZDBVO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 17:14:57 -0400
Date: Thu, 2 Apr 2009 23:13:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Pirko <jpirko@redhat.com>, kosaki.motohiro@jp.fujitsu.com,
       oleg@redhat.com, linux-kernel@vger.kernel.org, hugh@veritas.com,
       linux-mm@kvack.org
Subject: Re: [PATCH for -mm] getrusage: fill ru_maxrss value
Message-ID: <20090402211336.GB4076@elte.hu>
References: <20081230201052.128B.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081231110816.5f80e265@psychotron.englab.brq.redhat.com> <20081231213705.1293.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090103175913.GA21180@redhat.com> <2f11576a0901031313u791d7dcex94b927cc56026e40@mail.gmail.com> <20090105163204.3ec9ff10@psychotron.englab.brq.redhat.com> <20090105141313.a4abd475.akpm@linux-foundation.org> <20090106104839.78eb07d1@psychotron.englab.brq.redhat.com> <20090402134738.43d87cb7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402134738.43d87cb7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> I have a note here that this patch needs acks, but I didn't note who
> from.
> 
> Someone ack it :)

looks good to me at a quick glance. A stupid technicality. There's 
repetitive patterns of:

> +	if (current->mm) {
> +		unsigned long hiwater_rss = get_mm_hiwater_rss(current->mm);
> +
> +		if (sig->maxrss < hiwater_rss)
> +			sig->maxrss = hiwater_rss;
> +	}

in about 3 separate places. Wouldnt a helper along the lines of:

	sig->maxrss = mm_hiwater_rss(current->mm, sig->maxrss);

be much more readable?

The helper could be something like:

 static inline unsigned long
 mm_hiwater_rss(struct mm_struct *mm, unsigned long maxrss)
 {
	return max(maxrss, mm ? get_mm_hiwater_rss(mm) : 0);
 }	

much nicer?

	Ingo
