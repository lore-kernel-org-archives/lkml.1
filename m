Return-Path: <linux-kernel-owner+w=401wt.eu-S1759553AbZE2Pu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553AbZE2Pu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 11:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757618AbZE2Puq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 11:50:46 -0400
Received: from brick.kernel.dk ([93.163.65.50]:55233 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151AbZE2Puq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 11:50:46 -0400
Date: Fri, 29 May 2009 17:50:46 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk,
       damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
Message-ID: <20090529155046.GH11363@kernel.dk>
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com> <4A1E9D0B.4090402@gmail.com> <4A1E9D8B.8020908@gmail.com> <1243542908.6645.104.camel@laptop> <4A20011E.7020900@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A20011E.7020900@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29 2009, Artem Bityutskiy wrote:
> Peter Zijlstra wrote:
>> On Thu, 2009-05-28 at 17:19 +0300, Artem Bityutskiy wrote:
>>> Artem Bityutskiy wrote:
>>>> question is - should it? 'bdi_register()' a block device,
>>>> but we do not have one.
>>> Sorry, wanted to say: 'bdi_register()' registers a block
>>> device.
>>
>> BDI stands for backing device info and is not related to block devices
>> other than that block devices can also be (ok, always are) backing
>> devices.
>>
>> If you want to do writeback, you need a backing device to write to. The
>> BDI is the device abstraction for writeback.
>
> I see, thanks. The below UBIFS patch fixes the issue. I'll
> push it to ubifs-2.6.git tree, unless there are objections.
>
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Subject: [PATCH] UBIFS: do not forget to register BDI device
>
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> ---
> fs/ubifs/super.c |    3 +++
> 1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
> index 2349e2c..d1ac967 100644
> --- a/fs/ubifs/super.c
> +++ b/fs/ubifs/super.c
> @@ -1929,6 +1929,9 @@ static int ubifs_fill_super(struct super_block *sb, void *data, int silent)
> 	err  = bdi_init(&c->bdi);
> 	if (err)
> 		goto out_close;
> +	err = bdi_register(&c->bdi, NULL, "ubifs");
> +	if (err)
> +		goto out_close;

Not quite right, you need to call bdi_destroy() if you have done the
init.

I committed this one this morning:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=570a2fe1df85741988ad0ca22aa406744436e281

But feel free to commit/submit to the ubifs tree directly, then it'll
disappear from my tree once it is merged.

-- 
Jens Axboe

