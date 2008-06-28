Return-Path: <linux-kernel-owner+w=401wt.eu-S1752659AbYF1Cep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbYF1Cep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 22:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbYF1Cef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 22:34:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46683
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751726AbYF1Cee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 22:34:34 -0400
Date: Fri, 27 Jun 2008 19:34:34 -0700 (PDT)
Message-Id: <20080627.193434.123469914.davem@davemloft.net>
To: rweikusat@mssgmbh.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.25.7 v1-v2] af_unix: fix 'poll for write'/connected
 DGRAM sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <87bq1wp6ua.fsf@fever.mssgmbh.com>
References: <87tzfpse93.fsf_-_@fever.mssgmbh.com>
	<20080619.161313.90488863.davem@davemloft.net>
	<87bq1wp6ua.fsf@fever.mssgmbh.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rainer Weikusat <rweikusat@mssgmbh.com>
Date: Fri, 20 Jun 2008 15:35:25 +0200

> For n:1 'datagram connections' (eg /dev/log), the unix_dgram_sendmsg
> routine implements a form of receiver-imposed flow control by
> comparing the length of the receive queue of the 'peer socket' with
> the max_ack_backlog value stored in the corresponding sock structure,
> either blocking the thread which caused the send-routine to be called
> or returning EAGAIN. This routine is used by both SOCK_DGRAM and
> SOCK_SEQPACKET sockets. The poll-implementation for these socket types
> is datagram_poll from core/datagram.c. A socket is deemed to be
> writeable by this routine when the memory presently consumed by
> datagrams owned by it is less than the configured socket send buffer
> size. This is always wrong for PF_UNIX non-stream sockets connected to
> server sockets dealing with (potentially) multiple clients if the
> abovementioned receive queue is currently considered to be full.
> 'poll' will then return, indicating that the socket is writeable, but
> a subsequent write result in EAGAIN, effectively causing an (usual)
> application to 'poll for writeability by repeated send request with
> O_NONBLOCK set' until it has consumed its time quantum.
> 
> The change below uses a suitably modified variant of the datagram_poll
> routines for both type of PF_UNIX sockets, which tests if the
> recv-queue of the peer a socket is connected to is presently
> considered to be 'full' as part of the 'is this socket
> writeable'-checking code. The socket being polled is additionally
> put onto the peer_wait wait queue associated with its peer, because the
> unix_dgram_recvmsg routine does a wake up on this queue after a
> datagram was received and the 'other wakeup call' is done implicitly
> as part of skb destruction, meaning, a process blocked in poll
> because of a full peer receive queue could otherwise sleep forever
> if no datagram owned by its socket was already sitting on this queue.
> Among this change is a small (inline) helper routine named
> 'unix_recvq_full', which consolidates the actual testing code (in three
> different places) into a single location.
> 
> Signed-off-by: Rainer Weikusat <rweikusat@mssgmbh.com>

Applied, thanks a lot Rainer.
