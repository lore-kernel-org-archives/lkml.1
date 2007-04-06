Return-Path: <linux-kernel-owner+w=401wt.eu-S933231AbXDFQhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231AbXDFQhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 12:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933230AbXDFQhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 12:37:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34476 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933231AbXDFQha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 12:37:30 -0400
Message-ID: <4616761F.2050905@torque.net>
Date: Fri, 06 Apr 2007 12:32:31 -0400
From: Douglas Gilbert <dougg@torque.net>
Reply-To: dougg@torque.net
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Andrew Burgess <aab@cichlid.com>, cebbert@redhat.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       aradford@gmail.com
Subject: Re: Oops in scsi_send_eh_cmnd 2.6.21-rc5-git6,7,10,13
References: <200704061551.l36FpWoV015751@cichlid.com> <1175876096.3677.24.camel@mulgrave.il.steeleye.com>
In-Reply-To: <1175876096.3677.24.camel@mulgrave.il.steeleye.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Fri, 2007-04-06 at 08:51 -0700, Andrew Burgess wrote:
>> James Bottomley wrote:
>>
>>> It's actually a long standing bug in the 3w-xxxx driver.  Apparently it
>>> assumes request sense is always the use_sg == 0 case.  This is what it
>>> does on a request sense:
>>> static int tw_scsiop_request_sense(TW_Device_Extension *tw_dev, int request_id)
>>> {
>>>        dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_request_sense()\n");
>>>        /* For now we just zero the request buffer */
>>>        memset(tw_dev->srb[request_id]->request_buffer, 0, tw_dev->srb[request_id]->request_bufflen);
>>>        tw_dev->state[request_id] = TW_S_COMPLETED;
>>>        tw_state_request_finish(tw_dev, request_id);
>>> ....
>>> Note that it's clearing the request buffer, which is actually zeroing the scatterlist, hence the problem.
>> OK. Is there a quick workaround or should I just wait for
>> Adam & Company to make a patch?
> 
> Try this ... I think it's roughly the correct fix.
> 
>> You said your earlier patch would hide it, and then said you
>> had a length wrong in it and I'm not sure what length you
>> mean.
> 
> It's the length specifier in the error handler request sense command ...
> I'll fix it up and redo my patch through scsi-misc, since it's not going
> to fix the root cause of the problem.
> 
> James
> 
> diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
> index bf5d63e..6b303ba 100644
> --- a/drivers/scsi/3w-xxxx.c
> +++ b/drivers/scsi/3w-xxxx.c
> @@ -1864,10 +1864,17 @@ static int tw_scsiop_read_write(TW_Device_Extension *tw_dev, int request_id)
>  /* This function will handle the request sense scsi command */
>  static int tw_scsiop_request_sense(TW_Device_Extension *tw_dev, int request_id)
>  {
> +	char request_buffer[18];
> +
>  	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_request_sense()\n");
>  
> -	/* For now we just zero the request buffer */
> -	memset(tw_dev->srb[request_id]->request_buffer, 0, tw_dev->srb[request_id]->request_bufflen);
> +	memset(request_buffer, 0, sizeof(request_buffer));
> +	request_buffer[0] = 0x70; /* Immediate fixed format */
> +	request_buffer[7] = 11;	/* minimum size per SPC: 18 bytes */

James,
That last line should be:
        request_buffer[7] = 10;	/* minimum size per SPC: 18 bytes */

Doug Gilbert
