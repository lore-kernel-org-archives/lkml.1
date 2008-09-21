Return-Path: <linux-kernel-owner+w=401wt.eu-S1752536AbYIUJYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbYIUJYw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 05:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYIUJYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 05:24:44 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:42084 "HELO
	shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751150AbYIUJYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 05:24:43 -0400
Date: Sun, 21 Sep 2008 04:24:42 -0500
From: lkml@pengaru.com
To: linux-kernel@vger.kernel.org
Subject: Re: Honoring SO_RCVLOWAT in proto_ops.poll methods
Message-ID: <20080921092442.GS2761@fc6222126.aspadmin.net>
References: <20080920214229.GP2761@fc6222126.aspadmin.net> <20080920.152140.193698477.davem@davemloft.net> <20080920230046.GQ2761@fc6222126.aspadmin.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080920230046.GQ2761@fc6222126.aspadmin.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 06:00:46PM -0500, lkml@pengaru.com wrote:
> On Sat, Sep 20, 2008 at 03:21:40PM -0700, David Miller wrote:
> > From: lkml@pengaru.com
> > Date: Sat, 20 Sep 2008 16:42:29 -0500
> > 
> > > I have a need for select/poll/epoll_wait to block on sockets which have
> > > unread data sitting in the receive buffer with a quantity less than
> > > specified via setsockopt() w/SO_RCVLOWAT, not less than one like the
> > > current implementation.
> > 
> > If BSD never provided this behavior, such a change is likely
> > to break applications.
> 
> I did a quick look through FreeBSD source on fxr and found this macro:
> http://fxr.watson.org/fxr/source/sys/socketvar.h#L197
> 
> Which is used by the generic socket poll here:
> http://fxr.watson.org/fxr/source/kern/uipc_socket.c#L2731
> 
> You can look throughout that listing and so_rcv.sb_lowat is always what
> is compared against for determining rcv buf readability.
> 
> You might also want to look at the socket(7) man page which implies that
> what Linux currently does is exceptional & incorrect:
> 
>        SO_RCVLOWAT and SO_SNDLOWAT
>               Specify the minimum number of bytes in  the  buffer  until
>               the  socket  layer  will  pass  the  data  to the protocol
>               (SO_SNDLOWAT) or  the  user  on  receiving  (SO_RCVLOWAT).
>               These two values are initialised to 1.  SO_SNDLOWAT is not
>               changeable on Linux (setsockopt fails with the error  ENO-
>               PROTOOPT).   SO_RCVLOWAT  is  changeable  only since Linux
>               2.4.  The select(2) and poll(2) system calls currently  do
>               not  respect  the SO_RCVLOWAT setting on Linux, and mark a
>               socket readable when even a single byte of data is  avail-
>               able.   A subsequent read from the socket will block until
>               SO_RCVLOWAT bytes are available.
> 

I've been working on my application further and finally got around to
testing it with the assumption that poll won't block with regard to
SO_RCVLOWAT, and to my surprise even my recv() calls with MSG_PEEK flags
set are not blocking.  They block without MSG_PEEK, but not with.

Upon further investigation I find in tcp.c tcp_recvmsg() 2.6.26.5:

1306         target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);

...snip...

1371                 if (copied >= target && !sk->sk_backlog.tail)
1372                         break;
1373 
1374                 if (copied) {
1375                         if (sk->sk_err ||
1376                             sk->sk_state == TCP_CLOSE ||
1377                             (sk->sk_shutdown & RCV_SHUTDOWN) ||
1378                             !timeo ||
1379                             signal_pending(current) ||
1380                             (flags & MSG_PEEK))
1381                                 break;
1382                 } else {


So line #1380 drops out without satisfying copied >= target if MSG_PEEK is
set, and if you look at the remainder of the function it's assuming that
it needs to cleanup buffers before waiting for more.  So fixing this guy
is likely not as trivial as fixing poll, since the rest of the function
has to be massaged to not try free things be in MSG_PEEK mode.

Once again, this deviates from FreeBSD behavior.

At this point, for my application to work on Linux without burning CPU like
mad... I basically have to sleep and poll the socket regularly to see if
more data has arrived with the tcp socket ioctl SIOCINQ. :(

Regards,
Vito Caputo
