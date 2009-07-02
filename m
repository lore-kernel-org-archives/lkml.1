Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbZGBK05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbZGBK05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 06:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZGBK0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 06:26:49 -0400
Received: from brick.kernel.dk ([93.163.65.50]:53264 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbZGBK0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 06:26:49 -0400
Date: Thu, 2 Jul 2009 12:26:52 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Hannes Reinecke <hare@suse.de>
Cc: scameron@beardog.cca.cpqcorp.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cciss: Ignore stale commands after reboot
Message-ID: <20090702102651.GR23611@kernel.dk>
References: <20090702082313.F3754D340B@pentland.suse.de> <20090702082804.GP23611@kernel.dk> <4A4C7385.4030609@suse.de> <20090702091853.GQ23611@kernel.dk> <4A4C7FAB.2020009@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4C7FAB.2020009@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02 2009, Hannes Reinecke wrote:
> Jens Axboe wrote:
> > On Thu, Jul 02 2009, Hannes Reinecke wrote:
> >> Jens Axboe wrote:
> >>> On Thu, Jul 02 2009, Hannes Reinecke wrote:
> >>>> When doing an unexpected shutdown like kexec the cciss
> >>>> firmware might still have some commands in flight, which
> >>>> it is trying to complete.
> >>>> The driver is doing it's best on resetting the HBA,
> >>>> but sadly there's a firmware issue causing the firmware
> >>>> _not_ to abort or drop old commands.
> >>>> So the firmware will send us commands which we haven't
> >>>> accounted for, causing the driver to panic.
> >>>>
> >>>> With this patch we're just ignoring these commands as
> >>>> there is nothing we could be doing with them anyway.
> >>>>
> >>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
> >>>> ---
> >>>>  drivers/block/cciss.c     |   14 ++++++++++++--
> >>>>  drivers/block/cciss_cmd.h |    1 +
> >>>>  2 files changed, 13 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> >>>> index c7a527c..8dd4c0d 100644
> >>>> --- a/drivers/block/cciss.c
> >>>> +++ b/drivers/block/cciss.c
> >>>> @@ -226,7 +226,16 @@ static inline void addQ(struct hlist_head *list, CommandList_struct *c)
> >>>>
> >>>>  static inline void removeQ(CommandList_struct *c)
> >>>>  {
> >>>> -	if (WARN_ON(hlist_unhashed(&c->list)))
> >>>> +	/*
> >>>> +	 * After kexec/dump some commands might still
> >>>> +	 * be in flight, which the firmware will try
> >>>> +	 * to complete. Resetting the firmware doesn't work
> >>>> +	 * with old fw revisions, so we have to mark
> >>>> +	 * them off as 'stale' to prevent the driver from
> >>>> +	 * falling over.
> >>>> +	 */
> >>>> +	if (unlikely(hlist_unhashed(&c->list))) {
> >>>> +		c->cmd_type = CMD_MSG_STALE;
> >>>>  		return;
> >>>>
> >>>>       hlist_del_init(&c->list);
> >>> Ehm, that looks rather dangerous. What's the level of testing this patch
> >>> received?
> >>>
> >> Where is the danger here?
> >
> > The danger is that the patch doesn't even compile :-)
> > At least it had the { at the end of the if, otherwise it would have been
> > insta-hang.
> >
> Bah. Should've said so.

Sorry, just annoys me when people send out patches for inclusion that
don't even compile. It usually means that some other form of the patch
was tested and that this one hasn't even been run (obviously, since it
doesn't compile).

-- 
Jens Axboe

