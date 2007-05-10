Return-Path: <linux-kernel-owner+w=401wt.eu-S1759475AbXEJJrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475AbXEJJrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 05:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbXEJJrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 05:47:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335AbXEJJrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 05:47:10 -0400
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 10 May 2007 19:46:38 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17986.59902.831796.721280@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 002 of 2] md: Improve the is_mddev_idle test
In-Reply-To: message from Andrew Morton on Thursday May 10
References: <20070510161940.20204.patches@notabene>
	<1070510062231.20403@suse.de>
	<20070510003304.c5fc35d2.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday May 10, akpm@linux-foundation.org wrote:
> On Thu, 10 May 2007 16:22:31 +1000 NeilBrown <neilb@suse.de> wrote:
> 
> > The test currently looks for any (non-fuzz) difference, either
> > positive or negative.  This clearly is not needed.  Any non-sync
> > activity will cause the total sectors to grow faster than the sync_io
> > count (never slower) so we only need to look for a positive differences.
> > 
> > ...
> >
> > --- .prev/drivers/md/md.c	2007-05-10 15:51:54.000000000 +1000
> > +++ ./drivers/md/md.c	2007-05-10 16:05:10.000000000 +1000
> > @@ -5095,7 +5095,7 @@ static int is_mddev_idle(mddev_t *mddev)
> >  		 *
> >  		 * Note: the following is an unsigned comparison.
> >  		 */
> > -		if ((curr_events - rdev->last_events + 4096) > 8192) {
> > +		if ((long)curr_events - (long)rdev->last_events > 4096) {
> >  			rdev->last_events = curr_events;
> >  			idle = 0;
> 
> In which case would unsigned counters be more appropriate?

I guess.....

It is really the comparison that I want to be signed, I don't much
care about the counted - they are expected to wrap (though they might
not).
So maybe I really want

     if ((signed long)(curr_events - rdev->last_events) > 4096) {

to make it clear...
But people expect number to be signed by default, so that probably
isn't necessary.

Yeah, I'll make them signed one day.

Thanks,
NeilBrown
