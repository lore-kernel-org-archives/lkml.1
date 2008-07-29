Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbYG2Hbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbYG2Hbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 03:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbYG2Hb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 03:31:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752705AbYG2Hb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 03:31:27 -0400
Date: Tue, 29 Jul 2008 00:31:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@tungstengraphics.com>
Cc: Dave Airlie <airlied@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
       airlied@linux.ie, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 repost #1] DRM: don't enable irqs in locking
Message-Id: <20080729003113.d39851b5.akpm@linux-foundation.org>
In-Reply-To: <488E2CED.1040207@tungstengraphics.com>
References: <1216975369-6749-1-git-send-email-jirislaby@gmail.com>
	<21d7e9970807250154q4a1958f5k45f62408e97ae3c7@mail.gmail.com>
	<488E2CED.1040207@tungstengraphics.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 22:32:45 +0200 Thomas Hellstr__m <thomas@tungstengraphics.com> wrote:

> Dave Airlie wrote:
> > On Fri, Jul 25, 2008 at 6:42 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> >   
> >> drm_lock_take(); and drm_lock_free(); are called from
> >> drm_locked_tasklet_func(); which disables interrupts when grabbing its
> >> spinlock.
> >>
> >> Don't allow these locking functions to re-enable interrupts when
> >> the tasklet expects them disabled. I.e. use spin_lock_irqsave instead of
> >> spin_lock_bh (with their unlock opposites).
> >>     
> >
> > Hmm this has bounced through 2-3 variations.. Thomas any ideas what
> > the final correct answer is?
> >
> > Dave.
> >   
> Hmm,
> Yes, this bug could occur, but the remedy is not to use 
> spin_lock_irqsave() for lock_data::spinlock but to avoid calling 
> drm_lock_take with the drm_device::tasklet_lock held with irqs disabled.
> I'll see if I can come up with a patch.
> 

The code in drivers/gpu/drm/drm_lock.c needs some serious help in the
kerneldoc department.


/**
 * Take the heavyweight lock.
 *
 * \param lock lock pointer.
 * \param context locking context.
 * \return one if the lock is held, or zero otherwise.
 *
 * Attempt to mark the lock as held by the given context, via the \p cmpxchg instruction.
 */

The /** leadin specifically introduces a kerneldoc-formatted comment. 
Yet that comment uses some strange home-made way of denoting function
arguments.

The comments could quite easily be converted to kerneldoc form, which
would be the best thing to do here.

While you're there, please reformat the comments (drm_idlelock_take(),
mainly) to fit in 80-cols.  The code carefully does this, but the block
comments then go and ruin it all.

