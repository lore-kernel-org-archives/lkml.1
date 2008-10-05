Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbYJEEoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbYJEEoF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 00:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbYJEEn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 00:43:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750850AbYJEEn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 00:43:56 -0400
Date: Sat, 4 Oct 2008 21:43:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: dmitry.torokhov@gmail.com, IvDoorn@gmail.com, hmh@hmh.eng.br,
       sitsofe@yahoo.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rfkill-input doesn't work until 5 minutes after boot
Message-Id: <20081004214341.f4052ce8.akpm@linux-foundation.org>
In-Reply-To: <20081005004334.GA31844@srcf.ucam.org>
References: <20081004204342.GA29620@srcf.ucam.org>
	<20081005004334.GA31844@srcf.ucam.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2008 01:43:34 +0100 Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> rfkill-input implements debounce as follows:
> 
>         if (time_after(jiffies, task->last + msecs_to_jiffies(200))) {
> 
> However, task->last is initialised to 0 while jiffies starts at -300*HZ. 
> Any input within 5 minutes of kernel start is therefore ignored. Fix by 
> initialising task->last correctly.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> ---
> 
> Set the last event value at module load time, since otherwise we'll have 
> a window of failure if someone loads the module in a few hundred million 
> years. I look forward to being rewarded by the post-humans for caring so 
> much about them.

Jiffies wraparound is 49.7 days at HZ=1000.

> diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
> index e5b6955..86197bb 100644
> --- a/net/rfkill/rfkill-input.c
> +++ b/net/rfkill/rfkill-input.c
> @@ -255,6 +255,11 @@ static struct input_handler rfkill_handler = {
>  
>  static int __init rfkill_handler_init(void)
>  {
> +	rfkill_wlan.last = jiffies - HZ/5;
> +	rfkill_bt.last = jiffies - HZ/5;
> +	rfkill_uwb.last = jiffies - HZ/5;
> +	rfkill_wimax.last = jiffies - HZ/5;
> +	rfkill_wwan.last = jiffies - HZ/5;
>  	return input_register_handler(&rfkill_handler);
>  }

If someone adds a new rfkill_foo there's a risk that they'll forget to
make the corresponding change here.  A comment at the definition sites
would help.


Or, better, do something like

static struct rfkill_task rfkill_tasks[] = {
	DEFINE_RFKILL_TASK(RFKILL_TYPE_WLAN),
	...
};

#define rfkill_wlan	rfkill_tasks[0]
...

	for (i = 0; i < ARRAY_SIZE(rfkill_tasks); i++)
		...


but the new definition of DEFINE_RFKILL_TASK gets tricky.
