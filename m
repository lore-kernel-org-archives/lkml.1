Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbXITWJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbXITWJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 18:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbXITWJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 18:09:25 -0400
Received: from web53705.mail.re2.yahoo.com ([206.190.37.26]:28168 "HELO
	web53705.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751224AbXITWJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 18:09:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=hUD9GYNLgbvVTEDKt081d43UoCOke4ORTmPJMDj7D1GJ99aHGO69bBDhoIixKx9s9ntG4ZunEqzNnYgzqzVEH00ZvHp4BbCn5QTxvFv0hRaMNRz33EtUwilt5cHihfnGGr+7IaQFErbEY3NB3Urc0vGXOhpVyaU/QtZPln2mkIk=;
X-YMail-OSG: mQRVB7AVM1kW_vxYl93Vl.fJja9e7HTZBG3VR1GA3oLPNfWrEi4maD22G3OlPHIUoQ--
Date: Thu, 20 Sep 2007 15:09:23 -0700 (PDT)
From: Nagendra Tomar <tomer_iisc@yahoo.com>
Subject: Re: [PATCH 2.6.23-rc6 Resending] NETWORKING : Edge Triggered EPOLLOUT events get missed for TCP sockets
To: Davide Libenzi <davidel@xmailserver.org>
Cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0709201033120.8897@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <120313.72141.qm@web53705.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Davide Libenzi <davidel@xmailserver.org> wrote:

> Looking back at it, I think the current TCP code is right, once you look 
> at the "event" to be a output buffer full->with_space transition.
> If you drop an fd inside epoll with EPOLLOUT|EPOLLET and you get an event 
> (free space on the output buffer), if you do not consume it (say a 
> tcp_sendmsg that re-fill the buffer), you can't see other OUT event 
> anymore since they happen on the full->with_space transition.
> Yes, I know, the read size (EPOLLIN) works differently and you get an 
> event for every packet you receive. And yes, I do not like asymmetric 
> things. But that does not make the EPOLLOUT|EPOLLET wrong IMO.
> 

I agree that ET means the event should happen at the transition
from nospace->space condition, but isn't the other case (event is 
delivered every time the event actually happens) more usable.
Also the epoll man page says so

"... Edge Triggered event distribution delivers events only when 
events happens on the  monitored file."

This serves the purpose of ET (reducing the number of poll events) and
at the same time makes userspace coding easier. My userspace code
has the liberty of deciding when it can write to the socket. f.e. the
sendfile buffer management example that I quoted in my earlier post
will be difficult with the current ET|POLLOUT behaviour. I cannot 
write in full-buffer units. I'll ve to write partial buffers just to 
fill the TCP writeq which is needed to trigger the event.

Thanx,
Tomar



      ___________________________________________________________
Yahoo! Answers - Got a question? Someone out there knows the answer. Try it
now.
http://uk.answers.yahoo.com/ 
