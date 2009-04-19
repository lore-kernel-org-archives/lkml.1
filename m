Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbZDSC10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbZDSC10 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 22:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbZDSC1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 22:27:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55516 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003AbZDSC1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 22:27:13 -0400
From: "NeilBrown" <neilb@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 19 Apr 2009 12:27:01 +1000 (EST)
Message-ID: <2954ad7f6081b2a6da33f861b0654626.squirrel@neil.brown.name>
In-Reply-To: <49EA8766.9070605@zytor.com>
References: <200904180946.27722.prakash@punnoor.de>
    <49E98AD2.8060601@msgid.tls.msk.ru>
    <200904181117.03418.prakash@punnoor.de>
    <alpine.LNX.2.00.0904181551320.16493@swampdragon.chaosbits.net>
    <20090418145850.GD28512@mea-ext.zmailer.org>
    <49EA8766.9070605@zytor.com>
Subject: Re: Proposal: make RAID6 code optional
Cc: "Matti Aarnio" <matti.aarnio@zmailer.org>,
       "Jesper Juhl" <jj@chaosbits.net>,
       "Prakash Punnoor" <prakash@punnoor.de>,
       "Michael Tokarev" <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, April 19, 2009 12:07 pm, H. Peter Anvin wrote:
> Matti Aarnio wrote:
>>
>> I did quick "sum of symbol sizes" lookup of the   raid.ko, and got
>> it like this:
>>
>> nm -t d -n -S
>> /lib/modules/2.6.27.21-170.2.56.fc10.x86_64/kernel/drivers/md/raid456.ko
>> | grep raid4|awk '{print $2}'|sed -e 's/^0*//g'|awk '{sum+=$1}END{print
>> sum}'
>>   ...
>>
>> raid4:   152
>> raid5:  7165
>> raid6: 75558
>>
>> Entire 64kB of that raid6 is single pre-initialized r/o datablock:
>> raid6_gfmul
>>
>> So yes, having RAID6 personality as separate module would be appropriate
>> for
>> systems that are only interested in RAID4 or RAID5.  Separating the
>> RAID4
>> personality wastes space, separating RAID5 ...  barely 2 of 4k memory
>> pages.
>>
>
> RAID 4 is really just another layout scheme for RAID 5.  But yes, moving
> RAID 6 to a separate module makes sense.  The amount of RAID 5 code not
> used by RAID 6 is fairly trivial, so the right way to do this is to have
>  the raid6 module depend on the raid5 module.

In 2.6.30, the Q syndrome code has been moved into a separate module,
so raid456.ko should be quite a bit smaller.

Of the remaining code, much is common, and some have raid5 and raid6
versions.
Part of the reason for that is that we support async xor offload for
raid5 but not for raid6, so raid6 doesn't use the async paths.

In 2.6.31, we should get async offload of the Q syndrome, so there
is a good chance that we could unify a lot of the code that currently
has separate raid5 and raid6 paths.

In code terms, the different between raid5 and raid6 is quite small
 - raid6 has an extra 'parity' block
 - raid6 cannot do read-modify-write cycles (at least with the current
   implementation)

That is not reason enough to have separate code.

>
> There used to be a raid6 module which was forked from raid5, with a lot
> of duplicate code.  That really made really no sense.
>

It was a good way to get raid6 implemented without risking raid5,
but long term I fully agree.

NeilBrown

