Return-Path: <linux-kernel-owner+w=401wt.eu-S1751192AbXFDMnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192AbXFDMnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 08:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbXFDMmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 08:42:52 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:25502 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbXFDMmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 08:42:50 -0400
In-Reply-To: <20070531093703.373995b2@freepuppy>
Subject: Re: [PATCH 2/2] ehea: Receive SKB Aggregation
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Jan-Bernd Themann <themann@de.ibm.com>, Jeff Garzik <jeff@garzik.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ppc" <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       netdev <netdev@vger.kernel.org>,
       Stefan Roscher <ossrosch@linux.vnet.ibm.com>,
       ossthema@linux.vnet.ibm.com, Thomas Q Klein <tklein@de.ibm.com>,
       tklein@linux.ibm.com
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF83D042D3.CAC47E54-ONC12572F0.0041526E-C12572F0.0042A414@de.ibm.com>
From: Christoph Raisch <RAISCH@de.ibm.com>
Date: Mon, 4 Jun 2007 14:09:27 +0200
X-MIMETrack: Serialize by Router on D12ML067/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 04/06/2007 14:42:44
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Stephen Hemminger  wrote on 31.05.2007 18:37:03:

>
> >
> >
> > +static int try_get_ip_tcp_hdr(struct ehea_cqe *cqe, struct sk_buff
*skb,
> > +               struct iphdr **iph, struct tcphdr **tcph)
> > +{
> > +   int ip_len;
> > +
> > +   /* non tcp/udp packets */
> > +   if (!cqe->header_length)
> > +      return -1;
> > +
> > +   /* non tcp packet */
> > +   *iph = (struct iphdr *)(skb->data);
>
> Why the indirection, copying of headers..
This interacts with the header split function in the hardware.
>
> > +   if ((*iph)->protocol != IPPROTO_TCP)
> > +      return -1;
> > +
> > +   ip_len = (u8)((*iph)->ihl);
> > +   ip_len <<= 2;
> > +   *tcph = (struct tcphdr *)(((u64)*iph) + ip_len);
> > +
> > +   return 0;
> > +}
> > +
> >
>
> This code seems to be duplicating a lot  (but not all) of the TCP/IP
> input path validation checks. This is a security problem if nothing
else...
>
We should only do aggregation in the driver if this really is a TCP header,
otherwise things will get worse.
You're right, we should at least check that tcph is within the received
frame.

> Also, how do you prevent DoS attacks from hostile TCP senders that send
> huge number of back to back frames?

Actually a huge number of back to back frames is what we would want to
receive
at 10 gbit ;-)
How is it possible to figure out if this is what you want or just DoS?
It doesn't change anything compared to a non LRO driver, we process a
certain
maximum amount of frames before waiting for the next interrupt,
the packet filters/DoS should still see all traffic (which is above the
driver).
Any suggestions how to handle this better/different?

>
> --
> Stephen Hemminger

Gruss / Regards
Christoph Raisch

