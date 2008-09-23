Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbYIWJxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbYIWJxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 05:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbYIWJxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 05:53:18 -0400
Received: from hs-out-0708.google.com ([64.233.178.248]:21750 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbYIWJxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 05:53:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HIUnmHGRQPnJDjbA+uGNzdIRw9jPc8Q4JQLfZfDRoDukim8XhYhta19PlmE3TSzMKa
         iIkz7AE4FmPytZEgS9V69HQ5po/F4gA0ut1dBfe6n2w+/6d/c2cYfoihe8ML603Q6UPx
         lRjYUQBuu7RJ4EV7Sjl3q2h0VeMfgdrOhri38=
Message-ID: <bc64b4640809230253s79e0c257qfd559787e15ef8d8@mail.gmail.com>
Date: Tue, 23 Sep 2008 13:53:14 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Krzysztof Helt" <krzysztof.h1@wp.pl>
Subject: Re: [Linux-fbdev-devel] [fbdev] Lockdep error
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rpurdie@rpsys.net, adaplas@gmail.com
In-Reply-To: <20080916233916.4f9c0dfd.krzysztof.h1@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080915122152.GA4570@doriath.ww600.siemens.net>
	 <20080916233916.4f9c0dfd.krzysztof.h1@wp.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/17 Krzysztof Helt <krzysztof.h1@wp.pl>:
> On Mon, 15 Sep 2008 16:21:52 +0400
> Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
>
>> Hi,
>>
>> After doing
>> # echo 1 > /sys/class/graphics/fb0/blank
>> I got the following in my kernel log:
>>
>> =============================================
>> [ INFO: possible recursive locking detected ]
>> 2.6.27-rc6-00086-gda63874-dirty #97
>> ---------------------------------------------
>> echo/1564 is trying to acquire lock:
>>  ((fb_notifier_list).rwsem){..--}, at: [<c005a384>] __blocking_notifier_call_chain+0x38/0x6c
>>
>
> Does the patch below fix the problem for you?

Sorry for the delay.
Yes, the patch does fix the issue for me. Thank you.

>
> Kind regards,
> Krzysztof
>
> diff -urp linux-ref/drivers/video/console/fbcon.c linux-mm/drivers/video/console/fbcon.c
> --- linux-ref/drivers/video/console/fbcon.c     2008-09-05 23:38:47.000000000 +0200
> +++ linux-mm/drivers/video/console/fbcon.c      2008-09-16 23:30:52.309604454 +0200
> @@ -2400,11 +2400,15 @@ static int fbcon_blank(struct vc_data *v
>
>        if (!fbcon_is_inactive(vc, info)) {
>                if (ops->blank_state != blank) {
> +                       int ret = 1;
> +
>                        ops->blank_state = blank;
>                        fbcon_cursor(vc, blank ? CM_ERASE : CM_DRAW);
>                        ops->cursor_flash = (!blank);
>
> -                       if (fb_blank(info, blank))
> +                       if (info->fbops->fb_blank)
> +                               ret = info->fbops->fb_blank(blank, info);
> +                       if (ret)
>                                fbcon_generic_blank(vc, info, blank);
>                }
>
>



-- 
With best wishes
Dmitry
