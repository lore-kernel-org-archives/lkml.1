Return-Path: <linux-kernel-owner+w=401wt.eu-S1764675AbYFZNHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764675AbYFZNHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759498AbYFZMtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:49:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47012 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760242AbYFZMtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:49:12 -0400
Date: Thu, 26 Jun 2008 08:49:11 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush
	requirements
Message-ID: <20080626124911.GA19285@infradead.org>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-2-git-send-email-david@fromorbit.com> <20080626112612.GW4392@parisc-linux.org> <20080626113209.GK11558@disturbed> <20080626114242.GX4392@parisc-linux.org> <20080626122112.GL11558@disturbed> <20080626124009.GY4392@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626124009.GY4392@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 06:40:09AM -0600, Matthew Wilcox wrote:
> On Thu, Jun 26, 2008 at 10:21:12PM +1000, Dave Chinner wrote:
> > On Thu, Jun 26, 2008 at 05:42:42AM -0600, Matthew Wilcox wrote:
> > > Then let's leave it as a semaphore.  You can get rid of the sema_t if
> > > you like, but I don't think that turning completions into semaphores is
> > > a good idea (because it's confusing).
> > 
> > So remind me what the point of the semaphore removal tree is again?
> 
> To remove the semaphores which don't need to be semaphores any more.
> 
> > As Christoph suggested, I can put this under another API that
> > is implemented using completions. If I have to do that in XFS,
> > so be it....
> 
> You could, yes.  But you could just use completions directly ...
> 
> > The main reason for this that we've just uncovered the fact that the
> > way XFS uses semaphores is completely unsafe [*] on x86/x86_64 for
> > kernels prior to the new generic semaphores.
> > 
> > [*] 2.6.20 panics in up() because of this race when I/O completion
> > (the up call) races with a simultaneous down() (iowaiter):
> > 
> > 	T1		T2
> > 	up()		down()
> > 			kmem_free()
> > 
> > When the down() call completes, the up() call can still be
> > referencing the semaphore, and hence if we free the structure after
> > the down call then the up() will reference freed memory.  This is
> > probably the cause of many unexplained log replay or unmount panics
> > that we've been hitting for years with buffers that been freed while
> > apparently still in use....
> 
> This is exactly the kind of thing completions were supposed to be used
> for.  T1 should be calling complete() and T2 should be calling
> wait_for_completion().

Please read Dave's introductionary mail.  What XFS wants if completions
with a little bit extra, so he implemented the little bit extra.  This
little bit extra is pretty well described in the mail starting this
thread.
