Return-Path: <linux-kernel-owner+w=401wt.eu-S1750844AbZFJDJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750844AbZFJDJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbZFJDI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:08:57 -0400
Received: from relay1.sgi.com ([192.48.179.29]:48277 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750749AbZFJDI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:08:57 -0400
Date: Tue, 9 Jun 2009 22:08:52 -0500
From: Jack Steiner <steiner@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch 04/12] GRU - collect per-context user statistics
Message-ID: <20090610030852.GD25284@sgi.com>
References: <20090608171648.988318000@sgi.com> <20090608171953.673876000@sgi.com> <20090608160740.4d57ba5d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608160740.4d57ba5d.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 04:07:40PM -0700, Andrew Morton wrote:
> On Mon, 08 Jun 2009 12:16:52 -0500
> steiner@sgi.com wrote:
> 
> >  /*
> > + * Fetch GSEG statisticss
> > + */
> > +long gru_get_gseg_statistics(unsigned long arg)
> > +{
> > +	struct gru_thread_state *gts;
> > +	struct gru_get_gseg_statistics_req req;
> > +
> > +	if (copy_from_user(&req, (void __user *)arg, sizeof(req)))
> > +		return -EFAULT;
> > +
> > +	gts = gru_find_lock_gts(req.gseg);
> > +	if (gts) {
> > +		memcpy(&req.stats, &gts->ustats, sizeof(gts->ustats));
> > +		gru_unlock_gts(gts);
> > +	} else {
> > +		memset(&req.stats, 0, sizeof(gts->ustats));
> > +	}
> > +
> > +	if (copy_to_user((void __user *)arg, &req, sizeof(req)))
> > +		return -EFAULT;
> > +
> > +	return 0;
> > +}
> 
> So..  what's happening in the super-secret undocumented gts==NULL path?
> 
> It _looks_ like userspace passed into this ioctl a handle for something
> which the kernel doesn't know about.  If so, shouldn't we return
> -EINVAL or something?  

It makes sense but certainly needs a comment (will send later) to
explain the logic.

User space creates arrays of GRU contexts for threaded processes. The
library code that prints statistics scans the array & generates
statistic for each context. If an context was never referenced, there is
no GTS & all statistics are implicitly zero.

This could have been handled other ways but it is rare than an entry was
never referenced. A return of -EINVAL current is considered a bug, ie.
address is not a valid GRU address.


--- jack
