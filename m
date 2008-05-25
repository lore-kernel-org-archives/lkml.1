Return-Path: <linux-kernel-owner+w=401wt.eu-S1760760AbYEYKz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbYEYKz6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbYEYKzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:55:20 -0400
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1143 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbYEYKzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:55:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCHv2 04/28] cx25840: treat firmware data as const
Date: Sun, 25 May 2008 12:51:32 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org, Tyler Trafford <ttrafford@gmail.com>,
       Mike Isely <isely@isely.net>
References: <1211708969@pmac.infradead.org> <E1K0DO1-0007D2-3d@shinybook.infradead.org>
In-Reply-To: <E1K0DO1-0007D2-3d@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805251251.32373.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

There is no need to do the first two bytes first. As far as I can tell 
it was done to avoid having to allocate a local buffer. The initial 
version of this code was writing much larger blocks at a time to the 
i2c bus, so having to setup a large buffer on the stack was 
undesirable. The pvrusb driver requires a much smaller buffer (FWSEND), 
but the code was never changed. Now, however, the initial four-byte 
write is just in the way and can be removed in favor of always writing 
FWSEND-sized blocks of data.

I've CC-ed Mike Isely, the pvrusb2 maintainer, just in case there is an 
outlandish restriction I'm not aware of on that USB device requiring 
the firmware load to be done this way.

Regards,

	Hans

On Sunday 25 May 2008 12:23:33 David Woodhouse wrote:
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> ---
>  drivers/media/video/cx25840/cx25840-firmware.c |   21
> +++++++++++++-------- 1 files changed, 13 insertions(+), 8
> deletions(-)
>
> diff --git a/drivers/media/video/cx25840/cx25840-firmware.c
> b/drivers/media/video/cx25840/cx25840-firmware.c index
> 620d295..5c08ede 100644
> --- a/drivers/media/video/cx25840/cx25840-firmware.c
> +++ b/drivers/media/video/cx25840/cx25840-firmware.c
> @@ -79,7 +79,7 @@ static int check_fw_load(struct i2c_client *client,
> int size) return 0;
>  }
>
> -static int fw_write(struct i2c_client *client, u8 *data, int size)
> +static int fw_write(struct i2c_client *client, const u8 *data, int
> size) {
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
> @@ -108,6 +109,8 @@ int cx25840_loadfw(struct i2c_client *client)
>
>  	buffer[0] = 0x08;
>  	buffer[1] = 0x02;
> +
> +	/* Do we really need to do the first two bytes first? */
>  	buffer[2] = fw->data[0];
>  	buffer[3] = fw->data[1];
>  	retval = fw_write(client, buffer, 4);
> @@ -118,19 +121,21 @@ int cx25840_loadfw(struct i2c_client *client)
>  	}
>
>  	size = fw->size - 2;
> -	ptr = fw->data;
> +	ptr = fw->data + 2;
>  	while (size > 0) {
> -		ptr[0] = 0x08;
> -		ptr[1] = 0x02;
> -		retval = fw_write(client, ptr, min(FWSEND, size + 2));
> +		int len = min(FWSEND - 2, size);
> +
> +		memcpy(buffer + 2, ptr, len);
> +
> +		retval = fw_write(client, ptr, len + 2);
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


