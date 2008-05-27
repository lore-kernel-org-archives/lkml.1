Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbYE0Odg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbYE0Odg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 10:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbYE0Od3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 10:33:29 -0400
Received: from rn-out-0910.google.com ([64.233.170.187]:59489 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678AbYE0Od2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 10:33:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TGWVf2jg7f1xskuKQCUXX2OoFqX2P7jjmCmJRPB4oP6Ja/8WuAPhxtaqlFVEnGziY+jN3etHNR5htWZWQAh4+NEDi2oLDiTDM+ojNWvB/HgPRYFAHw+uujsCKHcmEx85NItf7H8zUs6cJTJG4KHJicR48jnsqYeSLdIKeuFwurI=
Message-ID: <170fa0d20805270733n4e685e5fs6e456e3b2edbff76@mail.gmail.com>
Date: Tue, 27 May 2008 10:33:26 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Neil Brown" <neilb@suse.de>
Subject: Re: [RFC][PATCH] md: avoid fullsync if a faulty member missed a dirty transition
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       paul.clements@steeleye.com
In-Reply-To: <18491.45187.557090.225552@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1207174155-20090-1-git-send-email-snitzer@gmail.com>
	 <18467.43895.220708.254814@notabene.brown>
	 <170fa0d20805082142o61462a7dnce7852a6b7c0d21d@mail.gmail.com>
	 <18467.59565.676987.926988@notabene.brown>
	 <170fa0d20805090800p45654901p36eea51e1ea7e9c7@mail.gmail.com>
	 <18477.30199.992302.271647@notabene.brown>
	 <170fa0d20805182133o46501cc4va81b087fb6b417bf@mail.gmail.com>
	 <18481.4005.570022.160686@notabene.brown>
	 <170fa0d20805200830w184709dch221f8b9636f3bc0e@mail.gmail.com>
	 <18491.45187.557090.225552@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 2:56 AM, Neil Brown <neilb@suse.de> wrote:
> On Tuesday May 20, snitzer@gmail.com wrote:
>>
>> Hi Neil,
>>
>> We're much closer.  The events_cleared is symmetric on both the failed
>> and active member of the raid1.  But there have been some instances
>> where the md thread hits a deadlock during my testing.  What follows
>> is the backtrace and live crash info:
> ...
>>
>> So running with your latest patches seems to introduce a race in
>> bitmap_daemon_work's if (unlikely((*bmc & COUNTER_MAX) ==
>> COUNTER_MAX)) { } block.
>
> As you not, that block is in the wrong place.
> It is actually locking up in
>                                wait_event(bitmap->mddev->sb_wait,
>                                    !test_bit(MD_CHANGE_CLEAN,
>                                              &bitmap->mddev->flags));
>
> which the patch adds.  However with my last update that wait_event
> isn't needed any more.  I was using it to ensure mddev->events matched
> what was on disk.  But we now read mddev->events much earlier and it
> will definitely be on disc by this time.
>
> So: this combined patch should do it.
>
> Thanks for all your testing.
>
> NeilBrown
>
>
> ---------------------------
> Improve setting of "events_cleared" for write-intent bitmaps.
>
> When an array is degraded, bits in the write-intent bitmap are not
> cleared, so that if the missing device is re-added, it can be synced
> by only updated those parts of the device that have changed since
> it was removed.
>
> The enable this a 'events_cleared' value is stored. It is the event
> counter for the array the last time that any bits were cleared.
>
> Sometimes - if a device disappears from an array while it is 'clean' -
> the events_cleared value gets updated incorrectly (there are subtle
> ordering issues between updateing events in the main metadata and the
> bitmap metadata) resulting in the missing device appearing to require
> a full resync when it is re-added.
>
> With this patch, we update events_cleared precisely when we are about
> to clear a bit in the bitmap.  We record events_cleared when we clear
> the bit internally, and copy that to the superblock which is written
> out before the bit on storage.  This makes it more "obviously correct".
>
> We also need to update events_cleared when the event_count is going
> backwards (as happens on a dirty->clean transition of a non-degraded
> array).
>
> Thanks to Mike Snitzer for identifying this problem and testing early
> "fixes".
>
>
> Cc:  "Mike Snitzer" <snitzer@gmail.com>
> Signed-off-by: Neil Brown <neilb@suse.de>
> Signed-off-by: Neil Brown <neilb@suse.de>

Neil,

Works great now.  Thanks.

Tested-by: Mike Snitzer <snitzer@gmail.com>
