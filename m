Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbYIOTzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbYIOTzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 15:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbYIOTzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 15:55:41 -0400
Received: from nebensachen.de ([195.34.83.29]:59020 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbYIOTzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 15:55:40 -0400
X-Hashcash: 1:20:080915:jens.axboe@oracle.com::bj49sN22IvlUDCeN:000000000000000000000000000000000000000011Uo
X-Hashcash: 1:20:080915:fujita.tomonori@lab.ntt.co.jp::BfxwMTyWpLSwVFXG:0000000000000000000000000000000040cc
X-Hashcash: 1:20:080915:greg@kroah.com::aa2knunzdtyrKd23:0001t3D
X-Hashcash: 1:20:080915:linux-kernel@vger.kernel.org::NhufzKLpB585xuPm:0000000000000000000000000000000000tth
From: Elias Oltmanns <eo@nebensachen.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: Block: Trouble with kobject initialisation for blk_cmd_filter
References: <87od3235fc.fsf@denkblock.local>
	<20080909102844.GD20055@kernel.dk>
	<20080909214602L.fujita.tomonori@lab.ntt.co.jp>
	<20080909131850.GL20055@kernel.dk>
Date: Mon, 15 Sep 2008 21:55:15 +0200
In-Reply-To: <20080909131850.GL20055@kernel.dk> (Jens Axboe's message of "Tue,
	9 Sep 2008 15:18:52 +0200")
Message-ID: <87fxo1xjz0.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> wrote:
> On Tue, Sep 09 2008, FUJITA Tomonori wrote:
>> On Tue, 9 Sep 2008 12:28:45 +0200
>
>> Jens Axboe <jens.axboe@oracle.com> wrote:
>> 
>> > On Fri, Sep 05 2008, Elias Oltmanns wrote:
>> > > Hi all,
>> > > 
>> > > current usage of the kobject in struct blk_cmd_filter is flawed. Doing
>> > > # modprobe -r sd-mod && modprobe sd-mod
>> > > while, for instance, a usb-stick is plugged in currently results in
>> > > nasty warnings and a dump_stack(). Since blk_cmd_filter is embedded in
>> > > struct request_queue, I don't see the need for a kobject anyway. What
>> > > about the much simpler option of a struct attribute_group in this
>> > > particular case?
>> > > 
>> > > This would imply that the cmd_filter subdirectory would appear under
>> > > sda/queue/ rather than sda/ (which is probably the right place) but,
>> > > alas, we have to keep compatibility in mind. So I've made some changes
>> > > to sysfs along the way in order to provide a legacy symlink. I'd have to
>> > > seperate these two changes for submission but I wanted to know your
>> > > opinion about it all first.
>> > > 
>> > > Thinking about it now makes me wonder whether this is too much for a rc
>> > > patch and whether we should just allocate the struct blk_cmd_filter
>> > > dynamically and have done with it. Anyway, tell me what you think.
>> > 
>> > I think this patch is a step in the right direction, lets get rid of
>> > that pesky kobject just for the cmdfilter. Can you resend the patch
>> > _without_ the sysfs changes and link support? We haven't released a
>> > kernel with cmd filter support yet, so we can change the location still
>> > and not have to worry about compatability.
>> 
>> The sysfs changes looks too much for 2.6.27-rcX but without the sysfs
>> changes, we have the cmdfilter under /sys/block/sda/queue/, right? We
>> don't need to worry about compatibility, but /sys/block/sda is more
>> appropriate? (though I don't think that the cmd filter is a good idea
>> so I don't care much).

What exactly does that mean? Is there any point in fixing this
particular bug for 2.6.28 or will the whole cmd-filter infrastructure
have to be modified in a more general way in order to address other
shortcomings?

>
> I agree, under sda/ makes a lot more sense than under sda/queue/
>
>> Jens, would it be better to just disable the cmdfilter stuff for
>> 2.6.27? It's too late for another try to fix this broken stuff, I
>> guess.
>
> Yeah, it's certainly starting to look like it... The amount of changes
> to unbreak it are too large to submit now, so lets postpone it until
> 2.6.28.

As far as I can make out, nothing has happened yet at this front. I've
just verified that reverting the following commits (in that order) seems
to be working nicely for me:

2dc75d3c3b4
bb23b431db7
a4a778971b9
4beab5c623f
14e507b852e
abf54393704
06a452e5b95
2b272d4f795
0b07de85a76

Is that what you had in mind? Will you take care of it?

Regards,

Elias
