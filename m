Return-Path: <linux-kernel-owner+w=401wt.eu-S1751844AbYDDVW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbYDDVW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 17:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYDDVWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 17:22:49 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:20664 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbYDDVWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 17:22:48 -0400
Message-ID: <47F6AA07.70706@oracle.com>
Date: Fri, 04 Apr 2008 17:21:59 -0500
From: Richard Frank <richard.frank@oracle.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: tziporet@dev.mellanox.co.il, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] InfiniBand/iWARP/RDMA merge plans for 2.6.26 (what's
 in infiniband.git)
References: <adave31bayd.fsf@cisco.com> <47F37CA4.8000109@mellanox.co.il>	<adahcek2pru.fsf@cisco.com> <47F68EDC.4050107@oracle.com> <adaiqyxs9b7.fsf@cisco.com>
In-Reply-To: <adaiqyxs9b7.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > We are very interested in these new operations and are moving in the
>  > direction of tightly integrating RDMA along with atomics (if
>  > available) into Oracle.  We plan on testing some early prototypes of
>  > the these in the few months.
>
> And you need the ConnectX-only masked atomics?  Or do the standard IB
> atomic operations work for you?  Of course using atomics at all means
> that things don't work on iWARP.
>
>   
We specifically asked for the masked operations.

Yes, this means Oracle will not get the performance boost of atomics on 
IWARP - but we still get rdma - and that's a real win / benefit for 
Oracle today - and more so over the next few months.

>  > Send with invalidate is an exact match for our current RDS V3 rdma
>  > driver - and should be more efficient than the current background
>  > syncing of the tpt  to ensure keys are invalidated.
>
> How does send with invalidate interact with the current IB FMR stuff?
> Seems that you would run into trouble keeping the state of the FMR
> straight if the remote side is invalidating them.
>
>   
The model we implement is based on "use once" keys - we issue the key to 
the rdma server and want to toss it as soon as the rdma is complete. 
Today, we explicitly free the key after the rdma completes and we get a 
message from the rdma server - saying rdma is complete. If the key is 
auto invalidated by the recv'ing HCA then we do not need to do it in the 
driver... which also meanswe do not need to issue the sync tpts to force 
the HCA to be update its cache.

At least this is how I think it works - Olaf is the divine source here.

> Also I would think that send-with-invalidate would be much more
> expensive than the current FMR method of batching up the invalidates,
> since you don't get to amortize the cost of syncing up all the internal
> HCA state.
>
>   
This is the one piece we do not know - our plans are to test this and 
see where the trade offs are. We will keep the current design / 
implementation to run over NICs that do not support send-with-invalidate.
>  - R.
>   
