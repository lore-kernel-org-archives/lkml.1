Return-Path: <linux-kernel-owner+w=401wt.eu-S1765161AbYETJ5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765161AbYETJ5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764374AbYETJxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:53:53 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:50638 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764290AbYETJxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:53:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=Lxiqlh+ysitS+sBcLTe1v4UQ8FB335LxZ3/ddV4TwnCx27V2l/CwHOEBlRSRDXJ8roqp/2ESh71lsgx2g+qG5+loqLW+m8RU3j//b2NqiRIl6RKAwHB1k8tuGOLDSCQPZgSge2n77epaQxwIxnPKDT4BdbXh0TB9RaOz1izo9SE=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 14/15] rfkill: do not allow userspace to override ALL RADIOS OFF
Date: Tue, 20 May 2008 12:09:06 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Dmitry Torokhov <dtor@mail.ru>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <1211136485-19878-15-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1211136485-19878-15-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805201209.06902.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 May 2008, Henrique de Moraes Holschuh wrote:
> SW_RFKILL_ALL is the "emergency power-off all radios" input event.  It must
> be handled, and must always do the same thing as far as the rfkill system
> is concerned: all transmitters are to go *immediately* offline.

I don't quite agree here. The SW_RFKILL_ALL key is the one send by thinkpad-acpi,
what makes that key so special that is has to be handled differently then a key
that only controls a single radio type?

All keys should have the same rules when it is pressed, so either all keys should
force the change, or none of them should.

> For safety, do NOT allow userspace to override EV_SW SW_RFKILL_ALL OFF.  As
> long as rfkill-input is loaded, that event will *always* be processed, and
> it will *always* force all rfkill switches to disable all wireless
> transmitters, regardless of user_claim attribute or anything else.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Dmitry Torokhov <dtor@mail.ru>
> ---
>  net/rfkill/rfkill-input.c |   29 ++++++++++++++---------------
>  net/rfkill/rfkill-input.h |    1 +
>  net/rfkill/rfkill.c       |   18 ++++++++++++++++++
>  3 files changed, 33 insertions(+), 15 deletions(-)
> 
> diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
> index 29c13d3..0fadeed 100644
> --- a/net/rfkill/rfkill-input.c
> +++ b/net/rfkill/rfkill-input.c
> @@ -127,21 +127,20 @@ static void rfkill_event(struct input_handle *handle, unsigned int type,
>  		switch (code) {
>  		case SW_RFKILL_ALL:
>  			/* EVERY radio type. data != 0 means radios ON */
> -			rfkill_schedule_set(&rfkill_wwan,
> -					    (data)? RFKILL_STATE_ON:
> -						    RFKILL_STATE_OFF);
> -			rfkill_schedule_set(&rfkill_wimax,
> -					    (data)? RFKILL_STATE_ON:
> -						    RFKILL_STATE_OFF);
> -			rfkill_schedule_set(&rfkill_uwb,
> -					    (data)? RFKILL_STATE_ON:
> -						    RFKILL_STATE_OFF);
> -			rfkill_schedule_set(&rfkill_bt,
> -					    (data)? RFKILL_STATE_ON:
> -						    RFKILL_STATE_OFF);
> -			rfkill_schedule_set(&rfkill_wlan,
> -					    (data)? RFKILL_STATE_ON:
> -						    RFKILL_STATE_OFF);
> +			/* handle EPO (emergency power off) through shortcut */
> +			if (data) {
> +				rfkill_schedule_set(&rfkill_wwan,
> +						    RFKILL_STATE_ON);
> +				rfkill_schedule_set(&rfkill_wimax,
> +						    RFKILL_STATE_ON);
> +				rfkill_schedule_set(&rfkill_uwb,
> +						    RFKILL_STATE_ON);
> +				rfkill_schedule_set(&rfkill_bt,
> +						    RFKILL_STATE_ON);
> +				rfkill_schedule_set(&rfkill_wlan,
> +						    RFKILL_STATE_ON);
> +			} else
> +				rfkill_epo();
>  			break;
>  		default:
>  			break;
> diff --git a/net/rfkill/rfkill-input.h b/net/rfkill/rfkill-input.h
> index 4dae500..f63d050 100644
> --- a/net/rfkill/rfkill-input.h
> +++ b/net/rfkill/rfkill-input.h
> @@ -12,5 +12,6 @@
>  #define __RFKILL_INPUT_H
>  
>  void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state);
> +void rfkill_epo(void);
>  
>  #endif /* __RFKILL_INPUT_H */
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index ba25bde..fdde692 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -182,6 +182,24 @@ void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
>  EXPORT_SYMBOL(rfkill_switch_all);
>  
>  /**
> + * rfkill_epo - emergency power off all transmitters
> + *
> + * This kicks all rfkill devices to RFKILL_STATE_OFF, ignoring
> + * everything in its path but rfkill_mutex.
> + */
> +void rfkill_epo(void)
> +{
> +	struct rfkill *rfkill;
> +
> +	mutex_lock(&rfkill_mutex);
> +	list_for_each_entry(rfkill, &rfkill_list, node) {
> +		rfkill_toggle_radio(rfkill, RFKILL_STATE_OFF, 1);
> +	}
> +	mutex_unlock(&rfkill_mutex);
> +}
> +EXPORT_SYMBOL_GPL(rfkill_epo);
> +
> +/**
>   * rfkill_force_state - Force the internal rfkill radio state
>   * @rfkill: pointer to the rfkill class to modify.
>   * @state: the current radio state the class should be forced to.


