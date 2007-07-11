Return-Path: <linux-kernel-owner+w=401wt.eu-S1765302AbXGKOu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765302AbXGKOu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 10:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763057AbXGKOuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 10:50:18 -0400
Received: from ns1.coraid.com ([65.14.39.133]:26908 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759723AbXGKOuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 10:50:17 -0400
Date: Wed, 11 Jul 2007 10:46:10 -0400
From: "Ed L. Cashin" <ecashin@coraid.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Greg K-H <greg@kroah.com>
Subject: Re: [PATCH 02/12] handle multiple network paths to AoE device
Message-ID: <20070711144610.GE32346@coraid.com>
References: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com> <60bd316bfa72fb225cefad39569999e583f4f72e.1182883861.git.ecashin@coraid.com> <20070702212949.5a1a1a31.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070702212949.5a1a1a31.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2007 at 09:29:49PM -0700, Andrew Morton wrote:
> On Tue, 26 Jun 2007 14:50:10 -0400 "Ed L. Cashin" <ecashin@coraid.com> wrote:
...
> > +loop:
> > +	skb = aoecmd_ata_id(d);
> >  	spin_unlock_irqrestore(&d->lock, flags);
> > +	if (!skb && !msleep_interruptible(200)) {
> > +		spin_lock_irqsave(&d->lock, flags);
> > +		goto loop;
> > +	}
> > +	aoenet_xmit(skb);
> >  	aoecmd_cfg(major, minor);
> > -
> >  	return 0;
> >  }
> 
> interruptible sleep?  Does this code work as intended when there's a signal
> pending?  (Maybe that's what the interruptible sleep is for: don't know,
> and am not inclined to work it out given the (low) level of comments in
> here and the (lower) level of changelogging).

Yes, if a signal is pending, then msleep_interruptible will not return
0.  That means we will not loop but will call aoenet_xmit with a NULL
skb, which is a noop.  So if the system is too low on memory or the
aoe driver is too low on frames, then the user can hit control-C to
interrupt the attempt to do a revalidate.

I will add a comment to that effect in the resubmitted patch.

-- 
  Ed L Cashin <ecashin@coraid.com>
