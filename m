Return-Path: <linux-kernel-owner+w=401wt.eu-S1761983AbZFKDTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761983AbZFKDTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 23:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756670AbZFKDTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 23:19:34 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:34494 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbZFKDTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 23:19:34 -0400
Message-ID: <4A307771.10303@ct.jp.nec.com>
Date: Thu, 11 Jun 2009 12:18:09 +0900
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Tejun Heo <tj@kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, k-ueda@ct.jp.nec.com
Subject: Re: [PATCH block#for-2.6.31] block: add request clone interface
References: <4A2E1490.7060902@ct.jp.nec.com> <20090609180344.GQ11363@kernel.dk> <4A2F1741.8090100@ct.jp.nec.com> <4A2F66ED.80206@panasas.com>
In-Reply-To: <4A2F66ED.80206@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boaz,

On 06/10/2009 04:55 PM +0900, Boaz Harrosh wrote:
> On 06/10/2009 05:15 AM, Kiyoshi Ueda wrote:
>> On 06/10/2009 03:03 AM +0900, Jens Axboe wrote:
>>> On Tue, Jun 09 2009, Kiyoshi Ueda wrote:
>>>> Hi Jens,
>>>>
>>>> +/*
>>>> + * Copy request information of the original request to the clone request.
>>>> + */
>>>> +static void __blk_rq_prep_clone(struct request *dst, struct request *src)
>>>> +{
>>>> +	dst->cpu = src->cpu;
>>>> +	dst->cmd_flags = (rq_data_dir(src) | REQ_NOMERGE);
>>>> +	dst->cmd_type = src->cmd_type;
>>>> +	dst->__sector = blk_rq_pos(src);
>>>> +	dst->__data_len = blk_rq_bytes(src);
>>>> +	dst->nr_phys_segments = src->nr_phys_segments;
>>>> +	dst->ioprio = src->ioprio;
>>>> +	dst->buffer = src->buffer;
>>>> +	dst->cmd_len = src->cmd_len;
>>>> +	dst->cmd = src->cmd;
>>> Are you making sure that 'src' always exists while 'dst' is alive?
>> Yes.
>> Request-based dm is the owner of 'src' (original) and
>> it never frees 'src' until the 'dst' (clone) are completed.
>>
>> I avoided deep-copying __cmd/buffer/sense as it's costly
>> (additional allocation and memcpy).
> 
> For my needs for example dst->cmd will be different then
> src->cmd. Could be untouched. The caller will set what he
> needs.
> 
> dst->sense should be untouched, caller can set to src->sense
> if he wants to. Or like me he already have another buffer.
> 
> dst->buffer is always NULL in my path so I don't know
> what that is. Tejun?
> 
> It should only be about bios and lengths.
> 
> And a big fat comment about what it does and what it
> does not.

OK, I removed ->cmd, ->sense and ->buffer from __blk_rq_prep_clone()
and added some documents.
Please see the updated patch:
    http://marc.info/?l=dm-devel&m=124468991432260&w=2

Thanks,
Kiyoshi Ueda
