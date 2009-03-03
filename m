Return-Path: <linux-kernel-owner+w=401wt.eu-S1758647AbZCCEbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647AbZCCEbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 23:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbZCCEbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 23:31:11 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:50293 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945AbZCCEbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 23:31:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=q/YSa1v14jY46jxCK6p9OMIPLmv+us+W7M9StPmrQ1bSe1UoQv3MLdQnrP2cuZEvQe
         dl3hB7QL+eqUXxOMbIJZa6HcvdyanFeXVze/4c6jj5+Qyo/TZ3VNBDM/3wKPzALBGRe0
         RfbnAY+mwo1mS6XVVR8QCjamWjTOqc5ZXcElo=
MIME-Version: 1.0
In-Reply-To: <20090303034600.GA3757@hash.localnet>
References: <1235688271-22346-1-git-send-email-jirislaby@gmail.com>
	 <20090226230338.M86894@bobcopeland.com> <49A7236E.2020807@gmail.com>
	 <b6c5339f0902261528i7b581125k29927c3c5ac4fe4c@mail.gmail.com>
	 <49A726A7.6090809@gmail.com> <20090227022704.GA29850@hash.localnet>
	 <20090227023912.GF13456@tesla> <20090227030608.GA29974@hash.localnet>
	 <1235884912.9224.26.camel@mj> <20090303034600.GA3757@hash.localnet>
Date: Tue, 3 Mar 2009 06:31:05 +0200
Message-ID: <40f31dec0903022031l20ecc3dcx9ba7859cb24fa5ae@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: fix hw rate index condition
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Pavel Roskin <proski@gnu.org>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Jiri Slaby <jirislaby@gmail.com>,
       "ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/3 Bob Copeland <me@bobcopeland.com>:
> On Sun, Mar 01, 2009 at 12:21:52AM -0500, Pavel Roskin wrote:
>> I would prefer that we don't hide problems.
>>
>> If we don't know why we cannot get a valid rate, we should use WARN_ON
>> and find out why and when it happens.  I'm fine with using a bogus rate
>> with WARN_ON.
>
> So here is at least stage one of this, not yet the global "unknown rate"
> infrastructure, but hopefully it will allow us to track down the issue.
>
> It makes hw_to_driver_rix a little uglier, but oh well.  Thoughts?
>
> From: Bob Copeland <me@bobcopeland.com>
> Date: Mon, 2 Mar 2009 21:55:18 -0500
> Subject: [PATCH] ath5k: warn and correct rate for unknown hw rate indexes
>
> ath5k sets up a mapping table from the hardware rate index to
> the rate index used by mac80211; however, we have seen some
> received frames with incorrect rate indexes.  Such frames
> normally get dropped with a warning in __ieee80211_rx(), but the
> warning doesn't include enough context to track down the error.
>
> This patch adds a warning to hw_to_driver_rix for any lookups
> that result in a rate index of -1, then returns a valid rate so
> the frame can be processed.
>
> This also includes the bug fix suggested by Pavel Roskin, in which
> the mapping table is made signed, so rates initialized to -1 stay
> that way.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath5k/base.c |   15 ++++++++++++---
>  drivers/net/wireless/ath5k/base.h |    2 +-
>  2 files changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index f7c424d..8d4b11c 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -1100,9 +1100,18 @@ ath5k_mode_setup(struct ath5k_softc *sc)
>  static inline int
>  ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix)
>  {
> -       WARN(hw_rix < 0 || hw_rix >= AR5K_MAX_RATES,
> -                       "hw_rix out of bounds: %x\n", hw_rix);
> -       return sc->rate_idx[sc->curband->band][hw_rix];
> +       int rix;
> +
> +       /* return base rate on errors */
> +       if (WARN(hw_rix < 0 || hw_rix >= AR5K_MAX_RATES,
> +                       "hw_rix out of bounds: %x\n", hw_rix))
> +               return 0;
> +
> +       rix = sc->rate_idx[sc->curband->band][hw_rix];
> +       if (WARN(rix < 0, "invalid hw_rix: %x\n", hw_rix))
> +               rix = 0;
> +
> +       return rix;
>  }
>
>  /***************\
> diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
> index 20e0d14..8229561 100644
> --- a/drivers/net/wireless/ath5k/base.h
> +++ b/drivers/net/wireless/ath5k/base.h
> @@ -112,7 +112,7 @@ struct ath5k_softc {
>        struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
>        struct ieee80211_channel channels[ATH_CHAN_MAX];
>        struct ieee80211_rate   rates[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
> -       u8                      rate_idx[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
> +       s8                      rate_idx[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
>        enum nl80211_iftype     opmode;
>        struct ath5k_hw         *ah;            /* Atheros HW */
>
> --
> 1.6.0.6
>

Another thought...

According to docs the rate field is only valid if more flag is clear
(we have the last descriptor) and only if the receive ok flag is set
or both receive ok and phy error flags are cleared. We never do such
checks so we might actually try to process this field when we already
know we shouldn't...

Also the following rate codes are reserved (except XR codes that we
already know):

0x00
0x04 -> the short preamble flag
0x05
0x10 - 0x17
0x1f

and i don't believe i've ever seen them, so we can warn on them too
and print something like "Reserved rate code: %x", also it would be
nice to warn on XR rates (1,2,3,6,7) in case we want to debug this in
the future.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
