Return-Path: <linux-kernel-owner+w=401wt.eu-S934538AbXEHLcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934538AbXEHLcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 07:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934519AbXEHLca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 07:32:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:60928 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934517AbXEHLca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 07:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=apMpd8e9egNwP54TcZoUN/6cEOn6+lodZHdfyP65zHihb+FQ2mzZYfpimDrPw43sA3b7EIr2jG/LlBSDci/LifHAUDkH1h/oqilNEd5lP1lWYeS0vH4EUanbcqKNjkJr/1/qJAYt8VH2zFQZneO8lpPeBHoR6r3pPcRjDEoQxt8=
Message-ID: <46405FC9.7010407@gmail.com>
Date: Tue, 08 May 2007 13:32:25 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Dan Kruchinin <dubalom@gmail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <greg@kroah.com>
Subject: Re: [PATCH -mm] drivers/usb/core/config.c: kzalloc(0,..)
References: <a8f16e2b0705072003m6172df63l199090149edd7612@mail.gmail.com>
In-Reply-To: <a8f16e2b0705072003m6172df63l199090149edd7612@mail.gmail.com>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Kruchinin napsal(a):
> The following patch fixes such SLUB report(when someone tries to
> allocate 0 bytes):
> -- 
> May  8 00:19:15 midgard kernel: [   21.933467] BUG: at
> include/linux/slub_def.h:88 kmalloc_index()
> May  8 00:19:15 midgard kernel: [   21.933470]
> [show_registers+410/736] show_trace_log_lvl+0x1a/0x30
> May  8 00:19:15 midgard kernel: [   21.933478]
> [print_trace_warning_symbol+50/64] show_trace+0x12/0x20
> May  8 00:19:15 midgard kernel: [   21.933482]  [fixup_irqs+38/192]
> dump_stack+0x16/0x20
> May  8 00:19:15 midgard kernel: [   21.933485]  [do_lookup+195/400]
> get_slab+0x213/0x230
> May  8 00:19:15 midgard kernel: [   21.933489]  [do_lookup+309/400]
> __kmalloc_track_caller+0x15/0x40
> May  8 00:19:15 midgard kernel: [   21.933493]  [__vunmap+25/240]
> __kzalloc+0x19/0x50
> May  8 00:19:15 midgard kernel: [   21.933498]  [<df05778e>]
> usb_parse_configuration+0x85e/0xe70 [usbcore]
> May  8 00:19:15 midgard kernel: [   21.933520]  [<df057fcb>]
> usb_get_configuration+0x12b/0x450 [usbcore]
> May  8 00:19:15 midgard kernel: [   21.933535]  [<df04ed87>]
> usb_new_device+0x17/0x1c0 [usbcore]
> May  8 00:19:15 midgard kernel: [   21.933550]  [<df05073a>]
> hub_thread+0x79a/0xfd0 [usbcore]
> May  8 00:19:15 midgard kernel: [   21.933564]
> [run_posix_cpu_timers+1218/2064] kthread+0x42/0x70
> May  8 00:19:15 midgard kernel: [   21.933569]  [math_error+87/240]
> kernel_thread_helper+0x7/0x10
> May  8 00:19:15 midgard kernel: [   21.933572]  =======================
> -- 
> 
> The problem was in drivers/usb/core/config.c in function
> usb_parse_interface:
> ---
> num_ep = num_ep_orig = alt->desc.bNumEndpoints;
> ...
> len = sizeof(struct usb_host_endpoint) * num_ep;
> alt->endpoint = kzalloc(len, GFP_KERNEL);
> ---
> 
> num_ep can be 0, as it was in my case, so following patch makes this
> situation more obvious
> and clear.
> 
> --------------
> diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
> index bfb3731..4db6b21 100644
> --- a/drivers/usb/core/config.c
> +++ b/drivers/usb/core/config.c
> @@ -185,7 +185,10 @@ static int usb_parse_interface(struct device
> *ddev, int cfgno,
>         num_ep = USB_MAXENDPOINTS;
>     }
> 
> -    len = sizeof(struct usb_host_endpoint) * num_ep;
> +    len = sizeof(struct usb_host_endpoint);
> +    if (num_ep > 0)
> +      len *= num_ep;
> +   
>     alt->endpoint = kzalloc(len, GFP_KERNEL);
>     if (!alt->endpoint)
>         return -ENOMEM;
> ---------------

I don't think, this is correct, but let USB people make a decision (always CC
subsys maintainers plus people who might be involved).

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
