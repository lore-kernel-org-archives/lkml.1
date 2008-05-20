Return-Path: <linux-kernel-owner+w=401wt.eu-S1765383AbYETJ4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765383AbYETJ4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764301AbYETJxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:53:52 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:21013 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764259AbYETJxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:53:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=EX4sMoz1Ro2jqdn9jwh1uqr+7ROwi/lH30WzVY3UgD13l5k1fpjrZiYmP9Zk8mHAUQh8pa3HY14F+zSGp7AXfyXB9gPvm5WPiz8MzHVntBZNAZYxm6x2DOtc2cMyxkK2u8ZJNgkI0Rxa9p5ZCWdI6RI+HzJGj/ySCSysJKclrfM=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 13/15] rfkill: add uevent notifications
Date: Tue, 20 May 2008 12:09:04 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Dmitry Torokhov <dtor@mail.ru>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <1211136485-19878-14-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1211136485-19878-14-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805201209.05080.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 May 2008, Henrique de Moraes Holschuh wrote:
> Use the notification chains to also send uevents, so that userspace can be
> notified of state changes of every rfkill switch.
> 
> Userspace should use these events for OSD/status report applications and
> rfkill GUI frontends.  HAL might want to broadcast them over DBUS, for
> example.  It might be also useful for userspace implementations of
> rfkill-input, or to use HAL as the platform driver which promotes rfkill
> switch change events into input events (to synchronize all other switches)
> when necessary for platforms that lack a convenient platform-specific
> kernel module to do it.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Dmitry Torokhov <dtor@mail.ru>
> ---
>  net/rfkill/rfkill.c |   42 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 42 insertions(+), 0 deletions(-)
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index 4ed8d19..ba25bde 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -382,12 +382,51 @@ static int rfkill_resume(struct device *dev)
>  #define rfkill_resume NULL
>  #endif
>  
> +static int rfkill_blocking_uevent_notifier(struct notifier_block *nb,
> +					unsigned long eventid,
> +					void *data)
> +{
> +	struct rfkill *rfkill = (struct rfkill *)data;
> +
> +	switch (eventid) {
> +	case RFKILL_STATE_CHANGED:
> +		kobject_uevent(&rfkill->dev.kobj, KOBJ_CHANGE);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block rfkill_blocking_uevent_nb = {
> +	.notifier_call	= rfkill_blocking_uevent_notifier,
> +	.priority	= 0,
> +};
> +
> +static int rfkill_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
> +{
> +	struct rfkill *rfkill = to_rfkill(dev);
> +	int error;
> +
> +	error = add_uevent_var(env, "RFKILL_NAME=%s", rfkill->name);
> +	if (error)
> +		return error;
> +	error = add_uevent_var(env, "RFKILL_TYPE=%s",
> +				rfkill_get_type_str(rfkill->type));
> +	if (error)
> +		return error;
> +	error = add_uevent_var(env, "RFKILL_STATE=%u", rfkill->state);
> +	return error;
> +}
> +
>  static struct class rfkill_class = {
>  	.name		= "rfkill",
>  	.dev_release	= rfkill_release,
>  	.dev_attrs	= rfkill_dev_attrs,
>  	.suspend	= rfkill_suspend,
>  	.resume		= rfkill_resume,
> +	.dev_uevent	= rfkill_dev_uevent,
>  };
>  
>  static int rfkill_add_switch(struct rfkill *rfkill)
> @@ -562,11 +601,14 @@ static int __init rfkill_init(void)
>  		return error;
>  	}
>  
> +	register_rfkill_notifier(&rfkill_blocking_uevent_nb);
> +
>  	return 0;
>  }
>  
>  static void __exit rfkill_exit(void)
>  {
> +	unregister_rfkill_notifier(&rfkill_blocking_uevent_nb);
>  	class_unregister(&rfkill_class);
>  }
>  


