Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbYCBPMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbYCBPMJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 10:12:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbYCBPL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 10:11:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:27297 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbYCBPL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 10:11:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V5fDoTPTS+66HIYYJYiXeAu9jHPz+0yyybvVh9sV3nK1TKENyGdRf3gQwmzcOZVS7nDwujliP1p7e8J9YlUlfxWdgZ9I9VXOG+CWJqs+a9Z5o9To03Rx27u8/es/gBtqJcCWE3Gj5UhRke5wNeHYwaO93rXjCtRChi7sqRWgRy4=
Message-ID: <c6b1100b0803020711m52bcbba3re1b673e734ef629a@mail.gmail.com>
Date: Sun, 2 Mar 2008 15:11:54 +0000
From: "Chris Clayton" <chris2553@googlemail.com>
To: "Stefano Brivio" <stefano.brivio@polimi.it>
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Cc: "John W. Linville" <linville@tuxdriver.com>, ivdoorn@gmail.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       johannes@sipsolutions.net, "Mattias Nissler" <mattias.nissler@gmx.de>,
       "Mike Kelly" <pioto@pioto.org>
In-Reply-To: <20080302113310.7acbe9b3@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com>
	 <200802261911.39577.chris2553@googlemail.com>
	 <20080226194838.GD3013@tuxdriver.com>
	 <c6b1100b0802261313v12fb9cd5j6501e80f6d071019@mail.gmail.com>
	 <20080226223814.4ef2b435@morte>
	 <c6b1100b0802261436i7c5a4136j753501933037187@mail.gmail.com>
	 <20080227082642.218b8014@morte> <20080227155111.GB3078@tuxdriver.com>
	 <20080227172546.GD3078@tuxdriver.com> <20080302113310.7acbe9b3@morte>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2008, Stefano Brivio <stefano.brivio@polimi.it> wrote:
> On Wed, 27 Feb 2008 12:25:46 -0500
>  "John W. Linville" <linville@tuxdriver.com> wrote:
>
>  > That might be easier said than done.  It looks like that patch depends
>  > on the big cfg80211 API change queued for 2.6.26.
>  >
>  > Stefano offered to rebase that on 2.6.25.  Stefano, could you post
>  > that as part of this thread?
>
>
> Sorry for the delay. This is based on 2.6.25-rc3. Please test.
>

I've tested this with the pid algorithm selected and my wireless
network connection is reliable. In a loop, I repeatedly ftp'd a kernel
source tarball from another box on my network for 40 minutes with no
failure, whilst at the same time, pinging my gateway. Without the
patch, that activity would have led to network failure in seconds. The
tests were with the patch applied to 2.6.25-rc3-git3, so that Ivo's
rt2x00 patches for 2.6.25 are also applied.

Thanks to everyone who has helped fix this.

>  ---
>
>  Merge rate_control_pid_shift_adjust() to rate_control_pid_adjust_rate()
>  in order to make the learning algorithm aware of constraints on rates. Also
>  add some comments and rename variables.
>
>  This fixes a bug which prevented 802.11b/g non-AP STAs from working with
>  802.11b only AP STAs.
>
>  Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

Tested-by: Chris Clayton <chris2553@googlemail.com>

>  ---
>  Index: linux-2.6.24/net/mac80211/rc80211_pid_algo.c
>  ===================================================================
>  --- linux-2.6.24.orig/net/mac80211/rc80211_pid_algo.c
>  +++ linux-2.6.24/net/mac80211/rc80211_pid_algo.c
>  @@ -2,7 +2,7 @@
>   * Copyright 2002-2005, Instant802 Networks, Inc.
>   * Copyright 2005, Devicescape Software, Inc.
>   * Copyright 2007, Mattias Nissler <mattias.nissler@gmx.de>
>  - * Copyright 2007, Stefano Brivio <stefano.brivio@polimi.it>
>  + * Copyright 2007-2008, Stefano Brivio <stefano.brivio@polimi.it>
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
>  @@ -63,72 +63,66 @@
>   * RC_PID_ARITH_SHIFT.
>   */
>
>  -
>  -/* Shift the adjustment so that we won't switch to a lower rate if it exhibited
>  - * a worse failed frames behaviour and we'll choose the highest rate whose
>  - * failed frames behaviour is not worse than the one of the original rate
>  - * target. While at it, check that the adjustment is within the ranges. Then,
>  - * provide the new rate index. */
>  -static int rate_control_pid_shift_adjust(struct rc_pid_rateinfo *r,
>  -                                        int adj, int cur, int l)
>  -{
>  -       int i, j, k, tmp;
>  -
>  -       j = r[cur].rev_index;
>  -       i = j + adj;
>  -
>  -       if (i < 0)
>  -               return r[0].index;
>  -       if (i >= l - 1)
>  -               return r[l - 1].index;
>  -
>  -       tmp = i;
>  -
>  -       if (adj < 0) {
>  -               for (k = j; k >= i; k--)
>  -                       if (r[k].diff <= r[j].diff)
>  -                               tmp = k;
>  -       } else {
>  -               for (k = i + 1; k + i < l; k++)
>  -                       if (r[k].diff <= r[i].diff)
>  -                               tmp = k;
>  -       }
>  -
>  -       return r[tmp].index;
>  -}
>  -
>  +/* Adjust the rate while ensuring that we won't switch to a lower rate if it
>  + * exhibited a worse failed frames behaviour and we'll choose the highest rate
>  + * whose failed frames behaviour is not worse than the one of the original rate
>  + * target. While at it, check that the new rate is valid. */
>   static void rate_control_pid_adjust_rate(struct ieee80211_local *local,
>                                          struct sta_info *sta, int adj,
>                                          struct rc_pid_rateinfo *rinfo)
>   {
>         struct ieee80211_sub_if_data *sdata;
>         struct ieee80211_hw_mode *mode;
>  -       int newidx;
>  -       int maxrate;
>  -       int back = (adj > 0) ? 1 : -1;
>  +       int cur_sorted, new_sorted, probe, tmp, n_bitrates;
>  +       int cur = sta->txrate;
>
>         sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
>
>         mode = local->oper_hw_mode;
>  -       maxrate = sdata->bss ? sdata->bss->max_ratectrl_rateidx : -1;
>  +       n_bitrates = mode->num_rates;
>
>  -       newidx = rate_control_pid_shift_adjust(rinfo, adj, sta->txrate,
>  -                                              mode->num_rates);
>  +       /* Map passed arguments to sorted values. */
>  +       cur_sorted = rinfo[cur].rev_index;
>  +       new_sorted = cur_sorted + adj;
>  +
>  +       /* Check limits. */
>  +       if (new_sorted < 0)
>  +               new_sorted = rinfo[0].rev_index;
>  +       else if (new_sorted >= n_bitrates)
>  +               new_sorted = rinfo[n_bitrates - 1].rev_index;
>
>  -       while (newidx != sta->txrate) {
>  -               if (rate_supported(sta, mode, newidx) &&
>  -                   (maxrate < 0 || newidx <= maxrate)) {
>  -                       sta->txrate = newidx;
>  -                       break;
>  -               }
>  +       tmp = new_sorted;
>
>  -               newidx += back;
>  +       if (adj < 0) {
>  +               /* Ensure that the rate decrease isn't disadvantageous. */
>  +               for (probe = cur_sorted; probe >= new_sorted; probe--)
>  +                       if (rinfo[probe].diff <= rinfo[cur_sorted].diff &&
>  +                           rate_supported(sta, mode, rinfo[probe].index))
>  +                               tmp = probe;
>  +       } else {
>  +               /* Look for rate increase with zero (or below) cost. */
>  +               for (probe = new_sorted + 1; probe < n_bitrates; probe++)
>  +                       if (rinfo[probe].diff <= rinfo[new_sorted].diff &&
>  +                           rate_supported(sta, mode, rinfo[probe].index))
>  +                               tmp = probe;
>         }
>
>  +       /* Fit the rate found to the nearest supported rate. */
>  +       do {
>  +               if (rate_supported(sta, mode, rinfo[tmp].index)) {
>  +                       sta->txrate = rinfo[tmp].index;
>  +                       break;
>  +               }
>  +               if (adj < 0)
>  +                       tmp--;
>  +               else
>  +                       tmp++;
>  +       } while (tmp < n_bitrates && tmp >= 0);
>  +
>   #ifdef CONFIG_MAC80211_DEBUGFS
>         rate_control_pid_event_rate_change(
>                 &((struct rc_pid_sta_info *)sta->rate_ctrl_priv)->events,
>  -               newidx, mode->rates[newidx].rate);
>  +               cur, mode->rates[cur].rate);
>   #endif
>   }
>
>
>
>  --
>  Ciao
>
> Stefano
>


-- 
Beauty is in the eye of the beerholder.
