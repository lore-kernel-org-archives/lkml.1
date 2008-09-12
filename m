Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbYILIdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbYILIdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 04:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbYILIdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 04:33:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48117 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbYILIdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 04:33:41 -0400
Date: Fri, 12 Sep 2008 04:33:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Janne Grunau <j@jannau.net>
Cc: Christoph Hellwig <hch@infradead.org>, Jarod Wilson <jwilson@redhat.com>,
       linux-kernel@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
       Christoph Bartelmus <lirc@bartelmus.de>,
       Mario Limonciello <superm1@ubuntu.com>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
Message-ID: <20080912083332.GA29577@infradead.org>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-2-git-send-email-jwilson@redhat.com> <20080909130102.GB27837@infradead.org> <200809120216.31153.j@jannau.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809120216.31153.j@jannau.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 02:16:30AM +0200, Janne Grunau wrote:
> I'm pretty sure LIRC will be recognized by its current users, it is 
> probably enough if it is in the help text though.

But we don't care just for your current users :)  Kernel features /
drivers do need good descriptions.

> > > +		} else {
> > > +			/* if device not opened so we can sleep half a second */
> > > +			set_current_state(TASK_INTERRUPTIBLE);
> > > +			schedule_timeout(HZ/2);
> > > +		}
> >
> > Yikes.  This should use some form of more fine-grained wakeus.
> 
> added a waitqueue and wait_event

I don't think you'll need a wait queue - you can just call
wake_up_process on ir->task while the thread just sleeps in schedule().

> > > +int lirc_unregister_plugin(int minor)
> >
> > Why doesn't this one take a struct lirc_plugin pointer?
> 
> I don't know, It doesn't really help though since the struct lirc_plugin 
> is copied by value to irctl.p in lirc_register_plugin.

Well, the lifetime rules for these structures seems a litte odd.  I
would except this to work like:

struct lirc_plugin statically allocated by the driver, then passed into
lirc_register_plugin, which dynamically allocates an irdev.  The irdev
would point to the plugin, not copy it.

And btw, any chance for an s/plugin/driver/g - that's the terminology
we use everywhere else in the kernel.

