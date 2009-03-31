Return-Path: <linux-kernel-owner+w=401wt.eu-S1754372AbZCaK3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbZCaK3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 06:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbZCaK3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 06:29:42 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:16581 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750897AbZCaK3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 06:29:41 -0400
Message-ID: <49D1F01C.7020307@panasas.com>
Date: Tue, 31 Mar 2009 13:27:40 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 4/8 ver5] exofs: address_space_operations
References: <49C1331D.1080805@panasas.com>	<1237399473-29344-1-git-send-email-bharrosh@panasas.com>	<49C64416.4060801@panasas.com>	<20090331010420.8a12810e.akpm@linux-foundation.org>	<49D1DCA4.6010306@panasas.com> <20090331031523.fcf01cae.akpm@linux-foundation.org>
In-Reply-To: <20090331031523.fcf01cae.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Mar 2009 10:29:38.0659 (UTC) FILETIME=[9840E330:01C9B1EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2009 01:15 PM, Andrew Morton wrote:
> On Tue, 31 Mar 2009 12:04:36 +0300 Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>>>> +static int write_exec(struct page_collect *pcol)
>>>> +{
>>>> +	struct exofs_i_info *oi = exofs_i(pcol->inode);
>>>> +	struct osd_obj_id obj = {pcol->sbi->s_pid,
>>>> +					pcol->inode->i_ino + EXOFS_OBJ_OFF};
>>>> +	struct osd_request *or = NULL;
>>>> +	struct page_collect *pcol_copy = NULL;
>>>> +	loff_t i_start = pcol->pg_first << PAGE_CACHE_SHIFT;
>>> bug.  On 32-bit this shift will overflow prior to getting promoted to
>>> 64-bit.  Do:
>>>
>>> 	loff_t i_start = (loff_t)pcol->pg_first << PAGE_CACHE_SHIFT;
>>>
>> In that case I might make pcol->pg_first loff_t.
> 
> That would work.
> 
>> Why is inode->i_index not an loff_t then?
> 
> hm, what's i_index?
> 

sorry, I meant page index

>> Page-index <=> byte-offset, is done all the time 12 bits does not
>> make a difference.
> 
> Page indices are 32-bit on 32-bit CPUs.  File offsets are 64-bit.  We
> are careful to avoid the above overflow bug whenever the conversion
> from page index to file size is made.  Try
> 
> 	fgrep '(loff_t)' mm/*.c
> 

right! which means that Linux does not support 64 bit offsets on
32 bit, but only 44 bits. But I guess exofs will not change that.

Boaz
