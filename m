Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbYJDWkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbYJDWkZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 18:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbYJDWkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 18:40:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754212AbYJDWkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 18:40:14 -0400
Date: Sat, 4 Oct 2008 15:39:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: dmitry.torokhov@gmail.com, IvDoorn@gmail.com, hmh@hmh.eng.br,
       sitsofe@yahoo.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rfkill-input doesn't work until 5 minutes after boot
Message-Id: <20081004153929.846a0bde.akpm@linux-foundation.org>
In-Reply-To: <20081004204342.GA29620@srcf.ucam.org>
References: <20081004204342.GA29620@srcf.ucam.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Oct 2008 21:43:43 +0100 Matthew Garrett <mjg59@srcf.ucam.org> wrote:

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
> 
> diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
> index e5b6955..de75934 100644
> --- a/net/rfkill/rfkill-input.c
> +++ b/net/rfkill/rfkill-input.c
> @@ -101,6 +101,7 @@ static void rfkill_schedule_toggle(struct rfkill_task *task)
>  		.mutex = __MUTEX_INITIALIZER(n.mutex),		\
>  		.lock = __SPIN_LOCK_UNLOCKED(n.lock),		\
>  		.desired_state = RFKILL_STATE_UNBLOCKED,	\
> +		.last = INITIAL_JIFFIES,			\
>  	}
>  
>  static DEFINE_RFKILL_TASK(rfkill_wlan, RFKILL_TYPE_WLAN);
> 

That'll only work as intended if CONFIG_RFKILL_INPUT=y?  If the module
is loaded 10 minutes after boot, the timestamp is still wrong.  It might
happily happen to work, but will still fail after 2^31 jiffies (or something
like that).

Generally speaking, INITIAL_JIFFIES is a secret internal debugging
detail and its use out in general kernel code is a red flag.

I think this initialisation should be done at runtime somehow.

> .27 material?

yup.
