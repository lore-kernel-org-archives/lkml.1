Return-Path: <linux-kernel-owner+w=401wt.eu-S1761599AbYDLKgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761599AbYDLKgb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 06:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759924AbYDLKfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 06:35:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:59745 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759484AbYDLKfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 06:35:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=aTIRSsCVgXUWapKZtGz+gva8Y3QD9HtfVoptVL2SFtpOTir+7GhvrAYmtviccgGqA4DzFlyD30lg/jn/fnZTlc80cHH3GDGFjLIDvlPd+3ukiNYm05kGzwydl4Tlg1u6Auu8swFrUfpo7tFE55OVmGsW4v/LKbMoLh73Fc4YELM=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 8/8] rfkill: add parameter to disable radios by default
Date: Sat, 12 Apr 2008 12:36:46 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <1207946244-14525-9-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1207946244-14525-9-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804121236.46626.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Currently, radios are always enabled when their rfkill interface is
> registered.  This is not optimal, the safest state for a radio is to be
> offline unless the user turns it on.

It defaults to the current state of the switch type.
What perhaps could be done, is that during registration it either reads
the status directly from rfkill to what the device initialized it to,
or call get_status() during registration to determine the new state itself.
That way we prevent series of module parameters and initialize to the state
the driver has indicated..

> Add a module parameter that causes all radios to be disabled when their
> rfkill interface is registered.  Add override parameters for each rfkill
> switch type as well, just in case the user wants the defaults to be
> different for a given radio type.

I am not a big fan of large series of module parameters, so in that aspect
I am not a fan of this patch.

> We don't change the module default, but I'd really recommed doing so in a
> future patch.
> 
> The parameters are called "default_state" (global), and
> "default_<type>_state", where <type> is: "wlan", "bluetooth", "uwb",
> "wimax", or "any".  Note that "any" realy is a type and does not mean every
> radio type (use the global "default_state" parameter for that.
> 
> The precedence order is "most specific first".
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: Dmitry Torokhov <dtor@mail.ru>
> ---
>  net/rfkill/rfkill.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 58 insertions(+), 1 deletions(-)
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index 9d3bffb..421de8c 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -39,6 +39,34 @@ MODULE_LICENSE("GPL");
>  static LIST_HEAD(rfkill_list);	/* list of registered rf switches */
>  static DEFINE_MUTEX(rfkill_mutex);
>  
> +static unsigned int rfkill_default_state = RFKILL_STATE_ON;
> +static unsigned int rfkill_default_state_wlan = UINT_MAX;
> +static unsigned int rfkill_default_state_bluetooth = UINT_MAX;
> +static unsigned int rfkill_default_state_uwb = UINT_MAX;
> +static unsigned int rfkill_default_state_wimax = UINT_MAX;
> +static unsigned int rfkill_default_state_wwan = UINT_MAX;
> +static unsigned int rfkill_default_state_any = UINT_MAX;
> +
> +module_param_named(default_state, rfkill_default_state, uint, 0444);
> +MODULE_PARM_DESC(default_state,
> +		 "Default initial state for all radio types, 0 = radio off");
> +
> +#define RFKILL_RADIO_DEFAULT(__type) \
> +	module_param_named(default_##__type##_state, \
> +			   rfkill_default_state_##__type, uint, 0444); \
> +	MODULE_PARM_DESC(default_##__type##_state, \
> +			 "Override initial state for radios of type " \
> +			 #__type ", 0 = radio off");
> +
> +RFKILL_RADIO_DEFAULT(wlan)
> +RFKILL_RADIO_DEFAULT(bluetooth)
> +RFKILL_RADIO_DEFAULT(uwb)
> +RFKILL_RADIO_DEFAULT(wimax)
> +RFKILL_RADIO_DEFAULT(wwan)
> +RFKILL_RADIO_DEFAULT(any)
> +
> +#undef RFKILL_RADIO_DEFAULT
> +
>  static enum rfkill_state rfkill_states[RFKILL_TYPE_MAX];
>  
>  
> @@ -485,6 +513,17 @@ void rfkill_unregister(struct rfkill *rfkill)
>  }
>  EXPORT_SYMBOL(rfkill_unregister);
>  
> +static int __init rfkill_init_states(unsigned int state, enum rfkill_type type)
> +{
> +	if (state == UINT_MAX)
> +		return 0;
> +	else if (state == RFKILL_STATE_OFF || state == RFKILL_STATE_ON) {
> +		rfkill_states[type] = state;
> +		return 0;
> +	}
> +	return 1;
> +}
> +
>  /*
>   * Rfkill module initialization/deinitialization.
>   */
> @@ -493,8 +532,26 @@ static int __init rfkill_init(void)
>  	int error;
>  	int i;
>  
> +	if (rfkill_default_state != RFKILL_STATE_OFF &&
> +	    rfkill_default_state != RFKILL_STATE_ON)
> +		return -EINVAL;
> +
>  	for (i = 0; i < ARRAY_SIZE(rfkill_states); i++)
> -		rfkill_states[i] = RFKILL_STATE_ON;
> +		rfkill_states[i] = rfkill_default_state;
> +
> +	if (rfkill_init_states(rfkill_default_state_wlan,
> +				  RFKILL_TYPE_WLAN)
> +	    || rfkill_init_states(rfkill_default_state_bluetooth,
> +				  RFKILL_TYPE_BLUETOOTH)
> +	    || rfkill_init_states(rfkill_default_state_uwb,
> +				  RFKILL_TYPE_UWB)
> +	    || rfkill_init_states(rfkill_default_state_wimax,
> +				  RFKILL_TYPE_WIMAX)
> +	    || rfkill_init_states(rfkill_default_state_wwan,
> +				  RFKILL_TYPE_WWAN)
> +	    || rfkill_init_states(rfkill_default_state_any,
> +				  RFKILL_TYPE_ANY))
> +		return -EINVAL;
>  
>  	error = class_register(&rfkill_class);
>  	if (error) {


