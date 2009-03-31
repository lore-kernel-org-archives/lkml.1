Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbZCaIpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbZCaIpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 04:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbZCaIpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 04:45:19 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:63113 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbZCaIpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 04:45:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AasYLWB6S4cMBUbilHnyT3a+WIBsJC2RaqHE4lTW5DBHhRSyUUfioB3rZ2HrUrhVo1
         5ILCpafc0owoDHcAeOoZd2RioVN0oJL06n51kxOv/u7940gjnl4sFxOV9D4z6s5DgLfg
         la0ceEk+kiCacEIGwjWUlzfPRv9W3ObP/2kPI=
Message-ID: <49D1D7A3.40303@panasas.com>
Date: Tue, 31 Mar 2009 11:43:15 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: petkovbb@gmail.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: Re: [PATCHSET pata-2.6] ide: rq->buffer, data, special and misc	cleanups
References: <1237910776-10983-1-git-send-email-tj@kernel.org> <200903281451.01361.bzolnier@gmail.com> <20090328140405.GA2741@liondog.tnic> <49D08CEC.3010705@kernel.org> <49D0A985.7090307@panasas.com> <49D0FF56.3080205@kernel.org>
In-Reply-To: <49D0FF56.3080205@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2009 08:20 PM, Tejun Heo wrote:
> Boaz Harrosh wrote:
>>> P.S.: Boaz, the above patchset implements blk_rq_map_kern_sgl() 
>> What is blk_rq_map_kern_sgl() ? I'm not sure I remember ?
>> What is it's API? and what does it do?
>>
>>> and kills the SCSI layer hack.  That was the issue you were trying
>>> to solve, right?
>> If you post URL of git tree I can have a look and start an early review
>> if you want
> 
> Here's the patchset.  It builds but I haven't even booted it yet, so
> expect some breakages.
> 
>   http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=map-untested
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git map-untested
> 
> Thanks.
> 

Hi Tejun.

I hope you have not been working on stabilizing this code yet, I've just seen
it this mornning (Israel time). It has obvious bugs, in the use of scatterlists.

But before you go running to fix them. Don't. I don't like the scatter-list API
at all. We where working hard to remove them from scsi and I don't like them
for block layer either. 

If it is for my personal needs then all I need is a simple:
"I have this bio please attach it to a request". The reason I have a bio
is because it comes from a filesystem and because I will be needing to use
the raid engines that are bio based.

I must have confused you with my blk_rq_map_pages() patches, these where made just
as an example of the ugliness and fragility of not using bios. It was suppose to be
a bad example, not to be accepted. (Hence the absence of my Singed-off-by:)

Scatterlists are bad because they are two times too fat for what they do here, they
need to be allocated, chained and slabbed, and finally they need to be converted to
a bio. Working directly with a bio is the shortest route.

Looking at the patches it seems you are changing them as I write (git-web is freezing)
So I sending this mail now. I was in the process of looking at them from the beginning.

So far it looks like a very deep change, I have some comments, but it will need a proper
review.

I do not understand what was your intention for the blk_rq_map_kern_sgl() how's
the user for it?

BTW: now you absolutely must do something with the name of blk_rq_map_sg() which does not
do any mapping and does not change request at all.

Boaz
