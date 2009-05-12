Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbZELPFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbZELPFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbZELPFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:05:35 -0400
Received: from sh.osrg.net ([192.16.179.4]:39965 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbZELPFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:05:34 -0400
Date: Wed, 13 May 2009 00:00:47 +0900
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, tj@kernel.org, axboe@kernel.dk,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com,
       sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com,
       stern@rowland.harvard.edu, zaitcev@redhat.com,
       Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au,
       grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net,
       jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com,
       dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com,
       davem@davemloft.net, rusty@rustcorp.com.au,
       Markus.Lidel@shadowconnect.com, dgilbert@interlog.com,
       djwong@us.ibm.com
Subject: Re: [PATCH 03/11] block: add rq->resid_len
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4A093A34.3020101@panasas.com>
References: <4A080C9D.9000109@panasas.com>
	<20090511235852Z.fujita.tomonori@lab.ntt.co.jp>
	<4A093A34.3020101@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090513000150H.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 13 May 2009 00:00:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009 11:58:28 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On 05/11/2009 05:59 PM, FUJITA Tomonori wrote:
> > On Mon, 11 May 2009 14:31:41 +0300
> > Boaz Harrosh <bharrosh@panasas.com> wrote:
> > 
> >>>>> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> >>>>> index 3da02e4..6605ec9 100644
> >>>>> --- a/drivers/scsi/libsas/sas_expander.c
> >>>>> +++ b/drivers/scsi/libsas/sas_expander.c
> >>>>> @@ -1936,12 +1936,8 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
> >>>>>  			       bio_data(rsp->bio), rsp->data_len);
> >>>>>  	if (ret > 0) {
> >>>>>  		/* positive number is the untransferred residual */
> >>>>> -		rsp->data_len = ret;
> >>>>> -		req->data_len = 0;
> >>>>> +		rsp->resid_len = ret;
> >>>>>  		ret = 0;
> >>>>> -	} else if (ret == 0) {
> >>>>> -		rsp->data_len = 0;
> >>>>> -		req->data_len = 0;
> >>>>>  	}
> >>>>>  
> >>>>>  	return ret;
> >>>> This is actually a bug fix, as well as a strait conversion
> >>> Can you elaborate a bit about the bug fix part?
> >>>
> >> Nothing big really, just that before (according to the comment), the theoretical
> >> negative case would be full-residual. and now it is zero (untouched).
> >>
> >> I know that in iscsi a negative residual is possible which means over-flow. That is:
> >> the target had more data to give then the buffer had space for. (which is not an error at all)
> > 
> > Hmm, iSCSI? This code is for SAS management Protocol.
> > 
> 
> I gave that as an example of what the scsi standard says about negative
> residual count return from the target. If SAS as sepecific and different
> meaning to negative residual, it should be noted and handled.

Please read the code first.

If sas_smp_handler() returns a negative value, a lld doesn't transfer
anything. The original code used full-residual. The original code is
fine. Your 'this is a bug fix' claim is wrong. We need to revert the
original behavior though.
