Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbYDMUiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbYDMUiT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 16:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbYDMUiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 16:38:09 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:60727 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbYDMUiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 16:38:08 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 13 Apr 2008 13:37:59 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] anon_inodes.c cleanups.
In-Reply-To: <200804130426.09365.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0804121512500.10140@alien.or.mcafeemobile.com>
References: <200804110835.07989.rusty@rustcorp.com.au>
 <Pine.LNX.4.64.0804111807340.12407@alien.or.mcafeemobile.com>
 <200804130426.09365.rusty@rustcorp.com.au>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008, Rusty Russell wrote:

> On Saturday 12 April 2008 11:15:26 Davide Libenzi wrote:
> > On Fri, 11 Apr 2008, Rusty Russell wrote:
> > > Arnd pointed me at anon_inode_getfd(), and the code annoyed me enough
> > > to send this patch.
> > >
> > > Mainly because the init routine carefully checks for errors, then panics
> > > (because we shouldn't run out of memory at boot).  Unfortunately, it's
> > > actually worse than simply oopsing, where we'd know what had failed.
> > >
> > > 1) anon_inode_inode can be read_mostly, same as anon_inode_mnt.
> >
> > Sure.
> >
> > > 3) anon_inode_mkinode has one caller, so it's a little confusing.
> >
> > Hmm? The function groups the code necessary to create the anonfds inode.
> > If every function that has one call site would be inlined, we'd have
> > monster long functions. Functions also have the purpose to group some code
> > that does some task, into a single unit (and the function name hopefully
> > gives an hint about what's doing). The compiler (not that in this case
> > really matter, since it's not even a slow-path, is a once-run path) may
> > take care of inlining, if sees that appropriate.
> 
> If you'd called it, say, "setup_anon_inode()", it would be fine.  It seems 
> overly generic unless you planned on calling it elsewhere.

That's fine with me. I'll wait for Al's tree to get merged and I'll change 
the name (and the read_mostly bits).



> > > 2) The IS_ERR(anon_inode_inode) check is unneeded, since we panic on
> > >    boot if that were true.
> > > 4) Don't clean up before panic.
> > > 5) Panic gives less information than an oops would, plus is untested.
> >
> > I remember we changed the failure-path of anonfds a couple of times along
> > the way, but I can't find email traces about why we did it.
> > So, I prefer error-checked code instead of oopses, and given that the
> > anonfds subsystem is not a required one for most of the components of the
> > kernel/userspace, I'd rather prefer to drop the panic().
> 
> We've seen this debate before, and I'm firmly on the "don't turn oopses into  
> errors on boot paths" side.  I know others disagree.
> 
> Given that it should never happen, I'd argue the highest priority minimal 
> amount of code, and second is ease of debugging if it ever did happen to 
> someone.  Oopsing has those features.

This, I'd prefer to have the bounce error back to do_initcalls() instead 
of nailing the system (given the non criticality of the anonfds subsystem). 




- Davide


