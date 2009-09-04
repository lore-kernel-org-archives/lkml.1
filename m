Return-Path: <linux-kernel-owner+w=401wt.eu-S932152AbZIDAru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbZIDAru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 20:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbZIDAru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 20:47:50 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:40312 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbZIDArt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 20:47:49 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: Regression in suspend to ram in 2.6.31-rc kernels
References: <c4e36d110908310451t7c238e09u5af112fa3321cc23@mail.gmail.com>
	<200908312119.12121.rjw@sisk.pl>
	<c4e36d110909010234i5f1b9357l805132137725a4f8@mail.gmail.com>
	<c4e36d110909031529q77b53122kdb85785ba293c478@mail.gmail.com>
	<20090903232317.GA6760@lst.de>
Date: Fri, 04 Sep 2009 09:47:46 +0900
In-Reply-To: <20090903232317.GA6760@lst.de> (Christoph Hellwig's message of
	"Fri, 4 Sep 2009 01:23:17 +0200")
Message-ID: <87ljkvmt71.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> On Fri, Sep 04, 2009 at 12:29:04AM +0200, Zdenek Kabelac wrote:
>> Ok - another bisect game played - and unexpected winner is:
>> 
>> (fat: add ->sync_fs)
>> 
>> f83d6d46e7adf241a064a4a425e5cd8a8fd8925f
>> 
>> Reverting this commit with current -rc8 kernel makes the system happy
>> during the suspend/resume cycle. Obviously it has it price :) so just
>> plain revert is probably not a good solution so the problem looks
>> 'more serious'  (fat is not the only fs with this patch) thus adding
>> original author to this thread.

>From it, I suspect the possible reason seems to read mmc after remove
event. I.e. the following sequence or something

    sync fs process
    [...]
    removed mmc event
    [...]
    fat_sync_fs()                   <- sync again?
        fat_clusters_flush()
            sb_bread()              <- read block on removed mmc

Can you add dump_stack() to the top of fat_sync_fs()? I hope it tells
why fat_sync_fs() is called (it is called from device unplug event?).

Well, that commit seems a bit strange. It calls fat_clusters_flush()
unconditionally without checking sb->s_dirt. However, if my guess is
right, "sync after removed event" itself sounds like the issue in
suspend process.

Thanks.

> Note that when you rever this patch on a current kernel you do actually
> get different behvaviour than when going back to before this commit.
>
> In 2.6.30 we called ->write_super in the various sync functions and
> then ->sync_fs, in 2.6.31-rc8 you would not call any syncing at all
> anymore.  I think this patch might just be a symptom for a situation
> where the suspend code causes a sync and the mmc driver can't handle
> it anymore.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
