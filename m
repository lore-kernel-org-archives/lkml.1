Return-Path: <linux-kernel-owner+w=401wt.eu-S1759303AbZE0Hzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303AbZE0Hzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbZE0Hzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:55:46 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:28198 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753889AbZE0Hzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:55:44 -0400
Message-ID: <4A1CF1C1.2000607@panasas.com>
Date: Wed, 27 May 2009 10:54:41 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com,
       rdreier@cisco.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, yanmin_zhang@linux.intel.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense
 buffer
References: <1243349222.2815.22.camel@localhost.localdomain>	<20090527003152X.fujita.tomonori@lab.ntt.co.jp>	<4A1C1331.8060304@panasas.com> <20090527103637W.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090527103637W.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2009 07:54:48.0068 (UTC) FILETIME=[682CF440:01C9DEA0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2009 04:36 AM, FUJITA Tomonori wrote:
> On Tue, 26 May 2009 19:05:05 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> On 05/26/2009 06:31 PM, FUJITA Tomonori wrote:
>>> Can we just fix some drivers not to do the DMA with the sense buffer in
>>> scsi_cmnd? IIRC, there are only five or six drivers that do such.
>> This is not so.
>> All drivers that go through scsi_eh_prep_cmnd() will eventually DMA through
>> the regular read path. Including all the drivers that do nothing and let
>> scsi-ml do the REQUEST_SENSE
>>
>> Actually I have exact numbers, from the last time I did all that
> 
> Hmm, we discussed this before, I think.
> 

Sure we did I sent these patches. to summarize, 3 types of drivers:
1. Only memcpy into sense_buffer				- 60%
2. Use scsi_eh_prep_cmnd and DMA read into sense.
2.1 Do nothing and scsi-ml does scsi_eh_prep_cmnd		- 30%
3. Prepare DMA descriptors for sense_buffer before execution	- 10%

> scsi-ml uses scsi_eh_prep_cmnd only via scsi_send_eh_cmnd(). There are
> some users of scsi_send_eh_cmnd in scsi-ml but only scsi_request_sense
> does the DMA in the sense_buffer of scsi_cmnd.
> 

Also drivers use scsi_eh_prep_cmnd at interrupt time and proceed to
DMA into the sense_buffer.

> Only scsi_error_handler() uses scsi_request_sense() and
> scsi_send_eh_cmnd() works synchronously. So scsi-ml can easily avoid
> the the DMA in the sense_buffer of scsi_cmnd if we have one sense
> buffer per scsi_host.

Not so. As James explained then, once you have a CHECK_CONDITION return, the
Q-per-host is frozen, yes. But as soon as you send the REQUEST_SENSE the 
target Q is unfrozen again and all in-flight commands can error, much before
the REQUEST_SENSE returns.

Boaz
