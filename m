Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbZEXPVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbZEXPVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbZEXPUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:20:51 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:55192 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbZEXPUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:20:50 -0400
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs 
 directories.
From: Kay Sievers <kay.sievers@vrfy.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       stern <stern@rowland.harvard.edu>
In-Reply-To: <m1bppid1pw.fsf@fess.ebiederm.org>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
	 <1243109591-21611-5-git-send-email-ebiederm@xmission.com>
	 <ac3eb2510905231427x62efaecfod2b11472fcdbcc21@mail.gmail.com>
	 <1243169978.3502.7.camel@poy>  <m1bppid1pw.fsf@fess.ebiederm.org>
Content-Type: text/plain
Date: Sun, 24 May 2009 17:20:48 +0200
Message-Id: <1243178448.4035.12.camel@poy>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-24 at 07:17 -0700, Eric W. Biederman wrote:

> Most of these look like attributes, for which the non-empty directory
> removal was correct.  Although I am puzzled by why we missed them.

Yes, most of them are attributes. I have USB hubs here with lots of
devices connected, setups I use for udev testing, so this might trigger
things that usually don't happen.

> host4/target4:0:0 worries me.  I don't have my head wrapped around
> what that is yet.  But is looks like is a directory (which we currently
> do not handle correctly), and even more it looks like that is quite
> possibly two kobjects in a parent/child situation where the child
> was not removed when the child was.
> 
> It definitely warrants more investigation.

It seems like a real bug. We get:
  dir:   host5/target5:0:0

and we removed a parent from an active child, and the device path misses
all its parents:
  'target7:0:0' (ffff880124eb1158): fill_kobj_path: path = '/host7/target7:0:0'

it gets cleaned up:
  'target7:0:0': free name

but it should still be fixed in the user. Adding Alan Stern, maybe he
has an idea what's going on here.

Note, that it is hard to reproduce, It only happens with a frequent
connect/disconnects on a hub full of devices. But it still seems like a
real bug in the USB device cleanup logic. At the end of this mail is the
log of all files which did exist at cleanup.

> Let's make the plan to investigate these, and see how hard it would be
> to actually remove these with the current device/sysfs infrastructure.
> 
> Fixing the users and adding back auto-deletion are the only two real options.

Seems, we should remove non-directory files, which in most cases belong
to the kobject itself, but the user's cleanup logic does not cover the
removal of the created files.

But I think, we should still warn, if we find a sub-directory inside a
directory we are going to remove.

Thanks,
Kay



attr:  state0/name
attr:  state0/desc
attr:  state0/latency
attr:  state0/power
attr:  state0/usage
attr:  state0/time
attr:  state1/name
attr:  state1/desc
attr:  state1/latency
attr:  state1/power
attr:  state1/usage
attr:  state1/time
attr:  state2/name
attr:  state2/desc
attr:  state2/latency
attr:  state2/power
attr:  state2/usage
attr:  state2/time
attr:  state3/name
attr:  state3/desc
attr:  state3/latency
attr:  state3/power
attr:  state3/usage
attr:  state3/time
attr:  state0/name
attr:  state0/desc
attr:  state0/latency
attr:  state0/power
attr:  state0/usage
attr:  state0/time
attr:  state1/name
attr:  state1/desc
attr:  state1/latency
attr:  state1/power
attr:  state1/usage
attr:  state1/time
attr:  state2/name
attr:  state2/desc
attr:  state2/latency
attr:  state2/power
attr:  state2/usage
attr:  state2/time
attr:  state3/name
attr:  state3/desc
attr:  state3/latency
attr:  state3/power
attr:  state3/usage
attr:  state3/time
battr: 0000:03:00.0/data
attr:  0000:03:00.0/loading
attr:  pcmC1D0c/pcm_class
attr:  card1/id
attr:  card1/number
attr:  iosched/quantum
attr:  iosched/fifo_expire_sync
attr:  iosched/fifo_expire_async
attr:  iosched/back_seek_max
attr:  iosched/back_seek_penalty
attr:  iosched/slice_sync
attr:  iosched/slice_async
attr:  iosched/slice_async_rq
attr:  iosched/slice_idle
attr:  queue/nr_requests
attr:  queue/read_ahead_kb
attr:  queue/max_hw_sectors_kb
attr:  queue/max_sectors_kb
attr:  queue/scheduler
attr:  queue/hw_sector_size
attr:  queue/rotational
attr:  queue/nomerges
attr:  queue/rq_affinity
attr:  queue/iostats
attr:  5:0:0:0/queue_depth
attr:  5:0:0:0/queue_type
attr:  5:0:0:0/max_sectors
attr:  iosched/quantum
attr:  iosched/fifo_expire_sync
attr:  iosched/fifo_expire_async
attr:  iosched/back_seek_max
attr:  iosched/back_seek_penalty
attr:  iosched/slice_sync
attr:  iosched/slice_async
attr:  iosched/slice_async_rq
attr:  iosched/slice_idle
attr:  queue/nr_requests
attr:  queue/read_ahead_kb
attr:  queue/max_hw_sectors_kb
attr:  queue/max_sectors_kb
attr:  queue/scheduler
attr:  queue/hw_sector_size
attr:  queue/rotational
attr:  queue/nomerges
attr:  queue/rq_affinity
attr:  queue/iostats
attr:  5:0:0:1/queue_depth
attr:  5:0:0:1/queue_type
attr:  5:0:0:1/max_sectors
dir:   host5/target5:0:0
attr:  pcmC1D0c/pcm_class
attr:  card1/id
attr:  card1/number
attr:  pcmC1D0c/pcm_class
attr:  card1/id
attr:  card1/number
attr:  iosched/quantum
attr:  iosched/fifo_expire_sync
attr:  iosched/fifo_expire_async
attr:  iosched/back_seek_max
attr:  iosched/back_seek_penalty
attr:  iosched/slice_sync
attr:  iosched/slice_async
attr:  iosched/slice_async_rq
attr:  iosched/slice_idle
attr:  queue/nr_requests
attr:  queue/read_ahead_kb
attr:  queue/max_hw_sectors_kb
attr:  queue/max_sectors_kb
attr:  queue/scheduler
attr:  queue/hw_sector_size
attr:  queue/rotational
attr:  queue/nomerges
attr:  queue/rq_affinity
attr:  queue/iostats
attr:  6:0:0:0/queue_depth
attr:  6:0:0:0/queue_type
attr:  6:0:0:0/max_sectors
attr:  iosched/quantum
attr:  iosched/fifo_expire_sync
attr:  iosched/fifo_expire_async
attr:  iosched/back_seek_max
attr:  iosched/back_seek_penalty
attr:  iosched/slice_sync
attr:  iosched/slice_async
attr:  iosched/slice_async_rq
attr:  iosched/slice_idle
attr:  queue/nr_requests
attr:  queue/read_ahead_kb
attr:  queue/max_hw_sectors_kb
attr:  queue/max_sectors_kb
attr:  queue/scheduler
attr:  queue/hw_sector_size
attr:  queue/rotational
attr:  queue/nomerges
attr:  queue/rq_affinity
attr:  queue/iostats
attr:  6:0:0:1/queue_depth
attr:  6:0:0:1/queue_type
attr:  6:0:0:1/max_sectors
attr:  pcmC1D0c/pcm_class
attr:  card1/id
attr:  card1/number
attr:  pcmC1D0c/pcm_class
attr:  card1/id
attr:  card1/number

