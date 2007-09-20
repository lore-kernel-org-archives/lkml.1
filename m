Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856AbXITWha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbXITWha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 18:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbXITWhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 18:37:22 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:48766 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbXITWhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 18:37:22 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 20 Sep 2007 15:37:18 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Nagendra Tomar <tomer_iisc@yahoo.com>
cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2.6.23-rc6 Resending] NETWORKING : Edge Triggered EPOLLOUT
 events get missed for TCP sockets
In-Reply-To: <120313.72141.qm@web53705.mail.re2.yahoo.com>
Message-ID: <Pine.LNX.4.64.0709201518540.8897@alien.or.mcafeemobile.com>
References: <120313.72141.qm@web53705.mail.re2.yahoo.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007, Nagendra Tomar wrote:

> 
> --- Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > Looking back at it, I think the current TCP code is right, once you look 
> > at the "event" to be a output buffer full->with_space transition.
> > If you drop an fd inside epoll with EPOLLOUT|EPOLLET and you get an event 
> > (free space on the output buffer), if you do not consume it (say a 
> > tcp_sendmsg that re-fill the buffer), you can't see other OUT event 
> > anymore since they happen on the full->with_space transition.
> > Yes, I know, the read size (EPOLLIN) works differently and you get an 
> > event for every packet you receive. And yes, I do not like asymmetric 
> > things. But that does not make the EPOLLOUT|EPOLLET wrong IMO.
> > 
> 
> I agree that ET means the event should happen at the transition
> from nospace->space condition, but isn't the other case (event is 
> delivered every time the event actually happens) more usable.
> Also the epoll man page says so
> 
> "... Edge Triggered event distribution delivers events only when 
> events happens on the  monitored file."
> 
> This serves the purpose of ET (reducing the number of poll events) and
> at the same time makes userspace coding easier. My userspace code
> has the liberty of deciding when it can write to the socket. f.e. the
> sendfile buffer management example that I quoted in my earlier post
> will be difficult with the current ET|POLLOUT behaviour. I cannot 
> write in full-buffer units. I'll ve to write partial buffers just to 
> fill the TCP writeq which is needed to trigger the event.

That's not what POLLOUT means in the Unix meaning. POLLOUT indicates the 
ability to write, and it is not meant as to signal every time a packet 
(skb) is sent on the wire (and the buffer released).
In your particular application, you could simply split the sendfile into 
appropriately sized chunks, and handle the buffer realease in there.



- Davide


