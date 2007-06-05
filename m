Return-Path: <linux-kernel-owner+w=401wt.eu-S932173AbXFEHCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbXFEHCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 03:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761407AbXFEHCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 03:02:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45137
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754802AbXFEHCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 03:02:32 -0400
Date: Tue, 05 Jun 2007 00:02:47 -0700 (PDT)
Message-Id: <20070605.000247.18308209.davem@davemloft.net>
To: miklos@szeredi.hu
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix race in AF_UNIX
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1Hv980-0006gQ-00@dorka.pomaz.szeredi.hu>
References: <E1HubUt-0004Hb-00@dorka.pomaz.szeredi.hu>
	<E1Hv980-0006gQ-00@dorka.pomaz.szeredi.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 04 Jun 2007 11:45:32 +0200

> > A recv() on an AF_UNIX, SOCK_STREAM socket can race with a
> > send()+close() on the peer, causing recv() to return zero, even though
> > the sent data should be received.
> > 
> > This happens if the send() and the close() is performed between
> > skb_dequeue() and checking sk->sk_shutdown in unix_stream_recvmsg():
> > 
> > process A  skb_dequeue() returns NULL, there's no data in the socket queue
> > process B  new data is inserted onto the queue by unix_stream_sendmsg()
> > process B  sk->sk_shutdown is set to SHUTDOWN_MASK by unix_release_sock()
> > process A  sk->sk_shutdown is checked, unix_release_sock() returns zero
> 
> This is only part of the story.  It turns out, there are other races
> involving the garbage collector, that can throw away perfectly good
> packets with AF_UNIX sockets in them.
> 
> The problems arise when a socket goes from installed to in-flight or
> vica versa during garbage collection.  Since gc is done with a
> spinlock held, this only shows up on SMP.
> 
> The following patch fixes it for me, but it's possibly the wrong
> approach.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

I haven't seen a repost of the first patch, which is necessary because
that first patch doesn't apply to the current tree.  Please don't
ignore Arnaldo's feedback like that, or else I'll ignore you just the
same. :-)

