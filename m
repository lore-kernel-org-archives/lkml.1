Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046Ab0BXUiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:38:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61189 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975Ab0BXUiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:38:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 02/10] rcu: annotated list rcu code
Date: Wed, 24 Feb 2010 21:32:13 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
References: <20100223180127.GF6700@linux.vnet.ibm.com> <1267041846-10469-3-git-send-email-arnd@arndb.de> <20100224201509.GB21067@Krystal>
In-Reply-To: <20100224201509.GB21067@Krystal>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002242132.13731.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+3DHN9XXRmbs0rKAXep4abAMcqYEK2i8JEn+B
 oEQIEHnZtM4NGd0fFg096RBtmjsknEJF3ELsnXVGY8sklzCXn7
 49tu6ePpr7vPIuU6pbytA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 February 2010, Mathieu Desnoyers wrote:
> * Arnd Bergmann (arnd@arndb.de) wrote:
> > The listrcu implementation now defines new rcu_list_head,
> > rcu_hlist_head and rcu_hlist_entry structures that are
> > annotated with __rcu. Only these can now be passed into
> > rcu_list_for_each and related interfaces.
> > 
> > When not running sparse, the types are defined to the
> > original list_head etc in order to not break working
> > setups that are lacking annotation.
> 
> Hrm, wait.. dumb question: how can an annotation break compilation ? If there is
> any way out of this, I would prefer if we can do without a #ifdef __CHECKER__ if
> possible. It calls for bugs and implementation mismatch.

The problem is that you can not (currently) declare a list_head
to be RCU protected by writing 'struct list_head __rcu list;',
because address space annotations only work on pointers.

The solution I used was to define a new struct rcu_list_head that
has the ->next member annotated as __rcu. Unfortunately, this
means that it is now incompatible to a struct list_head from
the compiler's point of view.

We could get rid of the #ifdef by unconditionally defining
the separate rcu_list_head, as long as all users are correctly
converted to it. This does have problems in cases such as the
module code that uses the same list with and without RCU, as
Alexey mentioned.

The alternative would be not to annotate list RCU at all and
__force away the warnings for these so we can still keep the
normal __rcu annotations.

	Arnd

