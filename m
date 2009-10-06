Return-Path: <linux-kernel-owner+w=401wt.eu-S932711AbZJFQfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711AbZJFQfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932628AbZJFQfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:35:39 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:56147 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932583AbZJFQfi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:35:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEACoNy0pMROOX/2dsb2JhbACBUdIWhCoE
Date: Tue, 6 Oct 2009 12:35:00 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch 2/4] tree rcu: Add debug RCU head option
Message-ID: <20091006163500.GC15904@Krystal>
References: <20091006143727.868480435@polymtl.ca> <20091006144038.140258698@polymtl.ca> <4ACB684A.6060107@gmail.com> <20091006160948.GB15904@Krystal> <4ACB6DAF.4000709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4ACB6DAF.4000709@gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:31:36 up 49 days,  3:21,  2 users,  load average: 0.24, 0.17,
	0.17
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Dumazet (eric.dumazet@gmail.com) wrote:
> Mathieu Desnoyers a écrit :
> > * Eric Dumazet (eric.dumazet@gmail.com) wrote:
> >> Mathieu Desnoyers a écrit :
> >>> Poisoning the rcu_head callback list. Only for rcu tree for now.
> >>>
> >>> Helps finding racy users of call_rcu(), which results in hangs because list
> >>> entries are overwritten and/or skipped. Using the lower bit to poison because
> >>> include/net/dst.h __pad_to_align_refcnt complains when struct rcu_head grows.
> >>>
> >> I see :)
> >>
> > 
> > I don't know if there is an easy fix for __pad_to_align_refcnt ?
> 
> 
> This check was added to make sure some tbench regression was not added if
> dst->__refcnt was moved around, I am sure you dont care about tbench being 10% slower,
> do you ?
> 

Indeed, I absolutely don't care when I'm doing debugging :)

Will merge, and add a "struct rcu_head *debug" field in struct rcu_head.

Thanks !

Mathieu

> 
> diff --git a/include/net/dst.h b/include/net/dst.h
> index 5a900dd..b8fba74 100644
> --- a/include/net/dst.h
> +++ b/include/net/dst.h
> @@ -154,7 +154,9 @@ static inline void dst_hold(struct dst_entry * dst)
>  	 * If your kernel compilation stops here, please check
>  	 * __pad_to_align_refcnt declaration in struct dst_entry
>  	 */
> +#if !defined(DEBUG_RCU_HEAD)
>  	BUILD_BUG_ON(offsetof(struct dst_entry, __refcnt) & 63);
> +#endif
>  	atomic_inc(&dst->__refcnt);
>  }
>  
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
