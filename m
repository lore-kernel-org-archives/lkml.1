Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbXIRCtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbXIRCtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 22:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbXIRCtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 22:49:08 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:62817 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbXIRCtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 22:49:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=HfphrTFGS6GN2y0fTGatOligtZiVniRUHwcX+xB3TmXsEBjertOfq4GGkRAxC8CAH8dDcp6dDROJAMqDQP4y9I2UrxpaM8D69IFM0rsFclnaaaDKXums0W9MKaFEWEOfLg0M2QDpp7sKwKtdTZXsVR4dsP5lHN7fvb0dby5Ex3Y=
Date: Tue, 18 Sep 2007 10:48:12 +0800
From: lepton <ytht.net@gmail.com>
Illegal-Object: Syntax error in To: address found on vger.kernel.org:
	To:	"YOSHIFUJI Hideaki /  =?ISO-8859-1?Q?=20=1B$B5HF#1QL@=1B(B=22?= <yoshfuji@linux-ipv6.org>"
			^-missing closing '"' in token
Cc: ytht.net@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [PATCH] 2.6.22.6 NETWORKING [IPV4]: Always use source addr in skb to reply packet
Message-ID: <20070918024812.GA15799@router.lepton.home>
References: <20070918021617.GA15540@router.lepton.home> <20070917.192044.48396034.davem@davemloft.net> <20070918.112644.28694997.yoshfuji@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918.112644.28694997.yoshfuji@linux-ipv6.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)

Hi,
  sorry for lack of details.
  let's think about ip_send_reply. it is only called
by tcp_v4_send_ack and tcp_v4_reset. I don't know why
we need a source address diffrent from ip_hdr(skb)->s_addr
  icmp_reply is only called by icmp_echo and icmp_timestamp.
Is there a situation to need we use a source address diffrent
from ip_hdr(skb)->s_addr?

  My situaiton is:
  I DNAT some tcp packet to my box. some times the box will
reply reset or ack packet with tcp_v4_send_ack and tcp_v4_reset, 
when this happens, it will use the rt->s_addr instead of
ip_hdr(skb)->s_addr, then the packet will send out without change
the source addr. Becaus netfilter don't know these packets belongs
to the DNATed connection.

  Another people's situaiton is (quoted from email to me):
 
 While conducting a research about networking, I discovered
 improper handling of ICMP echo reply messages in Linux 2.4.26.  I
 looked into the code and noticed that the icmp_reply function sets the
 destination address in the reply packet to rt->rt_src.  This produces
 strange results in some cases as can be easily shown with hping and
 tcpdump.  Here is an example (NOTE: eth0 address is set to
 10.10.10.1/24):

  # tcpdump -n -i any icmp &
 
  [1] 16842
  tcpdump: WARNING: Promiscuous mode not supported on the "any" device
  tcpdump: verbose output suppressed, use -v or -vv for full protocol
  decode
  listening on any, link-type LINUX_SLL (Linux cooked), capture size 96
  bytes
 
  # hping2 --icmp --spoof 10.10.10.3 10.10.10.1
 
  HPING 10.10.10.1 (eth0 10.10.10.1): icmp mode set, 28 headers + 0
  data bytes
  02:16:53.206016 IP 10.10.10.3 > 10.10.10.1: icmp 8: echo request seq
  0
  02:16:53.206082 IP 10.10.10.1 > 10.10.10.1: icmp 8: echo reply seq 0
  02:16:54.202123 IP 10.10.10.3 > 10.10.10.1: icmp 8: echo request seq
 
  If ICMP echo requests with a spoofed source address are sent to the
  address of our eth0 interface (which of course happens through the
  loopback interface), the code of icmp_reply sets the destination
  address in the reply to 10.10.10.1 instead of simply reversing the
  source and destination addresses as required by the RFC.

On Tue, Sep 18, 2007 at 11:26:44AM +0900, YOSHIFUJI Hideaki / ?$B5HF#1QL@?(B wrote:
> In article <20070917.192044.48396034.davem@davemloft.net> (at Mon, 17 Sep 2007 19:20:44 -0700 (PDT)), David Miller <davem@davemloft.net> says:
> 
> > From: lepton <ytht.net@gmail.com>
> > Date: Tue, 18 Sep 2007 10:16:17 +0800
> > 
> > > Hi,
> > >   In some situation, icmp_reply and ip_send_reply will send
> > >   out packet with the wrong source addr, the following patch
> > >   will fix this.
> > > 
> > >   I don't understand why we must use rt->rt_src in the current
> > >   code, if this is a wrong fix, please correct me.
> > > 
> > > Signed-off-by: Lepton Wu <ytht.net@gmail.com>
> > 
> > That the address is wrong is your opinion only :-)
> > 
> > Source address selection is a rather complex topic, and
> > here we are definitely purposefully using the source
> > address selected by the routing lookup for the reply.
> 
> And, if you do think something is "wrong", you need to describe it
> in detail, at least.
> 
> --yoshfuji
