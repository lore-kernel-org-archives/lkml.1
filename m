Return-Path: <linux-kernel-owner+w=401wt.eu-S1758326AbXJOHkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326AbXJOHkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 03:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbXJOHk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 03:40:26 -0400
Received: from smtp110.biz.mail.re2.yahoo.com ([206.190.53.9]:24967 "HELO
	smtp110.biz.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751869AbXJOHkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 03:40:25 -0400
X-YMail-OSG: E746dsgVM1mvAmaLgVcA3_S5BEXG81NEXEIYbLRcsesK3kVM
From: HighPoint Linux Team <linux@highpoint-tech.com>
Organization: HighPoint Technologies, Inc.
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] hptiop: avoid buffer overflow when returning sense data
Date: Mon, 15 Oct 2007 15:48:52 +0800
User-Agent: KMail/1.5.3
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200605101704.27491.linux@highpoint-tech.com> <200708291510.53793.linux@highpoint-tech.com> <200710151442.52230.linux@highpoint-tech.com>
In-Reply-To: <200710151442.52230.linux@highpoint-tech.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710151548.52588.linux@highpoint-tech.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> > 
> > avoid buffer overflow when returning sense data.
> > 
>
> That's really not enough information, sorry.
>
> > index 8b384fa..d32a4a9 100644
> > --- a/drivers/scsi/hptiop.c
> > +++ b/drivers/scsi/hptiop.c
> > @@ -375,8 +375,9 @@ static void hptiop_host_request_callback
> >  		scp->result = SAM_STAT_CHECK_CONDITION;
> >  		memset(&scp->sense_buffer,
> >  				0, sizeof(scp->sense_buffer));
> > -		memcpy(&scp->sense_buffer,
> > -			&req->sg_list, le32_to_cpu(req->dataxfer_length));
> > +		memcpy(&scp->sense_buffer, &req->sg_list,
> > +				min(sizeof(scp->sense_buffer),
> > +					le32_to_cpu(req->dataxfer_length)));
> >  		break;
> >  
> >  	default:
>
> See, we know what the fix does, but we don't know what the consequences are
> if the user's kernel doesn't have this fix.
> 
> So we are not able to work out whether this fix should be backported to
> 2.6.23.x and even to 2.6.22.x?

Sorry for ambiguity. With current adapter firmware the driver is working but future
firmware updates may return sense data larger than 96 bytes, causing overflow
on scp->sense_buffer and a kernel crash.

This fix should be backported to earlier kernels.

HighPoint Linux Team

