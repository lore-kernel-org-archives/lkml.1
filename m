Return-Path: <linux-kernel-owner+w=401wt.eu-S1759038AbYFRE4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbYFRE4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 00:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbYFRE4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 00:56:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48004
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753131AbYFRE4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 00:56:30 -0400
Date: Tue, 17 Jun 2008 21:56:30 -0700 (PDT)
Message-Id: <20080617.215630.47207590.davem@davemloft.net>
To: rweikusat@mssgmbh.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.25.7] af_unix: fix 'poll for write'/ connected
 DGRAM sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <871w2wca3r.fsf@fever.mssgmbh.com>
References: <871w2wca3r.fsf@fever.mssgmbh.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rainer Weikusat <rweikusat@mssgmbh.com>
Date: Tue, 17 Jun 2008 20:47:02 +0200

> The unix_dgram_sendmsg routine implements a (somewhat crude)
> form of receiver-imposed flow control by comparing the length of the
> receive queue of the 'peer socket' with the max_ack_backlog value
> stored in the corresponding sock structure, either blocking
> the thread which caused the send-routine to be called or returning
> EAGAIN. This routine is used by both SOCK_DGRAM and SOCK_SEQPACKET
> sockets. The poll-implementation for these socket types is
> datagram_poll from core/datagram.c. A socket is deemed to be writeable
> by this routine when the memory presently consumed by datagrams
> owned by it is less than the configured socket send buffer size. This
> is always wrong for connected PF_UNIX non-stream sockets when the
> abovementioned receive queue is currently considered to be full.
> 'poll' will then return, indicating that the socket is writeable, but
> a subsequent write result in EAGAIN, effectively causing an
> (usual) application to 'poll for writeability by repeated send request
> with O_NONBLOCK set' until it has consumed its time quantum.
> 
> The change below uses a suitably modified variant of the datagram_poll
> routines for both type of PF_UNIX sockets, which tests if the
> recv-queue of the peer a socket is connected to is presently
> considered to be 'full' as part of the 'is this socket
> writeable'-checking code. The socket being polled is additionally
> put onto the peer_wait wait queue associated with its peer, because the
> unix_dgram_sendmsg routine does a wake up on this queue after a
> datagram was received and the 'other wakeup call' is done implicitly
> as part of skb destruction, meaning, a process blocked in poll
> because of a full peer receive queue could otherwise sleep forever
> if no datagram owned by its socket was already sitting on this queue.
> Among this change is a small (inline) helper routine named
> 'unix_recvq_full', which consolidates the actual testing code (in three
> different places) into a single location.
> 
> Signed-off-by: <rweikusat@mssgmbh.com>

Thank you for fixing this bug.

I'm going to review the logic in the new poll routing a little
bit more, then apply it to net-2.6 unless I find some problems.

Thanks again.
