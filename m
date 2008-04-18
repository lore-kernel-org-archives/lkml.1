Return-Path: <linux-kernel-owner+w=401wt.eu-S1757574AbYDRMs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbYDRMs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 08:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbYDRMss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 08:48:48 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57683 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbYDRMsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 08:48:47 -0400
To: bfields@fieldses.org
CC: miklos@szeredi.hu, trond.myklebust@fys.uio.no, eshel@almaden.ibm.com,
       neilb@suse.de, akpm@linux-foundation.org, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20080417222620.GL9912@fieldses.org> (bfields@fieldses.org)
Subject: Re: nfs: infinite loop in fcntl(F_SETLKW)
References: <E1Jk2oI-0007UX-MS@pomaz-ex.szeredi.hu> <1207861339.8180.14.camel@heimdal.trondhjem.org> <1207861661.8180.18.camel@heimdal.trondhjem.org> <1207862436.8180.30.camel@heimdal.trondhjem.org> <20080410215410.GF22324@fieldses.org> <E1JkxZI-0003Bc-9C@pomaz-ex.szeredi.hu> <20080414171909.GE15950@fieldses.org> <E1JlW1p-0006vZ-NW@pomaz-ex.szeredi.hu> <20080415185856.GI32218@fieldses.org> <E1JmAUP-0002VA-9g@pomaz-ex.szeredi.hu> <20080417222620.GL9912@fieldses.org>
Message-Id: <E1Jmq0P-0005sj-On@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 18 Apr 2008 14:47:53 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > 1) if !FL_SLEEP, then return 0 if granted, -EAGAIN on contention
> > > > 2) if FL_SLEEP and fl_grant == NULL, then return 0 if granted, block on
> > > >    contention
> > > > 3) if FL_SLEEP and fl_grant != NULL, then return 0 if granted, on
> > > >    contention:
> > > >    a) either return -EINPROGRESS and call fl_grant when granted
> > > >    b) or return -EAGAIN  and call fl_notify when the lock needs retrying
> > > 
> > > I'd put it this way (after a quick check of the code to convince myself
> > > I'm remembering this right...):
> > > 
> > >   1) If FL_SLEEP, then return 0 if granted, and on contention either:
> > >      a) block, or
> > >      b) return -EAGAIN, and call fl_notify when the lock should be
> > >         retried.
> > 
> > Gfs2 seems to return -EINPROGRESS regardless of the FL_SLEEP flag:
> 
> Oops, you're right; in FL_SLEEP case fs/lockd/svclock.c:nlmsvc_lock() 
> returns NLM_LCK_BLOCKED.  I believe it'll get an fl_grant() callback
> after that and do a grant call back to the client, but I haven't
> checked....
> 
> Note, as has been pointed out by Mark Snitzer
> (http://article.gmane.org/gmane.linux.nfs/17801/), this limits the kind
> of error reporting the filesystem can do--if it needs to block on the
> initial lock call, it has to commit to queueing up, and eventually
> granting, the lock.

OK, but that AFAICS is a lock manager implementation issue, not an API
issue.  Which is important, but not as important as the API ;)

> > > OK, but I haven't read your patch yet, apologies....
> > 
> > No problem.  Here it is again with some cosmetic fixes and testing.
> 
> Thanks!  Ping me in a couple days if I haven't made any comments.  From
> a quick skim the GFS2 change and the error return change both seem
> reasonable.
> 
> I need to a real GFS2 testing setup....  (Did you test GFS2 locking
> specifically?)

No gfs2, only ext3.

Thanks,
Miklos
