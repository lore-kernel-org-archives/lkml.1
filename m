Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbZELAaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbZELAaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 20:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757280AbZELA3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 20:29:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:37017 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756359AbZELA3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 20:29:50 -0400
Message-ID: <4A08C26E.80801@kernel.org>
Date: Tue, 12 May 2009 09:27:26 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com,
       sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com,
       stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp,
       zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com,
       sfr@canb.auug.org.au, grant.likely@secretlab.ca,
       paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com,
       adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org,
       schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net,
       rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com,
       Doug Gilbert <dgilbert@interlog.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 03/11] block: add rq->resid_len
References: <1241423927-11871-1-git-send-email-tj@kernel.org> <1241423927-11871-4-git-send-email-tj@kernel.org> <4A06DFAB.40205@panasas.com> <4A0767E5.5050205@kernel.org> <4A080C9D.9000109@panasas.com>
In-Reply-To: <4A080C9D.9000109@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 12 May 2009 00:27:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Boaz.

Boaz Harrosh wrote:
> On 05/11/2009 02:48 AM, Tejun Heo wrote:
>> Does resid_len make any sense w/ failed requests?  I think we would be
>> better off with declaring residual count to be undefined on request
>> failure.  Is there any place which depends on it?
>>
>> That said, the value is eventually exported to userland, so it might
>> be better to not change it.  Eh... I don't know.
> 
> When possible, residual should be exact because the residual amount
> is not bounced and might even be zeroed-out for security, as the
> meaning of residual is that these bytes are garbage.

When a request failed, the whole buffer is garbage.  There's no
partial transfer.  There shouldn't be.  I don't think residual count
on request failure means anything.  Also, the 'whenever possible'
doesn't mean much when the issuer can't determine whether the value is
valid or not.  On success, we should guarantee resid count is valid,
on failure, I don't see a way we can.

>>>> index 3da02e4..6605ec9 100644
>>>> --- a/drivers/scsi/libsas/sas_expander.c
>>>> +++ b/drivers/scsi/libsas/sas_expander.c
>>>> @@ -1936,12 +1936,8 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>>>>  			       bio_data(rsp->bio), rsp->data_len);
>>>>  	if (ret > 0) {
>>>>  		/* positive number is the untransferred residual */
>>>> -		rsp->data_len = ret;
>>>> -		req->data_len = 0;
>>>> +		rsp->resid_len = ret;
>>>>  		ret = 0;
>>>> -	} else if (ret == 0) {
>>>> -		rsp->data_len = 0;
>>>> -		req->data_len = 0;
>>>>  	}
>>>>  
>>>>  	return ret;
>>> This is actually a bug fix, as well as a strait conversion
>> Can you elaborate a bit about the bug fix part?
> 
> Nothing big really, just that before (according to the comment), the
> theoretical negative case would be full-residual. and now it is zero
> (untouched).

Yeah, the same thing as above, I suppose.

> I know that in iscsi a negative residual is possible which means
> over-flow. That is: the target had more data to give then the buffer
> had space for. (which is not an error at all)

Hmm... I've never seen negative residual in use.  Is it even defined?

>>> The above is just a case of:
>>>
>>> -		int leftover = (req->hard_nr_sectors << 9);
>>> -
>>> -		if (blk_pc_request(req))
>>> -			leftover = req->data_len;
>>> +		int leftover = blk_rq_bytes();
>>>
>>> Which you separated into to stages, much later right?
>> Aieee.. yeah, that's one stupid misconversion.  That function should
>> just use blk_end_request_all().  Will fix.  Thanks for spotting it.
> 
> Yes, there is a couple of other places that have that with the
> meaning of blk_end_request_all() (Have I commented on one?). Are you
> doing this conversion in these patchset? or this is for a second
> pass?

If you spot some, please go ahead and submit patches.  I don't have
any patch in my queue which hasn't been posted.

Thanks.

-- 
tejun
