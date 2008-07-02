Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYGBSQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYGBSQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 14:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYGBSQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 14:16:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbYGBSQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 14:16:11 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Martin Sustrik <sustrik@fastmq.com>
Cc: Roger Heflin <rogerheflin@gmail.com>, Martin Lucina <mato@kotelna.sk>,
       linux-kernel@vger.kernel.org
Subject: Re: Higher than expected disk write(2) latency
References: <20080628121131.GA14181@nodbug.moloch.sk>
	<48663873.5010200@gmail.com> <486921AD.8060308@fastmq.com>
	<48692DC0.6060904@gmail.com> <486BB14D.5060609@fastmq.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 02 Jul 2008 14:15:50 -0400
In-Reply-To: <486BB14D.5060609@fastmq.com> (Martin Sustrik's message of "Wed,
	02 Jul 2008 18:48:13 +0200")
Message-ID: <x49abh0p2y1.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Sustrik <sustrik@fastmq.com> writes:

> Hi Roger,
>
>>> Fair enough. That exaplains the behaviour. Would AIO help here? If
>>> we are able to enqueue next write before the first one is finished,
>>> it can start writing it immediately without waiting for a
>>> revolution.
>>
>> If you could get them queued at the disk level, things that would
>> need to be watched were if the disk can queue things up (and all
>> controllers/drivers support it), and how many things the disk can
>> queue up, and how large each of those things can be, if they aren't
>> queued at the disk, there is the chance that the machine cannot get
>> the data to the disk faster enough for that next sector.
>>
>> I have always avoided fully sync operations as things *ALWAYS* got
>> really really slow because of all of the requirements need to make
>> sure that it always got the data to disk correctly on a unexpected
>> crash, and typically the type of applications I dealt with, if the
>> machine crashed the currently outputting data was known to be
>> incomplete and generally useless, so things were reran.
>>
>> Depending on your application you could always get a small fast
>> solid state device (no seek or RPM issues), and use it to keep a
>> journal that could be replayed on an unexpected crash...and then
>> just use various syncs to force things to disk at various points.
>
> We've tried AIO and the results are quite disappointing. If you open
> the file with O_SYNC, the latencies are the same as with sync I/O -
> each write takes 8.3ms (7500rpm disk).

I thought you were doing I/O to the underlying block device.  If so,
there's no need to open with O_SYNC.  You do, however, need to open the
device with O_DIRECT and align your buffers (and buffer lengths)
properly.

Which AIO interface are you using, libaio or librt?  How many I/Os are
you queueing to the device?  You may want to take a look at aio-stress.c
as a way to test your device (this uses libaio, the in-kernel AIO
interface).

Cheers,

Jeff
