Return-Path: <linux-kernel-owner+w=401wt.eu-S1763689AbYCDIjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763689AbYCDIjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763005AbYCDIjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:39:13 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:38317 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762840AbYCDIjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:39:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=nU22TaPgsjSkxYKoj+AQpUDUtDlcTJNKXsUryyPiLTZ5gN2Kag0+z7yWuH+pBNTuYZ8yAy8aIJeGEYW5aVOdaxl4rrImOEMBHeavusOikW31924ghEfK0rr3409BpOwgLJzbZhf9tdNZVVoLCZjq7/+vzzKgerFMHop59pXXPZM=
Date: Tue, 4 Mar 2008 08:40:24 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: netdev@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: locking api self-test hanging
Message-ID: <20080304084024.GA3980@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303210540.cea55e13.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04-03-2008 06:05, Andrew Morton wrote:
...
>>>> And I've fully bisected this hang twice and both times came up with
>>>>
>>>> commit 33f807ba0d9259e7c75c7a2ce8bd2787e5b540c7
>>>> Author: Stephen Hemminger <shemminger@linux-foundation.org>
>>>> Date:   Mon Nov 19 19:24:52 2007 -0800
>>>>
>>>>     [NETPOLL]: Kill NETPOLL_RX_DROP, set but never tested.
>>>>
>>>> which is stupid because that patch doesn't do anything.

...or maybe apparently doesn't do anything?

@@ -128,13 +127,11 @@ static int poll_one_napi(struct netpoll_info *npinfo,
        if (!test_bit(NAPI_STATE_SCHED, &napi->state))
                return budget;
 
-       npinfo->rx_flags |= NETPOLL_RX_DROP;


But in a next patch we can see:

@@ -51,12 +50,12 @@ static inline int netpoll_rx(struct sk_buff *skb)
        unsigned long flags;
        int ret = 0;
 
-       if (!npinfo || (!npinfo->rx_np && !npinfo->rx_flags))
+       if (!npinfo || !npinfo->rx_np)

So, it seems rx_flags could have been tested here for NETPOLL_RX_DROP
yet?

Regards,
Jarek P.
