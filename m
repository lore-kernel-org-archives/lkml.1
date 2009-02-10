Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111AbZBJAfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbZBJAfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 19:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbZBJAe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 19:34:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbZBJAez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 19:34:55 -0500
Date: Tue, 10 Feb 2009 01:34:52 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Federico Cuello <fedux@lugmen.org.ar>, linux-kernel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: [PATCH] write-back: fix break condition
Message-ID: <20090210003452.GA26143@wotan.suse.de>
References: <1233977610-8919-1-git-send-email-fedux@lugmen.org.ar> <20090209152140.aa3f50aa.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209152140.aa3f50aa.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 03:21:40PM -0800, Andrew Morton wrote:
> 
> Thanks, but please do cc the people who were involved with a patch when
> you find a problem with it!
> 
> On Sat,  7 Feb 2009 01:33:30 -0200
> Federico Cuello <fedux@lugmen.org.ar> wrote:
> 
> > Commit 673353723e7a6550625fb719059c5f31cfaecd18 fixed nr_to_write
> > counter, but didn't set the break condition properly.
> 
> It's actually commit dcf6a79dda5cc2a2bec183e50d829030c0972aaa
> ("write-back: fix nr_to_write counter").
> 
> > If nr_to_write == 0 after being decremented it will loop one more time
> > before setting done = 1 and breaking the loop.
> 
> We prefer that patches include the author's Signed-off-by:, as per
> Documentation/SubmittingPatches, please.
> 
> > 
> > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > index bb5fa2b..9e2ae50 100644
> > --- a/mm/page-writeback.c
> > +++ b/mm/page-writeback.c
> > @@ -981,20 +981,21 @@ continue_unlock:
> >  				}
> >   			}
> >  
> > -			if (nr_to_write > 0)
> > +			if (nr_to_write > 0) {
> >  				nr_to_write--;
> > -			else if (wbc->sync_mode == WB_SYNC_NONE) {
> > -				/*
> > -				 * We stop writing back only if we are not
> > -				 * doing integrity sync. In case of integrity
> > -				 * sync we have to keep going because someone
> > -				 * may be concurrently dirtying pages, and we
> > -				 * might have synced a lot of newly appeared
> > -				 * dirty pages, but have not synced all of the
> > -				 * old dirty pages.
> > -				 */
> > -				done = 1;
> > -				break;
> > +				if (nr_to_write == 0 && wbc->sync_mode == WB_SYNC_NONE) {
> > +					/*
> > +					 * We stop writing back only if we are not
> > +					 * doing integrity sync. In case of integrity
> > +					 * sync we have to keep going because someone
> > +					 * may be concurrently dirtying pages, and we
> > +					 * might have synced a lot of newly appeared
> > +					 * dirty pages, but have not synced all of the
> > +					 * old dirty pages.
> > +					 */
> > +					done = 1;
> > +					break;
> > +				}
> >  			}
> >  
> >  			if (wbc->nonblocking && bdi_write_congested(bdi)) {
> 
> Artem, Nick, please check?

Yes, this looks OK by me.

Acked-by: Nick Piggin <npiggin@suse.de>

