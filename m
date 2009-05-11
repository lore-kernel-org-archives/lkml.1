Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbZEKPDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbZEKPDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbZEKPDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:03:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:33542 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbZEKPDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:03:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:sender:to:cc:subject:from:in-reply-to:references:mime-version
         :content-type:content-transfer-encoding:message-id:lines;
        b=PhE3YQOUuLgXJe1T2eLHKRjGwnZNv0MfUZ3aCyVh0F+roRVtQ6gMlB8Js688c9Dseg
         0cWZy/pXkkvZ7+evwo5hBUfiXqsE5ZqGAHv/JA3C/mdNKzsCNp2Q9RQVBMr4lvjLXzTw
         aoQMM+zEvNb0c+A+Dmlq5QjwRvW4u1pKSbR9M=
Date: Mon, 11 May 2009 08:03:06 -0700 (PDT)
To: James.Bottomley@HansenPartnership.com
Cc: fujita.tomonori@lab.ntt.co.jp, tj@kernel.org, bharrosh@panasas.com,
       axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com,
       mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu,
       zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com,
       sfr@canb.auug.org.au, grant.likely@secretlab.ca,
       paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com,
       adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org,
       schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net,
       rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com,
       dgilbert@interlog.com, djwong@us.ibm.com
Subject: Re: [PATCH 03/11] block: add rq->resid_len
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1242051500.3338.9.camel@mulgrave.int.hansenpartnership.com>
References: <4A0767E5.5050205@kernel.org>
	<20090511145024B.fujita.tomonori@lab.ntt.co.jp>
	<1242051500.3338.9.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090512000249E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 09:18:20 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Mon, 2009-05-11 at 14:49 +0900, FUJITA Tomonori wrote:
> > On Mon, 11 May 2009 08:48:53 +0900
> > Tejun Heo <tj@kernel.org> wrote:
> > 
> > > Hello, Boaz.
> > > 
> > > Boaz Harrosh wrote:
> > > 
> > > > Hi Tejun, I've carefully reviewed these files which I know more
> > > > about.  The drivers/block files I've skipped, since I'm not familiar
> > > > with this code.
> > > > 
> > > > Except a small fallout, it looks very good. See some comments plus
> > > > Ack/review below
> > > 
> > > Thanks a lot for reviewing it closely.  It's really nice to have
> > > careful extra pair of eyes on the changes.  :-)
> > > 
> > > >> --- a/drivers/message/fusion/mptsas.c
> > > >> +++ b/drivers/message/fusion/mptsas.c
> > > >> @@ -1357,8 +1357,7 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
> > > >>  		smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
> > > >>  		memcpy(req->sense, smprep, sizeof(*smprep));
> > > >>  		req->sense_len = sizeof(*smprep);
> > > >> -		req->data_len = 0;
> > > >> -		rsp->data_len -= smprep->ResponseDataLength;
> > > >> +		rsp->resid_len = rsp->data_len - smprep->ResponseDataLength;
> > > >>  	} else {
> > > >>  		printk(MYIOC_s_ERR_FMT "%s: smp passthru reply failed to be returned\n",
> > > >>  		    ioc->name, __func__);
> > > > 
> > > > I think original code was assuming full residual count on the else side
> > > > (not MPT_IOCTL_STATUS_RF_VALID). So maybe add:
> > > > 
> > > > +		rsp->resid_len = rsp->data_len;
> > > 
> > > Does resid_len make any sense w/ failed requests?  I think we would be
> > > better off with declaring residual count to be undefined on request
> > > failure.  Is there any place which depends on it?
> > 
> > IIRC, I wrote the code. I think that this doesn't matter but it's
> > better not to change the behavior unless Eric ack on this change
> > (maybe LSI has some management binary that assume this behavior though
> > it's unlikely).
> 
> Actually, yes it does, for many possible reasons.
> 
> The first being if the device is too stupid to report an actual sector
> location the next best way of determining where the error occurred is
> from the residual.  We don't make use of this in kernel (perhaps we
> should?) but some of the user space programs for CD/DVD burning do.

This function is for SAS management protocol. Are there many possible
reasons?
