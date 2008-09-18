Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbYIRMts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbYIRMts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 08:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbYIRMti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 08:49:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:11513 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbYIRMth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 08:49:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=bIx1/o0r/YBQzZw+wmxsHj9J8HvMMI03fUte9nu8fJjYonS0ogXnv81gURtLjEQGXJ
         G8+loTTcbtBYC5dEgNcwIFefe9Lkd+xg22IO7+ERA8Dlu2gHdhEt9IV4FODmwpsRupw2
         MBFFZW4OstHEcgx0+M1RtUP1ysTlQuugsTCBg=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] rfkill: update LEDs for all state changes
Date: Thu, 18 Sep 2008 14:49:31 +0200
User-Agent: KMail/1.9.9
Cc: John Linville <linville@tuxdriver.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, Michael Buesch <mb@bu3sch.de>
References: <20080917023334.GA1187@khazad-dum.debian.net> <1221682077-21170-1-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1221682077-21170-1-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809181449.31495.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 September 2008, Henrique de Moraes Holschuh wrote:
> The LED state was not being updated by rfkill_force_state(), which will
> cause regressions in wireless drivers that had old-style rfkill support and
> are updated to use rfkill_force_state().
> 
> The LED state was not being updated when a change was detected through the
> rfkill->get_state() hook, either.
> 
> Move the LED trigger update calls into notify_rfkill_state_change(), where
> it should have been in the first place.  This takes care of both issues.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  net/rfkill/rfkill.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
>  John, this one is quite likely something that should be sent for
>  merge in mainline BEFORE 2.6.27 is released.
> 
>  I am NOT sure it fixes regressions, that depends on whether the drivers
>  using rfkill that are in 2.6.27 had working LED support before rfkill
>  support was added to them.  Unfortunately, it cannot fix the b43
>  regression by itself.
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index ea0dc04..f949a48 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -125,6 +125,7 @@ static void rfkill_led_trigger_activate(struct led_classdev *led)
>  
>  static void notify_rfkill_state_change(struct rfkill *rfkill)
>  {
> +	rfkill_led_trigger(rfkill, rfkill->state);
>  	blocking_notifier_call_chain(&rfkill_notifier_list,
>  			RFKILL_STATE_CHANGED,
>  			rfkill);
> @@ -217,10 +218,8 @@ static int rfkill_toggle_radio(struct rfkill *rfkill,
>  			rfkill->state = state;
>  	}
>  
> -	if (force || rfkill->state != oldstate) {
> -		rfkill_led_trigger(rfkill, rfkill->state);
> +	if (force || rfkill->state != oldstate)
>  		notify_rfkill_state_change(rfkill);
> -	}
>  
>  	return retval;
>  }


