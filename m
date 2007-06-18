Return-Path: <linux-kernel-owner+w=401wt.eu-S1762800AbXFRL5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762800AbXFRL5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 07:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761418AbXFRL4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 07:56:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53477 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761394AbXFRL4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 07:56:51 -0400
Date: Mon, 18 Jun 2007 13:01:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Graf <tgraf@suug.ch>
Cc: Miklos Szeredi <miklos@szeredi.hu>, davem@davemloft.net,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix race in AF_UNIX
Message-ID: <20070618130152.50215201@the-village.bc.nu>
In-Reply-To: <20070618104340.GZ521@postel.suug.ch>
References: <E1I0CTH-0006k3-00@dorka.pomaz.szeredi.hu>
	<20070618.021813.105401188.davem@davemloft.net>
	<E1I0DYW-0006uZ-00@dorka.pomaz.szeredi.hu>
	<20070618.023520.102546505.davem@davemloft.net>
	<E1I0DmJ-0006yg-00@dorka.pomaz.szeredi.hu>
	<20070618103241.GX521@postel.suug.ch>
	<E1I0EdX-0007Ia-00@dorka.pomaz.szeredi.hu>
	<20070618104340.GZ521@postel.suug.ch>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007 12:43:40 +0200
Thomas Graf <tgraf@suug.ch> wrote:

> * Miklos Szeredi <miklos@szeredi.hu> 2007-06-18 12:39
> > You are wrong.  Look in unix_release_sock():
> > 
> > 	if (atomic_read(&unix_tot_inflight))
> > 		unix_gc();		/* Garbage collect fds */
> > 
> > 
> > unix_tot_inflight is the number of AF_UNIX sockets currently being
> > transferred over some AF_UNIX sockets.
> > 
> > That means that just sending (non-unix socket) fds over unix sockets
> > will never invoke the gc.
> 
> That's what I meant, I'm sorry, I should have written unix socket
> file descriptor to not leave any room for misinterpretation.

You can bound the worst case on this and I think stay within the specs
(as the specs don't say a lot about it). One way would be to make
unix_gc() kick off a thread/tasklet and if the last unix_gc was within 5
seconds then use a timer to defer it - that prevents any user driven
"lets cause a ton of gc" cases.
