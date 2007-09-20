Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbXITR40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbXITR40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756967AbXITR4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:56:19 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:42757 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbXITR4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:56:18 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 20 Sep 2007 10:56:14 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Nagendra Tomar <tomer_iisc@yahoo.com>, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.23-rc6 Resending] NETWORKING : Edge Triggered EPOLLOUT
 events get missed for TCP sockets
In-Reply-To: <46F20F24.1020900@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0709201048290.8897@alien.or.mcafeemobile.com>
References: <331107.71046.qm@web53704.mail.re2.yahoo.com> <46F20F24.1020900@cosmosbay.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007, Eric Dumazet wrote:

> Does it means that with your patch each ACK on a ET managed socket will
> trigger an epoll event   ?
> 
> Maybe your very sensitive high throuput appication needs to set a flag or
> something at socket level to ask for such a behavior.
> 
> The default should stay as is. That is an event should be sent only if someone
> cared about the wakeup.

Unfortunately f_op->poll() does not let the caller to specify the events 
it's interested in, that would allow to split send/recevie wait queues and 
better detect read/write cases.
The detection of a waitqueue_active(->sk_wr_sleep) would work fine in 
detecting is someone is actually waiting for a write, w/out the false 
positives triggered by the read-waiters.
That would be a very sane thing to do, but would require a big&dumb change 
to all the ->poll around (that could be automated by a script - devices 
not caring about the events hint can just continue to use the single queue 
like they currently do), and a more critical and gradual change of all the 
devices that wants to take advantage of it.
That way, no more magic bits are needed, and a simple waitqueue_active() 
would tell you if someone is waiting for write-space events.



- Davide


