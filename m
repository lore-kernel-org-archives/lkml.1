Return-Path: <linux-kernel-owner+w=401wt.eu-S1752853AbXDKFsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbXDKFsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 01:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbXDKFsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 01:48:19 -0400
Received: from stinky.trash.net ([213.144.137.162]:44157 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbXDKFsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 01:48:18 -0400
Message-ID: <461C766E.5030107@trash.net>
Date: Wed, 11 Apr 2007 07:47:26 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, cramerj <cramerj@intel.com>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       "Leech, Christopher" <christopher.leech@intel.com>
Subject: Re: [PATCH] NET: [UPDATED] Multiqueue network device support implementation.
References: <D5C1322C3E673F459512FB59E0DDC329029E454C@orsmsx414.amr.corp.intel.com>
In-Reply-To: <D5C1322C3E673F459512FB59E0DDC329029E454C@orsmsx414.amr.corp.intel.com>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Waskiewicz Jr, Peter P wrote:
>>This leaks the device. You treat every single-queue device as 
>>having a single subqueue. If it doesn't get too ugly it would 
>>be nice to avoid this and only allocate the subqueue states 
>>for real multiqueue devices.
> 
> 
> We went back and forth on this.  The reason we allocate a queue in every
> case, even on single-queue devices, was to make the stack not have
> branching for multiqueue and non-multiqueue devices.  If we don't have
> at least one queue on a device, then we can't have
> netif_subqueue_stopped() in the hotpath unless we check if a device is
> multiqueue before.  The original patches I released had this branching,
> and I was asked to not do that.


OK, thanks for the explanation.

>>>+			skb->queue_mapping =
>>>+				 q->prio2band[q->band2queue[band&TC_PRIO_MAX]];
>>
>>
>>Does this needs to be cleared at some point again? TC actions 
>>might redirect or mirror packets to other (multiqueue) devices.
> 
> 
> If an skb is redirected to another device, the skb should be filtered
> through that device's qdisc, yes?


Yes, but the device might not have a queue or use something different
than prio, so the value would stay the same. I think you need to clear
it before enqueueing a packet or alternatively when redirecting in the
mirred action.

