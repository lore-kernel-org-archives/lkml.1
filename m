Return-Path: <linux-kernel-owner+w=401wt.eu-S1752213AbZIYGmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbZIYGmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 02:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZIYGmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 02:42:42 -0400
Received: from n7.bullet.mail.ac4.yahoo.com ([76.13.13.235]:33616 "HELO
	n7.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751076AbZIYGmm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 02:42:42 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 611970.71409.bm@omp124.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=zFkYM2dEZxuUhdMTK1qHtNo2vqXU8iSqYt5IsLXvF6PPU7XCNQ+LF0tyWGaLzTU903i6oxjZerSq+BUdHW5Z5MLI6GEp7Pcm23v6q+fjVOOtct05vY7Qi/76Nh298u4dKtFlLTDkwo64s1PuUKxckpowfcflcRywRL0pL7M5zHI=;
Message-ID: <511432.48405.qm@web63401.mail.re1.yahoo.com>
X-YMail-OSG: rI8q9YYVM1ngGIMq1Mnph9NZ9tqra8VaxS5MiBcIlnj.vLnt9jvXKuIhNOvEBo0Mvvahx0J9LH0vKfV1y.qIQ092ppy6mIsZrdjRuUgFszjdl92XpQg9l2NvJAH6bymrGeJl0tYNjeoH5541tjVNCNxSfG6Ujyf6smdQbVAHHkdp..xYSgb_CAlF2gCPiHX73efPY10RDpwW6mH5OLqrtaLytpsejvC9YNVbItS4K6pGyrF5krH7GqTzMktWa7x7KlaisnJrH9uCMYqJkSYcnIdiaGJxqmyqGMMO.RRtDYHyJqsIXnZW0auiickUksa9UlHbyFvP90rFvLfTKnuNxQ--
X-Mailer: YahooMailClassic/7.0.14 YahooMailWebService/0.7.347.3
Date: Thu, 24 Sep 2009 23:42:45 -0700 (PDT)
From: Joe Cao <caoco2002@yahoo.com>
Subject: Re: TCP stack bug related to F-RTO?
To: zhigang gong <zhigang.gong@gmail.com>
Cc: linux-kernel@vger.kernel.org, jcaoco2002@yahoo.com, netdev@vger.kernel.org
In-Reply-To: <40c9f5b20909241932k5e1f1d74kf8065e2e06aa4d09@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On the wrong tcp checksum, that's because of hardware checksum offload.

As for the seq/ack number, because the trace is long, I deliberately removed those irrelevant packets between after the three-way handshake and when the problem happens.  That can be seen from the timestamps.

Please also note that I intentionally replaced the IP addresses and mac addresses in the trace to hide proprietary information in the trace.

Anyway, the problem is not related to the checksum, or seq/ack number, otherwise, you won't see the behavior shown in the trace.

Thanks,
Joe

--- On Thu, 9/24/09, zhigang gong <zhigang.gong@gmail.com> wrote:

> From: zhigang gong <zhigang.gong@gmail.com>
> Subject: Re: TCP stack bug related to F-RTO?
> To: "Joe Cao" <caoco2002@yahoo.com>
> Cc: linux-kernel@vger.kernel.org, jcaoco2002@yahoo.com, netdev@vger.kernel.org
> Date: Thursday, September 24, 2009, 7:32 PM
> On Fri, Sep 25, 2009 at 1:43 AM, Joe
> Cao <caoco2002@yahoo.com>
> wrote:
> > Hello,
> >
> > I have found the following behavior with different
> versions of linux kernel. The attached pcap trace is
> collected with server (192.168.0.13) running 2.6.24 and
> shows the problem. Basically the behavior is like this:
> >
> > 1. The client opens up a big window,
> > 2. the server sends 19 packets in a row (pkt #14- #32
> in the trace), but all of them are dropped due to some
> congestion.
> > 3. The server hits RTO and retransmits pkt #14 in #33
> > 4. The client immediately acks #33 (=#14), and the
> server (seems like to enter F-RTO) expends the window and
> sends *NEW* pkt #35 & #36.=A0 Timeoute is doubled to
> 2*RTO; The client immediately sends two Dup-ack to #35 and
> #36.
> > 5. after 2*RTO, pkt #15 is retransmitted in #39.
> > 6. The client immediately acks #39 (=#15) in #40, and
> the server continues to expand the window and sends two
> *NEW* pkt #41 & #42. Now the timeoute is doubled to 4
> *RTO.
> > 8. After 4*RTO timeout, #16 is retransmitted.
> > 9....
> > 10. The above steps repeats for retransmitting pkt
> #16-#32 and each time the timeout is doubled.
> > 11. It takes a long long time to retransmit all the
> lost packets and before that is done, the client sends a RST
> because of timeout.
> >
> > The above behavior looks like F-RTO is in effect.
>  And there seems to be a bug in the TCP's congestion
> control and
> > retransmission algorithm. Why doesn't the TCP on
> server (running 2.6.24) enter the slow start?
> As I know, the early implementation hasn't enter slow start
> if the
> remote end is in the same network.  I'm not sure that
> of the version
> 2.6.24. But after I have a look at your trace, I think this
> is not the
> point of your problem. The behaviour of your client
> 192.168.0.82 is
> very strange. The client always send a packet with error
> TCP checksum
> and the 4# to 13# packets sent by the
> client   totally don't conform
> to  the TCP protocol, not only with wrong TCP checksum
> but also with
> incorrect seq and ack number.
> 
> My suggestion is that before you start to investigate the
> server
> side's behaviour, you need to correct your client side's
> TCP/IP stack
> implementation first.
> 
> >Why should the server take that long to recover from a
> short period of packet loss?
> 
> >
> > Has anyone else noticed similar problem before?  If
> my analysis was wrong, can anyone gives me some pointers to
> what's really wrong and how to fix it?
> >
> > Thanks a lot,
> > Joe
> >
> > PS. Please cc me when this message is replied.
> >
> >
> >
> 


      

