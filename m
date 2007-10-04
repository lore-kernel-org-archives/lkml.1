Return-Path: <linux-kernel-owner+w=401wt.eu-S1760259AbXJDS4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259AbXJDS4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 14:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756584AbXJDSzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 14:55:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38781 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756509AbXJDSzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 14:55:51 -0400
Date: Thu, 4 Oct 2007 11:54:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: miklos@szeredi.hu, wfg@mail.ustc.edu.cn, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove throttle_vm_writeout()
Message-Id: <20071004115458.10897e51.akpm@linux-foundation.org>
In-Reply-To: <1191521410.5574.36.camel@lappy>
References: <E1IdPla-0002Bd-00@dorka.pomaz.szeredi.hu>
	<1191501626.22357.14.camel@twins>
	<E1IdQJn-0002Cv-00@dorka.pomaz.szeredi.hu>
	<1191504186.22357.20.camel@twins>
	<E1IdR58-0002Fq-00@dorka.pomaz.szeredi.hu>
	<1191516427.5574.7.camel@lappy>
	<20071004104650.d158121f.akpm@linux-foundation.org>
	<1191521410.5574.36.camel@lappy>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Oct 2007 20:10:10 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> 
> On Thu, 2007-10-04 at 10:46 -0700, Andrew Morton wrote:
> > On Thu, 04 Oct 2007 18:47:07 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > > static int may_write_to_queue(struct backing_dev_info *bdi)
> > > {
> > > 	if (current->flags & PF_SWAPWRITE)
> > > 		return 1;
> > > 	if (!bdi_write_congested(bdi))
> > > 		return 1;
> > > 	if (bdi == current->backing_dev_info)
> > > 		return 1;
> > > 	return 0;
> > > }
> > > 
> > > Which will write to congested queues. Anybody know why?
> 
> OK, I guess I could have found that :-/

Nice changelog, if I do say so myself ;)

> >     One fix for this would be to add an additional "really congested"
> >     threshold in the request queues, so kswapd can still perform
> >     nonblocking writeout.  This gives kswapd priority over pdflush while
> >     allowing kswapd to feed many disk queues.  I doubt if this will be
> >     called for.
> 
> I could do that.

I guess first you'd need to be able to reproduce the problem which that
patch fixed, then check that it remains fixed.

Sigh.  That problem was fairly subtle.  We could re-break reclaim in
this way and not find out about it for six months.  There's a lesson here. 
Several.  
