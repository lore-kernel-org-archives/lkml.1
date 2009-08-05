Return-Path: <linux-kernel-owner+w=401wt.eu-S933470AbZHEFEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470AbZHEFEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 01:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933368AbZHEFEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 01:04:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:22325 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933237AbZHEFEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 01:04:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent:message-id;
        b=UQbW+Fi6GrrEtKxSSgBgvJ92Eaa1KN6qyRhVPB2ncaEppCJEcfSet8o86ZsPqIGbyl
         zA/4Guox2a25aHJYtSXYHs7ctIViY5ektNnDQgnROFLxPMkRv2pGTgEel7no+jm1GfnT
         ck76EbwnMn4Nc7yKfbfW/iTMmwy2D3LH3tTpg=
Date: Tue, 4 Aug 2009 22:04:43 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
Cc: linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, kwangwoo.lee@gmail.com,
       Thierry Reding <thierry.reding@avionic-design.de>,
       Trilok Soni <soni.trilok@gmail.com>
Subject: Re: [PATCH 2/2] tsc2007: reduced number of I2C transfers
References: <4A69DDED.50402@mocean-labs.com> <20090724180022.GA6477@dtor-d630.eng.vmware.com> <4A6A0D77.6000600@mocean-labs.com> <20090726080212.GA24365@dtor-d630.eng.vmware.com> <4A7825B3.1010806@mocean-labs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A7825B3.1010806@mocean-labs.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090805050445.1C034526EA5@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 02:12:35PM +0200, Richard Röjfors wrote:
> Dmitry Torokhov wrote:
>>
>> I modified the patch a bit before applying. In fact there were a few
>> changes to all the patces so it would be nice if you could take a look
>> at the 'next' branch of my tree:
>>
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git next
>>
>> Also, I di dnot quite like the logic of the patch making
>> get_pendown_state callback optional; could you please try the patch
>> below and let me know of it works for you?
>
> I like your changes, there is just a small miss while checking the  
> platform data. You forgot to remove the check for get_pen_down_state in  
> the probe function, see the patch below (to be applied on top of yours):
>
> I also would like a check if the power down failed or not during probe.
>
> --Richard
>
> Input: tsc2007 - Check if I2C communication works during probe
>
> Check the result when sending the power down command to the controller.
>
> Signed-off-by: Richard Röjfors <richard.rojfors.ext@mocean-labs.com>
> ---
> Index: linux-2.6.31-rc2/drivers/input/touchscreen/tsc2007.c
> ===================================================================
> --- linux-2.6.31-rc2/drivers/input/touchscreen/tsc2007.c	(revision 1071)
> +++ linux-2.6.31-rc2/drivers/input/touchscreen/tsc2007.c	(revision 1073)
> @@ -269,7 +269,7 @@
>  	struct input_dev *input_dev;
>  	int err;
>
> -	if (!pdata || !pdata->get_pendown_state) {
> +	if (!pdata) {
>  		dev_err(&client->dev, "platform data is required!\n");
>  		return -EINVAL;
>  	}


Ah, yes, thanks.

> @@ -326,10 +326,14 @@
>  	i2c_set_clientdata(client, ts);
>
>  	/* Prepare for touch readings - power down ADC and enable PENIRQ */
> -	tsc2007_xfer(ts, PWRDOWN);
> +	err = tsc2007_xfer(ts, PWRDOWN);
> +	if (err < 0)
> +		goto err_unreg_dev;
>
>  	return 0;
>
> + err_unreg_dev:
> +	input_unregister_device(ts->input);

This will case double free.. I will adjust locally.

>   err_free_irq:
>  	tsc2007_free_irq(ts);
>  	if (pdata->exit_platform_hw)

-- 
Dmitry
