Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbYH2Q64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbYH2Q64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755778AbYH2Q6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:58:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37717 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbYH2Q6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:58:45 -0400
Date: Fri, 29 Aug 2008 11:58:47 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Markku Savela <msa@moth.iki.fi>, linux-kernel@vger.kernel.org
Subject: Re: Frustrated with capabilities..
Message-ID: <20080829165847.GA19672@hallyn.com>
References: <87hc96by8x.fsf@burp.tkv.asdf.org> <20080828141826.GA6797@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080828141826.GA6797@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Machek (pavel@suse.cz):
> On Wed 2008-08-27 12:31:10, Markku Savela wrote:
> > I just want to run an exectable with limited capabilities and assumed
> > the following approach would work fine:
> > 
> >  1) fork process
> >  2) in child
> > 
> >     2.1 set current capabilities (eip) using cap_set_proc
> >     2.2 execve the executable.
> > 
> > But it frigging does not work! Just before the execve, the result of
> > cap_to_text is
> > 
> >     = cap_net_bind_service+eip
> > 
> > but, in the execve executable, the result is suddenly
> > 
> >     = cap_net_bind_service+i
> > 
> > Why does the execve clear the effective and permitted capabities,
> > against my clear instructions? (I also have the prctl KEEP_CAPS set,

KEEP_CAPS prevents capability set clearing at setuid, not at exec.

> > though in this case it should be irrelevant).
> > 
> > - The kernel is from ubuntu distro, 2.6.24.
> > 
> > - the executable *does* *not* have any setuid/setgid bits
> > 
> > - the upcoming file capabities will not be any help, because I will
> >   need to start the same executable with different capabilities
> >   depending on context.

They will help.  The context is pI.  When a file is executed, the task's
new permitted set is calculated as:

	pP' = (fI&pI) | (fP & X)

So you can give /bin/foo the file capabilities:
	fI=cap1,cap2,cap3
Then task 1 runs with pI=cap1, so when it executes /bin/foo it will get
	pP' = cap1
Task 2 runs with pI=cap2,cap3,cap4 so when it executes /bin/foo it will
get
	pP' = cap2,cap3

> Yes, you need upcoming filesystem capabilities.  Binary may not
> inherit capabilities unless filesystem flags permit that.
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
