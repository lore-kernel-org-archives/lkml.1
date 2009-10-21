Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbZJUUzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbZJUUzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 16:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbZJUUzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 16:55:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34577 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbZJUUzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 16:55:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4ADF752D.7010206@s5r6.in-berlin.de>
Date: Wed, 21 Oct 2009 22:55:09 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091017 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Jarkko Lavinen <jarkko.lavinen@nokia.com>
CC: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
       linux-mmc@vger.kernel.org
Subject: Re: [PATCH 1/2] Disk hot removal causing oopses and fixes
References: <20091021161201.GA16968@angel.research.nokia.com>
In-Reply-To: <20091021161201.GA16968@angel.research.nokia.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarkko Lavinen wrote:
> When MMC driver notices a card has been removed, it removes the
> card and the block device.  The call proceeds to
> blk_cleanup_queue() which marks the request queue dead, calls
> elevator exit to release the elevator and puts request queue.
> This releases elevator always and may also release the request
> queue.
> 
> If file system is still mounted and using the disk after
> blk_cleanup_queue() has been called, io requests will access
> already free'ed structures and oopses and BUG_ON()s jump in.
[...]
>  fs/block_dev.c |   24 ++++++++++++++++++++----
>  1 files changed, 20 insertions(+), 4 deletions(-)
[...]

And in patch 2/2:
>  block/blk-core.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)

This doesn't look right.  I suspect you need to fix the MMC subsystem.
It has to reference-count its objects so that they are not freed as long
as they are used by upper layers, notably by the block subsystem.

OK, actually I am not 100% sure whether the issue is in the lower layers
alone --- I'm only (reasonably) familiar with drivers below the SCSI
subsystem, not with those directly below the block subsystem.

In case of SCSI, low level requests the removal of scsi_device or
Scsi_Host instances when appropriate, and the respective removal
functions in SCSI core make sure that upper layers will not use a
scsi_device after scsi_remove_device (or other flavors of it) anymore;
likewise it guarantees that a Scsi_Host will not be used by upper layers
anymore when scsi_remove_host returns to the low level driver.

So, while I don't know what the block subsystem offers in this regard,
the fix cannot be that the block layer somehow notices that lower layers
went away and goes quiet then; instead the way to go is that lower
layers make sure that the block request queue is destroyed before MMC
device objects are destroyed (or in other words:  that the MMC device
objects stay around at least as long as the block request queue exists).

[Quoting in different order than posted:]
> I've been testing mmc driver robustness against rapid card removal
> reinsert cycles and it has been rather easy to get a kernel oopses 
> (on 2.6.28) because of insufficient locking. 

I dare say without knowing the MMC and block system:  It is not a
locking issue, it is a reference counting issue.

Make sure to always "get" an object before you hand a pointer to it over
to some store or to another context (and of course "put" it when that
reference is removed from that store or, respectively, not longer used
by that other context).  And make sure that an object is destroyed only
when the reference count goes to zero.  The kref API does this, and so
do the APIs which are wrapped around it (like get_device, put_device).

So, make sure that the reference to the MMC device which the block layer
needs is counted for as long as there is the request queue.

PS:  The kref API is based on an atomic counter so that there is
fundamentally never a need to use locking (mutual exclusion) for proper
reference counting and proper deferral of object destruction.  The whole
secret is not to forget to count _all_ references.
-- 
Stefan Richter
-=====-==--= =-=- =-=-=
http://arcgraph.de/sr/
