Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbZFCHoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbZFCHoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 03:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbZFCHoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 03:44:17 -0400
Received: from brick.kernel.dk ([93.163.65.50]:49427 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbZFCHoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 03:44:16 -0400
Date: Wed, 3 Jun 2009 09:44:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "david@fromorbit.com" <david@fromorbit.com>,
       "hch@infradead.org" <hch@infradead.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "jack@suse.cz" <jack@suse.cz>,
       "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "damien.wyart@free.fr" <damien.wyart@free.fr>
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
Message-ID: <20090603074417.GC11363@kernel.dk>
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com> <4A1E9D0B.4090402@gmail.com> <4A1E9D8B.8020908@gmail.com> <1243542908.6645.104.camel@laptop> <4A20011E.7020900@nokia.com> <20090529155046.GH11363@kernel.dk> <4A20072B.7050807@nokia.com> <20090529170742.GI11363@kernel.dk> <4A2628A7.9080407@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2628A7.9080407@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03 2009, Artem Bityutskiy wrote:
> Jens Axboe wrote:
>> On Fri, May 29 2009, Artem Bityutskiy wrote:
>>> Jens Axboe wrote:
>>>>> diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
>>>>> index 2349e2c..d1ac967 100644
>>>>> --- a/fs/ubifs/super.c
>>>>> +++ b/fs/ubifs/super.c
>>>>> @@ -1929,6 +1929,9 @@ static int ubifs_fill_super(struct super_block *sb, void *data, int silent)
>>>>> 	err  = bdi_init(&c->bdi);
>>>>> 	if (err)
>>>>> 		goto out_close;
>>>>> +	err = bdi_register(&c->bdi, NULL, "ubifs");
>>>>> +	if (err)
>>>>> +		goto out_close;
>>>> Not quite right, you need to call bdi_destroy() if you have done the
>>>> init.
>>> Right, bdi_destroy() is already there for long time.
>>> I'm confused.
>>>
>>>> I committed this one this morning:
>>>>
>>>> http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=570a2fe1df85741988ad0ca22aa406744436e281
>>> Hmm, it is the same as my patch, but you do
>>> +       err = bdi_register(&c->bdi);
>>> while I do
>>> +	err = bdi_register(&c->bdi, NULL, "ubifs");
>>
>> Oops, that's my bad. If you combine the two, we should have a working
>> patch :-)
>>
>>>> But feel free to commit/submit to the ubifs tree directly, then it'll
>>>> disappear from my tree once it is merged.
>>> Yeah, I think it can go via my tree. I'd merge it at
>>> 2.6.31 window. This change does not depend on your
>>> work anyway.
>>
>> Right, I'll just carry the fixup patches meanwhile as well, but wont
>> upstream them.
>
> Just to make sure I understood you correctly. I assume my original
> patch is fine (because there is bdi_destroy()) and merge it to
> ubifs tree.

It needs to be:

        err = bdi_register(&c->bdi, NULL, "ubifs");
        if (err)
                goto out_bdi;

so you hit the bdi_destroy() for that failure, not goto out_close;
Otherwise it was fine.

-- 
Jens Axboe

