Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936AbZIZQxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbZIZQxm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 12:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbZIZQxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 12:53:42 -0400
Received: from n4b.bullet.mail.ac4.yahoo.com ([76.13.13.74]:31171 "HELO
	n4b.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751640AbZIZQxl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 12:53:41 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 962082.4864.bm@omp108.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=WsvKvGWDBWQdv59LXMgM7H/g5wTQd0GnfiS9o/nUoIIoTdEwh58jUl/mHHLAZ3IkUwbCOX7ZI3bE03llfg94be1xwerdOONCkBlUxkLLAq6IN4/kc7xp7yL/J5hybQBTyFFeAYjgQlOJALePFr+iVEBkPOg34Mfke5dgmFc3EnI=;
Message-ID: <844721.77331.qm@web63403.mail.re1.yahoo.com>
X-YMail-OSG: DOvTl64VM1mRVbaqWHU3dkqMK35Wv98zGcMezLxRIwn.a8mMYw1DcO1E.LVjODDKc7SZre0oenHpeVQ9opvM7qKk1R51FbJP80IXuLvE5ux1ghKTrdi2ZlfHxhTSEyoPGRpRSdvdgRmBxkKdv8TiUezUsu54RvykfQN.FysUlVAXAEYLJRFT4KRGr9J.1GUlknQsi_8t35DDjWHkRo3QTUG1c6FNnb4IOLMpJwxS80LoReB_dxsMIFzI54Izku.Z.vWCRhVtTSgbO6P0tp_y124iT4FPZvuiG80kk1_3qikwtN9IQqCH5uzUycL1Fdj0KJX2WTwR2nMoWn8vMKb6KH.tOZQfotZg_j0DMH8bHLlPBxQuOcti
X-Mailer: YahooMailClassic/7.0.14 YahooMailWebService/0.7.347.3
Date: Sat, 26 Sep 2009 09:53:44 -0700 (PDT)
From: Joe Cao <caoco2002@yahoo.com>
Subject: Re: TCP stack bug related to F-RTO?
To: =?iso-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Ray Lee <ray-lk@madrabbit.org>, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0909252049260.1854@melkinkari.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ilpo,

Can you elaborate on "Some retransmission would happen here as step 3"?  When the second timeout happens, it will again go into FRTO and then retransmit the write queue head.

I looked at the patch (debian Bug#478062) that's probably what you mentioned as the fix. All it does was to exclude the SACK case when considering FRTO.  But in my case, SACK was enabled, as seen in the trace.

In other words, do we still have a problem with FRTO when SACK is enabled in the latest kernel?

Thanks,
Joe  

--- On Fri, 9/25/09, Ilpo Järvinen <ilpo.jarvinen@helsinki.fi> wrote:

> From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> Subject: Re: TCP stack bug related to F-RTO?
> To: "Joe Cao" <caoco2002@yahoo.com>
> Cc: "Ray Lee" <ray-lk@madrabbit.org>, "Netdev" <netdev@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>
> Date: Friday, September 25, 2009, 11:03 AM
> On Fri, 25 Sep 2009, Joe Cao wrote:
> 
> > Thanks for the reply!  Do you happen to know
> which patch fixed the 
> > problem?
> 
> You can find those patches from the stable queue git tree.
> I gave you hint 
> from what release to look from in the last mail. However,
> as 2.6.24 is 
> anyway obsolete my recommendation is that you should
> probably consider 
> upgrading to fix all the other bugs that have been found
> since 2.6.24 was 
> obsoleted.
> 
> > Is there a bug tracking system for linux kernel?
> 
> Nothing that knows everything about everything.
> 
> > I studied the FRTO code in latest kernel 2.6.31.. 
> It seems the problem 
> > is still there:  
> >
> > 1. Every time a RTO fires, because tcp_is_sackfrto(tp)
> returns 1, 
> > tcp_use_frto() returns true.  And the server tcp
> enters FRTO.
> > 2. After the head of write queue is retransmitted, two
> new data packets 
> > are transmitted, the server receives two
> dup-ACKs.  That will make the 
> > TCP enter tcp_enter_frto_loss(), however, that only
> rests ssthresh and 
> > some other fields.
> 
> Perhaps those other fields are far more important than you
> think... :-)
> ...Some retransmission would happen here as step 3.
> 
> > 3. After another longer RTO fires, because
> tcp_is_sackfrto(tp) returns 
> > 1, tcp_use_frto() again returns true.  The stack
> enters FRTO again.
> > 4. The above repeats and the stack couldn't
> retransmits the lost packets 
> > faster.
> > 
> > Is my understanding above correct?
> 
> ...No. All magic that happens in tcp_enter_frto_loss should
> be enough to 
> really do more than a single retransmission (that is, in
> any other than 
> 2.6.24 series kernel). There was an unfortunate bug in this
> area in 2.6.24 
> which basically undoed the effect of correct actions
> tcp_enter_frto_loss 
> did which effectively prevented tcp_xmit_retransmit_queue
> from doing its 
> part.
> 
> -- 
>  i.
> 
> --- On Fri, 9/25/09, Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> wrote:
> 
> > From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> > Subject: Re: TCP stack bug related to F-RTO?
> > To: "Ray Lee" <ray-lk@madrabbit.org>
> > Cc: "Joe Cao" <caoco2002@yahoo.com>,
> "Netdev" <netdev@vger.kernel.org>,
> "LKML" <linux-kernel@vger.kernel.org>,
> jcaoco2002@yahoo.com
> > Date: Friday, September 25, 2009, 6:09 AM
> > On Thu, 24 Sep 2009, Ray Lee wrote:
> > 
> > > [adding netdev cc:]
> > > 
> > > On Thu, Sep 24, 2009 at 10:43 AM, Joe Cao <caoco2002@yahoo.com>
> > wrote:
> > > >
> > > > Hello,
> > > >
> > > > I have found the following behavior with
> > different versions of linux 
> > > > kernel. The attached pcap trace is collected
> with
> > server 
> > > > (192.168.0.13) running 2.6.24 and shows the
> > problem. Basically the 
> > > > behavior is like this: 
> > > >
> > > > 1. The client opens up a big window,
> > > > 2. the server sends 19 packets in a row (pkt
> #14-
> > #32 in the trace), but all of them are dropped due to
> some
> > congestion.
> > > > 3. The server hits RTO and retransmits pkt
> #14 in
> > #33
> > > > 4. The client immediately acks #33 (=#14),
> and
> > the server (seems like to enter F-RTO) expends the
> window
> > and sends *NEW* pkt #35 & #36.=A0 Timeoute is
> doubled to
> > 2*RTO; The client immediately sends two Dup-ack to #35
> and
> > #36.
> > > > 5. after 2*RTO, pkt #15 is retransmitted in
> #39.
> > > > 6. The client immediately acks #39 (=#15) in
> #40,
> > and the server continues to expand the window and
> sends two
> > *NEW* pkt #41 & #42. Now the timeoute is doubled
> to 4
> > *RTO.
> > > > 8. After 4*RTO timeout, #16 is
> retransmitted.
> > > > 9....
> > > > 10. The above steps repeats for
> retransmitting
> > pkt #16-#32 and each time the timeout is doubled.
> > > > 11. It takes a long long time to retransmit
> all
> > the lost packets and before that is done, the client
> sends a
> > RST because of timeout.
> > > >
> > > > The above behavior looks like F-RTO is in
> effect.
> >  And there seems to 
> > > > be a bug in the TCP's congestion control
> and
> > retransmission algorithm. 
> > > > Why doesn't the TCP on server (running
> 2.6.24)
> > enter the slow start? 
> > > > Why should the server take that long to
> recover
> > from a short period 
> > > > of packet loss?
> > > >
> > > > Has anyone else noticed similar problem
> before?
> >  If my analysis was 
> > > > wrong, can anyone gives me some pointers to
> > what's really wrong and 
> > > > how to fix it?
> > 
> > Yes, 2.6.24 is an obsoleted version with known wrongs
> in
> > FRTO 
> > implementation. Fixes never when to 2.6.24 stable
> series as
> > it was 
> > _already_ obsoleted when the problems where reported
> and
> > found. The 
> > correct fixes may be found from 2.6.25.7 (.7 iirc) and
> are
> > included from 
> > 2.6.26 onward too.
> > 
> > Just in case you happen to run ubuntu based kernel
> from
> > that era (of 
> > course you should be reporting the bug here then...),
> a
> > word of warning: 
> > it seemed nearly impossible for them to get a simple
> thing
> > like that 
> > fixed, I haven't been looking if they'd eventually
> come to
> > some sensible 
> > conclusion in that matter or is it still unresolved
> (or
> > e.g., closed 
> > without real resolution).
> 
> 


      

