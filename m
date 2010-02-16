Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab0BPNUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 08:20:35 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:34351 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab0BPNUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 08:20:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Q0xYpH35voqzArWU+gfxDbYiR6LxGPmfPVVpvtIRDj5SHZ3FIhMPT8F5ZViJNUhxNw
         ThU5nT8ORgHz7cqwoCjvkbTwIhqJ+/Tr9KZmmco4eIv0Msz1nXZ5hDQsyR+bfViJ7bUg
         huyK3St687ynrIh726RhNRM9I4+LjebbqQmxM=
Subject: Re: [net-next PATCH v4 3/3] net: reserve ports for applications
 using fixed port numbers
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cong Wang <amwang@redhat.com>
Cc: Octavian Purdila <opurdila@ixiacom.com>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>
In-Reply-To: <4B7A9852.5020105@redhat.com>
References: <1266271241-6293-1-git-send-email-opurdila@ixiacom.com>
	 <1266271241-6293-4-git-send-email-opurdila@ixiacom.com>
	 <4B7A6740.1000701@redhat.com> <201002161306.29708.opurdila@ixiacom.com>
	 <4B7A9852.5020105@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Feb 2010 14:20:25 +0100
Message-ID: <1266326425.3045.53.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 16 février 2010 à 21:06 +0800, Cong Wang a écrit :
> Octavian Purdila wrote:
> > On Tuesday 16 February 2010 11:37:04 you wrote:
> >>>  	BUILD_BUG_ON(sizeof(struct inet_skb_parm) > sizeof(dummy_skb->cb));
> >>>
> >>> +	sysctl_local_reserved_ports = kzalloc(65536 / 8, GFP_KERNEL);
> >>> +	if (!sysctl_local_reserved_ports)
> >>> +		goto out;
> >>> +
> >> I think we should also consider the ports in ip_local_port_range,
> >> since we can only reserve the ports in that range.
> >>
> > 
> > That is subject to changes at runtime, which means we will have to readjust 
> > the bitmap at runtime which introduces the need for additional synchronization 
> > operations which I would rather avoid. 
> 
> Why? As long as the bitmap is global, this will not be hard.
> 
> Consider that if one user writes a port number which is beyond
> the ip_local_port_range into ip_local_reserved_ports, we should
> not accept this, because it doesn't make any sense. But with your
> patch, we do.

I disagree with you. This is perfectly OK.

A port not being flagged in ip_local_reserved_ports doesnt mean it can
be used for allocation.

If you want to really block ports from being used at boot, you could for
example :

# temporarly reduce the ip_local_port_range
echo "61000 61001" >/proc/sys/net/ipv4/ip_local_port_range
# Build our bitmap (could be slow, if a remote database is read)
for port in $LIST_RESERVED_PORT
do
  echo $port >/proc/sys/net/ipv4/ip_local_reserved_ports
done
echo "10000 61000" >/proc/sys/net/ipv4/ip_local_port_range


