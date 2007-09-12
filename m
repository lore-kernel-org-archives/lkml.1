Return-Path: <linux-kernel-owner+w=401wt.eu-S967274AbXILNiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967274AbXILNiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 09:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965613AbXILNh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 09:37:56 -0400
Received: from mail.fieldses.org ([66.93.2.214]:42217 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965753AbXILNhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 09:37:55 -0400
Date: Wed, 12 Sep 2007 09:37:29 -0400
To: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>
Cc: trond.myklebust@fys.uio.no, netdev@vger.kernel.org,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [NFS] [patch] sunrpc: make closing of old temporary sockets
	work (was: problems with lockd in 2.6.22.6)
Message-ID: <20070912133729.GA24998@fieldses.org>
References: <200709121407.11151.wolfgang.walter@studentenwerk.mhn.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709121407.11151.wolfgang.walter@studentenwerk.mhn.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 02:07:10PM +0200, Wolfgang Walter wrote:
> as already described old temporary sockets (client is gone) of lockd aren't
> closed after some time. So, with enough clients and some time gone, there
> are 80 open dangling sockets and you start getting messages of the form:
> 
> lockd: too many open TCP sockets, consider increasing the number of nfsd threads.

Thanks for working on this problem!

> If I understand the code then the intention was that the server closes
> temporary sockets after about 6 to 12 minutes:
> 
> 	a timer is started which calls svc_age_temp_sockets every 6 minutes.
> 
> 	svc_age_temp_sockets:
> 		if a socket is marked OLD it gets closed.
> 		sockets which are not marked as OLD are marked OLD
> 
> 	every time the sockets receives something OLD is cleared.
> 
> But svc_age_temp_sockets never closes any socket though because it only
> closes sockets with svsk->sk_inuse == 0. This seems to be a bug.
> 
> Here is a patch against 2.6.22.6 which changes the test to
> svsk->sk_inuse <= 0 which was probably meant. The patched kernel runs fine
> here. Unused sockets get closed (after 6 to 12 minutes)

So the fact that this changes the behavior means that sk_inuse is taking
on negative values.  This can't be right--how can something like
svc_sock_put() (which does an atomic_dec_and_test) work in that case?

I wish I had time today to figure out what's going on in this case.  But
from a quick through svsock.c for sk_inuse, it looks odd; I'm suspicious
of anything without the stereotyped behavior--initializing to one,
atomic_inc()ing whenever someone takes a reference, and
atomic_dec_and_test()ing whenever someone drops it....

--b.
