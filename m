Return-Path: <linux-kernel-owner+w=401wt.eu-S1762241AbXH3OwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762241AbXH3OwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759996AbXH3Ovz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:51:55 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55582 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759337AbXH3Ovy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:51:54 -0400
Date: Thu, 30 Aug 2007 08:51:53 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] TASK_KILLED
Message-ID: <20070830145153.GT14130@parisc-linux.org>
References: <20070829204048.GQ14130@parisc-linux.org> <1188479497.6755.12.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188479497.6755.12.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 09:11:37AM -0400, Trond Myklebust wrote:
> > diff --git a/fs/read_write.c b/fs/read_write.c
> > index 507ddff..29e3f21 100644
> > --- a/fs/read_write.c
> > +++ b/fs/read_write.c
> > @@ -220,7 +220,7 @@ Einval:
> >  
> >  static void wait_on_retry_sync_kiocb(struct kiocb *iocb)
> >  {
> > -	set_current_state(TASK_UNINTERRUPTIBLE);
> > +	set_current_state(TASK_KILLABLE);
> >  	if (!kiocbIsKicked(iocb))
> >  		schedule();
> >  	else
> 
> Won't this change just cause functions like do_sync_read() and
> do_sync_write() to loop forever when you kill the process?

Indeed.  I didn't intend to include this hunk because I hadn't tested
it -- I've not seen a task get stuck there.  In trying to fix it, I
noticed that the sync_page_killable() is inadequate -- it'll return -EIO
for any signal, not just a fatal one.  Sure, other signals won't wake
it, but if they're pending, it'll do the wrong thing.  Fixed patch
coming up ... just as soon as I find out what other bug I've introduced.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
