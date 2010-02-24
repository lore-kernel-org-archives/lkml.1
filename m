Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315Ab0BXXIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 18:08:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59089 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758213Ab0BXXIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 18:08:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 07/10] module: __rcu annotations
Date: Thu, 25 Feb 2010 00:07:47 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.32-13-generic; KDE/4.4.0; x86_64; ; )
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
References: <20100223180127.GF6700@linux.vnet.ibm.com> <201002242126.09994.arnd@arndb.de> <20100224221749.GI6980@linux.vnet.ibm.com>
In-Reply-To: <20100224221749.GI6980@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002250007.47563.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19isU68jmjAa32bohdW4fc7P/bFksNtCukf5/W
 dQJMzFaZo4z/QEKVduJhlrExMyCREEoDM3+xsExnYv0mKWK/dZ
 qCl3dS1L5bMeNrllZ3wrw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 February 2010 23:17:49 Paul E. McKenney wrote:
> > Ok, this is a significant limitation of the list rcu annotation
> > then, it's not possible to pass the same list into list_for_each_entry
> > and list_for_each_entry_rcu with the way I changed the rcu list
> > definition. I would be possible to do a __list_for_each_entry_rcu
> > macro that takes an rcu_list_head but does not actually use
> > rcu_dereference, but I'm not sure if that's good enough.
> 
> Hmmm...  If the __rcu annotation was visible at runtime, it would be
> easy provide an annotated version of list_for_each_entry_rcu() that
> checks for module_mutex being held under lockdep.

Well, if we keep the struct rcu_list_head and make it mandatory for
rcu protected lists, it could be defined as

struct rcu_list_head {
	struct list_head head;
#ifdef CONFIG_PROVE_RCU
	bool (*check)(void);
#endif
};

#ifdef CONFIG_PROVE_RCU
#define RCU_LIST_HEAD_INIT_CHECK(__head, __check) \
	{ .head = LIST_HEAD_INIT((__head).head), .check = (__check) }
#else
#define RCU_LIST_HEAD_INIT_CHECK(__list,__check) {.head = LIST_HEAD_INIT((__head).head) }
#endif

#define RCU_LIST_HEAD_INIT(head) RCU_LIST_HEAD_INIT_CHECK(head,&rcu_read_lock_held)
#define RCU_LIST_HEAD_INIT_BH(head) RCU_LIST_HEAD_INIT_CHECK(head,&rcu_read_lock_bh_held)

#define list_entry_rcu_check(ptr, type, member, check) \
        container_of(rcu_dereference_check((void __rcu __force *)(ptr), check), type, member)

#define list_for_each_entry_rcu(pos, __head, member) \
        for (pos = list_entry_rcu_check((__head)->head.next, typeof(*pos), \
					 member, (__head)->check); \
                prefetch(pos->member.next), &pos->member != (head); \
                pos = list_entry_rcu_check(pos->member.next, typeof(*pos), \
					 member, (__head)->check)))

That would let us check all the heads for correct usage, and at the same
time avoid having to annotate all the list entries.

	Arnd
