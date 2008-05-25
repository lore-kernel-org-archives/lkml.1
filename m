Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbYEYPUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbYEYPUo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 11:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbYEYPUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 11:20:31 -0400
Received: from cnc.isely.net ([64.81.146.143]:56818 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbYEYPUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 11:20:08 -0400
Date: Sun, 25 May 2008 10:20:04 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       akpm@linux-foundation.org, Tyler Trafford <ttrafford@gmail.com>,
       Mike Isely at pobox <isely@pobox.com>
Subject: Re: [PATCHv2 04/28] cx25840: treat firmware data as const
In-Reply-To: <200805251251.32373.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0805251011540.25571@cnc.isely.net>
References: <1211708969@pmac.infradead.org> <E1K0DO1-0007D2-3d@shinybook.infradead.org>
 <200805251251.32373.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 May 2008, Hans Verkuil wrote:

> Hi David,
> 
> There is no need to do the first two bytes first. As far as I can tell 
> it was done to avoid having to allocate a local buffer. The initial 
> version of this code was writing much larger blocks at a time to the 
> i2c bus, so having to setup a large buffer on the stack was 
> undesirable. The pvrusb driver requires a much smaller buffer (FWSEND), 
> but the code was never changed. Now, however, the initial four-byte 
> write is just in the way and can be removed in favor of always writing 
> FWSEND-sized blocks of data.
> 
> I've CC-ed Mike Isely, the pvrusb2 maintainer, just in case there is an 
> outlandish restriction I'm not aware of on that USB device requiring 
> the firmware load to be done this way.
> 

The pvrusb2 driver's FWSEND limit is an artifact of the hardware and 
cannot be changed.  HOWEVER, in the standalone driver (not in the 
kernel) I have a hack implemented that can monitor and intercept such 
I2C operations and break them into smaller I2C transactions.  I 
implemented this to allow the standalone driver to function correctly on 
some older kernels where FWSEND is too large.  I can enable that hack 
for the kernel driver and thus lift the limit.  But without it, FWSEND 
absolutely has to be small enough that the entire transaction (including 
a few bytes of transport overhead) can fit within a 64 byte URB.

I see that this change allocates a local buffer on the stack (sized by 
FWSEND).  Though the buffer is small (48 bytes, see above paragraph), it 
is controlled by a macro and thus leaves open the possibility that it 
could be accidentally increased to a point where the stack gets 
overflowed.  Seems like not a good idea, but either way it should not 
affect the pvrusb2 driver.

Acked-By: Mike Isely <isely@pobox.com>

  -Mike


> Regards,
> 
> 	Hans
> 
> On Sunday 25 May 2008 12:23:33 David Woodhouse wrote:
> > Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> > ---
> >  drivers/media/video/cx25840/cx25840-firmware.c |   21
> > +++++++++++++-------- 1 files changed, 13 insertions(+), 8
> > deletions(-)
> >
> > diff --git a/drivers/media/video/cx25840/cx25840-firmware.c
> > b/drivers/media/video/cx25840/cx25840-firmware.c index
> > 620d295..5c08ede 100644
> > --- a/drivers/media/video/cx25840/cx25840-firmware.c
> > +++ b/drivers/media/video/cx25840/cx25840-firmware.c
> > @@ -79,7 +79,7 @@ static int check_fw_load(struct i2c_client *client,
> > int size) return 0;
> >  }
> >
> > -static int fw_write(struct i2c_client *client, u8 *data, int size)
> > +static int fw_write(struct i2c_client *client, const u8 *data, int
> > size) {
> >  	if (i2c_master_send(client, data, size) < size) {
> >  		v4l_err(client, "firmware load i2c failure\n");
> > @@ -93,7 +93,8 @@ int cx25840_loadfw(struct i2c_client *client)
> >  {
> >  	struct cx25840_state *state = i2c_get_clientdata(client);
> >  	const struct firmware *fw = NULL;
> > -	u8 buffer[4], *ptr;
> > +	u8 buffer[FWSEND];
> > +	const u8 *ptr;
> >  	int size, retval;
> >
> >  	if (state->is_cx23885)
> > @@ -108,6 +109,8 @@ int cx25840_loadfw(struct i2c_client *client)
> >
> >  	buffer[0] = 0x08;
> >  	buffer[1] = 0x02;
> > +
> > +	/* Do we really need to do the first two bytes first? */
> >  	buffer[2] = fw->data[0];
> >  	buffer[3] = fw->data[1];
> >  	retval = fw_write(client, buffer, 4);
> > @@ -118,19 +121,21 @@ int cx25840_loadfw(struct i2c_client *client)
> >  	}
> >
> >  	size = fw->size - 2;
> > -	ptr = fw->data;
> > +	ptr = fw->data + 2;
> >  	while (size > 0) {
> > -		ptr[0] = 0x08;
> > -		ptr[1] = 0x02;
> > -		retval = fw_write(client, ptr, min(FWSEND, size + 2));
> > +		int len = min(FWSEND - 2, size);
> > +
> > +		memcpy(buffer + 2, ptr, len);
> > +
> > +		retval = fw_write(client, ptr, len + 2);
> >
> >  		if (retval < 0) {
> >  			release_firmware(fw);
> >  			return retval;
> >  		}
> >
> > -		size -= FWSEND - 2;
> > -		ptr += FWSEND - 2;
> > +		size -= len;
> > +		ptr += len;
> >  	}
> >
> >  	end_fw_load(client);
> 
> 
> 

-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
