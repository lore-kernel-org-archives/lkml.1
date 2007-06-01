Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbXFAD0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbXFAD0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 23:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbXFAD0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 23:26:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:51207 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbXFAD0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 23:26:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=IP2C4UcyXjjMZlZ+21TvwGXbq9vuzASDXEtyqcCwlPckbqi5bTzZGs5B6ueKbmY3BxOgEQb2/8UkuBG6BumCLlbwmc2/QLhE+JR/Y6P8VQACCOjTxOadQ7KmxDYXEwhYEHhPUh3wJnjUcvOEV3kiFwhfdBiHXTYW3doATbf9Vyg=
Message-ID: <465F9197.7060002@gmail.com>
Date: Fri, 01 Jun 2007 12:25:11 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Stefan Bader <Stefan.Bader@de.ibm.com>
CC: Phillip Susi <psusi@cfl.rr.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices,
 filesystems, and dm/md.
References: <18006.38689.818186.221707@notabene.brown>	 <18010.12472.209452.148229@notabene.brown>	 <20070528094358.GM25091@agk.fab.redhat.com>	 <5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com>	 <20070529220500.GA6513@agk.fab.redhat.com>	 <5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com>	 <465DAC72.1010201@cfl.rr.com> <5201e28f0705310414u1a9aebc4je135748274543946@mail.gmail.com>
In-Reply-To: <5201e28f0705310414u1a9aebc4je135748274543946@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Bader wrote:
> 2007/5/30, Phillip Susi <psusi@cfl.rr.com>:
>> Stefan Bader wrote:
>> >
>> > Since drive a supports barrier request we don't get -EOPNOTSUPP but
>> > the request with block y might get written before block x since the
>> > disk are independent. I guess the chances of this are quite low since
>> > at some point a barrier request will also hit drive b but for the time
>> > being it might be better to indicate -EOPNOTSUPP right from
>> > device-mapper.
>>
>> The device mapper needs to ensure that ALL underlying devices get a
>> barrier request when one comes down from above, even if it has to
>> construct zero length barriers to send to most of them.
>>
> 
> And somehow also make sure all of the barriers have been processed
> before returning the barrier that came in. Plus it would have to queue
> all mapping requests until the barrier is done (if strictly acting
> according to barrier.txt).
> 
> But I am wondering a bit whether the requirements to barriers are
> really that tight as described in Tejun's document (barrier request is
> only started if everything before is safe, the barrier itself isn't
> returned until it is safe, too, and all requests after the barrier
> aren't started before the barrier is done). Is it really necessary to
> defer any further requests until the barrier has been written to save
> storage? Or would it be sufficient to guarantee that, if a barrier
> request returns, everything up to (including the barrier) is on safe
> storage?

Well, what's described in barrier.txt is the current implemented
semantics and what filesystems expect, so we can't change it underneath
them but we definitely can introduce new more relaxed variants, but one
thing we should bear in mind is that harddisks don't have humongous
caches or very smart controller / instruction set.  No matter how
relaxed interface the block layer provides, in the end, it just has to
issue whole-sale FLUSH CACHE on the device to guarantee data ordering on
the media.

IMHO, we can do better by paying more attention to how we do things in
the request queue which can be deeper and more intelligent than the
device queue.

Thanks.

-- 
tejun
