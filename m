Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbYCPRxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbYCPRxQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 13:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYCPRxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 13:53:04 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:46958 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYCPRxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 13:53:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=SCuwZ0Hdy+/d2Y2vnmc+px7J2uzK9Xx7s6lTr2dqPCsCmotWcloBuKUyjoXqQNyjOSL0j/AjUM/qI4Z9MTGvkHdZmoYoHOJbVzyT9TZzu77rzvz7uci3oGZN/mYhICenCgMtakRhW1zSvRhHLYudjQglFdxfXv7ufT9hFszmk/M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.25-rc4
Date: Sun, 16 Mar 2008 19:07:04 +0100
User-Agent: KMail/1.9.9
Cc: Anders Eriksson <aeriksson@fastmail.fm>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <20080316140118.891732DC044@tippex.mynet.homeunix.org> <alpine.LFD.1.00.0803160924580.3020@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803160924580.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803161907.04581.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 March 2008, Linus Torvalds wrote:
> 
> On Sun, 16 Mar 2008, Anders Eriksson wrote:
> > 
> > Many bisects later, now with taking care of making 'make oldconfig' off a 
> > known good config for each iteration, and doing 10 reboots and 5 smartd 
> > invocations for each version deemed good (not that anyone failed midway).
> 
> Ok, this is interesting. It's clearly a regression, so we need to undo it. 
> However, it's not trivial to revert, since lots of things have changed 
> around that area since.
> 
> In particular, commit 7267c3377443322588cddaf457cf106839a60463 ("ide: 
> remove REQ_TYPE_ATA_CMD") ended up removing the whole drive_cmd_intr() 
> function, because now all the commands are handled with the
> REQ_TYPE_ATA_TASKFILE model instead, which uses a whole another path.
> 
> And quite frankly, I think the commit you bisected to really is very 
> broken. It starts doing error handling *before* it has handled the DRQ 
> bit, and that's bogus, since iirc a lot of controllers need to have their 
> DRQ issues satisfied before anything else.

We don't do error handling for special commands (REQ_TYPE_ATA_*) at all,
ide_error() just dumps device's status/error register(s) and finishes early:

ide_startstop_t ide_error (ide_drive_t *drive, const char *msg, u8 stat)
{
	struct request *rq;
	u8 err;

	err = ide_dump_status(drive, msg, stat);

	if ((rq = HWGROUP(drive)->rq) == NULL)
		return ide_stopped;

	/* retry only "normal" I/O: */
	if (!blk_fs_request(rq)) {
		rq->errors = 1;
		ide_end_drive_cmd(drive, stat, err);
		return ide_stopped;
	}

[ Yeah, I completely agree that it needs some re-design but I don't see how
  it can be related to the problem experienced by Anders. ]

> So what probably happens is that yes, you get an error, but the IDE drive 

This is unlikely as we should get some error message from ide_dump_status()
and we are not getting any (Anders, please correct me if I'm wrong).

Moreover the problem was initially narrowed down to commit
852738f39258deafb3d89c187cb1a4050820d555 which is two commits _before_
the one that we are currently discussing.

I think that we are looking into completely wrong direction...

Thanks,
Bart
