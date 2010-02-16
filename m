Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab0BPLKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 06:10:05 -0500
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:29082 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751600Ab0BPLKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 06:10:00 -0500
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: Ixia
To: Cong Wang <amwang@redhat.com>
Subject: Re: [net-next PATCH v4 3/3] net: reserve ports for applications using fixed port numbers
Date: Tue, 16 Feb 2010 13:06:29 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.32-2-686; KDE/4.3.2; i686; ; )
Cc: David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eric Dumazet <eric.dumazet@gmail.com>
References: <1266271241-6293-1-git-send-email-opurdila@ixiacom.com> <1266271241-6293-4-git-send-email-opurdila@ixiacom.com> <4B7A6740.1000701@redhat.com>
In-Reply-To: <4B7A6740.1000701@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002161306.29708.opurdila@ixiacom.com>
X-OriginalArrivalTime: 16 Feb 2010 11:09:59.0238 (UTC) FILETIME=[940B6E60:01CAAEF8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 February 2010 11:37:04 you wrote:
> >  	BUILD_BUG_ON(sizeof(struct inet_skb_parm) > sizeof(dummy_skb->cb));
> >
> > +	sysctl_local_reserved_ports = kzalloc(65536 / 8, GFP_KERNEL);
> > +	if (!sysctl_local_reserved_ports)
> > +		goto out;
> > +
> 
> I think we should also consider the ports in ip_local_port_range,
> since we can only reserve the ports in that range.
> 

That is subject to changes at runtime, which means we will have to readjust 
the bitmap at runtime which introduces the need for additional synchronization 
operations which I would rather avoid. 

> > +	{
> > +		.procname	= "ip_local_reserved_ports",
> > +		.data		= NULL, /* initialized in sysctl_ipv4_init */
> > +		.maxlen		= 65536,
> > +		.mode		= 0644,
> > +		.proc_handler	= proc_dobitmap,
> > +	},
> 
> Isn't there an off-by-one here?
> 
> In patch 2/3, you use 0 to set the fist bit, then how about 65535 which
> writes 65536th bit? This is beyond the range of port number.
> 

This seems fine to me, 65535 is the value used by both the port checking 
function and the proc read/write function. And it translates indeed to  
65536th bit, but that is also bit 65535 if you start counting bits from 0 
instead of 1. The usual computing/natural arithmetic confusion for the meaning 
of first :)

