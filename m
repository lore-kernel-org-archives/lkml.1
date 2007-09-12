Return-Path: <linux-kernel-owner+w=401wt.eu-S969760AbXILOhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969760AbXILOhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 10:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933293AbXILOhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 10:37:21 -0400
Received: from dresden.studentenwerk.mhn.de ([141.84.225.229]:57616 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933205AbXILOhT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 10:37:19 -0400
From: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>
Organization: Studentenwerk =?iso-8859-1?q?M=FCnchen?=
To: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [NFS] [patch] sunrpc: make closing of old temporary sockets work (was: problems with lockd in 2.6.22.6)
Date: Wed, 12 Sep 2007 16:37:16 +0200
User-Agent: KMail/1.9.5
Cc: trond.myklebust@fys.uio.no, netdev@vger.kernel.org,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200709121407.11151.wolfgang.walter@studentenwerk.mhn.de> <20070912133729.GA24998@fieldses.org>
In-Reply-To: <20070912133729.GA24998@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709121637.16802.wolfgang.walter@studentenwerk.mhn.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 12. September 2007 15:37 schrieb J. Bruce Fields:
> On Wed, Sep 12, 2007 at 02:07:10PM +0200, Wolfgang Walter wrote:
> > as already described old temporary sockets (client is gone) of lockd
> > aren't closed after some time. So, with enough clients and some time
> > gone, there are 80 open dangling sockets and you start getting messages
> > of the form:
> >
> > lockd: too many open TCP sockets, consider increasing the number of nfsd
> > threads.
>
> Thanks for working on this problem!
>
> > If I understand the code then the intention was that the server closes
> > temporary sockets after about 6 to 12 minutes:
> >
> > 	a timer is started which calls svc_age_temp_sockets every 6 minutes.
> >
> > 	svc_age_temp_sockets:
> > 		if a socket is marked OLD it gets closed.
> > 		sockets which are not marked as OLD are marked OLD
> >
> > 	every time the sockets receives something OLD is cleared.
> >
> > But svc_age_temp_sockets never closes any socket though because it only
> > closes sockets with svsk->sk_inuse == 0. This seems to be a bug.
> >
> > Here is a patch against 2.6.22.6 which changes the test to
> > svsk->sk_inuse <= 0 which was probably meant. The patched kernel runs
> > fine here. Unused sockets get closed (after 6 to 12 minutes)
>
> So the fact that this changes the behavior means that sk_inuse is taking
> on negative values.  This can't be right--how can something like
> svc_sock_put() (which does an atomic_dec_and_test) work in that case?

You probably misread the code.

if (atomic_read(&svsk->sk_inuse) || test_bit(SK_BUSY, &svsk->sk_flags))
	continue;

This means: any socket where svsk->sk_inuse != 0 or SK_BUSY is set is ignored
by svc_age_temp_sockets: no attempt is made to close the svc.

This seems to be wrong: if svsk->sk_inuse is zero only if svc_delete_socket
has been called for it and will be deleted anyway (probably it is already
closed then).

But the intention of svc_age_temp_sockets is to close open temporary
sockets where no traffic has been received for more than 6 minutes. These
sockets have svsk->sk_inuse >= 1.

My patch does exactly this:

instead of

"skip sockets which are not already deleted or which are busy"

to

"skip sockets which are already deleted or which are busy"

>
> I wish I had time today to figure out what's going on in this case.  But
> from a quick through svsock.c for sk_inuse, it looks odd; I'm suspicious
> of anything without the stereotyped behavior--initializing to one,
> atomic_inc()ing whenever someone takes a reference, and
> atomic_dec_and_test()ing whenever someone drops it....
>

Then svc_tcp_accept would be wrong, too (it closes sockets the same way just
without testing for sk_inuse and SK_BUSY).

I think this works because as long as a socket is in sv_tempsocks or
sv_permsocks svsk->sk_inuse can never reach zero. As svc_age_temp_sockets locks
the list nobody can bring svsk->sk_inuse to zero as long as
svc_age_temp_sockets holds the lock. As svc_age_temp_sockets calls
atomic_inc(&svsk->sk_inuse) when holding the lock there is no
problem. (the same is true for svc_tcp_accept).

This is the reason why I doubt that this check for svsk->sk_inuse in
svc_age_temp_sockets is usefull at all. It should be always false.

Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
