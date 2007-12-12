Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbXLLSpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbXLLSpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbXLLSpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:45:04 -0500
Received: from mga03.intel.com ([143.182.124.21]:17060 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbXLLSpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:45:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,158,1196668800"; 
   d="scan'208";a="339645575"
Message-ID: <47602B77.2090202@intel.com>
Date: Wed, 12 Dec 2007 10:41:59 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: gallatin@myri.com, joonwpark81@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [RFC] net: napi fix
References: <47601A73.5010804@myri.com> <20071212.093819.205755031.davem@davemloft.net>
In-Reply-To: <20071212.093819.205755031.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2007 18:42:36.0220 (UTC) FILETIME=[C3A347C0:01C83CEE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Andrew Gallatin <gallatin@myri.com>
> Date: Wed, 12 Dec 2007 12:29:23 -0500
> 
>> Is the netif_running() check even required?
> 
> No, it is not.
> 
> When a device is brought down, one of the first things
> that happens is that we wait for all pending NAPI polls
> to complete, then block any new polls from starting.

I think this was previously (pre-2.6.24) not the case, which is why e1000 et al
has this check as well and that's exactly what is causing most of the
net_rx_action oopses in the first place. Without the netif_running() check
previously the drivers were just unusable with NAPI and prone to many races with
down (i.e. touching some ethtool ioctl which wants to do a reset while routing
small packets at high numbers). that's why we added the netif_running() check in
the first place :)

There might be more drivers lurking that need this change...

Auke
