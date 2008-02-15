Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbYBOVxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbYBOVxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbYBOVxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:53:35 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:35923 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbYBOVxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:53:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wCEfzYLaRFG9rcwCvtyQJFYNgn0DEJEQvB4zibugFqQB7RMxRaeZutmEoDpidE2w44B8o3AO6KJM6s56TJIZTj8owFh8/WI8rsmFH/xbqDlO5+R6BEt0k6G3Bi78siWbUpsnQmPO/Ms52EowVWCXGZYC8yUIN4wze2a6RcE1Bzo=
Message-ID: <40f31dec0802151353l2d03fdaam23d4f731a6c7bddc@mail.gmail.com>
Date: Fri, 15 Feb 2008 23:53:33 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] WDEV: ath5k, test single chip before reset
Cc: linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1203107827-27632-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203107827-27632-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/2/15, Jiri Slaby <jirislaby@gmail.com>:
> Move ath5k_hw_nic_wakeup after ah_single_chip being set, because we
>  test the value in there and decides whether reset or not.
>
>  Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>  Cc: Nick Kossifidis <mickflemm@gmail.com>
>  Cc: Luis R. Rodriguez <mcgrof@gmail.com>
>  ---
>   drivers/net/wireless/ath5k/hw.c |   21 ++++++++++-----------
>   1 files changed, 10 insertions(+), 11 deletions(-)
>
>  diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
>  index 3a4bf40..9cdd27f 100644
>  --- a/drivers/net/wireless/ath5k/hw.c
>  +++ b/drivers/net/wireless/ath5k/hw.c
>  @@ -181,11 +181,6 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
>         else if (ah->ah_version <= AR5K_AR5211)
>                 ah->ah_proc_rx_desc = ath5k_hw_proc_old_rx_status;
>
>  -       /* Bring device out of sleep and reset it's units */
>  -       ret = ath5k_hw_nic_wakeup(ah, AR5K_INIT_MODE, true);
>  -       if (ret)
>  -               goto err_free;
>  -
>         /* Get MAC, PHY and RADIO revisions */
>         srev = ath5k_hw_reg_read(ah, AR5K_SREV);
>         ah->ah_mac_srev = srev;
>  @@ -210,12 +205,13 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
>         }
>
>         /* Identify single chip solutions */
>  -       if((srev <= AR5K_SREV_VER_AR5414) &&
>  -       (srev >= AR5K_SREV_VER_AR2424)) {
>  -               ah->ah_single_chip = true;
>  -       } else {
>  -               ah->ah_single_chip = false;
>  -       }
>  +       ah->ah_single_chip = srev >= AR5K_SREV_VER_AR2424 &&
>  +                       srev <= AR5K_SREV_VER_AR5414;
>  +
>  +       /* Bring device out of sleep and reset it's units */
>  +       ret = ath5k_hw_nic_wakeup(ah, AR5K_INIT_MODE, true);
>  +       if (ret)
>  +               goto err_free;
>
>         /* Single chip radio */
>         if (ah->ah_radio_2ghz_revision == ah->ah_radio_5ghz_revision)
>

NACK, single chip flag is going out since only needed check is for
5424/2424 during nic_wakeup, 5413/2413 behave like the rest
5211/5212-combatible cards.

Sorry for delaying the relevant patches, i'm working with the 2413
card i got from Mike to make it work and it'll take some time (not as
easy as i thought, i probably miss something)...


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
