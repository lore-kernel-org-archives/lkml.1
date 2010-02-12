Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab0BLLTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 06:19:22 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:58540 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab0BLLTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 06:19:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=um8epwkyQS4Fc1I8IYrtRiealMix6sqLShH8+g8HdGcRqFeNvRVu1O0Dqg1ZZng8ER
         Nh4Y3VNtW5YRFqak46nImWcc99uU/IRBTA+at/gk4Sj5u8pK3bEUynS2W89VmtzW3YZY
         G0lpKBV6SDgnTqFKlScSV32KmdzRH5G7f/2sY=
Message-ID: <4B753931.30405@gmail.com>
Date: Fri, 12 Feb 2010 06:19:13 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Andreas Petlund <apetlund@simula.no>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       =?UTF-8?B?SWxwbyBK?= =?UTF-8?B?w6RydmluZW4=?= 
	<ilpo.jarvinen@helsinki.fi>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       David Miller <davem@davemloft.net>, damian@tvk.rwth-aachen.de
Subject: Re: [net-next PATCH v3 2/3] net: TCP thin linear timeouts
References: <4B73F30D.6040205@simula.no>
In-Reply-To: <4B73F30D.6040205@simula.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last year, I'm pretty sure I was on record as thinking this is only a
marginally good idea, that would be better at the application layer.

Also that naming was a bit dicey.  Now the names are more descriptive,
but the "force" is a bit overkill.

How about?
   NET_TCP_FORCE_THIN_LINEAR_TIMEOUTS    -> NET_TCP_THIN_LINEAR_TIMEOUTS
   TCP_THIN_LT                           -> TCP_THIN_LINEAR_TIMEOUTS
   TCP_THIN_LT_RETRIES                   -> TCP_THIN_LINEAR_RETRIES
   tcp_force_thin_linear_timeouts        -> tcp_thin_linear_timeouts
   sysctl_tcp_force_thin_linear_timeouts -> sysctl_tcp_thin_linear_timeouts
   tp->thin_lt                           -> tp->thin_lto

The latter mostly traditional "to" for "timeout", as used most everywhere.


Andreas Petlund wrote:
> diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
> index de7d1bf..a682479 100644
> --- a/net/ipv4/tcp_timer.c
> +++ b/net/ipv4/tcp_timer.c
> @@ -29,6 +29,7 @@ int sysctl_tcp_keepalive_intvl __read_mostly = TCP_KEEPALIVE_INTVL;
>  int sysctl_tcp_retries1 __read_mostly = TCP_RETR1;
>  int sysctl_tcp_retries2 __read_mostly = TCP_RETR2;
>  int sysctl_tcp_orphan_retries __read_mostly;
> +int sysctl_tcp_force_thin_linear_timeouts __read_mostly;
>  
Where is the sysctl initialized?


> +	if ((tp->thin_lt || sysctl_tcp_force_thin_linear_timeouts) &&
> +	    tcp_stream_is_thin(sk) && sk->sk_state == TCP_ESTABLISHED &&
> +	    icsk->icsk_retransmits <= TCP_THIN_LT_RETRIES) {

Just for efficiency, I'd reorder this
   +	if (sk->sk_state == TCP_ESTABLISHED &&
   +	    (tp->thin_lt || sysctl_tcp_force_thin_linear_timeouts) &&
   +	    tcp_stream_is_thin(sk) &&
   +	    icsk->icsk_retransmits <= TCP_THIN_LT_RETRIES) {

