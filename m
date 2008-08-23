Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbYHWP4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbYHWP4c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 11:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYHWP4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 11:56:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47947 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbYHWP4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 11:56:21 -0400
Date: Sat, 23 Aug 2008 17:55:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Witbrodt <dawitbro@sbcglobal.net>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
       Bill Fink <billfink@mindspring.com>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user
	with the same regression
Message-ID: <20080823155529.GA27974@elte.hu>
References: <982729.41105.qm@web82107.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <982729.41105.qm@web82107.mail.mud.yahoo.com>
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


* David Witbrodt <dawitbro@sbcglobal.net> wrote:

>      for (;;) {
>          tmp = *p;
>          if (!tmp || tmp->start > end) {
> +insert:
>              new->sibling = tmp;
>              *p = new;
>              new->parent = root;
> @@ -164,7 +165,10 @@ static struct resource * __request_resource(struct resource *root, struct resour
>          p = &tmp->sibling;
>          if (tmp->end < start)
>              continue;
> -        return tmp;
> +        printk("ignoring resource conflict between %s/{%p..%p} and %s/{%p..%p}\n", new->name, 
> +               (void *)new->start, (void *)new->end, tmp->name, (void *)tmp->start, (void *)tmp->end);
> +        WARN_ON(1);
> +        goto insert;

sorry about that, my first patch was more broken than i thought (it will 
basically hang on _any_ box), please try the second patch.

Note how the above hack code does a stupid goto, and 'p' is updated for 
the next loop iteration already. The second version of the debug patch 
only updates 'p' in the 'continue' case and will hopefully get you much 
further into bootup!

	Ingo
