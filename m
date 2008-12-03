Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbYLCQTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbYLCQTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 11:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbYLCQTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 11:19:03 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59324 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005AbYLCQTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 11:19:02 -0500
Subject: Re: [PATCH] [SCSI] libsas: fix test for negative unsigned and typos
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: roel kluin <roel.kluin@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <49316E4C.7070808@gmail.com>
References: <49316E4C.7070808@gmail.com>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 10:19:01 -0600
Message-Id: <1228321141.5551.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-11-29 at 11:31 -0500, roel kluin wrote:
> unsigned req->data_len cannot be negative, and fix typo
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> I am not sure whether this is what was intended, please review.

I think it was.  The fix looks like we need it.  However:

> diff --git a/drivers/scsi/libsas/sas_host_smp.c b/drivers/scsi/libsas/sas_host_smp.c
> index 16f9312..6eb0779 100644
> --- a/drivers/scsi/libsas/sas_host_smp.c
> +++ b/drivers/scsi/libsas/sas_host_smp.c
> @@ -199,12 +199,12 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
>  		break;
>  
>  	case SMP_DISCOVER:
> -		req->data_len =- 16;
> -		if (req->data_len < 0) {
> +		if (req->data_len < 15) {
>  			req->data_len = 0;
>  			error = -EINVAL;
>  			goto out;
>  		}

What I don't like about this code is the magic numbers for lengths.
This patch now doubles them (and makes them even more magic by having <
n-1).  How about fixing it like this instead:

if ((int)req->data_len < 0) {
...

That way the signed comparison just works if there was a negative
overflow?

Thanks,

James


