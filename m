Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbYKBVxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbYKBVxA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 16:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbYKBVwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 16:52:51 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:3657 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbYKBVwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 16:52:50 -0500
Date: Sun, 2 Nov 2008 16:52:18 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, mickflemm@gmail.com, jirislaby@gmail.com,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org, michael+ath5k@stapelberg.de
Subject: Re: [ath5k-devel] [PATCH] ath5k: fix detection of jumbo frames
Message-ID: <20081102215218.GA6203@hash.localnet>
References: <1225652938-6244-1-git-send-email-me@bobcopeland.com> <43e72e890811021300o6bef49b0i515d0f72974cef00@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890811021300o6bef49b0i515d0f72974cef00@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2008 at 01:00:27PM -0800, Luis R. Rodriguez wrote:
> >, and, since
> > 63266a653589e1a237527479f10212ea77ce7844 "ath5k: rates cleanup", we do not fall back to the basic rate, such packets would trigger
> > the following WARN_ON:
> 
> So its slow because using rate 0 takes a while? If indeed you don't
> see a valid use for this rate I'd say to completely disallow it and
> use BUG_ON() on it.

Not sure I follow - these are incoming frames, which all had a status_0
of 0x1a40 (rs_more=0x1000 & length=0xa40).  So hw rate index was zero
on these for some reason, but in my testing the rate index of all other 
packets was something reasonable, e.g. 0x27.  

I looked over the rate tables compared to hal-legacy; I think what we
have now is correct, just the old ath5k code in hw_to_driver_rix would 
set rate=1 for any hw rate index that we didn't know about:

-       /* Something went wrong, fallback to basic rate for this band */
-       if ((mac80211_rix >= sc->curband->n_bitrates) ||
-               (mac80211_rix <= 0 ))
-               mac80211_rix = 1;

That's gone now, and that's why we didn't have the WARN_ON previously.

For TX-side, I think we don't use rate 0 already since Bruno's cleanup,
we should just use the hw_value fields in ath5k_rates which are all 
nonzero.

-- 
Bob Copeland %% www.bobcopeland.com

