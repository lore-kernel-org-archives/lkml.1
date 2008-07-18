Return-Path: <linux-kernel-owner+w=401wt.eu-S1760981AbYGRRHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760981AbYGRRHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760643AbYGRRHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:07:18 -0400
Received: from ixia01.ro.gtsce.net ([212.146.94.66]:3504 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760553AbYGRRHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:07:16 -0400
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: IXIA
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] tcp: do not promote SPLICE_F_NONBLOCK to socket O_NONBLOCK
Date: Fri, 18 Jul 2008 20:04:44 +0300
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk
References: <200807171633.49791.opurdila@ixiacom.com> <200807181850.07393.opurdila@ixiacom.com> <20080718160009.GA29740@2ka.mipt.ru>
In-Reply-To: <20080718160009.GA29740@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807182004.44664.opurdila@ixiacom.com>
X-OriginalArrivalTime: 18 Jul 2008 17:09:12.0843 (UTC) FILETIME=[003B0DB0:01C8E8F9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 July 2008, Evgeniy Polyakov wrote:

> > It will take 17 because this is what the user requested. And when trying
> > to push the 17th on the pipe, it will block. I base this both on
> > experiments and on my understanding of the tcp splice receive
> > implementation.
>
> Seems like we do not understand each other. How it can take 17 if there
> are only 16 pages? By 'push' you mean splice-into-pipe or 
> splice-out-of-pipe-into-other-fd? Where exactly will it block?
>

Suppose we have 20 packets in the socket queue and the pipe is empty and the 
application calls splice(sock, pipe, 17, flags=0).

Then, tcp_splice_read will be called, which in turn calls tcp_read_sock. 

tcp_read_sock will loop until all the 17 bytes will be read from the socket. 
tcp_read_sock calls skb_splice_bits which calls splice_to_pipe.

Now while skb_splice_bits is carefull to only put a maximum of PIPE_BUFFERS 
during its iteration, due to the looping in tcp_read_sock, we will end up 
with 17 calls to splice_to_pipe. Thus on the 17th call, splice_to_pipe will 
block.

Does this make sense?

Thanks,
tavi
