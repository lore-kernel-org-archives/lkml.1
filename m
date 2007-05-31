Return-Path: <linux-kernel-owner+w=401wt.eu-S1760860AbXEaQsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860AbXEaQsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 12:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760621AbXEaQsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 12:48:41 -0400
Received: from smtp.osdl.org ([207.189.120.12]:45192 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760599AbXEaQsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 12:48:40 -0400
Date: Thu, 31 May 2007 09:37:03 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Thomas Klein <osstklei@de.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>, Christoph Raisch <raisch@de.ibm.com>,
       "Jan-Bernd Themann" <ossthema@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ppc" <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       netdev <netdev@vger.kernel.org>, Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] ehea: Receive SKB Aggregation
Message-ID: <20070531093703.373995b2@freepuppy>
In-Reply-To: <200705311354.56979.osstklei@de.ibm.com>
References: <200705311354.56979.osstklei@de.ibm.com>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
>  
> +static int try_get_ip_tcp_hdr(struct ehea_cqe *cqe, struct sk_buff *skb,
> +			      struct iphdr **iph, struct tcphdr **tcph)
> +{
> +	int ip_len;
> +
> +	/* non tcp/udp packets */
> +	if (!cqe->header_length)
> +		return -1;
> +
> +	/* non tcp packet */
> +	*iph = (struct iphdr *)(skb->data);

Why the indirection, copying of headers..

> +	if ((*iph)->protocol != IPPROTO_TCP)
> +		return -1;
> +
> +	ip_len = (u8)((*iph)->ihl);
> +	ip_len <<= 2;
> +	*tcph = (struct tcphdr *)(((u64)*iph) + ip_len);
> +
> +	return 0;
> +}
> +
> 

This code seems to be duplicating a lot  (but not all) of the TCP/IP
input path validation checks. This is a security problem if nothing else...

Also, how do you prevent DoS attacks from hostile TCP senders that send
huge number of back to back frames?

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
