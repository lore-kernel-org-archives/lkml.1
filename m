Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbZEKFyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbZEKFyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 01:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbZEKFyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 01:54:08 -0400
Received: from sh.osrg.net ([192.16.179.4]:50652 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbZEKFyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 01:54:06 -0400
Date: Mon, 11 May 2009 14:49:09 +0900
To: tj@kernel.org
Cc: bharrosh@panasas.com, axboe@kernel.dk, linux-kernel@vger.kernel.org,
       jeff@garzik.org, linux-ide@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com,
       mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu,
       fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com,
       Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au,
       grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net,
       jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com,
       dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com,
       davem@davemloft.net, rusty@rustcorp.com.au,
       Markus.Lidel@shadowconnect.com, dgilbert@interlog.com,
       djwong@us.ibm.com
Subject: Re: [PATCH 03/11] block: add rq->resid_len
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4A0767E5.5050205@kernel.org>
References: <1241423927-11871-4-git-send-email-tj@kernel.org>
	<4A06DFAB.40205@panasas.com>
	<4A0767E5.5050205@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090511145024B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 11 May 2009 14:49:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 08:48:53 +0900
Tejun Heo <tj@kernel.org> wrote:

> Hello, Boaz.
> 
> Boaz Harrosh wrote:
> 
> > Hi Tejun, I've carefully reviewed these files which I know more
> > about.  The drivers/block files I've skipped, since I'm not familiar
> > with this code.
> > 
> > Except a small fallout, it looks very good. See some comments plus
> > Ack/review below
> 
> Thanks a lot for reviewing it closely.  It's really nice to have
> careful extra pair of eyes on the changes.  :-)
> 
> >> --- a/drivers/message/fusion/mptsas.c
> >> +++ b/drivers/message/fusion/mptsas.c
> >> @@ -1357,8 +1357,7 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
> >>  		smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
> >>  		memcpy(req->sense, smprep, sizeof(*smprep));
> >>  		req->sense_len = sizeof(*smprep);
> >> -		req->data_len = 0;
> >> -		rsp->data_len -= smprep->ResponseDataLength;
> >> +		rsp->resid_len = rsp->data_len - smprep->ResponseDataLength;
> >>  	} else {
> >>  		printk(MYIOC_s_ERR_FMT "%s: smp passthru reply failed to be returned\n",
> >>  		    ioc->name, __func__);
> > 
> > I think original code was assuming full residual count on the else side
> > (not MPT_IOCTL_STATUS_RF_VALID). So maybe add:
> > 
> > +		rsp->resid_len = rsp->data_len;
> 
> Does resid_len make any sense w/ failed requests?  I think we would be
> better off with declaring residual count to be undefined on request
> failure.  Is there any place which depends on it?

IIRC, I wrote the code. I think that this doesn't matter but it's
better not to change the behavior unless Eric ack on this change
(maybe LSI has some management binary that assume this behavior though
it's unlikely).
