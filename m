Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbZG3AKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbZG3AKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 20:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755659AbZG3AKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 20:10:35 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:48178 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbZG3AKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 20:10:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hlI0pMG/fHITsAm4/mjkzpcAW9BYKmwq/6Q5MTor84KWsr/Z93/lWZm9Fnm0kWroWj
         vxm9L04H4PrzI4ATCeNAYUtqbUiNg2T9mT1sKmjYsn5IBi4EYovXr3XR6BlBAKvYDwYu
         FpCqV8BbMawe4PQFxMTlxjpkRpxOHTClBHYUw=
Subject: Re: [PATCH] net: Keep interface binding when sending packets with 
	ipi_ifindex = 0
From: John Dykstra <john.dykstra1@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chia-chi Yeh <chiachi@android.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20090727144402.513369f1.akpm@linux-foundation.org>
References: <6c039e090907231439t1def08a4n10978733bee55bec@mail.gmail.com>
	 <20090727144402.513369f1.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 19:10:21 -0500
Message-Id: <1248912621.13447.12.camel@merlyn>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 14:44 -0700, Andrew Morton wrote:
> (cc netdev)
> 
> On Thu, 23 Jul 2009 14:39:28 -0700
> Chia-chi Yeh (_________) <chiachi@android.com> wrote:
> 
> > In IPv4, sending a packet with ipi_ifindex = 0 via an interface-bound
> > socket will unbind the packet to that interface. This behavior is
> > different from IPv6 which treats ipi6_ifindex = 0 as unspecified.
> > Furthermore, IPv6 does not allow sending packets to other interface
> > than the bound one, but I am not sure if it is necessary in IPv4. The
> > following patch keeps the interface binding when ipi_ifindex = 0.
> > 
> > Thanks,
> > Chia-chi
> > 
> > --- a/net/ipv4/ip_sockglue.c	2009-07-24 04:50:45.000000000 +0800
> > +++ b/net/ipv4/ip_sockglue.c	2009-07-24 04:51:09.000000000 +0800
> > @@ -213,7 +213,8 @@
> >  			if (cmsg->cmsg_len != CMSG_LEN(sizeof(struct in_pktinfo)))
> >  				return -EINVAL;
> >  			info = (struct in_pktinfo *)CMSG_DATA(cmsg);
> > -			ipc->oif = info->ipi_ifindex;
> > +			if (info->ipi_ifindex)
> > +				ipc->oif = info->ipi_ifindex;
> >  			ipc->addr = info->ipi_spec_dst.s_addr;
> >  			break;
> >  		}

A convenient copy of the man page says "When ipi_ifindex is not zero the
primary local address of the interface specified by the index overwrites
ipi_spec_dst for the routing table lookup."

But this is changing API behavior that's been this way since at least
the beginning of git history.

I guess Dave's letting this stand.  I'm posting this just to make sure
this is an explicit decision.

--
John

