Return-Path: <linux-kernel-owner+w=401wt.eu-S1759289AbZFWLZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289AbZFWLZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756780AbZFWLZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:25:48 -0400
Received: from www.tglx.de ([62.245.132.106]:36256 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756036AbZFWLZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:25:47 -0400
Date: Tue, 23 Jun 2009 13:24:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <greg@kroah.com>
cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-kernel@vger.kernel.org, linux-rt@pengutronix.de,
       Ian Abbott <abbotti@mev.co.uk>,
       Frank Mori Hess <fmhess@users.sourceforge.net>
Subject: Re: [PATCH -rt] disable building all staging drivers
In-Reply-To: <20090622171948.GA15145@kroah.com>
Message-ID: <alpine.LFD.2.00.0906231216220.2767@localhost.localdomain>
References: <1244929118-23326-1-git-send-email-u.kleine-koenig@pengutronix.de> <20090614112802.GA4502@kroah.com> <20090614230044.GA21624@pengutronix.de> <20090622151515.GA16627@pengutronix.de> <20090622171948.GA15145@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009, Greg KH wrote:
> > 17:02:43 E: ERROR: "there_is_no_init_MUTEX_LOCKED_for_RT_semaphores" [drivers/staging/rt2870/rt2870sta.ko] undefined!
> 
> What needs to be done in the rt2870 driver to resolve this issue?

It looks like the semaphores are used to wait for an event. There are
actually 3 of those:

	 init_MUTEX_LOCKED(&(pAd->mlme_semaphore));
	 init_MUTEX_LOCKED(&(pAd->RTUSBCmd_semaphore));
	 init_MUTEX_LOCKED(&(pAd->RTUSBTimer_semaphore));

All are used in kernel threads which wait with down_interruptible() on
them. The up() calls are in some completely non obvious places.

I had a look into the timer one. The semaphore is the least thing you
need to worry about there. The open coded timer list management and
the thread which does timer polling for some obscure reason are the
things which need to be fixed in the first place. Once this is cleaned
up the semaphore will be gone anyway.

But, after looking into that code I really have to ask you whether you
are serious about fixing it instead of rewriting it from scratch and
just keep the code as is for reference to the hardware details.

Thanks,

	tglx
