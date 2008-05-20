Return-Path: <linux-kernel-owner+w=401wt.eu-S1764617AbYETJzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764617AbYETJzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762286AbYETJxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:53:49 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:21013 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764154AbYETJxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:53:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=sms2w75mVhXu6Mkes0+KT938PjImLsU+AJsw9FY8SNPlaHNKmOhxKzppPtetE8E+bHUyDLbxRNnBUfM7VIEtzAFJzgrL6zr9H4FkY14PLt2OoVDst3KBFRtrpltO6L4mnMSrlp6uq7HmtwwdBwHzrY+3+Kx2Ztv/WLD7jUfaaEU=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 10/15] rfkill: rework suspend and resume handlers
Date: Tue, 20 May 2008 12:08:57 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <1211136485-19878-11-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1211136485-19878-11-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805201208.57557.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 May 2008, Henrique de Moraes Holschuh wrote:
> The resume handler should reset the wireless transmitter rfkill
> state to exactly what it was when the system was suspended.  Do it,
> and do it using the normal routines for state change while at it.
> 
> The suspend handler should force-switch the transmitter to blocked
> state, ignoring caches.  Do it.
> 
> Also take an opportunity shot to rfkill_remove_switch() and also
> force the transmitter to blocked state there, bypassing caches.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> ---
>  net/rfkill/rfkill.c |   35 ++++++++++++++++++-----------------
>  1 files changed, 18 insertions(+), 17 deletions(-)
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index c5a79ab..f11220b 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -75,24 +75,25 @@ static void update_rfkill_state(struct rfkill *rfkill)
>  }
>  
>  static int rfkill_toggle_radio(struct rfkill *rfkill,
> -				enum rfkill_state state)
> +				enum rfkill_state state,
> +				int force)
>  {
>  	int retval = 0;
>  	enum rfkill_state oldstate, newstate;
>  
>  	oldstate = rfkill->state;
>  
> -	if (rfkill->get_state &&
> +	if (rfkill->get_state && !force &&
>  	    !rfkill->get_state(rfkill->data, &newstate))
>  		rfkill->state = newstate;
>  
> -	if (state != rfkill->state) {
> +	if (force || state != rfkill->state) {
>  		retval = rfkill->toggle_radio(rfkill->data, state);
>  		if (!retval)
>  			rfkill->state = state;
>  	}
>  
> -	if (rfkill->state != oldstate)
> +	if (force || rfkill->state != oldstate)
>  		rfkill_led_trigger(rfkill, rfkill->state);
>  
>  	return retval;
> @@ -107,7 +108,6 @@ static int rfkill_toggle_radio(struct rfkill *rfkill,
>   * a specific switch is claimed by userspace in which case it is
>   * left alone.
>   */
> -
>  void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
>  {
>  	struct rfkill *rfkill;
> @@ -118,7 +118,7 @@ void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
>  
>  	list_for_each_entry(rfkill, &rfkill_list, node) {
>  		if ((!rfkill->user_claim) && (rfkill->type == type))
> -			rfkill_toggle_radio(rfkill, state);
> +			rfkill_toggle_radio(rfkill, state, 0);
>  	}
>  
>  	mutex_unlock(&rfkill_mutex);
> @@ -210,7 +210,8 @@ static ssize_t rfkill_state_store(struct device *dev,
>  	if (mutex_lock_interruptible(&rfkill->mutex))
>  		return -ERESTARTSYS;
>  	error = rfkill_toggle_radio(rfkill,
> -			state ? RFKILL_STATE_ON : RFKILL_STATE_OFF);
> +			state ? RFKILL_STATE_ON : RFKILL_STATE_OFF,
> +			0);
>  	mutex_unlock(&rfkill->mutex);
>  
>  	return error ? error : count;
> @@ -251,7 +252,8 @@ static ssize_t rfkill_claim_store(struct device *dev,
>  	if (rfkill->user_claim != claim) {
>  		if (!claim)
>  			rfkill_toggle_radio(rfkill,
> -					    rfkill_states[rfkill->type]);
> +					    rfkill_states[rfkill->type],
> +					    0);
>  		rfkill->user_claim = claim;
>  	}
>  
> @@ -284,12 +286,11 @@ static int rfkill_suspend(struct device *dev, pm_message_t state)
>  
>  	if (dev->power.power_state.event != state.event) {
>  		if (state.event & PM_EVENT_SLEEP) {
> -			mutex_lock(&rfkill->mutex);
> -
> -			if (rfkill->state == RFKILL_STATE_ON)
> -				rfkill->toggle_radio(rfkill->data,
> -						     RFKILL_STATE_OFF);
> +			/* Stop transmitter, keep state, no notifies */
> +			update_rfkill_state(rfkill);
>  
> +			mutex_lock(&rfkill->mutex);
> +			rfkill->toggle_radio(rfkill->data, RFKILL_STATE_OFF);
>  			mutex_unlock(&rfkill->mutex);
>  		}
>  
> @@ -306,8 +307,8 @@ static int rfkill_resume(struct device *dev)
>  	if (dev->power.power_state.event != PM_EVENT_ON) {
>  		mutex_lock(&rfkill->mutex);
>  
> -		if (rfkill->state == RFKILL_STATE_ON)
> -			rfkill->toggle_radio(rfkill->data, RFKILL_STATE_ON);
> +		/* restore radio state AND notify everybody */
> +		rfkill_toggle_radio(rfkill, rfkill->state, 1);
>  
>  		mutex_unlock(&rfkill->mutex);
>  	}
> @@ -334,7 +335,7 @@ static int rfkill_add_switch(struct rfkill *rfkill)
>  
>  	mutex_lock(&rfkill_mutex);
>  
> -	error = rfkill_toggle_radio(rfkill, rfkill_states[rfkill->type]);
> +	error = rfkill_toggle_radio(rfkill, rfkill_states[rfkill->type], 0);
>  	if (!error)
>  		list_add_tail(&rfkill->node, &rfkill_list);
>  
> @@ -347,7 +348,7 @@ static void rfkill_remove_switch(struct rfkill *rfkill)
>  {
>  	mutex_lock(&rfkill_mutex);
>  	list_del_init(&rfkill->node);
> -	rfkill_toggle_radio(rfkill, RFKILL_STATE_OFF);
> +	rfkill_toggle_radio(rfkill, RFKILL_STATE_OFF, 1);
>  	mutex_unlock(&rfkill_mutex);
>  }
>  


