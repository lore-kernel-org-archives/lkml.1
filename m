Return-Path: <linux-kernel-owner+w=401wt.eu-S932747AbXBSWZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747AbXBSWZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 17:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932744AbXBSWZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 17:25:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34197 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756AbXBSWZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 17:25:18 -0500
Message-ID: <45DA23C7.6090800@torque.net>
Date: Mon, 19 Feb 2007 17:25:11 -0500
From: Douglas Gilbert <dougg@torque.net>
Reply-To: dougg@torque.net
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       James.Bottomley@steeleye.com
Subject: Re: [PATCH] Block layer: separate out queue-oriented ioctls
References: <Pine.LNX.4.44L0.0702191148421.13197-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0702191148421.13197-100000@netrider.rowland.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Mon, 19 Feb 2007, Joerg Schilling wrote:
> 
>> Alan Stern <stern@rowland.harvard.edu> wrote:
>>
>>> Well, if Doug wants to reduce the value returned by SG_GET_RESERVED_SIZE, 
>>> it's okay with me.  An advantage of doing this is that older versions of 
>>> cdrecord would then work correctly.
>>>
>>> However you don't seem to realize that people can use programs like
>>> cdrecord with devices whose drivers don't support SG_GET_RESERVED_SIZE --
>>> because that ioctl works only with sg.  Programs would have to try
>>> SG_GET_RESERVED_SIZE and if it faied, then try BLKSECTGET.
>> Is there any reason not to have one single ioctl for one basic feature?
> 
> Indeed there is not.  That's what I wrote in an earlier email:
> 
>   "There should be one single ioctl which can be applied uniformly to all
>   CD-type devices (in fact, to all devices using a request_queue) to learn
>   max_sectors.  This rules out using SG_GET_RESERVED_SIZE."
> 
>>> Remember also, the "reserved size" is _not_ the maximum allowed size of a
>>> DMA transfer.  Rather, it is the size of an internal buffer maintained by
>>> sg.  It's legal to do an I/O transfer larger than the "reserved size", but 
>>> it is not legal to do an I/O transfer larger than max_sectors.
>> At the time the call SG_GET_RESERVED_SIZE has been discussed/defined, we did 
>> originally agree that the max value should be limited to what the HW allows
>> as DMA size. This is why I did originally files a bug against 
>> SG_GET_RESERVED_SIZE.
> 
> How do you feel about the patch below, either in addition to or instead of 
> the previous patch?

Alan,
The SG_GET_RESERVED_SIZE ioctl is also defined in
the block layer, see block/scsi_ioctl.c .
I suspect it is just a kludge to fool cdrecord that it
is talking to a sg device. [One of many kludges in the
block SG_IO ioctl implementation to that end.]
So perhaps the block layer versions of SG_SET_RESERVED_SIZE
and SG_GET_RESERVED_SIZE need to be similarly capped.
Actually I think that I would default SG_GET_RESERVED_SIZE to
request_queue->max_sectors * 512 in the block layer
implementation (as there is no "reserve buffer" associated
with a block device).


<aside>
The idea of a reserved buffer may live on in bsg as experience
with sg has shown that it is the fastest way to do (mmap-ed) IO.
Having one reserved buffer per file descriptor means not
having to create and tear down a scatter gather list
per IO. [Having a pool of such lists would be even better.]
Until optical storage needs 10 times its current datarates
then cdrecord will not need this mechanism.
</aside>

Doug Gilbert


> Index: usb-2.6/drivers/scsi/sg.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/sg.c
> +++ usb-2.6/drivers/scsi/sg.c
> @@ -917,6 +917,8 @@ sg_ioctl(struct inode *inode, struct fil
>  			return result;
>                  if (val < 0)
>                          return -EINVAL;
> +		if (val > sdp->device->request_queue->max_sectors * 512)
> +			return -EOVERFLOW;
>  		if (val != sfp->reserve.bufflen) {
>  			if (sg_res_in_use(sfp) || sfp->mmap_called)
>  				return -EBUSY;
> @@ -925,7 +927,8 @@ sg_ioctl(struct inode *inode, struct fil
>  		}
>  		return 0;
>  	case SG_GET_RESERVED_SIZE:
> -		val = (int) sfp->reserve.bufflen;
> +		val = min_t(int, sfp->reserve.bufflen,
> +				sdp->device->request_queue->max_sectors * 512);
>  		return put_user(val, ip);
>  	case SG_SET_COMMAND_Q:
>  		result = get_user(val, ip);
> 

