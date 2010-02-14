Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab0BNIua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 03:50:30 -0500
Received: from mail-bw0-f216.google.com ([209.85.218.216]:62655 "EHLO
	mail-bw0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab0BNIu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 03:50:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KZRhJ2Z3ghZinXrBfLgKqU0+q8n0PKueP3CggZnpkv07jvgHsWnDjw5iEK2N1ee1XP
         n4oGs81Pfakg3ptq4vB/dFg1RXEJop3zwZQSsTy3tmZqS0j0xS4x49F4dVeBL0Vi/Aog
         SgLsLv8PtYaeBGLYdXUK9JNo73MOoD9kBrN6c=
Subject: Re: [PATCH tip/core/rcu 05/13] net: add checking to
 rcu_dereference()  primitives
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirqus@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>
In-Reply-To: <e2d7436a1002140034h74617164p1a5dc90df3587095@mail.gmail.com>
References: <20100212000016.GA25781@linux.vnet.ibm.com>
	 <1265932839-25899-5-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1265948152.2891.25.camel@edumazet-laptop>
	 <e2d7436a1002140034h74617164p1a5dc90df3587095@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Feb 2010 09:50:15 +0100
Message-ID: <1266137415.2939.11.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 14 février 2010 à 09:34 +0100, Michał Mirosław a écrit :
> 2010/2/12 Eric Dumazet <eric.dumazet@gmail.com>:
> > Le jeudi 11 février 2010 à 16:00 -0800, Paul E. McKenney a écrit :
> [...]
> >> @@ -1654,12 +1654,12 @@ static struct dn_route *dn_rt_cache_get_first(struct seq_file *seq)
> >>
> >>       for(s->bucket = dn_rt_hash_mask; s->bucket >= 0; --s->bucket) {
> >>               rcu_read_lock_bh();
> >> -             rt = dn_rt_hash_table[s->bucket].chain;
> >> +             rt = rcu_dereference_bh(dn_rt_hash_table[s->bucket].chain);
> >>               if (rt)
> >>                       break;
> >>               rcu_read_unlock_bh();
> >>       }
> >> -     return rcu_dereference(rt);
> >> +     return rt;
> >>  }
> 
> Isn't there a bug? Looks like data pointed to by rt should be
> protected by RCU, but the rcu_read_lock is withdrawn before access.
> 

Not really a bug, since we exit from dn_rt_cache_get_first() with
rcu_read_lock_bh()

We call the unlock only if NULL is returned, and rcu_dereference(NULL)
can be done in any context.

Paul had to move the rcu_dereference() so that no lockdep warning
triggers for rcu_dereference(NULL), its more a cleanup than a bug fix.



