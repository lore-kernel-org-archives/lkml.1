Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbZLCDUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbZLCDUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 22:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbZLCDUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 22:20:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38449 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbZLCDUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 22:20:15 -0500
Message-ID: <4B172E38.1020208@zytor.com>
Date: Wed, 02 Dec 2009 19:19:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: seperate reserve_early and reserve_early_overlap_check
References: <4B0CF1B3.1050200@kernel.org> <4B17199F.1000804@zytor.com> <4B1722F0.6030308@kernel.org>
In-Reply-To: <4B1722F0.6030308@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2009 06:31 PM, Yinghai Lu wrote:
>> 1. Renaming reserve_early() to reserve_early_overlap_check() is most
>> likely going to get overlooked, and people will use the "new"
>> reserve_early() thinking that they got the old one.
> kill reserve_early()
> and use
> reserve_early_overlap_check()
> reserve_early_overlap_not_check()

I would think that we should just leave the current reserve_early() in
place... it is what we want most of the time.

I guess I'd like to know specifically when one does *not* want an
overlap check, which is really the issue here.

>> 2. This creates overlapping ranges in the reservation array itself.
> 
> why?
> 
> if the range is retrieved from find_e820_area(). that range should be safe.
> we could add the early_res directly.

If there is no overlap, the current reserve_early() will work just fine.
 If there is overlap, then your code would create overlapping
reservations in the array, since it doesn't seem to check.

Either the new interface is unnecessary, or it is bad... I don't see any
other alternatives.  Unless the only point is to try to shave off a few
microseconds, but if so, it seems rather pointless to seek to the end of
the array first...

> 
> your patch seems to solve the multiple overlap ok problem.
> 
> these overlap check stuff is added by SGI guys to bandit their bios problem. maybe we can kill them at some point.
> 

It's probably a good idea to have them... errors happen.

One thing I would like to see is to change the underlying data structure
to instead of having (start, end, attributes) for each reservation, have
(start, attributes) for all address space.  Such a list would by
definition always be sorted, and overlaps would be trivial to detect.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

