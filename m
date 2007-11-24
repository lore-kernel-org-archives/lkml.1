Return-Path: <linux-kernel-owner+w=401wt.eu-S1752955AbXKXFTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbXKXFTz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 00:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbXKXFTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 00:19:45 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:44519 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbXKXFTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 00:19:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=e/QSxsumDSEHW7FNdglXsTpJKPxIjFXDun7CbMPcqq5Sb1GQoG0ubpqW1FwAiB9CTqI/vfv0KmJ+g9/cYAqiS0mQl0dOdONjFw5oKSWyw3s42u0QqMSnibYp0YYBUYmtWf//xB5mwM3mSQpyopxEu7l0WMO3Mm2fKZv7WAm5OQA=
Message-ID: <4747B46A.5000503@gmail.com>
Date: Sat, 24 Nov 2007 14:19:38 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] sata_nv: don't use legacy DMA in ADMA mode (v2)
References: <47463580.8080909@shaw.ca> <4747B3BB.4000708@gmail.com>
In-Reply-To: <4747B3BB.4000708@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Robert Hancock wrote:
>> We need to run any DMA command with result taskfile requested in ADMA mode
>> when the port is in ADMA mode, otherwise it may try to use the legacy DMA engine
>> in ADMA mode which is not allowed. Enforce this with BUG_ON() since data
>> corruption could potentially result if this happened. Also WARN_ON() if we try
>> and send result taskfile commands while NCQ commands are still active, since the
>> hardware doesn't allow this.
>>
>> Signed-off-by: Robert Hancock <hancockr@shaw.ca>
>>
>> @@ -1425,9 +1427,17 @@
>> +	/* We can't handle result taskfile with NCQ commands active, since
>> +	   retrieving the taskfile switches us out of ADMA mode and would abort
>> +	   existing commands. */
>> +	WARN_ON((qc->flags & ATA_QCFLAG_RESULT_TF) &&
>> +		(qc->ap->qc_allocated & ~(1 << qc->tag)));
> 
> I owe an apology here.  ap->qc_allocated & ~(1 << qc->tag) test isn't
> correct.  Sorry.  qc deferring happens after qc is allocated so the
> condition can trigger (although it should be rare) even when nothing is
> going wrong, so I guess it should be WARN_ON((qc->flags &
> ATA_QCFLAG_RESULT_TF) && link->sactive).

Or, just make the assumption clear by not allowing NCQ w/ RESULT_TF at all.

	if (unlikely(qc->tf.protocol == ATA_PROT_NCQ &&
		     (qc->flags & ATA_QCFLAG_RESULT_TF)) {
		ata_dev_printk(qc->dev, KERN_ERR,
			       "NCQ w/ RESULT_TF not allowed\n");
		return AC_ERR_SYSTEM;
	}

Thanks.

-- 
tejun
