Return-Path: <linux-kernel-owner+w=401wt.eu-S1758998AbZBEKTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758998AbZBEKTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 05:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbZBEKTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 05:19:10 -0500
Received: from mail-ausfall.charite.de ([193.175.70.131]:50550 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996AbZBEKTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 05:19:08 -0500
Date: Thu, 5 Feb 2009 11:19:04 +0100
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: Federico Cuello <fedux@lugmen.org.ar>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Subject: Re: sync-Regression in 2.6.28.2?
Message-ID: <20090205101904.GJ23918@charite.de>
Mail-Followup-To: Federico Cuello <fedux@lugmen.org.ar>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
	linux-kernel@vger.kernel.org
References: <20090127093533.GB7037@charite.de> <200902031209.12615.nickpiggin@yahoo.com.au> <4988A034.20406@lugmen.org.ar> <200902041717.27320.nickpiggin@yahoo.com.au> <4989D0D4.80300@lugmen.org.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4989D0D4.80300@lugmen.org.ar>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Federico Cuello <fedux@lugmen.org.ar>:
> Nick Piggin wrote:
> > [...]
> > Thanks, could you reply-to-all when replying to retain ccs please?
> >
> > Common theme is ext4, which uses no_nrwrite_index_update, and I introduced
> > a bug in there which could possibly cause ext4 to go into a loop...
> >
> > Would it be possible if you can test the following patch?
> >   
> 
> I'll test it as soon as I get home.
> 
> Meanwhile, I think the new patch may be slightly wrong. If I understand
> correctly PageWriteback(page) is called before nr_to_write is tested for
> being > 0 and then decremented if true, but "done" is  not set to 1
> until the next iteration. So another call to PageWriteback(page) while
> take place and then "done" will be set to true (if wbc->sync_mode ==
> WB_SYNC_NONE).
> 
> If nr_to_write == 1 at the beginning of the loop then two pages will be
> written.
> 
> I think the test condition should something like:
> 
> if (--nr_to_write <= 0 && wbc->sync_mode == WB_SYNC_NONE) {
>     done = 1;
>     break;
> }
> 
> .
> .
> 
> > Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> > Acked-by: Nick Piggin <npiggin@suse.de>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >  mm/page-writeback.c |   21 +++++++++++++++------
> >  1 files changed, 15 insertions(+), 6 deletions(-)
> >
> > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > index b493db7..dc32dae 100644
> > --- a/mm/page-writeback.c
> > +++ b/mm/page-writeback.c
> > @@ -1051,13 +1051,22 @@ continue_unlock:
> >  				}
> >   			}
> >  
> > -			if (wbc->sync_mode == WB_SYNC_NONE) {
> > -				wbc->nr_to_write--;
> > -				if (wbc->nr_to_write <= 0) {
> > -					done = 1;
> > -					break;
> > -				}
> > +			if (nr_to_write > 0)
> > +				nr_to_write--;
> > +			else if (wbc->sync_mode == WB_SYNC_NONE) {
> > +				/*
> > +				 * We stop writing back only if we are not
> > +				 * doing integrity sync. In case of integrity
> > +				 * sync we have to keep going because someone
> > +				 * may be concurrently dirtying pages, and we
> > +				 * might have synced a lot of newly appeared
> > +				 * dirty pages, but have not synced all of the
> > +				 * old dirty pages.
> > +				 */
> > +				done = 1;
> > +				break;
> >  			}
> > +
> >  			if (wbc->nonblocking && bdi_write_congested(bdi)) {
> >  				wbc->encountered_congestion = 1;
> >  				done = 1;
> >   
> 
While I didn't test the patch, I can confirm that the problem is also
in 2.6.28.3

-- 
Ralf Hildebrandt                                Ralf.Hildebrandt@charite.de
Charite - Universitätsmedizin Berlin            Tel.  +49 (0)30-450 570-155
Geschäftsbereich IT | Abt. Netzwerk             Fax.  +49 (0)30-450 570-962
Hindenburgdamm 30 | 12200 Berlin
