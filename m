Return-Path: <linux-kernel-owner+w=401wt.eu-S1761997AbXFRKkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761997AbXFRKkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759260AbXFRKkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 06:40:40 -0400
Received: from postel.suug.ch ([194.88.212.233]:38284 "EHLO postel.suug.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758852AbXFRKkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 06:40:39 -0400
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jun 2007 06:40:39 EDT
Date: Mon, 18 Jun 2007 12:40:59 +0200
From: Thomas Graf <tgraf@suug.ch>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: davem@davemloft.net, akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       alan@lxorguk.ukuu.org.uk, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix race in AF_UNIX
Message-ID: <20070618104059.GY521@postel.suug.ch>
References: <E1I0CTH-0006k3-00@dorka.pomaz.szeredi.hu> <20070618.021813.105401188.davem@davemloft.net> <E1I0DYW-0006uZ-00@dorka.pomaz.szeredi.hu> <20070618.023520.102546505.davem@davemloft.net> <E1I0DmJ-0006yg-00@dorka.pomaz.szeredi.hu> <20070618103241.GX521@postel.suug.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618103241.GX521@postel.suug.ch>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Graf <tgraf@suug.ch> 2007-06-18 12:32
> * Miklos Szeredi <miklos@szeredi.hu> 2007-06-18 11:44
> > Garbage collection only ever happens, if the app is sending AF_UNIX
> > sockets over AF_UNIX sockets.  Which is a rather rare case.  And which
> > is basically why this bug went unnoticed for so long.
> > 
> > So my second patch only affects the performance of _exactly_ those
> > apps which might well be bitten by the bug itself.
> 
> That's not entirely the truth. It affects all applications using
> AF_UNIX sockets while file descriptors are being transfered. I
> agree that the performance impact is not severe on most systems
> but if file descriptors are being transfered continously by just
> a single application it can become rather severe.

Also think of the scenario where an application, deliberately or not,
begins a file descriptor tranfser using sendmsg() and the receiving
part never invokes recvmsg() to decrement the inflight counters
again. Every unix socket that gets closed would result in a gc call
locking all sockets.
