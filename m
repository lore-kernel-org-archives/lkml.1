Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbYAOOFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbYAOOFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 09:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbYAOOFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 09:05:25 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:33166 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbYAOOFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 09:05:23 -0500
Date: Tue, 15 Jan 2008 09:04:51 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, peterz@infradead.org
Subject: Re: [PATCH][RFC] fast file mapping for loop
Message-ID: <20080115090451.060dbedd@think.oraclecorp.com>
In-Reply-To: <20080115100739.GX6258@kernel.dk>
References: <20080109085231.GE6650@kernel.dk>
	<20080114121021.0d392102@think.oraclecorp.com>
	<20080114175359.GS6258@kernel.dk>
	<20080115092503.GV6258@kernel.dk>
	<20080115093651.GW6258@kernel.dk>
	<20080115100739.GX6258@kernel.dk>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008 11:07:40 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> > > I split and merged the patch into five bits (added ext3 support),
> > > so perhaps that would be easier for people to read/review.
> > > Attached and also exist in the loop-extent_map branch here:

Thanks!

> > > 
> > > http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=loop-extent_map
> > 
> > Seems my ext3 version doesn't work, it craps out in
> > ext3_get_blocks_handle() triggering this bug:
> > 
> > J_ASSERT(handle != NULL || create == 0);
> > 
> > I'll see if I can fix that, being fairly fs ignorant...
> 
> This works, but probably pretty suboptimal (should end the new journal
> in map_io_complete()?). And yes I know the >> 9 isn't correct, since
> the fs block size is larger. Just making sure that we always have
> enough blocks.

You can use DIO_CREDITS instead of len >> 9, just like the ext3
O_DIRECT code does.  Your current patch is fine, except it breaks
data=ordered rules.  My plan to work within data=ordered:

1) Inside ext3_map_extent (while the transaction was running), increment
a counter in the ext3 journal for number of pending IOs.  Then end the
transaction handle.

2) Drop this counter inside the IO completion call

3) Change the ext3 commit code to wait for the IO count to be zero.

I'll give it a shot later this week, until then your current patch is
just data=writeback, which is good enough for testing.

-chris
