Return-Path: <linux-kernel-owner+w=401wt.eu-S1030973AbXD1GKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030973AbXD1GKj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 02:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030802AbXD1GKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 02:10:30 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:40891 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707AbXD1GKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 02:10:25 -0400
Date: Sat, 28 Apr 2007 07:37:17 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Bill Huey <billh@gnuppy.monkey.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Dilger <adilger@clusterfs.com>,
       Marat Buharov <marat.buharov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       Alex Tomas <alex@clusterfs.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
In-Reply-To: <20070427201235.GA11170@gnuppy.monkey.org>
Message-ID: <Pine.LNX.4.64.0704280708500.9055@artax.karlin.mff.cuni.cz>
References: <1177660767.6567.41.camel@Homer.simpson.net>
 <20070427013350.d0d7ac38.akpm@linux-foundation.org>
 <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>
 <alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org>
 <20070427193130.GD5967@schatzie.adilger.int>
 <alpine.LFD.0.98.0704271246550.9964@woody.linux-foundation.org>
 <20070427201235.GA11170@gnuppy.monkey.org>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Bill Huey wrote:

> On Fri, Apr 27, 2007 at 12:50:34PM -0700, Linus Torvalds wrote:
>> Oh, well.. Journalling sucks.
>>
>> I was actually _really_ hoping that somebody would come along and tell
>> everybody that this whole journal-logging is stupid, and that it's just
>> better to not ever re-write blocks on disk, but instead write to new
>> blocks with version numbers (and not re-use old blocks until new versions
>> are stable on disk).
>>
>> There was even somebody who did something like that for a PhD thesis, I
>> forget the details (and it apparently died when the thesis was presumably
>> accepted ;).
>
> That sounds a whole lot like NetApp's WAFL file system and is heavily 
> patented.
>
> bill

Hi

SpadFS doesn't write to unallocated parts like log filesystems (LFS) or 
phase tree filesystems (TUX2); it writes inside normal used structures, 
but it marks each structure with generation tags --- when it updates 
global table of tags, it atomically makes several structures valid. I 
don't know about this idea being used elsewhere.

It's fsync is slow too (needs to write all (meta)data too), but it at 
least doesn't livelock --- fsync is basically:
* write all buffers and wait for completion
* take lock preventing metadata updates
* write all buffers again (those that were updated while previous write 
was in progress) and wait for completion
* update global generation count table
* release the lock

Maybe Suse will be paying me from this autumn to make more features to it 
--- so far it works, doesn't eat data, but isn't much known :)

Mikulas
