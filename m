Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbZELI7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbZELI7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 04:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbZELI7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 04:59:42 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:19396 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750943AbZELI7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 04:59:41 -0400
Message-ID: <4A093A34.3020101@panasas.com>
Date: Tue, 12 May 2009 11:58:28 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: tj@kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org,
       jeff@garzik.org, linux-ide@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
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
References: <4A06DFAB.40205@panasas.com>	<4A0767E5.5050205@kernel.org>	<4A080C9D.9000109@panasas.com> <20090511235852Z.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090511235852Z.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 May 2009 08:58:35.0104 (UTC) FILETIME=[D5120E00:01C9D2DF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2009 05:59 PM, FUJITA Tomonori wrote:
> On Mon, 11 May 2009 14:31:41 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>>>>> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
>>>>> index 3da02e4..6605ec9 100644
>>>>> --- a/drivers/scsi/libsas/sas_expander.c
>>>>> +++ b/drivers/scsi/libsas/sas_expander.c
>>>>> @@ -1936,12 +1936,8 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>>>>>  			       bio_data(rsp->bio), rsp->data_len);
>>>>>  	if (ret > 0) {
>>>>>  		/* positive number is the untransferred residual */
>>>>> -		rsp->data_len = ret;
>>>>> -		req->data_len = 0;
>>>>> +		rsp->resid_len = ret;
>>>>>  		ret = 0;
>>>>> -	} else if (ret == 0) {
>>>>> -		rsp->data_len = 0;
>>>>> -		req->data_len = 0;
>>>>>  	}
>>>>>  
>>>>>  	return ret;
>>>> This is actually a bug fix, as well as a strait conversion
>>> Can you elaborate a bit about the bug fix part?
>>>
>> Nothing big really, just that before (according to the comment), the theoretical
>> negative case would be full-residual. and now it is zero (untouched).
>>
>> I know that in iscsi a negative residual is possible which means over-flow. That is:
>> the target had more data to give then the buffer had space for. (which is not an error at all)
> 
> Hmm, iSCSI? This code is for SAS management Protocol.
> 

I gave that as an example of what the scsi standard says about negative
residual count return from the target. If SAS as sepecific and different
meaning to negative residual, it should be noted and handled.

> smp_execute_task returns a negative value for some errors (ENOMEM, the
> hardware doesn't respond, etc). It's not related with 'transferred
> buffer length' at all.

This is a serious problem, and a violation of the block/scsi stacks. If so, then
in that case error/status should be set properly. And residual cleared.

Failing to return an error might theoretically be catastrophic. If what
you say is certain then previous behaviour is better then after this patch.

I'm not at all familiar with this code. Could you send a patch to
fix these things?

Thanks
Boaz
