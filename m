Return-Path: <linux-kernel-owner+w=401wt.eu-S1759206AbYBLT3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206AbYBLT3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbYBLT2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:28:52 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:4298 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757760AbYBLT2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:28:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=QOodIS0AxGoIhu/uKbT5YG/IzvSzzjN0ikNSbzjFmepIvs93ZRPp69FI7Szrgo9Ny/LWCCZ6+gfZ5xAdF2mBA5+AmMQ55wZzBXgylULGv7T8+ecGYvg3+dA5DRL+1JgTIL8shg829KvaSb5jM7F1xlSFPka+ssZLkcGKeQnRMY0=
Date: Tue, 12 Feb 2008 20:32:18 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Miller <davem@davemloft.net>, shemminger@vyatta.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fib_trie: rcu_assign_pointer warning fix
Message-ID: <20080212193218.GA2803@ami.dom.local>
References: <20080211.171645.74019568.davem@davemloft.net> <20080212085714.GB2582@ff.dom.local> <20080212160729.GA9157@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212160729.GA9157@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 08:07:29AM -0800, Paul E. McKenney wrote:
...
> "All programmers are blind, especially me."

Hmm... I got it my way: you - superheroes - sometimes seem to be just
like us - common people... (Probably early in the morning, before
dressing your funny costumes?) 

> You are right, Jarek.  I ran this through gcc, and the following
> comes close:
> 
> #define rcu_assign_pointer(p, v) \
> 	({ \
> 		if (!__builtin_constant_p(v) || (v)) \
> 			smp_wmb(); \
> 		(p) = (v); \
> 	})
> 
> But I am concerned about the following case:
> 
> 	rcu_assign_pointer(global_index, 0);
> 
> 	. . .
> 
> 	x = global_array[rcu_dereference(global_index)];
> 
> Since arrays have a zero-th element, we would really want a memory
> barrier in this case.

It seems the above version of this macro uses the barrier for 0, but
if I miss something, or for these other: documenting reasons, then of
course you are right.

> 
> So how about leaving the index-unfriendly version of rcu_assign_pointer()
> and adding an rcu_assign_index() as follows?
> 
> 							Thanx, Paul
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  rcupdate.h |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff -urpNa -X dontdiff linux-2.6.24/include/linux/rcupdate.h linux-2.6.24-rai/include/linux/rcupdate.h
> --- linux-2.6.24/include/linux/rcupdate.h	2008-01-24 14:58:37.000000000 -0800
> +++ linux-2.6.24-rai/include/linux/rcupdate.h	2008-02-12 08:04:59.000000000 -0800
> @@ -278,6 +278,24 @@ extern struct lockdep_map rcu_lock_map;
>  					})
>  
>  /**
> + * rcu_assign_index - assign (publicize) a index of a newly
> + * initialized array elementg that will be dereferenced by RCU

---------------------------^
 + * initialized array element that will be dereferenced by RCU

Regards,
Jarek P.
