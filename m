Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbXIXIMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbXIXIMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 04:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbXIXIMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 04:12:14 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:37206 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752888AbXIXIMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 04:12:13 -0400
Message-ID: <390621530.21855@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Mon, 24 Sep 2007 16:12:07 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hugh@veritas.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       spamtrap@knobisoft.de
Subject: Re: 2.6.23-rc6-mm1 -- mkfs stuck in 'D'
Message-ID: <20070924081207.GA2266@mail.ustc.edu.cn>
References: <20070919164348.GC2519@shadowen.org> <Pine.LNX.4.64.0709192035370.14804@blonde.wat.veritas.com> <20070919224409.24baa75b@lappy> <Pine.LNX.4.64.0709201210470.13752@blonde.wat.veritas.com> <390426111.11400@ustc.edu.cn> <20070922151622.711178e2@lappy> <390510451.02278@ustc.edu.cn> <20070923150235.284b49bf@twins> <390602872.13640@ustc.edu.cn> <20070924093523.0fec7330@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924093523.0fec7330@twins>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 09:35:23AM +0200, Peter Zijlstra wrote:
> On Mon, 24 Sep 2007 11:01:10 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn>
> wrote:
> 
> > > That is an interesting idea how about this:
> > 
> > It looks like a workaround, but it does solve the most important problem.
> > And it is a good logic by itself.  So I'd vote for it.
> > 
> > The fundamental problem is that the per-bdi-writeback-completion based
> > estimation is not accurate under light loads. The problem remains for
> > a light-load sda when there is a heavy-load sdb. 
> 
> Well, sure, in that case sda would get to write out a lot of small
> things. But in that case it would be fair wrt the other writers.

Hmm, I cannot agree it to be fair - but pretty acceptable ;-)
Your patch already brings great improvements in the multi-bdi case.

> > One more workaround
> > could be to grant bdi(s) a minimal bdi_thresh. 
> 
> Ah, no, that is no good. For if there were a lot of BDIs this might
> happen:
>   nr_bdis * min_thresh > dirty_limit.

Sure it is in the extreme case. However the limit could be ensured
if we really want(which I'm really not sure;-) it:

        if (nr_reclaimable + nr_writeback < dirty_thresh &&
                bdi_nr_reclaimable + bdi_nr_writeback <= bdi_min_thresh)
                break;

> > Or better to adjust the estimation logic?
> 
> Not sure what we can do here. The current thing is simple, fast and fair.

Agreed.

> > > +		/*
> > > +		 * break out early when:
> > > +		 *  - we're below the bdi limit
> > > +		 *  - we're below half the total limit
> > > +		 *
> > > +		 * we let the numbers exceed the strict bdi limit if the total
> > > +		 * numbers are too low, this avoids (excessive) small writeouts.
> > > +		 */
> > > +		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh ||
> > > +		    nr_reclaimable + nr_writeback < dirty_thresh / 2)
> > >  			break;
> > 
> > This may be slightly better:
> > 
> > 		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
> >                         break;
> >                 /*
> >                  * Throttle it only when the background writeback cannot catchup.
> >                  */
> >                 if (nr_reclaimable + nr_writeback <
> >                                 (background_thresh + dirty_thresh) / 2)
> > 			break;
> 
> Ah, indeed. Good idea.

Thank you :-)

