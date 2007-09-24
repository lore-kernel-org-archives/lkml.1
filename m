Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbXIXHfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbXIXHfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 03:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbXIXHfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 03:35:33 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:40340 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751756AbXIXHfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 03:35:33 -0400
Date: Mon, 24 Sep 2007 09:35:23 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Hugh Dickins <hugh@veritas.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       spamtrap@knobisoft.de
Subject: Re: 2.6.23-rc6-mm1 -- mkfs stuck in 'D'
Message-ID: <20070924093523.0fec7330@twins>
In-Reply-To: <390602872.13640@ustc.edu.cn>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<20070919164348.GC2519@shadowen.org>
	<Pine.LNX.4.64.0709192035370.14804@blonde.wat.veritas.com>
	<20070919224409.24baa75b@lappy>
	<Pine.LNX.4.64.0709201210470.13752@blonde.wat.veritas.com>
	<390426111.11400@ustc.edu.cn>
	<20070922151622.711178e2@lappy>
	<390510451.02278@ustc.edu.cn>
	<20070923150235.284b49bf@twins>
	<390602872.13640@ustc.edu.cn>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 11:01:10 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn>
wrote:

> > That is an interesting idea how about this:
> 
> It looks like a workaround, but it does solve the most important problem.
> And it is a good logic by itself.  So I'd vote for it.
> 
> The fundamental problem is that the per-bdi-writeback-completion based
> estimation is not accurate under light loads. The problem remains for
> a light-load sda when there is a heavy-load sdb. 

Well, sure, in that case sda would get to write out a lot of small
things. But in that case it would be fair wrt the other writers.

> One more workaround
> could be to grant bdi(s) a minimal bdi_thresh. 

Ah, no, that is no good. For if there were a lot of BDIs this might
happen:
  nr_bdis * min_thresh > dirty_limit.

> Or better to adjust the estimation logic?

Not sure what we can do here. The current thing is simple, fast and fair.

> > +		/*
> > +		 * break out early when:
> > +		 *  - we're below the bdi limit
> > +		 *  - we're below half the total limit
> > +		 *
> > +		 * we let the numbers exceed the strict bdi limit if the total
> > +		 * numbers are too low, this avoids (excessive) small writeouts.
> > +		 */
> > +		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh ||
> > +		    nr_reclaimable + nr_writeback < dirty_thresh / 2)
> >  			break;
> 
> This may be slightly better:
> 
> 		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
>                         break;
>                 /*
>                  * Throttle it only when the background writeback cannot catchup.
>                  */
>                 if (nr_reclaimable + nr_writeback <
>                                 (background_thresh + dirty_thresh) / 2)
> 			break;

Ah, indeed. Good idea.
