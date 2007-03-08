Return-Path: <linux-kernel-owner+w=401wt.eu-S1161123AbXCHXgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161123AbXCHXgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 18:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161200AbXCHXgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 18:36:52 -0500
Received: from smtp121.iad.emailsrvr.com ([207.97.245.121]:57203 "EHLO
	smtp121.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161123AbXCHXgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 18:36:50 -0500
Message-ID: <45F09E2E.4050309@gentoo.org>
Date: Thu, 08 Mar 2007 18:37:18 -0500
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0b2 (X11/20070208)
MIME-Version: 1.0
To: Andrew Johnson <ajohnson@intrinsyc.com>
CC: pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Software Suspend: Fix suspend when console is in	VT_AUTO/KD_GRAPHICS
 mode
References: <1173394485.28589.17.camel@localhost.localdomain>
In-Reply-To: <1173394485.28589.17.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Johnson wrote:
> When the console is in VT_AUTO/KD_GRAPHICS mode, switching to the
> SUSPEND_CONSOLE fails, resulting in vt_waitactive() waiting indefinately
> or until the task is interrupted.  The following patch tests if a
> console switch can occur in set_console() and returns early if a console
> switch is not possible.
> 
> Signed-off-by: Andrew Johnson <ajohnson@intrinsyc.com>
> 
> diff -rup linux-2.6.20.1/drivers/char/vt.c linux/drivers/char/vt.c
> --- linux-2.6.20.1/drivers/char/vt.c	2007-02-19 22:34:32.000000000 -0800
> +++ linux/drivers/char/vt.c	2007-03-08 14:15:41.000000000 -0800
> @@ -2188,10 +2188,20 @@ static void console_callback(struct work
>  	release_console_sem();
>  }
>  
> -void set_console(int nr)
> +extern char vt_dont_switch;
> +
> +int set_console(int nr)
>  {
> +	struct vc_data *vc = vc_cons[fg_console].d;
> +
> +	if(!vc_cons_allocated(nr) || vt_dont_switch || vc->vc_mode ==
> KD_GRAPHICS) {
> +		return -EINVAL;
> +	}
> +
>  	want_console = nr;
>  	schedule_console_callback();
> +
> +	return 0;
>  }

I haven't tested, but I think the above -EINVAL return will break chvt. 
chvt uses the VT_ACTIVATE ioctl which calls set_console(), and it is 
valid for chvt to be used to change away from a graphics-mode console -- 
that shouldn't be an error condition.

Daniel

