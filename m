Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbYGRSTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbYGRSTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 14:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYGRSSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 14:18:50 -0400
Received: from ixia01.ro.gtsce.net ([212.146.94.66]:1797 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752324AbYGRSSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 14:18:49 -0400
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: IXIA
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] tcp: do not promote SPLICE_F_NONBLOCK to socket O_NONBLOCK
Date: Fri, 18 Jul 2008 21:16:43 +0300
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk
References: <200807171633.49791.opurdila@ixiacom.com> <200807182004.44664.opurdila@ixiacom.com> <20080718175341.GA21496@2ka.mipt.ru>
In-Reply-To: <20080718175341.GA21496@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807182116.43451.opurdila@ixiacom.com>
X-OriginalArrivalTime: 18 Jul 2008 18:20:46.0278 (UTC) FILETIME=[FF513E60:01C8E902]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 July 2008, Evgeniy Polyakov wrote:
> Hi.
>
> On Fri, Jul 18, 2008 at 08:04:44PM +0300, Octavian Purdila 
(opurdila@ixiacom.com) wrote:
> > Suppose we have 20 packets in the socket queue and the pipe is empty and
> > the application calls splice(sock, pipe, 17, flags=0).
> >
> > Then, tcp_splice_read will be called, which in turn calls tcp_read_sock.
> >
> > tcp_read_sock will loop until all the 17 bytes will be read from the
> > socket. tcp_read_sock calls skb_splice_bits which calls splice_to_pipe.
>
> How come?
> spd_fill_page() should fail when it will be called for the 17'th skb and
> all reading from the socket will return, and thus can be sent to the
> file.
>

spd_fill_page work with the splice_pipe_descriptor declared in 
skb_splice_bits, thus spd_fill_page does not have visibility across multiple 
skb_splice_bits calls.

> > Now while skb_splice_bits is carefull to only put a maximum of
> > PIPE_BUFFERS during its iteration, due to the looping in tcp_read_sock,
> > we will end up with 17 calls to splice_to_pipe. Thus on the 17th call,
> > splice_to_pipe will block.
>
> Where exactly?
> Why
> tcp_splice_data_recv()->skb_splice_bits()->__skb_splice_bits()->spd_fill_pa
>ge() callchain does not return error and that pipe is full?


Ok, let me try to move through the function calls:

tcp_read_sock
 ... -> skb_splice_bits -> spd_fill_page; 
  on return (spd->nr_page is 1 and pipe->nrbufs is 1)
 ... -> skb_splice_bits -> spd_fill_page; 
  on return (spd->nr_page is 1 and pipe->nrbufs is 2)
 ... -> skb_splice_bits -> spd_fill_page; 
  on return (spd->nr_page is 1 and pipe->nrbufs is 3)
...

and so on until pipe->nrbufs is 16. At than point, we will block in pipe_wait, 
inside splice_to_pipe.

Thanks,
tavi








