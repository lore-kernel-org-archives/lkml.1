Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbYFRMbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbYFRMbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 08:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbYFRMbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 08:31:21 -0400
Received: from mss-uk.mssgmbh.com ([217.174.251.109]:45672 "EHLO
	mss-uk.mssgmbh.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbYFRMbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 08:31:19 -0400
To: David Miller <davem@davemloft.net>
Cc: rweikusat@mssgmbh.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.25.7] af_unix: fix 'poll for write'/ connected DGRAM sockets
In-Reply-To: <20080617.215630.47207590.davem@davemloft.net> (David Miller's message of "Tue, 17 Jun 2008 21:56:30 -0700 (PDT)")
References: <871w2wca3r.fsf@fever.mssgmbh.com>
	<20080617.215630.47207590.davem@davemloft.net>
From: Rainer Weikusat <rweikusat@mssgmbh.com>
Date: Wed, 18 Jun 2008 14:31:07 +0200
Message-ID: <874p7qsz5g.fsf@fever.mssgmbh.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:
> From: Rainer Weikusat <rweikusat@mssgmbh.com>
> Date: Tue, 17 Jun 2008 20:47:02 +0200
>> The unix_dgram_sendmsg routine implements

[...]

> I'm going to review the logic in the new poll routing a little
> bit more, then apply it to net-2.6 unless I find some problems.

Thank you for having a look at this. I have found a couple of problems
myself in the meantime:

	- I misread the check in unix_dgram_sendmsg, which guards the
          'receive queue' test: That actually tests if the peer of the
          other socket is not the sending socket itself, ie it is true
          if the sending socket is either unconnected or the destination
          socket is the 1 in a n:1-setup (The well-known example of
          this would be /dev/log. This happened to be my use
          scenario, too).

	- Assuming the socket wasn't writeable because it still owns
          too many datagrams, it shouldn't be but onto the peer_wait
          queue of the peer. If the destination socket consumes one of
          the datagrams credited to the sending socket, the thread
          will be woken up 'as usual'. Otherwise, there is no point in
          waking it at all.

	- Splitting the 'check for writeable' code in two parts, one
          above and one below the other checks, was a stupid idea: The
          only requirement is that the thread is added to the other
          wait queue before it checks the state of the peer's
          sk_receive_queue and I think having all this code together
          makes it easier to understand.

	- The naming is inconsistent with the other datagram socket
          routines.

I will submit an updated patch which addresses this.

A couple of related-but-different oddities:

	- What happens if a thread is blocked in poll and another
          thread re-connects the socket to someone else? This should
          presumably cause the other thread to be woken up if it is
          presently queued on the peer wait queue.

	- What happens if someone connects the other socket? Presently
          (insofar I understand the code correctly),
          nothing. unix_dgram_connect just sets the peer of a socket
          which was unconnected before, despite its receive queue
          may still contain packets sent to it before the connect,
          which it (according to the comment above _disconnect),
          shouldn't receive anymore (I have tested that this actually
          happens with the help of perl).
