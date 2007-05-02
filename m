Return-Path: <linux-kernel-owner+w=401wt.eu-S1767230AbXEBS7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767230AbXEBS7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767231AbXEBS7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:59:31 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:59126 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767230AbXEBS73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:59:29 -0400
Date: Wed, 2 May 2007 20:57:16 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Grant Likely <grant.likely@secretlab.ca>, Jens Axboe <axboe@kernel.dk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add support for Xilinx SystemACE CompactFlash interface.
In-Reply-To: <20070502004557.6d61b180.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0705022047330.18504@yvahk01.tjqt.qr>
References: <11780881962680-git-send-email-grant.likely@secretlab.ca>
 <20070502004557.6d61b180.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 2 2007 00:45, Andrew Morton wrote:
>> +static void ace_identin_8(struct ace_device *ace)
>> +{
>> +	void* r = ace->baseaddr + 0x40;
>> +	int i = ACE_FIFO_SIZE/2;
>> +	while (i--)
>> +#if defined(__BIG_ENDIAN)
>> +		*ace->data_ptr++ = (in_8(r)) | (in_8(r+1)<<8);
>> +#else
>> +		*ace->data_ptr++ = (in_8(r)<<8) | (in_8(r+1));
>> +#endif
>> +}
>
>This ifdeffery appears in several places.  SUggest the addition of a helper
>function which does it in a single place.

*ace->data_ptr++ = le16_to_cpu((in_8(r)<<8) | (in_8(r+1)));

could help.

>> +#define ace_identin(ace)		ace->reg_ops->identin(ace)
>> +#define ace_datain(ace)			ace->reg_ops->datain(ace)
>> +#define ace_dataout(ace)		ace->reg_ops->dataout(ace)
>
>inline functions are preferred.  The above is a strange mixture of inlines
>and macros.  Can they all be made inlines?

First, a () pair is lacking, it should - for safety - be
	(ace)->reg_ops->dataout(ace)
and since it may be evaluated twice too, inlines are a definite yes.

>> +/* FSM tasks; used to direct state transitions */
>> +#define ACE_TASK_IDLE      0
>> +#define ACE_TASK_IDENTIFY  1
>> +#define ACE_TASK_READ      2
>> +#define ACE_TASK_WRITE     3
>> +#define ACE_FSM_NUM_TASKS  4
>> +
>> +/* FSM state definitions */
>> +#define ACE_FSM_STATE_IDLE               0
>> +#define ACE_FSM_STATE_REQ_LOCK           1
>> +#define ACE_FSM_STATE_WAIT_LOCK          2
>> +#define ACE_FSM_STATE_WAIT_CFREADY       3
>> +#define ACE_FSM_STATE_IDENTIFY_PREPARE   4
>> +#define ACE_FSM_STATE_IDENTIFY_TRANSFER  5
>> +#define ACE_FSM_STATE_IDENTIFY_COMPLETE  6
>> +#define ACE_FSM_STATE_REQ_PREPARE        7
>> +#define ACE_FSM_STATE_REQ_TRANSFER       8
>> +#define ACE_FSM_STATE_REQ_COMPLETE       9
>> +#define ACE_FSM_STATE_ERROR             10
>> +#define ACE_FSM_NUM_STATES              11

enums for good!

>> +#if defined(DEBUG)
>> +const char* ace_statenames[ACE_FSM_NUM_STATES] = {
>> +	"idle",
>> +	"req lock",
>> +	"wait lock",
>> +	"wait cf ready",
>> +	"identify prepare",
>> +	"identify transfer",
>> +	"identify complete",
>> +	"request prepare",
>> +	"request transfer",
>> +	"request complete",
>> +};
>> +#endif
>
>Can these have static storage class?

And const please :) IOW,

static const char *const ace_statenames

Btw, ACE_FSM_NUM_STATES is defines as 11 above, but I only see 10
elements in that array. Intentional?

Also, should this be unintentional, and the number state names
matches ACE_FSM_NUM_STATES, an array of unspecified size may do
the trick.

>Who owns gendisk.private_data?  Is it the device driver?  I've never
>looked...

Check out loop.c, it gives some hints who owns that. :)



Jan
-- 
