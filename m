Return-Path: <linux-kernel-owner+w=401wt.eu-S1763753AbYF3TDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763753AbYF3TDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756607AbYF3TCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:02:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:50484 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbYF3TCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:02:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aZCFmOIZ+KwLbv+Z51FLIoVmArjI1cvaORDq1aV6Stq9fuSr8JaW8hVaSsunUwVT+h
         2O+z9DW7DS0D/85qVWKMMGrkTBZ6FlcgdWJ8IJm53EUAYaME3qp3aPoQZ773TV0Szdsk
         o8ze6pHonRmI/y4hi72IdmA/KDDFvwszuZoAQ=
Message-ID: <48692DC0.6060904@gmail.com>
Date: Mon, 30 Jun 2008 14:02:24 -0500
From: Roger Heflin <rogerheflin@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Martin Sustrik <sustrik@fastmq.com>
CC: Martin Lucina <mato@kotelna.sk>, linux-kernel@vger.kernel.org
Subject: Re: Higher than expected disk write(2) latency
References: <20080628121131.GA14181@nodbug.moloch.sk> <48663873.5010200@gmail.com> <486921AD.8060308@fastmq.com>
In-Reply-To: <486921AD.8060308@fastmq.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Sustrik wrote:
> Hi Roger,
> 
>>> If these figures are to be believed, then why are we seeing latencies of
>>> 8.3 msec?  Is this normal?  Or are we just being overly optimistic in
>>> our performance expectations?
>>
>> Consider this, 60/7200rpm=8.3ms for one rotation.
>>
>> You write sector n and n+1, it takes some amount of time for that 
>> first set of sectors to come under the head, when it does you write it 
>> and immediately return.   Immediately after that you attempt write 
>> sector n+2 and n+3 which just a bit ago passed under the head, so you 
>> have to wait an *ENTIRE* revolution for those sectors to again come 
>> under the head to be written, another ~8.3ms, and you continue to 
>> repeat this with each block being written.   If the sector was 
>> randomly placed in the rotation (ie 50% chance of the disk being off 
>> by 1/2 a rotation or less-you would have a 4.15 ms average seek time 
>> for your test)-but the case of sequential sync writes this leaves the 
>> sector about as far as possible from the head (it just passed under 
>> the head).
> 
> Fair enough. That exaplains the behaviour. Would AIO help here? If we 
> are able to enqueue next write before the first one is finished, it can 
> start writing it immediately without waiting for a revolution.

If you could get them queued at the disk level, things that would need to be 
watched were if the disk can queue things up (and all controllers/drivers 
support it), and how many things the disk can queue up, and how large each of 
those things can be, if they aren't queued at the disk, there is the chance that 
the machine cannot get the data to the disk faster enough for that next sector.

I have always avoided fully sync operations as things *ALWAYS* got really really 
slow because of all of the requirements need to make sure that it always got the 
data to disk correctly on a unexpected crash, and typically the type of 
applications I dealt with, if the machine crashed the currently outputting data 
was known to be incomplete and generally useless, so things were reran.

Depending on your application you could always get a small fast solid state 
device (no seek or RPM issues), and use it to keep a journal that could be 
replayed on an unexpected crash...and then just use various syncs to force 
things to disk at various points.

> 
>>> We also ran the same test on a different system with recent SAS disks
>>> connected via a HP/Compaq CCISS controller.  I don't have the exact
>>> details of the drives used, since I don't know how to get them out of
>>> the cciss driver, but the latencies we got were around 4 msec.  Whilst
>>> this is better than the "commodity" hardware used in the tests above, it
>>> still seems excessive.
>>
>> Almost the same case as for the 7200 rpm disk, but I bet these SAS 
>> drives are 15k drives?   If so 60/15000=4ms.
> 
> Bingo!

Note that in my experience the SAS drives do deal with more concurrently a lot 
better than the SATA drives, one would expect a SAS drive to scale about 2x 
better than a SATA drive (faster RPM) but the test results indicate that they 
were considerably better when hitting it with more concurrent streams that would 
be expected.

                              Roger
