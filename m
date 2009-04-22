Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbZDVNYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbZDVNYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 09:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbZDVNYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 09:24:34 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:1888 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbZDVNYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 09:24:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Y5C5EZhsRFYK8cEqpd47D6aO8eZTXVcSDfAN5n4YD4WrP/M7BIojkwzZYMTnSMnLpW
         MT4cJ2Geq9oaKhRSXluUOMRNNnDIUssXvCSKZH6PpewqCf9He1j0Pfq4vuqQ23Ktl2xA
         z7hB6BIP0AEJ3Qndlq1xPgef2IRIuZZJ1z2qE=
Message-ID: <49EF1A88.1040105@panasas.com>
Date: Wed, 22 Apr 2009 16:24:24 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Vladislav Bolkhovitin <vst@vlnb.net>, Tejun Heo <tj@kernel.org>
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Douglas Gilbert <dgilbert@interlog.com>, Christoph Hellwig <hch@lst.de>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] [Target_Core_Mod/pSCSI]: Add optional legacy	scsi_execute_async()
 usage for Linux/SCSI passthrough
References: <1239930560.4176.577.camel@haakon2.linux-iscsi.org> <49EB036B.8090607@panasas.com> <49EDB8EF.7040503@vlnb.net>
In-Reply-To: <49EDB8EF.7040503@vlnb.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2009 03:15 PM, Vladislav Bolkhovitin wrote:
> Boaz Harrosh, on 04/19/2009 02:56 PM wrote:
>> On 04/17/2009 04:09 AM, Nicholas A. Bellinger wrote:
> 
> [..]
> 
>> Are you aware that scsi_execute_async() has gone in 2.6.30-rc1?
>>
>> I'm not sure what would be the best alternative for you. I would say
>> a bio, but it is still being debated. Your current options are:
>>
>> 1. bio_alloc then loop () bio_add_pc_page, and finally blk_rq_append_bio
>>    (Which block people don't like)
>> 2. sglist => page-pointers-array translation and blk_rq_map_user with 
>>    struct rq_map_data mode. (not possible with all kind of sglists)
>> 2. sglist => iovec translation and blk_rq_map_user_iov()
>>    (Very very ugly mapping of pages to virtual pointers)
>>
>> I have a similar situation with my OSD code.
> 
> Do you have somewhere in it a need to run an arbitrary CDB with data 
> pages stored in an sglist? Is that code accepted in the mainline?
> 

No, I have a direct bio which comes from two sources.
1. A bio prepared by a filesystem to describe a write/read to a file (osd object)
2. A cloned bio that comes from a stacking block-device over osd-object.

So I do not have an sglist at all, anywhere in code.

> If yes, why not to resurrect the necessary bits of scsi_execute_async() 
> (option (1) above)? It was deleted, because in 2.6.30 there are no users 
> of it left, but if there are users (OSD), then why not to return it? 
> Seems nothing better for the sg->bio case can be invented.
> 

I hate scsi_execute_async() for lots of reasons, 
1. The cover-up of an historical abuse of sglists by sg/sr
2. Override of use_sg/data-pointer crap
3. What is data-format got to do with sync/async execution
4. the need of all that scsi_io_context and the re-invention
   of async_done API.
5. ...
Good riddence

But you might be looking into an API introduced by an RFC by
Tejun Heo in the form of blk_rq_map_kern_sgl() which should
be a more appropriate general API for your use.
(And is not directly usable for me in OSD)

> Vlad

Boaz
