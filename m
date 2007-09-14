Return-Path: <linux-kernel-owner+w=401wt.eu-S1765510AbXINO3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765510AbXINO3x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 10:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756444AbXINO3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 10:29:43 -0400
Received: from mail.fieldses.org ([66.93.2.214]:42246 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920AbXINO3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 10:29:42 -0400
Date: Fri, 14 Sep 2007 10:29:15 -0400
To: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>
Cc: Neil Brown <neilb@suse.de>, trond.myklebust@fys.uio.no,
       netdev@vger.kernel.org, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] sunrpc: make closing of old temporary sockets work
	(was: problems with lockd in 2.6.22.6)
Message-ID: <20070914142915.GE20606@fieldses.org>
References: <200709121407.11151.wolfgang.walter@studentenwerk.mhn.de> <200709122140.57783.wolfgang.walter@studentenwerk.mhn.de> <20070912195512.GC13792@fieldses.org> <200709141112.30634.wolfgang.walter@studentenwerk.mhn.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709141112.30634.wolfgang.walter@studentenwerk.mhn.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 11:12:30AM +0200, Wolfgang Walter wrote:
> Am Mittwoch, 12. September 2007 21:55 schrieb J. Bruce Fields:
> > On Wed, Sep 12, 2007 at 09:40:57PM +0200, Wolfgang Walter wrote:
> > > On Wednesday 12 September 2007, J. Bruce Fields wrote:
> > > > On Wed, Sep 12, 2007 at 04:14:06PM +0200, Neil Brown wrote:
> > > > > So it is in 2.6.21 and later and should probably go to .stable for
> > > > > .21 and .22.
> > > > >
> > > > > Bruce:  for you :-)
> > > >
> > > > OK, thanks!  But, (as is alas often the case) I'm still confused:
> > > > >  		if (!test_and_set_bit(SK_OLD, &svsk->sk_flags))
> > > > >  			continue;
> > > > > -		if (atomic_read(&svsk->sk_inuse) || test_bit(SK_BUSY,
> > > > > &svsk->sk_flags)) +		if (atomic_read(&svsk->sk_inuse) > 1
> > > > > +		    || test_bit(SK_BUSY, &svsk->sk_flags))
> > > > >  			continue;
> > > > >  		atomic_inc(&svsk->sk_inuse);
> > > > >  		list_move(le, &to_be_aged);
> > > >
> > > > What is it that ensures svsk->sk_inuse isn't incremented or SK_BUSY set
> > > > after that test?  Not all the code that does either of those is under
> > > > the same serv->sv_lock lock that this code is.
> > >
> > > This should not matter - SK_CLOSED may be set at any time.
> > >
> > > svc_age_temp_sockets only detaches the socket, sets SK_CLOSED and then
> > > enqueues it. If SK_BUSY is set its already enqueued and svc_sock_enqueue
> > > ensures that it is not enqueued twice.
> >
> > Oh, got it.  And the list manipulation is safe thanks to sv_lock.  Neat,
> > thanks.  Can you verify that this solves your problem?
> 
> Patch works fine here.

Great, thanks again!

--b.
