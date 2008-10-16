Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbYJPKc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbYJPKc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 06:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbYJPKcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 06:32:16 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:38066 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939AbYJPKcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 06:32:15 -0400
Date: Thu, 16 Oct 2008 12:32:11 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Valdis.Kletnieks@vt.edu, Alan Cox <alan@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: hidraw_exit in discarded section (was: Re: [PATCH 1/1] HID: fix
 tty<->hid deadlock)
In-Reply-To: <1220541367-10984-1-git-send-email-jirislaby@gmail.com>
Message-ID: <Pine.LNX.4.64.0810161229300.25933@anakin>
References: <48BFFAE0.5010001@gmail.com> <1220541367-10984-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008, Jiri Slaby wrote:
> hid_compat_load() runs on the default workqueue, it request_module(), it
> execs modprobe, it exits, tty flushes default workqueue, it hangs, because
> we are still in it.
> 
> I haven't run into it since there always was at least one opener of the tty,
> I guess. Could you try the patch below?
> 
> --
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  drivers/hid/hid-core.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 92c16e1..18d952a 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1663,6 +1663,7 @@ static void hid_compat_load(struct work_struct *ws)
>  	request_module("hid-dummy");
>  }
>  static DECLARE_WORK(hid_compat_work, hid_compat_load);
> +static struct workqueue_struct *hid_compat_wq;
>  #endif
>  
>  static int __init hid_init(void)
> @@ -1680,7 +1681,12 @@ static int __init hid_init(void)
>  		goto err_bus;
>  
>  #ifdef CONFIG_HID_COMPAT
> -	schedule_work(&hid_compat_work);
> +	hid_compat_wq = create_workqueue("hid_compat");
> +	if (!hid_compat_wq) {
> +		hidraw_exit();
> +		goto err;
> +	}
> +	queue_work(hid_compat_wq, &hid_compat_work);
>  #endif
>  
>  	return 0;
> @@ -1692,6 +1698,9 @@ err:
>  
>  static void __exit hid_exit(void)
>  {
> +#ifdef CONFIG_HID_COMPAT
> +	destroy_workqueue(hid_compat_wq);
> +#endif
>  	hidraw_exit();
>  	bus_unregister(&hid_bus_type);
>  }

hid_init() is marked __init.
hidraw_exit() is marked __exit.

Hence I get:

    `hidraw_exit' referenced in section `.init.text' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o

and my `enable everything' m68k kernel fails to link.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
