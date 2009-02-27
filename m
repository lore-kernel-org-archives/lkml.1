Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbZB0CkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbZB0CkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 21:40:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZB0CkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 21:40:04 -0500
Received: from mail.atheros.com ([12.36.123.2]:26029 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbZB0CkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 21:40:03 -0500
Date: Thu, 26 Feb 2009 18:39:12 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
CC: Jiri Slaby <jirislaby@gmail.com>, "proski@gnu.org" <proski@gnu.org>,
       "ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: fix hw rate index condition
Message-ID: <20090227023912.GF13456@tesla>
References: <1235688271-22346-1-git-send-email-jirislaby@gmail.com> <20090226230338.M86894@bobcopeland.com> <49A7236E.2020807@gmail.com> <b6c5339f0902261528i7b581125k29927c3c5ac4fe4c@mail.gmail.com> <49A726A7.6090809@gmail.com> <20090227022704.GA29850@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090227022704.GA29850@hash.localnet>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 06:27:04PM -0800, Bob Copeland wrote:
> On Fri, Feb 27, 2009 at 12:32:55AM +0100, Jiri Slaby wrote:
> > On 27.2.2009 00:28, Bob Copeland wrote:
> >> hw_to_driver_rix() returns sc->rate_idx[x][y] as an int, and that
> >> array is initialized to (u8)-1 for invalid rates.  So, it can
> >> return 255 if the hardware rate index (y) is bad, then the check
> >> "rxs.rate_idx>= 0" would always be true, right?  If it's not a
> >> real bug yet, it likely will be one day :)
> >
> > Ah, yes, it really is a bug(tm), care to post a fix?
> 
> Actually, I remembered in the dark recesses of my moldering brain
> that someone had a lost patch for this a while ago, so I searched
> the archives.  Pavel, ok to add your s-o-b?
> 
> From: Pavel Roskin <proski@gnu.org>
> Subject: [PATCH] ath5k: use signed elements for rate index table
> 
> A lookup table is used to convert from hardware rate indexes back
> to driver-based rate indexes.  For unknown hardware rates, we
> initialize these values to -1, but since the array elements are of
> type u8, they will be in the range 0-255.  This can cause array
> overruns because subsequent sanity checks only check for negative
> values.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath5k/base.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
> index 20e0d14..8229561 100644
> --- a/drivers/net/wireless/ath5k/base.h
> +++ b/drivers/net/wireless/ath5k/base.h
> @@ -112,7 +112,7 @@ struct ath5k_softc {
>         struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
>         struct ieee80211_channel channels[ATH_CHAN_MAX];
>         struct ieee80211_rate   rates[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
> -       u8                      rate_idx[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
> +       s8                      rate_idx[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];

Might be worth adding a note why this is the case. Can't we simply avoid
this by checking earlier for the error or simply assigning it an actual
default _good_ hw rate value?

  Luis
