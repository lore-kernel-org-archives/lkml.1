Return-Path: <linux-kernel-owner+w=401wt.eu-S932802AbXGLBUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802AbXGLBUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 21:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932264AbXGLBUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 21:20:06 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37164 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223AbXGLBUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 21:20:03 -0400
Message-ID: <469581BA.4010009@cs.wisc.edu>
Date: Wed, 11 Jul 2007 20:19:54 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jeremy Linton <jli@greshamstorage.com>
CC: James Bottomley <James.Bottomley@SteelEye.com>,
       Linux Scsi <linux-scsi@vger.kernel.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][BUG] Incorrect SCSI transfer length computation from
 odd sized scsi_execute_async() transfers.
References: <46957820.9090008@greshamstorage.com>
In-Reply-To: <46957820.9090008@greshamstorage.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Linton wrote:
> Any function which use scsi_execute_async() and transfers "odd" sized 
> data that doesn't align correctly with the segment sizes may have its 
> transfer length padded out to the closest segment size.
> 
> For writes, this results in unnecessary data being transfered to the 
> SCSI target. For reads, it affects the residual data length being 
> returned to the application since the residual length will be based on 
> the padded transfer size rather than the actual request size.
> 
> The easiest way to see this is by trying to read using the SG_IO ioctl a 
> large (>32k) buffer size from a tape device that only has a few bytes of 
> data stored for the current block. The resulting resid will generally be 
> incorrect.
> 
> I've fixed this simply by changing scsi_req_map_sg() so that it places 
> the requested transfer length in rq->data_len rather than the sum of all 
> the sg segments.
> 
> This patch applies against scsi_lib.c in 2.6.22.
> 
> Signed-off-by: Jeremy Linton <jli@greshamstorage.com>
> 
> 
> --- linux-2.6.22/drivers/scsi/scsi_lib.c.orig   2007-07-11 
> 19:07:06.000000000 -0500
> +++ linux-2.6.22/drivers/scsi/scsi_lib.c        2007-07-11 
> 18:43:36.000000000 -0500
> @@ -350,7 +350,7 @@ static int scsi_req_map_sg(struct reques
>         }
> 
>         rq->buffer = rq->data = NULL;
> -       rq->data_len = data_len;
> +       rq->data_len = bufflen;
>         return 0;
> 

I think you needed some other bits in there. See this patch 
http://marc.info/?l=linux-scsi&m=117392208211297&w=2

I tried just setting the bufflen first, and that still had problems. 
Could you try the patch here

http://marc.info/?l=linux-scsi&m=117392208211297&w=2
