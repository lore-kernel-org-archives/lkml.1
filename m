Return-Path: <linux-kernel-owner+w=401wt.eu-S932572AbZHDIEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbZHDIEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 04:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932230AbZHDIEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 04:04:37 -0400
Received: from mail.bigtelecom.ru ([87.255.0.61]:33379 "EHLO
	mail.bigtelecom.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227AbZHDIEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 04:04:35 -0400
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Aug 2009 04:04:35 EDT
Message-ID: <4A77E9FA.7030503@bigtelecom.ru>
Date: Tue, 04 Aug 2009 11:57:46 +0400
From: Badalian Vyacheslav <slavon@bigtelecom.ru>
User-Agent: Thunderbird 2.0.0.22 (X11/20090723)
MIME-Version: 1.0
To: =?UTF-8?B?IkNoaWEtY2hpIFllaCAo6JGJ5a626b2KKSI=?= 
	<chiachi@android.com>
CC: David Miller <davem@davemloft.net>, john.dykstra1@gmail.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] net: Keep interface binding when sending packets with
 	ipi_ifindex = 0
References: <6c039e090907231439t1def08a4n10978733bee55bec@mail.gmail.com>	 <20090727144402.513369f1.akpm@linux-foundation.org>	 <1248912621.13447.12.camel@merlyn>	 <20090803.212323.256579233.davem@davemloft.net> <6c039e090908040036j38666152y2db1d4c55529eaff@mail.gmail.com>
In-Reply-To: <6c039e090908040036j38666152y2db1d4c55529eaff@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chia-chi Yeh (葉家齊) пишет:
> After thinking more deeply, I believe that IPv6 does the right thing
> and IPv4 does not. SO_BINDTODEVICE requires CAP_NET_RAW, so it is a
> privileged operation. Therefore, it looks weird to me if one can
> specify other interface than the bound one without the same
> capability. The following patch makes the behavior in IPv4 and IPv6
> identical. Thanks for your help.
> 
> Chia-chi
> 
> --- a/net/ipv4/ip_sockglue.c    2009-08-04 15:11:39.000000000 +0800
> +++ b/net/ipv4/ip_sockglue.c    2009-08-04 15:17:05.000000000 +0800
> @@ -213,7 +213,11 @@
>                         if (cmsg->cmsg_len != CMSG_LEN(sizeof(struct
> in_pktinfo)))
>                                 return -EINVAL;
>                         info = (struct in_pktinfo *)CMSG_DATA(cmsg);
> -                       ipc->oif = info->ipi_ifindex;
> +                       if (info->ipi_ifindex) {
> +                               if (ipc->oif && info->ipi_ifindex != ipc->oif)
> +                                       return -EINVAL;
> +                               ipc->oif = info->ipi_ifindex;

Hello
Sorry if its my mistake or i someone not understand :)

if (ipc->oif && info->ipi_ifindex != ipc->oif)
	// if match: info->ipi_ifindex != ipc->oif
	return ...
else
	// else match: info->ipi_ifindex == ipc->oif
	// but you do 
	ipc->oif = info->ipi_ifindex; 
	// why if you else match allready check for it?

Thanks



> +                       }
>                         ipc->addr = info->ipi_spec_dst.s_addr;
>                         break;
>                 }
> 
> On Tue, Aug 4, 2009 at 12:23 PM, David Miller<davem@davemloft.net> wrote:
>> From: John Dykstra <john.dykstra1@gmail.com>
>> Date: Wed, 29 Jul 2009 19:10:21 -0500
>>
>>> I guess Dave's letting this stand.  I'm posting this just to make sure
>>> this is an explicit decision.
>> I'm still thinking about this.
>>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

