Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbZGFWkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbZGFWkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 18:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbZGFWkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 18:40:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57524 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbZGFWkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 18:40:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: [PATCH] Input: mark serio and i8042 as suspended when hibernating too.
Date: Tue, 7 Jul 2009 00:40:42 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       maciej.rutecki@gmail.com, alan-jenkins@tuffmail.co.uk,
       linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
References: <1246760019-4120-1-git-send-email-cascardo@holoscopio.com>
In-Reply-To: <1246760019-4120-1-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907070040.43299.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 July 2009, Thadeu Lima de Souza Cascardo wrote:
> serio ports are not being restarted any longer because resume operations
> after hibernate do nothing, since the device has not been marked as
> suspended. This happens because suspend is only considering the SUSPEND
> event but not the FREEZE event.
> 
> Note that this driver has still to migrate to dev_pm_ops, but this fixes
> this particular bug now.

Hmm, this looks like a fix for:
http://bugzilla.kernel.org/show_bug.cgi?id=13643

Any objections to merging it through the suspend tree?

Best,
Rafael


> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  drivers/input/serio/i8042.c |    7 ++++---
>  drivers/input/serio/serio.c |    7 ++++---
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
> index f919bf5..582245c 100644
> --- a/drivers/input/serio/i8042.c
> +++ b/drivers/input/serio/i8042.c
> @@ -934,10 +934,11 @@ static bool i8042_suspended;
>  
>  static int i8042_suspend(struct platform_device *dev, pm_message_t state)
>  {
> -	if (!i8042_suspended && state.event == PM_EVENT_SUSPEND) {
> +	if (!i8042_suspended && state.event == PM_EVENT_SUSPEND)
>  		i8042_controller_reset();
> -		i8042_suspended = true;
> -	}
> +
> +	i8042_suspended = state.event == PM_EVENT_SUSPEND ||
> +			  state.event == PM_EVENT_FREEZE;
>  
>  	return 0;
>  }
> diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
> index fb17573..d66f494 100644
> --- a/drivers/input/serio/serio.c
> +++ b/drivers/input/serio/serio.c
> @@ -935,10 +935,11 @@ static int serio_suspend(struct device *dev, pm_message_t state)
>  {
>  	struct serio *serio = to_serio_port(dev);
>  
> -	if (!serio->suspended && state.event == PM_EVENT_SUSPEND) {
> +	if (!serio->suspended && state.event == PM_EVENT_SUSPEND)
>  		serio_cleanup(serio);
> -		serio->suspended = true;
> -	}
> +
> +	serio->suspended = state.event == PM_EVENT_SUSPEND ||
> +			   state.event == PM_EVENT_FREEZE;
>  
>  	return 0;
>  }
