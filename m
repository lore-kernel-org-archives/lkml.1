Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbYEYPiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbYEYPiD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 11:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbYEYPhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 11:37:54 -0400
Received: from cnc.isely.net ([64.81.146.143]:42658 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674AbYEYPhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 11:37:53 -0400
Date: Sun, 25 May 2008 10:37:51 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: David Woodhouse <dwmw2@infradead.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       akpm@linux-foundation.org, Tyler Trafford <ttrafford@gmail.com>,
       Mike Isely at pobox <isely@pobox.com>
Subject: Re: [PATCHv2 04/28] cx25840: treat firmware data as const
In-Reply-To: <1211727367.31212.119.camel@shinybook.infradead.org>
Message-ID: <Pine.LNX.4.64.0805251037080.25571@cnc.isely.net>
References: <1211708969@pmac.infradead.org>  <E1K0DO1-0007D2-3d@shinybook.infradead.org>
  <200805251251.32373.hverkuil@xs4all.nl> <1211727367.31212.119.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 May 2008, David Woodhouse wrote:

> Hm, looks like I was also passing the wrong pointer to fw_write().
> Here's the new version...
> 
> commit 57dc4762554119ffb5c711b2716f47997bc5c181
> Author: David Woodhouse <dwmw2@infradead.org>
> Date:   Fri May 23 23:58:24 2008 +0100
> 
>     cx25840: treat firmware data as const
>     
>     Signed-off-by: David Woodhouse <dwmw2@infradead.org>

Just to be technically correct, this is what I tested successfully with 
the pvrusb2 driver.

Acked-By: Mike Isely <isely@pobox.com>

  -Mike


> 
> diff --git a/drivers/media/video/cx25840/cx25840-firmware.c b/drivers/media/video/cx25840/cx25840-firmware.c
> index 620d295..8d489a4 100644
> --- a/drivers/media/video/cx25840/cx25840-firmware.c
> +++ b/drivers/media/video/cx25840/cx25840-firmware.c
> @@ -79,7 +79,7 @@ static int check_fw_load(struct i2c_client *client, int size)
>  	return 0;
>  }
>  
> -static int fw_write(struct i2c_client *client, u8 *data, int size)
> +static int fw_write(struct i2c_client *client, const u8 *data, int size)
>  {
>  	if (i2c_master_send(client, data, size) < size) {
>  		v4l_err(client, "firmware load i2c failure\n");
> @@ -93,7 +93,8 @@ int cx25840_loadfw(struct i2c_client *client)
>  {
>  	struct cx25840_state *state = i2c_get_clientdata(client);
>  	const struct firmware *fw = NULL;
> -	u8 buffer[4], *ptr;
> +	u8 buffer[FWSEND];
> +	const u8 *ptr;
>  	int size, retval;
>  
>  	if (state->is_cx23885)
> @@ -108,29 +109,23 @@ int cx25840_loadfw(struct i2c_client *client)
>  
>  	buffer[0] = 0x08;
>  	buffer[1] = 0x02;
> -	buffer[2] = fw->data[0];
> -	buffer[3] = fw->data[1];
> -	retval = fw_write(client, buffer, 4);
>  
> -	if (retval < 0) {
> -		release_firmware(fw);
> -		return retval;
> -	}
> -
> -	size = fw->size - 2;
> +	size = fw->size;
>  	ptr = fw->data;
>  	while (size > 0) {
> -		ptr[0] = 0x08;
> -		ptr[1] = 0x02;
> -		retval = fw_write(client, ptr, min(FWSEND, size + 2));
> +		int len = min(FWSEND - 2, size);
> +
> +		memcpy(buffer + 2, ptr, len);
> +
> +		retval = fw_write(client, buffer, len + 2);
>  
>  		if (retval < 0) {
>  			release_firmware(fw);
>  			return retval;
>  		}
>  
> -		size -= FWSEND - 2;
> -		ptr += FWSEND - 2;
> +		size -= len;
> +		ptr += len;
>  	}
>  
>  	end_fw_load(client);
> 
> 

-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
