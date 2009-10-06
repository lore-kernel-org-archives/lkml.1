Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbZJFP4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbZJFP4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758077AbZJFP4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:56:11 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:36381 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147AbZJFP4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:56:10 -0400
Message-ID: <4ACB684A.6060107@gmail.com>
Date: Tue, 06 Oct 2009 17:54:50 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch 2/4] tree rcu: Add debug RCU head option
References: <20091006143727.868480435@polymtl.ca> <20091006144038.140258698@polymtl.ca>
In-Reply-To: <20091006144038.140258698@polymtl.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 06 Oct 2009 17:54:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers a écrit :
> Poisoning the rcu_head callback list. Only for rcu tree for now.
> 
> Helps finding racy users of call_rcu(), which results in hangs because list
> entries are overwritten and/or skipped. Using the lower bit to poison because
> include/net/dst.h __pad_to_align_refcnt complains when struct rcu_head grows.
> 

I see :)

> --- linux-2.6-lttng.orig/include/linux/rcupdate.h	2009-10-06 10:35:15.000000000 -0400
> +++ linux-2.6-lttng/include/linux/rcupdate.h	2009-10-06 10:35:18.000000000 -0400
> @@ -45,6 +45,8 @@
>   * struct rcu_head - callback structure for use with RCU
>   * @next: next update requests in a list
>   * @func: actual update function to call after the grace period.
> + *
> + * Debug mode assumes func pointer value is word-aligned.

Ouch, I guess you never tried CONFIG_CC_OPTIMIZE_FOR_SIZE=y ?

random extract from "nm -v vmlinux"

c0415e58 T in4_pton
c0415f66 T in6_pton
c04161f0 T in_aton
c0416240 T net_ratelimit
c0416250 t linkwatch_add_event
c0416281 t linkwatch_schedule_work
c0416301 T linkwatch_fire_event
c0416368 t __linkwatch_run_queue
c04164d2 t linkwatch_event
c04164f4 T linkwatch_run_queue
c0416500 T sk_chk_filter
c0416703 t sk_filter_rcu_release
c041671d T sk_detach_filter
c041676a T sk_attach_filter
c0416862 T sk_run_filter
c0416f5d T sk_filter
c0416fc4 t __flow_cache_shrink

gcc -v
Using built-in specs.
Target: i686-pc-linux-gnu
Configured with: ../gcc-4.4.1/configure --enable-languages=c,c++ --prefix=/usr
Thread model: posix
gcc version 4.4.1 (GCC)

