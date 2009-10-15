Return-Path: <linux-kernel-owner+w=401wt.eu-S934912AbZJORxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934912AbZJORxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 13:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934612AbZJORxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 13:53:54 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:59711 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934526AbZJORxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 13:53:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=c949HthCGYYbiU/GX64dnDQoKpybkBfsv9e1lVwJeQ/RDVR6yjhmNtzBY2Bq9RFQpH
         BnxZWOwmnDNSbnpTCyK9DH/2W0GOjPro0DXdqUSeUTXP0B4mBM+gqmFxYfMe9CbSRtGQ
         racMF5+QH/bwYkwMVDnaRircftaCLH/eIEeaU=
Message-ID: <4AD76184.6030900@gmail.com>
Date: Thu, 15 Oct 2009 19:53:08 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
       hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-wireless@vger.kernel.org,
       linux-ppp@vger.kernel.org, netdev@vger.kernel.org, paulus@samba.org
Subject: Re: NOHZ: local_softirq_pending 08
References: <4AD31213.6020006@imap.cc> <20091015114052.GA9870@ff.dom.local>
In-Reply-To: <20091015114052.GA9870@ff.dom.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote, On 10/15/2009 01:40 PM:

> On 12-10-2009 13:25, Tilman Schmidt wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> On Mon, 12 Oct 2009 03:32:46 -0700 (PDT), David Miller wrote:
>>> The PPP receive paths in ppp_generic.c do a local_bh_disable()/
>>> local_bh_enable() around packet receiving (via ppp_recv_lock()/
>>> ppp_recv_unlock() in ppp_do_recv).
>>>
>>> So at least that part is perfectly fine.
>>>
>>> ppp_input(), as called from ppp_sync_process(), also disables BH's
>>> around ppp_do_recv() calls (via read_lock_bh()/read_unlock_bh()).
>>>
>>> So that's fine too.
>>>
>>> Do you have a bug report or are you just scanning around looking
>>> for trouble? :-)
>> I have encountered the message in the subject during a test of
>> the Gigaset CAPI driver, and would like to determine whether
>> it's a bug in the driver, a bug somewhere else, or no bug at
>> all. The test scenario was PPP over ISDN with pppd+capiplugin.
>> In an alternative scenario, also PPP over ISDN but with
>> smpppd+capidrv, the message did not occur.
>>
>> Johannes' answer pointed me to the netif_rx() function.
>> The Gigaset driver itself doesn't call that function at all.
>> In the scenario where I saw the message, it was the SYNC_PPP
>> line discipline that did. But from your explanation I gather
>> that the cause cannot lie there.
>>
>> So now I'm looking for other possible causes of that message.


BTW, it seems calling napi_schedule() from process context should
trigger such a warning too.

Jarek P.

> 
> Anyway, I agree with Michael Buesch there is no reason to waste time
> for tracking all netif_rx vs netif_rx_ni uses, and it seems we could
> avoid it by using the "proper" version of raise_softirq_irqoff() in
> __napi_schedule(). Could anybody try if I'm not wrong?
> 
> Thanks,
> Jarek P.
> ---
> 
>  net/core/dev.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 28b0b9e..7fc4009 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2728,7 +2728,7 @@ void __napi_schedule(struct napi_struct *n)
>  
>  	local_irq_save(flags);
>  	list_add_tail(&n->poll_list, &__get_cpu_var(softnet_data).poll_list);
> -	__raise_softirq_irqoff(NET_RX_SOFTIRQ);
> +	raise_softirq_irqoff(NET_RX_SOFTIRQ);
>  	local_irq_restore(flags);
>  }
>  EXPORT_SYMBOL(__napi_schedule);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ppp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


