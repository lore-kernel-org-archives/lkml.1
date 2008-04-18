Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbYDROc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbYDROc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 10:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbYDROcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 10:32:45 -0400
Received: from ozlabs.org ([203.10.76.45]:42866 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbYDROco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 10:32:44 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] /dev/vring: simple userspace-kernel ringbuffer interface.
Date: Sat, 19 Apr 2008 00:32:39 +1000
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org, Max Krasnyansky <maxk@qualcomm.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <200804181433.48488.rusty@rustcorp.com.au> <200804181439.49051.rusty@rustcorp.com.au> <20080418041846.db15150b.akpm@linux-foundation.org>
In-Reply-To: <20080418041846.db15150b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804190032.39626.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 April 2008 21:18:46 Andrew Morton wrote:
> > +	/* Must be a power of two, and limit indices to a u16. */
> > +	if (!num_descs || (num_descs & (num_descs-1)) || num_descs > 65536)
>
> We have an is_power_of_2().

Thanks, fixed.

> > + * vring_get - check out a vring file descriptor
> > + * @filp: the file structure to attach to (eg. from fget()).
> > + *
> > + * Userspace opens /dev/vring and mmaps it, then hands that fd to the
> > + * kernel subsystem it wants to communicate with.  That subsystem uses
> > + * this routine and vring_set_ops() to attach to it.
> > + *
> > + * This simply checks that it really is a vring fd (otherwise it
> > + * returns NULL), the other routine checks that it's not already
> > + * attached.
> > + */
>
> hm, I don't understand the big picture here yet.
>
> Isn't this kinda-sorta like what a relayfs file does?  The oprofile
> buffers?  etc?  Nothing in common at all, no hope?

An excellent question, but I thought the modern kernel etiquette was to only 
comment on whitespace and formatting, and call it "review"? :)

Yes, kinda-sorta in that it's a ring buffer.  No, in that it's bidir and 
consumption can be out-of-order (kind of important for I/O buffers).

But the reason I'm not proposing it as a syscall is that I'm not convinced 
it's the One True Solution which everyone should be using.  Time will tell: 
it's clearly not tied to tun and it's been generically useful for virtual 
I/O, but history has not been kind to new userspace interfaces.

> > +	mutex_unlock(&vr->lock);
> > +	local_irq_enable();
>
> what's this doing here?

Snot from previous version.  Removed.

> > +void vring_unset_ops(struct vring_info *vr)
> > +{
> > +	BUG_ON(!vr->ops);
> > +	mutex_lock(&vr->lock);
> > +	vr->ops = NULL;
> > +	mutex_unlock(&vr->lock);
> > +}
> > +EXPORT_SYMBOL_GPL(vring_unset_ops);
>
> Isn't this just vring_set_ops(vr, NULL, NULL)?

Yes, except I like the clarity and the BUG_ON.

> ponders #include <copyright.h>

"#include <copyright-gpl2-plus>" for me, just to add more inclement weather to 
that teacup...

Thanks,
Rusty.
