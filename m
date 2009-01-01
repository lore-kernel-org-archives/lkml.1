Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbZAATAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbZAATAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 14:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZAAS76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 13:59:58 -0500
Received: from customer-vserver-jkruis-1.all2all.org ([62.58.108.47]:35966
	"EHLO jkruis.all2all.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZAAS75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 13:59:57 -0500
Message-ID: <495D12A8.9030703@samwel.tk>
Date: Thu, 01 Jan 2009 19:59:52 +0100
From: Bart Samwel <bart@samwel.tk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Dave Johnson <dave-lkml-01@centerclick.org>
CC: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [ext3] kjournald writing after each read despite noatime,commit=nnn
References: <18779.58377.160214.225792@wellington.i202.centerclick.org>	<495CCCDF.3030606@samwel.tk> <18780.62500.100687.402706@wellington.i202.centerclick.org>
In-Reply-To: <18780.62500.100687.402706@wellington.i202.centerclick.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Dave Johnson wrote:
> Bart Samwel writes:
>> This is the defined behaviour for laptop_mode. Whenever a *physical*
>> READ takes place, this is taken to indicate that the disk is spun up at
>> that time. The laptop_mode functionality then takes that opportunity to
>> sync any dirty data to disk, two seconds (or whatever value you put in
>> /proc/sys/vm/laptop_mode) after the physical disk activity has ceased.
>> The rationale behind this is that you want to sync your stuff when the
>> disk is spun up, and then you want to hold back writing back stuff for a
>> very long while. And the only way it can detect that the disk is spun up
>> is when there is physical disk activity.
>>
>> This is exactly what happens in your case. The READ activity reported by
>> block_dump is *physical* read activity: some data was needed that was
>> not cached in memory. block_dump does not show you what data was
>> retrieved from the ext3 fs *without* having to access the disk, it only
>> shows actual physical disk I/O.
> 
> Yep sounds good, but this happens even if there is no dirty data
> needing a sync back to disk.
> 
> $ grep 'Dirty\|Write' /proc/meminfo 
> Dirty:               0 kB
> Writeback:           0 kB
> WritebackTmp:        0 kB
> $ cat /some/uncached/file >/dev/null 
> 
> Jan  1 11:43:49 gw kernel: cat(6615): READ block 864408 on hda1 
> Jan  1 11:43:51 gw kernel: kjournald(760): WRITE block 2376 on hda1 

This looks like it's a generic property of syncing an ext3 file system.
Try turning off laptop_mode and then running "sync". You will probably
see the same behaviour.

> Note, the reason I ask is this is a SSD so just because a physical
> read has taken place recently unneeded writes should be avoided.
> 
> Turning laptop_mode to 0, but leaving other settings the same
> resolves the uneeded write:

For your SSD I guess you need to get rid of the
sync-after-disk-activity, but keep the other VM behaviours of
laptop_mode (such as avoiding swapping out pages / writing back dirty
pages in order to free memory as long as it is also possible to just
drop pages that are not dirty).
You can probably achieve this by:
- having a large commit interval etc., like you have now
- setting laptop_mode to a very large value, e.g. a couple of hours.
That will trigger a sync if and only if there has been *no* disk
activity at all for hours on end -- i.e., pretty much never. And the
other write-reducing VM features of laptop_mode will still be enabled.

It would perhaps be a good thing to split these mechanisms into separate
knobs. Write batching (the sync-after-disk-activity stuff and also the
dirty_ratio / dirty_background_ratio changes) are a completely separate
mechanism from write avoidance (the other mechanism I mentioned).

Cheers,
Bart
