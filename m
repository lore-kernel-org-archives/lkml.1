Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbYJ0Su7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbYJ0Su7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 14:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYJ0Sut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 14:50:49 -0400
Received: from ox1.aei.mpg.de ([194.94.224.6]:55627 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbYJ0Sus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 14:50:48 -0400
Date: Mon, 27 Oct 2008 19:51:19 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, tomas.winkler@intel.com, kernel@nn7.de,
       linux-wireless@vger.kernel.org
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
Message-ID: <20081027185119.GA4057@localhost.aei.mpg.de>
References: <20081027162054.GA4015@localhost.aei.mpg.de> <200810271839.39236.rjw@sisk.pl> <20081027175719.GA5759@localhost.aei.mpg.de> <200810271916.38079.rjw@sisk.pl> <20081027183648.GA4165@localhost.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027183648.GA4165@localhost.aei.mpg.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 27.Oct'08 at 19:36:48 +0100, Carlos R. Mafra wrote:
> On Mon 27.Oct'08 at 19:16:37 +0100, Rafael J. Wysocki wrote:
> > On Monday, 27 of October 2008, Carlos R. Mafra wrote:
> > > On Mon 27.Oct'08 at 18:39:38 +0100, Rafael J. Wysocki wrote:
> > > > On Monday, 27 of October 2008, Carlos R. Mafra wrote:
> > > > > Hi,
> > > > > 
> > > > > So I managed to bisect my suspend to RAM regression in 2.6.27-rc2
> > > > > to commit 3b7ee69d0caefbdb85a606a98bff841b8c63b97e ("mac80211: disassociate 
> > > > > when moving to new BSS") by Tomas Winkler (Cc:-ed).
> > > > > 
> > > > > Unfortunately it doesn't revert cleanly so I can't double check it.
> > > > 
> > > > Why are you saying it doesn't revert cleanly?  For me it does revert without
> > > > rejects from 2.6.28-rc2.
> > > 
> > > I get this
> > > 
> > > [mafra@localhost:linux-2.6]$ git checkout v2.6.28-rc2 -b s2ram
> > > Switched to a new branch "s2ram"
> > > [mafra@localhost:linux-2.6]$ git revert 3b7ee69d
> > > warning: too many files, skipping inexact rename detection
> > > Auto-merged net/mac80211/mlme.c
> > > CONFLICT (content): Merge conflict in net/mac80211/mlme.c
> > > Automatic revert failed.  After resolving the conflicts,
> > > mark the corrected paths with 'git add <paths>' or 'git rm <paths>' and commit the result.
> > > 
> > > I don't know what is happening here :-(
> > 
> > If you have quilt installed, you can do:
> > 
> > $ git show 3b7ee69d > suspicious.patch
> > $ quilt import -R suspicious.patch
> > $ quilt push
> > 
> > (that should work without rejects) and build the kernel.
> 
> I wanted to do it with git, but gave up after some time :-(
> 
> So I finally read the commit in 
> question 3b7ee69d0caefbdb85a606a98bff841b8c63b97e and applied
> the patch below, which reverts it up to the whitespace fixes.
> 
> And reverting it really made my brand new 2.6.28-rc2-something
> work again, regarding suspend to RAM.
> 
> So consider it confirmed that this commit is guilty here.

I double checked it.

Linus' tree v2.6.28-rc2-58-g1d63e72 does not work, whereas
with the patch below applied makes suspend to RAM work again.


> ---
>  net/mac80211/mlme.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 87665d7..1751ebb 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2396,10 +2396,6 @@ void ieee80211_sta_req_auth(struct ieee80211_sub_if_data *sdata,
>  	    (ifsta->flags & (IEEE80211_STA_SSID_SET |
>  			     IEEE80211_STA_AUTO_SSID_SEL))) {
>  
> -		if (ifsta->state == IEEE80211_STA_MLME_ASSOCIATED)
> -			ieee80211_set_disassoc(sdata, ifsta, true, true,
> -					       WLAN_REASON_DEAUTH_LEAVING);
> -
>  		set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
>  		queue_work(local->hw.workqueue, &ifsta->work);
>  	}
> -- 
> 1.6.0.rc2
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
