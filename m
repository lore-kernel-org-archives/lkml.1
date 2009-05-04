Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbZEDHw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbZEDHw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 03:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbZEDHwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 03:52:19 -0400
Received: from yop.chewa.net ([91.121.105.214]:47989 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbZEDHwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 03:52:19 -0400
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 May 2009 03:52:18 EDT
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Implementation of the sendgroup() system call
MIME-Version: 1.0
Date: Mon, 04 May 2009 09:42:51 +0200
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
Cc: Elad Lahav <elahav@uwaterloo.ca>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Organization: Remlab.net
In-Reply-To: <87eiv5ibnd.fsf@basil.nowhere.org>
References: <49FE47A1.7070700@uwaterloo.ca> <87eiv5ibnd.fsf@basil.nowhere.org>
Message-ID: <ca171d917a9c2657184c8fcd0a4b654e@chewa.net>
User-Agent: RoundCube Webmail/0.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 04 May 2009 10:13:10 ext Andi Kleen wrote:
> Elad Lahav <elahav@uwaterloo.ca> writes:
> > The attached patch contains an implementation of sendgroup(), a system
> > call that allows a UDP packet to be transmitted efficiently to
> > multiple recipients. Use cases for this system call include
> > live-streaming and multi-player online games.
> > The basic idea is that the caller maintains a group - a list of IP
> > addresses and UDP ports - and calls sendgroup() with the group list
> > and a common payload. Optionally, the call allows for per-recipient
> > data to be prepended or appended to the shared block. The data is
> > copied once in the kernel into an allocated page, and the
> > per-recipient socket buffers point to that page. Savings come from
> > avoiding both the multiple calls and the multiple copies of the data
> > required with regular socket operations.
>
> My guess it's more the copies than the calls? It sounds like
> you want sendfile() for UDP. I think that would be a cleaner solution
> than such a specific hack for your application. It would
> have the advantage of saving the first copy too and be
> truly zero copy on capable NICs.

Say you have a fragmented skbuff-capable NIC.

It is already possible to write() to a pipe, then issue a series of N tee()
from the pipe for each of N connected sockets, and finally splice() to
/dev/null. That would be one copy and N+2 system calls. I guess the one
copy cannot be removed because UDP payloads are not page-sized, so
vmsplice() won't cut it. As a small optmization, you could replace the last
tee() with a splice(), so that's N+1 system calls.

When using a non-connected socket and multiple destination, then you need
one corked sendmsg() to set the destination, followed by one splice() to
push the payload. That's at least 2N+1 system calls.

UDP payload will typically be small, probably 1400 bytes or less. The
system call overhead might well be higher than the memory copy overhead.

On top of that, the splice() trick only works if the NIC can cope with
fragments. The performance might be worse than with normal sendto(). The
application has no way to check this from the socket. For a reason.
Depending on the routing table, different destinations could use different
NICs with different capabilities.

To sum up, I can see to problems using splice() and friends here, with
regards to the use case:
- no support for destination socket addesses,
- no support for batch tee() operations.

Whether that justifies a new socket call is not for me to opiniate.
Personally, I would definitely use it in the RTSP broadcast output of the
VLC media player once/if it ever hits glibc.

> Or perhaps simple send to a local multicast group and let
> some netfilter module turn that into regular UDP.

Unless netfilter has changed dramatically recentely, it is not usable for
applications. A monolithic system-wide configuration paradigm is not usable
for applications, as they cannot know how not to step on another
application's feet.

-- 
Rémi Denis-Courmont

