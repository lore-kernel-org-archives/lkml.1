Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab0BPO2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 09:28:55 -0500
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:2017 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756413Ab0BPO2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:28:53 -0500
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: Ixia
To: Cong Wang <amwang@redhat.com>
Subject: Re: [net-next PATCH v4 3/3] net: reserve ports for applications using fixed port numbers
Date: Tue, 16 Feb 2010 16:25:22 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.32-2-686; KDE/4.3.2; i686; ; )
Cc: David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eric Dumazet <eric.dumazet@gmail.com>
References: <1266271241-6293-1-git-send-email-opurdila@ixiacom.com> <201002161306.29708.opurdila@ixiacom.com> <4B7A9852.5020105@redhat.com>
In-Reply-To: <4B7A9852.5020105@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002161625.22495.opurdila@ixiacom.com>
X-OriginalArrivalTime: 16 Feb 2010 14:28:52.0288 (UTC) FILETIME=[5CB25C00:01CAAF14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 February 2010 15:06:26 you wrote:
> Octavian Purdila wrote:
> > On Tuesday 16 February 2010 11:37:04 you wrote:
> >>>  	BUILD_BUG_ON(sizeof(struct inet_skb_parm) > sizeof(dummy_skb->cb));
> >>>
> >>> +	sysctl_local_reserved_ports = kzalloc(65536 / 8, GFP_KERNEL);
> >>> +	if (!sysctl_local_reserved_ports)
> >>> +		goto out;
> >>> +
> >>
> >> I think we should also consider the ports in ip_local_port_range,
> >> since we can only reserve the ports in that range.
> >
> > That is subject to changes at runtime, which means we will have to
> > readjust the bitmap at runtime which introduces the need for additional
> > synchronization operations which I would rather avoid.
> 
> Why? As long as the bitmap is global, this will not be hard.
> 

For the more important point see bellow, but with regard to reallocation, this 
means we need to at least use rcu_read_lock() in the fast path to avoid races 
between freeing the old bitmap and doing a read in progress. 

Granted, that is a light operation, but would it makes things so much more 
complicated just so that we save one memory page (assuming the range is the 
default [32000 64000] one).

> Consider that if one user writes a port number which is beyond
> the ip_local_port_range into ip_local_reserved_ports, we should
> not accept this, because it doesn't make any sense. But with your
> patch, we do.
> 

I think it should be allowed. I see ip_local_reserved_ports and ip_local_range 
as independent settings that can be change at any time.

That way I can flag port 8080 even if the current range is [32000, 64000] and 
then later I can expand the range to [1024, 64000] without loosing the 8080 
reservation.
