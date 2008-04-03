Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbYDCORg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbYDCORg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 10:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbYDCOR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 10:17:27 -0400
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:33460 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321AbYDCOR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 10:17:26 -0400
Message-ID: <47F4E694.4060103@panasas.com>
Date: Thu, 03 Apr 2008 17:15:48 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: schwidefsky@de.ibm.com
CC: linux-kernel@vger.kernel.org, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com,
       jens.axboe@oracle.com, zaitcev@redhat.com
Subject: Re: kernel BUG at drivers/block/ub.c:820!
References: <1207212156.5602.5.camel@localhost>	 <47F4C044.1090609@panasas.com> <1207231045.9155.6.camel@localhost>
In-Reply-To: <1207231045.9155.6.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03 2008 at 16:57 +0300, Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> On Thu, 2008-04-03 at 14:32 +0300, Boaz Harrosh wrote:
>>> With git bisect I could came up with:
>>> 610d8b0c972e3b75493efef8e96175518fd736d3 good
>>> 3bcddeac1c4c7e6fb90531b80f236b1a05dfe514 compile error
>>> 5450d3e1d68f10be087f0855d8bad5458b50ecbe compile error
>>> b8286239ddaf2632cec65c01e68a403ac4c3d079 compile error
>>> 7d699bafe258ebd8f9b4ec182c554200b369a504 bad
>>>
>>> If I replace the BUG() with a printk my kernel survives the usb plug but
>>> udev doesn't find the stick.
>>>
>> It is not the right fix but what happens if you change above code to this:
>>
>> static void ub_end_rq(struct request *rq, unsigned int scsi_status)
>> {
>>         int error;
>>
>>         if (scsi_status == 0) {
>>                 error = 0;
>>         } else {
>>                 error = -EIO;
>>                 rq->errors = scsi_status;
>>         }
>>         if (__blk_end_request(rq, error, blk_rq_bytes(rq)))
>>                 __blk_end_request(rq, error, ~0);  /* <-- added line BUG removed. */
>>         }
>> }
> 
> I've tried this patch:
> 
> --- snip
> diff --git a/drivers/block/ub.c b/drivers/block/ub.c
> index c452e2d..0031e72 100644
> --- a/drivers/block/ub.c
> +++ b/drivers/block/ub.c
> @@ -808,7 +808,7 @@ static void ub_rw_cmd_done(struct ub_dev *sc, struct ub_scsi_cmd *cmd)
>  
>  static void ub_end_rq(struct request *rq, unsigned int scsi_status)
>  {
> -	int error;
> +	int error, size;
>  
>  	if (scsi_status == 0) {
>  		error = 0;
> @@ -816,8 +816,12 @@ static void ub_end_rq(struct request *rq, unsigned int scsi_status)
>  		error = -EIO;
>  		rq->errors = scsi_status;
>  	}
> -	if (__blk_end_request(rq, error, blk_rq_bytes(rq)))
> -		BUG();
> +	size = blk_rq_bytes(rq);
> +	if (__blk_end_request(rq, error, size)) {
> +		  printk(KERN_WARNING "ub_end_rq: __blk_end_request failed "
> +			 "with size %i\n", size);
> +		__blk_end_request(rq, error, ~0);
> +	}
>  }
>  
>  static int ub_rw_cmd_retry(struct ub_dev *sc, struct ub_lun *lun,
> 
> --- snip
> 
> The output on the console:
> 
> # usb 5-4: new high speed USB device using ehci_hcd and address 3
> # usb 5-4: configuration #1 chosen from 1 choice
> #  uba: uba1
> # usbcore: registered new interface driver ub
> # Initializing USB Mass Storage driver...
> # usbcore: registered new interface driver usb-storage
> # USB Mass Storage support registered.
> # ub_end_rq: __blk_end_request failed with size 218
> # ub_end_rq: __blk_end_request failed with size 218
> # ub_end_rq: __blk_end_request failed with size 218
> # ub_end_rq: __blk_end_request failed with size 218
> 
> I can mount the stick and read files from it without any additional
> warnings. Just the initial detection seems to create the odd sized
> requests.
> 

OK So first this confirms that for ages the ub.c driver was leaking BIO's
on first connection. Just that it was never noticed before.

or that we have a BLOCK_PC at hand but before the 7d699baf patch
we completed with - rq->hard_nr_sectors << 9 - where now blk_rq_bytes(rq)
will return 218 which is less. Could you also put rq->hard_nr_sectors
in the print above?

Did you mange to find what is that 218 bytes command. Put a WARN_ON(1)
in ub_request_fn_1 for any command that has a blk_rq_bytes(rq) of 218
so we'll see who issues these commands. And what is the real bug.

Boaz
