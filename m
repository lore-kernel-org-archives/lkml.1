Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbYCaKBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbYCaKBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 06:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768AbYCaKBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 06:01:34 -0400
Received: from smtp21.orange.fr ([80.12.242.49]:17691 "EHLO smtp21.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807AbYCaKBd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 06:01:33 -0400
X-ME-UUID: 20080331100131799.C33CB1C00087@mwinf2122.orange.fr
Message-ID: <47F0B66C.6080404@cosmosbay.com>
Date: Mon, 31 Mar 2008 12:01:16 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC,PATCH] loopback: calls netif_receive_skb() instead of	netif_rx()
References: <47BDC848.50607@cosmosbay.com> <20080226.182120.183405235.davem@davemloft.net> <47C92F49.4070100@cosmosbay.com> <20080323.032949.194309002.davem@davemloft.net> <47E6A5FD.6060407@cosmosbay.com> <20080331094823.GA11651@elte.hu>
In-Reply-To: <20080331094823.GA11651@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Eric Dumazet <dada1@cosmosbay.com> wrote:
>
>   
>> I noticed some paths in kernel are very stack aggressive, and on i386 
>> with CONFIG_4KSTACKS we were really in a dangerous land, even without 
>> my patch.
>>
>> What we call 4K stacks is in fact 4K - sizeof(struct task_struct), so 
>> a litle bit more than 2K. [...]
>>     
>
> that's just wrong - 4K stacks on x86 are 4K-sizeof(thread_info) - the 
> task struct is allocated elsewhere. The patch below runs just fine on 
> 4K-stack x86.
>
>   
Yes, this error was corrected by Andi already :)

Thank you Ingo but this patch was already suggested by me previously ( 
http://marc.info/?l=linux-netdev&m=120361996713007&w=2 ) and was 
rejected, since we can very easily consume all stack space, especially 
with 4K stacks.
(try with NFS mounts and XFS for example)



Only safe way is to check available free stack space, since we can nest  
loopback_xmit() several time.
In case of protocol errors (like in TCP, if we answer to an ACK by 
another ACK, or ICMP loops), we would exhaust stack instead of delaying 
packets for next softirq run.

Problem is to check available space :

It depends on stack growing UP or DOWN, and depends on caller running on 
process stack, or softirq stack, or even hardirq stack.




> 	Ingo
>
> ------------->
> Subject: net: loopback speedup
> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon Mar 31 11:23:21 CEST 2008
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/net/loopback.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux/drivers/net/loopback.c
> ===================================================================
> --- linux.orig/drivers/net/loopback.c
> +++ linux/drivers/net/loopback.c
> @@ -158,7 +158,7 @@ static int loopback_xmit(struct sk_buff 
>  	lb_stats->bytes += skb->len;
>  	lb_stats->packets++;
>  
> -	netif_rx(skb);
> +	netif_receive_skb(skb);
>  
>  	return 0;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   




