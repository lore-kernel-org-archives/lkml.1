Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbYEaXUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbYEaXUO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 19:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbYEaXUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 19:20:01 -0400
Received: from linode.ducksong.com ([64.22.125.164]:44084 "EHLO
	linode.ducksong.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbYEaXUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 19:20:00 -0400
X-Greylist: delayed 2046 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 May 2008 19:20:00 EDT
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
From: Patrick McManus <mcmanus@ducksong.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
In-Reply-To: <20080531163501.GB22607@elte.hu>
References: <20080526115628.GA31316@elte.hu>
	 <20080529084524.GA24892@elte.hu>
	 <Pine.LNX.4.64.0805291332401.16829@wrl-59.cs.helsinki.fi>
	 <20080529112257.GA18130@elte.hu> <20080530181839.GA31915@elte.hu>
	 <20080531060947.GA26441@elte.hu>
	 <Pine.LNX.4.64.0805311431100.2329@wrl-59.cs.helsinki.fi>
	 <Pine.LNX.4.64.0805311505410.2329@wrl-59.cs.helsinki.fi>
	 <20080531125428.GA22111@elte.hu>
	 <Pine.LNX.4.64.0805311555570.2329@wrl-59.cs.helsinki.fi>
	 <20080531163501.GB22607@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Date: Sat, 31 May 2008 18:46:14 -0400
Message-Id: <1212273974.28319.107.camel@tng>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-05-31 at 18:35 +0200, Ingo Molnar wrote:
> * Ilpo Järvinen <ilpo.jarvinen@helsinki.fi> wrote:
> 

> > ...setsockopt(listenfd, SOL_TCP, TCP_DEFER_ACCEPT, &val, sizeof(val)) 
> > seems to be the magic trick that is interestion here.
> 
> seems to be used:
> 
>  22003 write(3, "distccd[22003] (dcc_listen_by_ad"..., 62) = 62
>  22003 listen(4, 10)                     = 0
>  22003 setsockopt(4, SOL_TCP, TCP_DEFER_ACCEPT, [1], 4) = 0
> 
> i'll queue up your reverts for testing in -tip.


So the code you will revert came from my fingers. The circumstances here
make me nervous; while I'm at a loss to explain what might be going on
in particular, let me offer an apology in advance should the revert help
resolve the issue.

Here's what makes me nervous:

 * not a lot of code uses DEFER_ACCEPT.. frankly it was pretty broken
before 26 - but not broken this way .. the correlation of your bug using
it is significant. 

 * in 26, a server TCP socket (with DA) goes to ESTABLISHED when the 3rd
part of the handshake is received (as normal without DA), but the socket
isn't put on the accept queue until a real data packet arrives. (That's
the point of DA). In <= 25 this socket would have syn-recv until the
data packet arrived.

  - I did run tests where the server died in between the handshake being
completed and first data packet arriving - the client should see RST and
the server socket should disappear. But maybe something was missed?

Do I understand this correctly, the server process is gone but the
socket is still in the table? And the client process is still there
waiting for the server to do something - having sent a bunch of data?

Do we know if any data bytes (not handshake bytes) have been consumed by
the server side? If they were, that would seem to vindicate DA.

Also pointing away from DA is that you started seeing this with rc3 -
that code was included in rc1.Is that a firm observation, or maybe there
weren't enough datapoints to conclude that rc1 and rc2 were clean?

The most interesting patch is ec3c0982a2dd1e671bad8e9d26c28dcba0039d87
if anyone wants to eyeball it.



 

