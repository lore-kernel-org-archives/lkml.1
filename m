Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbZDSIwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbZDSIwE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 04:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbZDSIvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 04:51:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:48993 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbZDSIvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 04:51:50 -0400
Message-ID: <49EAE602.3090802@kernel.org>
Date: Sun, 19 Apr 2009 17:51:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Nikanth Karthikesan <knikanth@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] make hd_struct->in_flight atomic to avoid	diskstat
  corruption
References: <200904161254.41433.knikanth@suse.de> <20090416073557.GU5178@kernel.dk> <200904161445.03955.knikanth@suse.de> <49E74377.6050209@kernel.org> <20090416163254.GQ5178@kernel.dk>
In-Reply-To: <20090416163254.GQ5178@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 19 Apr 2009 08:51:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Jens Axboe wrote:
> On Thu, Apr 16 2009, Tejun Heo wrote:
>> Hello, Nikanth, Jens.
>>
>> Nikanth Karthikesan wrote:
>>>> Hmm. Did you observe this behaviour?
>>> Sorry, not on current kernels. But on a very old 2.6.5 kernel.
>>>
>>> Reading Documentation/iostats.txt and the changelog of commit 
>>> e71bf0d0ee89e51b92776391c5634938236977d5 made me assume that this could be a 
>>> problem even today.
>> The only problem we can run into there is if a request doesn't get
>> attributed to a partition on issue but gets attributed to a partition
>> on completion, which seems to be possible if a new partition is added
>> while IO on the whole device which fell into the new partition area is
>> already in progress, which, on the first glance, seems possible if the
>> admin tries really hard.  I think we can get around the problem by
>> doing part->in_flight = min(max(new_val, part0->in_flight), 0) in
>> dec_in_flight().  This is pretty extreme corner case tho.
> 
> Heh, that is pretty extreme. I'd prefer just quiescing the queue,
> perhaps we should do that for partition map swaps.

Yeah, I think that would be the better approach for swapping ptbl.
RCU isn't really necessary there.

Thanks.

-- 
tejun
