Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbZEOWSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbZEOWSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 18:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbZEOWSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 18:18:39 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:47497 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbZEOWSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 18:18:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Zfevynwrmwlhk/Iw/STxCcG1IAc+SDwOKQtzM2I7ICr9z8Fb+Y4ou1TyHfYX04c4pP
         jfMtcfD/KNThYQg3aKwNjsr2dDQUTPv+BT8yJaM9ComRGmOS9jQv2A3jZ88VkvYzrop7
         W54Cjh/2H7MasKjPcv5jNvSlWo5vYmSoeJnJo=
Message-ID: <4A0DEA33.5050905@gmail.com>
Date: Sat, 16 May 2009 07:18:27 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Pete Zaitcev <zaitcev@redhat.com>, Eric Moore <Eric.Moore@lsi.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH block#for-2.6.31 2/3] block: set rq->resid_len to blk_rq_bytes()
 on issue
References: <4A0D86DB.9000203@kernel.org> <4A0D87D2.7090806@gmail.com> <4A0D8C73.50208@ru.mvista.com>
In-Reply-To: <4A0D8C73.50208@ru.mvista.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sergei Shtylyov wrote:
>> Index: block/drivers/message/fusion/mptsas.c
>> ===================================================================
>> --- block.orig/drivers/message/fusion/mptsas.c
>> +++ block/drivers/message/fusion/mptsas.c
>> @@ -1357,7 +1357,8 @@ static int mptsas_smp_handler(struct Scs
>>          smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
>>          memcpy(req->sense, smprep, sizeof(*smprep));
>>          req->sense_len = sizeof(*smprep);
>> -        rsp->resid_len = blk_rq_bytes(rsp) - smprep->ResponseDataLength;
>> +        req->resid_len = 0;
>> +        rsp->resid_len -= smprep->ResponseDataLength;
> 
>    Is negative resid_len intended here? If so, shouldn't it be simply:
> 
>         rsp->resid_len = -smprep->ResponseDataLength;

>From patch description.

 This patchset restores the original behavior by setting rq->resid_len
 to blk_rq_bytes(rq) on issue and restoring explicit clearing in
 affected drivers.

So, rsp->resid_len equals the initial request length before the
subtraction and after subtraction it becomes the residue count.  The
original code was

	req->data_len = 0;
	rsp->data_len -= smprep->ResponseDataLength;

>> Index: block/drivers/scsi/libsas/sas_expander.c
>> ===================================================================
>> --- block.orig/drivers/scsi/libsas/sas_expander.c
>> +++ block/drivers/scsi/libsas/sas_expander.c
>> @@ -1937,7 +1937,11 @@ int sas_smp_handler(struct Scsi_Host *sh
>>      if (ret > 0) {
>>          /* positive number is the untransferred residual */
>>          rsp->resid_len = ret;
>> +        req->resid_len = 0;
>>          ret = 0;
>> +    } else if (ret == 0) {
>> +        rsp->resid_len = 0;
>> +        req->resid_len = 0;

Heh... there's a reason I mentioned the original commit.  The original
code was

	if (ret > 0) {
		/* positive number is the untransferred residual */
		rsp->data_len = ret;
		req->data_len = 0;
		ret = 0;
	} else if (ret == 0) {
		rsp->data_len = 0;
		req->data_len = 0;
	}

>> Index: block/drivers/scsi/libsas/sas_host_smp.c
>> ===================================================================
>> --- block.orig/drivers/scsi/libsas/sas_host_smp.c
>> +++ block/drivers/scsi/libsas/sas_host_smp.c
>> @@ -176,9 +176,6 @@ int sas_smp_host_handler(struct Scsi_Hos
>>      resp_data[1] = req_data[1];
>>      resp_data[2] = SMP_RESP_FUNC_UNK;
>>  
>> -    req->resid_len = blk_rq_bytes(req);
>> -    rsp->resid_len = blk_rq_bytes(rsp);
>> -

Cuz it's already set to blk_rq_bytes().

>>      switch (req_data[1]) {
>>      case SMP_REPORT_GENERAL:
>>          req->resid_len -= 8;
>> Index: block/drivers/scsi/mpt2sas/mpt2sas_transport.c
>> ===================================================================
>> --- block.orig/drivers/scsi/mpt2sas/mpt2sas_transport.c
>> +++ block/drivers/scsi/mpt2sas/mpt2sas_transport.c
>> @@ -1170,8 +1170,8 @@ transport_smp_handler(struct Scsi_Host *
>>  
>>          memcpy(req->sense, mpi_reply, sizeof(*mpi_reply));
>>          req->sense_len = sizeof(*mpi_reply);
>> -        rsp->resid_len = blk_rq_bytes(rsp) -
>> -                 mpi_reply->ResponseDataLength;
>> +        req->resid_len = 0;
>> +        rsp->resid_len -= mpi_reply->ResponseDataLength;
> 
>    Again, is negative resid_len intended?

Ditto.

Thanks.

-- 
tejun
