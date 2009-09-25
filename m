Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbZIYP6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbZIYP6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 11:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbZIYP6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 11:58:12 -0400
Received: from n1d.bullet.mail.ac4.yahoo.com ([76.13.13.85]:20846 "HELO
	n1d.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753111AbZIYP6M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 11:58:12 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 867475.58418.bm@omp112.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=VFPspJkGNTkPTujTpk2ZZoo9prKVKeGAkg0uyW3SyK2epqUZIzJqSgPEH7bJEmYDMFR8XmWw+bJa+s0/zawwkJLtEN1LkYSCElk5sYJM/ZMRGuccfq29qWJfaQklSaPoY0LBSxhUcPheVkSqXcvgyg5bfUB70Ub9qnbD3lTcJLQ=;
Message-ID: <773030.8168.qm@web63404.mail.re1.yahoo.com>
X-YMail-OSG: ZwQUYxkVM1m4I3uhx.lx6HHGmMUaOL1smed0QbPk8QsAQoWNQauYM5eicHja34evufh7clotHLMs4nO9OmhSEfnrMHuiGSuZGQ5BrC23Ra1gQRGKEfQwySFxd5nj_SxlqM_XUvolcZpK3Bmk4.u8FTTUt1w4Q9qyIAsyf3Z8QBBXKk154e5yrIBxKQtdnCua3LGzjPYqY9n.IgfzHoqAgeEY1QaDkFMw5Ml4O4GXf6SjBw0xa1sXTs3iO_9ozszB.jXxkX1vYu47PCZkJ6zyjTGbucarvlmrwAQ0rDTiEUXdufs.7pzxFMi7xsmOWFIGCuepGf24aa1A14szc0enlNlLRiQsukfVk5UT3lmTiQIpciqMUqEc
X-Mailer: YahooMailClassic/7.0.14 YahooMailWebService/0.7.347.3
Date: Fri, 25 Sep 2009 08:58:15 -0700 (PDT)
From: Joe Cao <caoco2002@yahoo.com>
Subject: Re: TCP stack bug related to F-RTO?
To: Ray Lee <ray-lk@madrabbit.org>,
       =?iso-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       caoco2002@yahoo.com
In-Reply-To: <alpine.DEB.2.00.0909251556130.13543@wel-95.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ilpo,

Thanks for the reply!  Do you happen to know which patch fixed the problem? Is there a bug tracking system for linux kernel?

I studied the FRTO code in latest kernel 2.6.31.  It seems the problem is still there:  

1. Every time a RTO fires, because tcp_is_sackfrto(tp) returns 1, tcp_use_frto() returns true.  And the server tcp enters FRTO.
2. After the head of write queue is retransmitted, two new data packets are transmitted, the server receives two dup-ACKs.  That will make the TCP enter tcp_enter_frto_loss(), however, that only rests ssthresh and some other fields.
3. After another longer RTO fires, because tcp_is_sackfrto(tp) returns 1, tcp_use_frto() again returns true.  The stack enters FRTO again.
4. The above repeats and the stack couldn't retransmits the lost packets faster.

Is my understanding above correct?

Thanks,
Joe 

--- On Fri, 9/25/09, Ilpo Järvinen <ilpo.jarvinen@helsinki.fi> wrote:

> From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> Subject: Re: TCP stack bug related to F-RTO?
> To: "Ray Lee" <ray-lk@madrabbit.org>
> Cc: "Joe Cao" <caoco2002@yahoo.com>, "Netdev" <netdev@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>, jcaoco2002@yahoo.com
> Date: Friday, September 25, 2009, 6:09 AM
> On Thu, 24 Sep 2009, Ray Lee wrote:
> 
> > [adding netdev cc:]
> > 
> > On Thu, Sep 24, 2009 at 10:43 AM, Joe Cao <caoco2002@yahoo.com>
> wrote:
> > >
> > > Hello,
> > >
> > > I have found the following behavior with
> different versions of linux 
> > > kernel. The attached pcap trace is collected with
> server 
> > > (192.168.0.13) running 2.6.24 and shows the
> problem. Basically the 
> > > behavior is like this: 
> > >
> > > 1. The client opens up a big window,
> > > 2. the server sends 19 packets in a row (pkt #14-
> #32 in the trace), but all of them are dropped due to some
> congestion.
> > > 3. The server hits RTO and retransmits pkt #14 in
> #33
> > > 4. The client immediately acks #33 (=#14), and
> the server (seems like to enter F-RTO) expends the window
> and sends *NEW* pkt #35 & #36.=A0 Timeoute is doubled to
> 2*RTO; The client immediately sends two Dup-ack to #35 and
> #36.
> > > 5. after 2*RTO, pkt #15 is retransmitted in #39.
> > > 6. The client immediately acks #39 (=#15) in #40,
> and the server continues to expand the window and sends two
> *NEW* pkt #41 & #42. Now the timeoute is doubled to 4
> *RTO.
> > > 8. After 4*RTO timeout, #16 is retransmitted.
> > > 9....
> > > 10. The above steps repeats for retransmitting
> pkt #16-#32 and each time the timeout is doubled.
> > > 11. It takes a long long time to retransmit all
> the lost packets and before that is done, the client sends a
> RST because of timeout.
> > >
> > > The above behavior looks like F-RTO is in effect.
>  And there seems to 
> > > be a bug in the TCP's congestion control and
> retransmission algorithm. 
> > > Why doesn't the TCP on server (running 2.6.24)
> enter the slow start? 
> > > Why should the server take that long to recover
> from a short period 
> > > of packet loss?
> > >
> > > Has anyone else noticed similar problem before?
>  If my analysis was 
> > > wrong, can anyone gives me some pointers to
> what's really wrong and 
> > > how to fix it?
> 
> Yes, 2.6.24 is an obsoleted version with known wrongs in
> FRTO 
> implementation. Fixes never when to 2.6.24 stable series as
> it was 
> _already_ obsoleted when the problems where reported and
> found. The 
> correct fixes may be found from 2.6.25.7 (.7 iirc) and are
> included from 
> 2.6.26 onward too.
> 
> Just in case you happen to run ubuntu based kernel from
> that era (of 
> course you should be reporting the bug here then...), a
> word of warning: 
> it seemed nearly impossible for them to get a simple thing
> like that 
> fixed, I haven't been looking if they'd eventually come to
> some sensible 
> conclusion in that matter or is it still unresolved (or
> e.g., closed 
> without real resolution).
> 
> -- 
>  i.


      

