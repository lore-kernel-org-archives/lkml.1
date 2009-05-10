Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbZEJW3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbZEJW3V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 18:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbZEJW3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 18:29:08 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:36358 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbZEJW3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 18:29:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CJtWmuZgdo6/S/HJfQse6fmE1ls3r226u0xzBvAWYsDiN7dfifdIOE8lrlxeuBMf/P
         OPHWVmqdcyXDkcaRvFKA+hupGp2AWem9nE0fQxzG1kIWIgwRjgOM3fdE3iQrDksfU7KE
         Q5FJvxFVRT16ZCvz1fxLg7Fn2CrT53NqoFeTg=
MIME-Version: 1.0
In-Reply-To: <4A074682.6010403@gmail.com>
References: <c6b1100b0905101239n564e4379v5460c281260950bc@mail.gmail.com>
	 <4A074682.6010403@gmail.com>
Date: Sun, 10 May 2009 22:29:04 +0000
Message-ID: <c6b1100b0905101529tfafe11p3ddcbf4b604ddd29@mail.gmail.com>
Subject: Re: Oops in wireless from today's git
From: Chris Clayton <chris2553@googlemail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/10 Jiri Slaby <jirislaby@gmail.com>:
> On 05/10/2009 09:39 PM, Chris Clayton wrote:
>> I've just done a git pull and built, installed and booted the kernel.
>> Unfortunately I got the oops below.
>
> What's your HEAD? Looks like the issue solved by
> 0cc113d866fa87c1455cbaff8d1f7ac054090bd5.
>

Sorry, I'm a real novice git user, but if by HEAD you mean the latest
commit, its a4d7749be5de4a7261bcbe3c7d96c748792ec455. The file
.git/FETCH_HEAD contains:

a4d7749be5de4a7261bcbe3c7d96c748792ec455                branch
'master' of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6


I've done some investigating and found that reverting the following
patch prevents the oops:

mac80211: minstrel, fix memory corruption

minstrel doesn't count max rate count in fact, since it doesn't use
a loop variable `i' and hence allocs space only for bitrates found in
the first band.

Fix it by involving the `i' as an index so that it traverses all the
bands now and finds the real max bitrate count.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 3824990..70df3dc 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -476,7 +476,7 @@ minstrel_alloc_sta(void *priv, struct
ieee80211_sta *sta, gfp_t gfp)
                return NULL;

        for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
-               sband = hw->wiphy->bands[hw->conf.channel->band];
+               sband = hw->wiphy->bands[i];
                if (sband->n_bitrates > max_rates)
                        max_rates = sband->n_bitrates;
        }

I can also prevent the oops by applying this patch:

--- linux-2.6/net/mac80211/rc80211_minstrel.c.save      2009-05-10
21:53:34.000000000 +0000
+++ linux-2.6/net/mac80211/rc80211_minstrel.c   2009-05-10
21:53:57.000000000 +0000
@@ -477,7 +477,7 @@ minstrel_alloc_sta(void *priv, struct ie

        for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
                sband = hw->wiphy->bands[i];
-               if (sband->n_bitrates > max_rates)
+               if (sband && sband->n_bitrates > max_rates)
                        max_rates = sband->n_bitrates;
        }


-- 
No, Sir; there is nothing which has yet been contrived by man, by which
so much happiness is produced as by a good tavern or inn - Doctor Samuel
Johnson
