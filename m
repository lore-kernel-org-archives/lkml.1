Return-Path: <linux-kernel-owner+w=401wt.eu-S1760215AbYC0TH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215AbYC0TH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 15:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbYC0THP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 15:07:15 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:48593 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752485AbYC0THO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 15:07:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LwsD7c9KH9P7/fMHzt1ykVQfkgav1fzQkN7BEzLDW56cetVrF+IadrbRMcmdfbxJ5boCB8LZFh5b6U9Yse+lWcogCb8KRsE9u0dOyzt1C1aPwJb5Qtt0LW9TSGFYe8OhEgZIz7UVRut6jcFh43CDsc0aGJp3eZiEq6AQcqd4XOw=  ;
X-YMail-OSG: hfxxovwVM1lYivIiOiiiv.M1hCnJ2mz5KUVxEa06WleqmQ8_O0lNCjnGxu_gk1H6KrQW1N6ZCg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Subject: Re: [patch] usb ohci : fix 2 timers to fire at jiffies + 1s
Date: Thu, 27 Mar 2008 11:53:01 -0700
User-Agent: KMail/1.9.6
Cc: linux-usb <linux-usb@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
References: <Pine.LNX.4.44L0.0803261136590.6324-100000@iolanthe.rowland.org> <1206549143.2931.27.camel@castor.localdomain>
In-Reply-To: <1206549143.2931.27.camel@castor.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803271153.02248.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 March 2008, Richard Kennedy wrote:
>     Code inspection discovered in 2 places timers were being
>     incorrectly setup using round_jiffies_relative(HZ).
>     The timer would then fire at time (0 <= T < HZ).
>     
>     Fix them to use round_jiffies(jiffies + HZ);
>     
>     Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

> ---
> 
> compiled on latest v2.6.25-rc7-11 git head but not otherwise tested.
> Richard
> 
> diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
> index dd4798e..33f1c1c 100644
> --- a/drivers/usb/host/ohci-hcd.c
> +++ b/drivers/usb/host/ohci-hcd.c
> @@ -467,7 +467,7 @@ static void unlink_watchdog_func(unsigned long _ohci)
>  out:
>  	kfree(seen);
>  	if (ohci->eds_scheduled)
> -		mod_timer(&ohci->unlink_watchdog, round_jiffies_relative(HZ));
> +		mod_timer(&ohci->unlink_watchdog, round_jiffies(jiffies + HZ));
>  done:
>  	spin_unlock_irqrestore(&ohci->lock, flags);
>  }
> diff --git a/drivers/usb/host/ohci-q.c b/drivers/usb/host/ohci-q.c
> index 5181732..9c9f3b5 100644
> --- a/drivers/usb/host/ohci-q.c
> +++ b/drivers/usb/host/ohci-q.c
> @@ -169,7 +169,7 @@ static int ed_schedule (struct ohci_hcd *ohci, struct ed *ed)
>  	if (quirk_zfmicro(ohci)
>  			&& (ed->type == PIPE_INTERRUPT)
>  			&& !(ohci->eds_scheduled++))
> -		mod_timer(&ohci->unlink_watchdog, round_jiffies_relative(HZ));
> +		mod_timer(&ohci->unlink_watchdog, round_jiffies(jiffies + HZ));
>  	wmb ();
>  
>  	/* we care about rm_list when setting CLE/BLE in case the HC was at
> 
> 


