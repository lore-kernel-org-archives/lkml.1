Return-Path: <linux-kernel-owner+w=401wt.eu-S1756258AbZLKDUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbZLKDUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 22:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755845AbZLKDUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 22:20:18 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:30661 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755846AbZLKDUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 22:20:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wSE9Vu3C+P/CA9R8jDNYKHCIvYnYgqIAcrexXS5HgHyHpJ2PkeqNr7Mp6C/OtG+8nVmVUF0xDMrVjOExRIqzZnbRKYIqEvcl8oibXDMqGXrDJyFoPnJgzrN8/5M8MWGh0QmAPnyuy+O12ciJDB8I99+Mr+NPnCEXJWXjxPpKw3Q=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: qsvFhuYVM1nzJhODo3RsW62z27kNeqdtYzgmnQazkDvbNsLetwTSuDsewNmJ821PIVnBXuBCDuqxHP3SoLy2J8qtic6sxV0xlr4bFuCy1P.oeVeco2PWL727tHEl_w5uQuNnH2y9CJq4p3WLfoR.prHiL4aiors.EjmTdn5HOrcmujZlIBj0DW6MGb5985VPsImHseVglqs38BbU2pp4JDrA7253tQGe3euw48P6fMWx2dP7.dg7jcnk.ipL9ROl5yU.DcQANya0LxF5nZ2eQanZAThlFW4F_aKHNaYVBd10zaTvzrmTbsC3b8xw7KFeD6UtPakxan1H7VhFiEvGT2DS.B6WwjIU7Fxpxy9l7lfU2jTVvtTWDPhp1ShOLwE-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH] drivers/usb/gadget: Use ERR_PTR/IS_ERR
Date: Thu, 10 Dec 2009 19:20:21 -0800
User-Agent: KMail/1.9.10
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0912091422350.27028@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0912091422350.27028@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912101920.21635.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 December 2009, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Use ERR_PTR and IS_ERR rather than mixing integers and pointers.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression *E;
> @@
> 
> * E < 0
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

> 
> ---
>  drivers/usb/gadget/f_audio.c        |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/gadget/f_audio.c b/drivers/usb/gadget/f_audio.c
> index c43c89f..0f2eee1 100644
> --- a/drivers/usb/gadget/f_audio.c
> +++ b/drivers/usb/gadget/f_audio.c
> @@ -252,12 +252,12 @@ static struct f_audio_buf *f_audio_buffer_alloc(int buf_size)
>  
>  	copy_buf = kzalloc(sizeof *copy_buf, GFP_ATOMIC);
>  	if (!copy_buf)
> -		return (struct f_audio_buf *)-ENOMEM;
> +		return ERR_PTR(-ENOMEM);
>  
>  	copy_buf->buf = kzalloc(buf_size, GFP_ATOMIC);
>  	if (!copy_buf->buf) {
>  		kfree(copy_buf);
> -		return (struct f_audio_buf *)-ENOMEM;
> +		return ERR_PTR(-ENOMEM);
>  	}
>  
>  	return copy_buf;
> @@ -332,7 +332,7 @@ static int f_audio_out_ep_complete(struct usb_ep *ep, struct usb_request *req)
>  		list_add_tail(&copy_buf->list, &audio->play_queue);
>  		schedule_work(&audio->playback_work);
>  		copy_buf = f_audio_buffer_alloc(audio_buf_size);
> -		if (copy_buf < 0)
> +		if (IS_ERR(copy_buf))
>  			return -ENOMEM;
>  	}
>  
> @@ -576,6 +576,8 @@ static int f_audio_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
>  			usb_ep_enable(out_ep, audio->out_desc);
>  			out_ep->driver_data = audio;
>  			audio->copy_buf = f_audio_buffer_alloc(audio_buf_size);
> +			if (IS_ERR(audio->copy_buf))
> +				return -ENOMEM;
>  
>  			/*
>  			 * allocate a bunch of read buffers
> 
> 


