Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbZKCTvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbZKCTvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbZKCTvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:51:32 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:46817 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZKCTvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:51:31 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4AF089C1.4010806@s5r6.in-berlin.de>
Date: Tue, 03 Nov 2009 20:51:29 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091025 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Jarkko Lavinen <jarkko.lavinen@nokia.com>
CC: Jens Axboe <axboe@kernel.dk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH 1/2] Disk hot removal causing oopses and fixes
References: <20091021161201.GA16968@angel.research.nokia.com> <4ADF752D.7010206@s5r6.in-berlin.de> <20091103115444.GA8507@angel.research.nokia.com>
In-Reply-To: <20091103115444.GA8507@angel.research.nokia.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarkko Lavinen wrote:
> Hi Steven
> 
> Sorry for late reply.
> 
>> It has to reference-count its objects so that they are not freed as long
>> as they are used by upper layers,
> 
> The block layer and device removal seems to be designed from
> top-down approach.  Althouh disc is referenced from
> __blkdev_get(), disc's request queue is not.  Also
> blk_cleanup_queue() calls elevator_exit() without caring if
> anyone still uses the elevator.
[...]

I still don't understand how there can be a problem here.  Shouldn't the
sequence be:

 1. low-level determines that a device went away
 2. low-level takes note that from now on no new requests must be
    enqueued anymore
 3. low-level calls blk_cleanup_queue
 4. blk_cleanup_queue waits until remaining requests are done
    (it calls blk_sync_queue)
 5. blk_cleanup_queue cleans up block layer data
 6. low-level can now clean up/ free its own data

Does the MMC layer miss step 2?  Because without this, step 4 would be
in vain.
-- 
Stefan Richter
-=====-==--= =-== ---==
http://arcgraph.de/sr/
