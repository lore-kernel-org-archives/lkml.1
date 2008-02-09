Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbYBIFLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbYBIFLd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 00:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbYBIFL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 00:11:26 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44718 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYBIFL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 00:11:26 -0500
Date: Fri, 8 Feb 2008 21:15:39 -0800
From: Greg KH <greg@kroah.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kobject must be initialized before calling kobject_init()?!
Message-ID: <20080209051539.GA28565@kroah.com>
References: <adaabma21vq.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaabma21vq.fsf@cisco.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 08:24:25PM -0800, Roland Dreier wrote:
> So I was perusing the code in lib/kobject.c, and I saw this:
> 
> 	void kobject_init(struct kobject *kobj, struct kobj_type *ktype)
> 	{
> 		// [a couple of of parameter checks...]
> 		if (kobj->state_initialized) {
> 			/* do not error out as sometimes we can recover */
> 			printk(KERN_ERR "kobject (%p): tried to init an initialized "
> 			       "object, something is seriously wrong.\n", kobj);
> 			dump_stack();
> 		}
> 
> in other words the first thing you do is check a member of the
> structure you're supposed to be initializing -- if someone just
> kmalloc()s a struct kobject and passes it into this function, there's
> a good chance that state_initialized won't be zero.  In fact, with
> slab debugging on, it's guaranteed to be poisoned with a non-zero
> value.
> 
> So are users supposed to be zeroing out struct kobjects before
> initializing them?

Yes.  See also the check about the non-zero reference count when
initializing the kref, that too will trip.

> If so, this should probably be documented.

You're right.  Patches gladly accepted :)

thanks,

greg k-h
