Return-Path: <linux-kernel-owner+w=401wt.eu-S1752737AbYKYN2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbYKYN2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 08:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbYKYN21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 08:28:27 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:36616 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbYKYN20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 08:28:26 -0500
Subject: Re: [PATCH] NFS regression in 2.6.26?, "task blocked for more than
 120 seconds"
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-nfs@vger.kernel.org, Max Kellermann <mk@cm4all.com>,
       linux-kernel@vger.kernel.org, gcosta@redhat.com,
       Grant Coady <grant_lkml@dodo.com.au>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>
In-Reply-To: <1227596962.16868.22.camel@localhost.localdomain>
References: <20081017123207.GA14979@rabbit.intern.cm-ag>
	 <1224484046.23068.14.camel@localhost.localdomain>
	 <1225539927.2221.3.camel@localhost.localdomain>
	 <1225546878.4390.3.camel@heimdal.trondhjem.org>
	 <1227596962.16868.22.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 08:28:16 -0500
Message-Id: <1227619696.7057.19.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: D6B5410FCC3461C6E0BA2648D9E2A7E410546546
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 217 max/h 9 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-25 at 07:09 +0000, Ian Campbell wrote:
> On Sat, 2008-11-01 at 09:41 -0400, Trond Myklebust wrote:
> > On Sat, 2008-11-01 at 11:45 +0000, Ian Campbell wrote:
> > > On Mon, 2008-10-20 at 07:27 +0100, Ian Campbell wrote:
> > > > So far I have bisected down to this range and am currently testing
> > > > acee478 which has been up for >4days.
> > > 
> > > Another update. It has now bisected down to a small range 
> > > 
> > > 7272dcd31d56580dee7693c21e369fd167e137fe SUNRPC: xprt_autoclose() should not call xprt_disconnect()
> > > e06799f958bf7f9f8fae15f0c6f519953fb0257c SUNRPC: Use shutdown() instead of close() when disconnecting a TCP socket
> > > ef80367071dce7d2533e79ae8f3c84ec42708dc8 SUNRPC: TCP clear XPRT_CLOSE_WAIT when the socket is closed for writes
> > > 3b948ae5be5e22532584113e2e02029519bbad8f SUNRPC: Allow the client to detect if the TCP connection is closed
> > > 67a391d72ca7efb387c30ec761a487e50a3ff085 SUNRPC: Fix TCP rebinding logic
> > > 66af1e558538137080615e7ad6d1f2f80862de01 SUNRPC: Fix a race in xs_tcp_state_change()
> > > 
> > > I'm currently testing 3b948ae5be5e22532584113e2e02029519bbad8f.
> > > 
> > > 7272dcd31d56580dee7693c21e369fd167e137fe repro'd in half a day while
> > > ef818a28fac9bd214e676986d8301db0582b92a9 (parent of
> > > 66af1e558538137080615e7ad6d1f2f80862de01) survived for 7 days.
> 
> According to bisect:
> 
> e06799f958bf7f9f8fae15f0c6f519953fb0257c is first bad commit
> commit e06799f958bf7f9f8fae15f0c6f519953fb0257c
> Author: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date:   Mon Nov 5 15:44:12 2007 -0500
> 
>     SUNRPC: Use shutdown() instead of close() when disconnecting a TCP socket
>     
>     By using shutdown() rather than close() we allow the RPC client to wait
>     for the TCP close handshake to complete before we start trying to reconnect
>     using the same port.
>     We use shutdown(SHUT_WR) only instead of shutting down both directions,
>     however we wait until the server has closed the connection on its side.
>     
>     Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> 
> I've started testing 2.6.26 + revert. It's been a long while since I
> started this process so I'll also have a go at an up to date version.
> 
> Cheers,

That would indicate that the server is failing to close the TCP
connection when the client closes on its end.

Could you remind me what server you are using? Also, does 'netstat -t'
show connections that are stuck in the CLOSE_WAIT state when you see the
hang?

Trond

