Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbYLCV3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbYLCV3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 16:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbYLCV3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 16:29:19 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55687 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753953AbYLCV3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 16:29:18 -0500
Date: Wed, 3 Dec 2008 16:29:17 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH-mm] usb: file_storage use unaligned endian helpers
 rather than private versions
In-Reply-To: <1228270993.5412.4.camel@brick>
Message-ID: <Pine.LNX.4.44L0.0812031615470.2181-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2008, Harvey Harrison wrote:

> Use the new helpers for unaligned endian access.  Make some small changes
> to reading 24-bit lba values, read the full 32 bit value and mask.  Produces
> smaller and faster code on x86 and on powerpc.
> 
> Coalesce some byte-writes in 32bit writes to allow byteswapping to happen
> at compile time and become a 32-bit write without swapping if possible (x86
> especially)
> 
> This shrinks the size of file_storage.o by ~64 bytes on x86_32.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Alan, what do you think?

Well, it looks correct... but it's awfully ugly.  Can't we keep the 
benefits of the new helpers while not messing the code up too much?

> --- a/drivers/usb/gadget/file_storage.c
> +++ b/drivers/usb/gadget/file_storage.c
> @@ -795,37 +795,6 @@ static int fsg_set_halt(struct fsg_dev *fsg, struct usb_ep *ep)
>  	return usb_ep_set_halt(ep);
>  }
>  
> -
> -/*-------------------------------------------------------------------------*/
> -
> -/* Routines for unaligned data access */
> -
> -static u16 get_be16(u8 *buf)
> -{
> -	return ((u16) buf[0] << 8) | ((u16) buf[1]);
> -}
> -
> -static u32 get_be32(u8 *buf)
> -{
> -	return ((u32) buf[0] << 24) | ((u32) buf[1] << 16) |
> -			((u32) buf[2] << 8) | ((u32) buf[3]);
> -}
> -
> -static void put_be16(u8 *buf, u16 val)
> -{
> -	buf[0] = val >> 8;
> -	buf[1] = val;
> -}
> -
> -static void put_be32(u8 *buf, u32 val)
> -{
> -	buf[0] = val >> 24;
> -	buf[1] = val >> 16;
> -	buf[2] = val >> 8;
> -	buf[3] = val & 0xff;
> -}

Suppose instead we do this:

#define get_be16(buf)	load_be16_noalign((be16 *) (buf))
#define get_be24(buf)	(load_be32_noalign((be32 *) (buf)) >> 8)
#define get_be32(buf)	load_be32_noalign((be32 *) (buf))

#define put_be16(buf, val)	store_be16_noalign((be16 *) (buf), val)
#define put_be32(buf, val)	store_be32_noalign((be32 *) (buf), val)

Then almost no more changes would be needed, only the 24-bit
consolidation stuff.

> @@ -1583,9 +1552,9 @@ static int do_read(struct fsg_dev *fsg)
>  	/* Get the starting Logical Block Address and check that it's
>  	 * not too big */
>  	if (fsg->cmnd[0] == SC_READ_6)
> -		lba = (fsg->cmnd[1] << 16) | get_be16(&fsg->cmnd[2]);
> +		lba = load_be32_noalign((__be32 *)&fsg->cmnd[0]) & 0xffffff;

Like this, which would become

		lba = get_be24(&fsg->cmnd[1]);

> @@ -2126,9 +2095,9 @@ static int do_request_sense(struct fsg_dev *fsg, struct fsg_buffhd *bh)
>  static int do_read_capacity(struct fsg_dev *fsg, struct fsg_buffhd *bh)
>  {
>  	struct lun	*curlun = fsg->curlun;
> -	u32		lba = get_be32(&fsg->cmnd[2]);
> +	u32		lba = load_be32_noalign((__be32 *)&fsg->cmnd[2]);
>  	int		pmi = fsg->cmnd[8];
> -	u8		*buf = (u8 *) bh->buf;
> +	__be32		*buf = (__be32 *)bh->buf;
>  
>  	/* Check the PMI and LBA fields */
>  	if (pmi > 1 || (pmi == 0 && lba != 0)) {
> @@ -2136,8 +2105,8 @@ static int do_read_capacity(struct fsg_dev *fsg, struct fsg_buffhd *bh)
>  		return -EINVAL;
>  	}
>  
> -	put_be32(&buf[0], curlun->num_sectors - 1);	// Max logical block
> -	put_be32(&buf[4], 512);				// Block length
> +	store_be32_noalign(&buf[0], curlun->num_sectors - 1);	// Max logical block
> +	store_be32_noalign(&buf[1], 512);			// Block length
>  	return 8;
>  }
>  

I don't like these changes.  You've gone from an array of bytes to an
array of 32-bit words, which doesn't agree with the data structures
defined in the SCSI specification.  Besides, with my new macros this
isn't needed.

What do you think?

Alan Stern

