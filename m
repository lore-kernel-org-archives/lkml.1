Return-Path: <linux-kernel-owner+w=401wt.eu-S1757439AbXFLNrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbXFLNrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 09:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbXFLNrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 09:47:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:11875 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144AbXFLNrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 09:47:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d7iyP1I+Dl8r6PTImjhGIJkPnLszVwNec8wL4V9Sr0f14wN8CaqCT2yBWzpxoVN/SD+5j7Dfsyz9at6QYvYFNwr7PqxIaDhYgXtJLAFO7Q6LaNGKlCIQima6ENHdKTaz2geEm/DePv37RT7jjr6e3Sjwq6N1eCHjc1a5CRsnboQ=
Message-ID: <f24d23310706120647n4e125964i3885bd5c340b8903@mail.gmail.com>
Date: Tue, 12 Jun 2007 19:17:07 +0530
From: "debian developer" <debiandev@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [patch 1/4] lockdep: variuos fixes
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070612121916.533503225@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070612121351.448814658@chello.nl>
	 <20070612121916.533503225@chello.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What exactly is being copyright'ed here?

On 6/12/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>  - update the copyright notices
>  - use the default hash function
>  - fix a thinko in a BUILD_BUG_ON
>  - add a WARN_ON to spot inconsitent naming
>  - fix a termination issue in /proc/lock_stat
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Acked-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/lockdep.h |    3 ++-
>  kernel/lockdep.c        |   20 +++++++++++---------
>  kernel/lockdep_proc.c   |    6 +++++-
>  3 files changed, 18 insertions(+), 11 deletions(-)
>
> Index: linux-2.6/kernel/lockdep.c
> ===================================================================
> --- linux-2.6.orig/kernel/lockdep.c
> +++ linux-2.6/kernel/lockdep.c
> @@ -5,7 +5,8 @@
>   *
>   * Started by Ingo Molnar:
>   *
> - *  Copyright (C) 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
> + *  Copyright (C) 2006,2007 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
> + *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
>   *
>   * this code maps all the lock dependencies as they occur in a live kernel
>   * and will warn about the following classes of locking bugs:
> @@ -37,6 +38,7 @@
>  #include <linux/debug_locks.h>
>  #include <linux/irqflags.h>
>  #include <linux/utsname.h>
> +#include <linux/hash.h>
>
>  #include <asm/sections.h>
>
> @@ -238,8 +240,7 @@ LIST_HEAD(all_lock_classes);
>   */
>  #define CLASSHASH_BITS         (MAX_LOCKDEP_KEYS_BITS - 1)
>  #define CLASSHASH_SIZE         (1UL << CLASSHASH_BITS)
> -#define CLASSHASH_MASK         (CLASSHASH_SIZE - 1)
> -#define __classhashfn(key)     ((((unsigned long)key >> CLASSHASH_BITS) + (unsigned long)key) & CLASSHASH_MASK)
> +#define __classhashfn(key)     hash_long((unsigned long)key, CLASSHASH_BITS)
>  #define classhashentry(key)    (classhash_table + __classhashfn((key)))
>
>  static struct list_head classhash_table[CLASSHASH_SIZE];
> @@ -250,9 +251,7 @@ static struct list_head classhash_table[
>   */
>  #define CHAINHASH_BITS         (MAX_LOCKDEP_CHAINS_BITS-1)
>  #define CHAINHASH_SIZE         (1UL << CHAINHASH_BITS)
> -#define CHAINHASH_MASK         (CHAINHASH_SIZE - 1)
> -#define __chainhashfn(chain) \
> -               (((chain >> CHAINHASH_BITS) + chain) & CHAINHASH_MASK)
> +#define __chainhashfn(chain)   hash_long(chain, CHAINHASH_BITS)
>  #define chainhashentry(chain)  (chainhash_table + __chainhashfn((chain)))
>
>  static struct list_head chainhash_table[CHAINHASH_SIZE];
> @@ -680,7 +679,7 @@ look_up_lock_class(struct lockdep_map *l
>          * (or spin_lock_init()) call - which acts as the key. For static
>          * locks we use the lock object itself as the key.
>          */
> -       BUILD_BUG_ON(sizeof(struct lock_class_key) > sizeof(struct lock_class));
> +       BUILD_BUG_ON(sizeof(struct lock_class_key) > sizeof(struct lockdep_map));
>
>         key = lock->key->subkeys + subclass;
>
> @@ -690,9 +689,12 @@ look_up_lock_class(struct lockdep_map *l
>          * We can walk the hash lockfree, because the hash only
>          * grows, and we are careful when adding entries to the end:
>          */
> -       list_for_each_entry(class, hash_head, hash_entry)
> -               if (class->key == key)
> +       list_for_each_entry(class, hash_head, hash_entry) {
> +               if (class->key == key) {
> +                       WARN_ON_ONCE(class->name != lock->name);
>                         return class;
> +               }
> +       }
>
>         return NULL;
>  }
> Index: linux-2.6/include/linux/lockdep.h
> ===================================================================
> --- linux-2.6.orig/include/linux/lockdep.h
> +++ linux-2.6/include/linux/lockdep.h
> @@ -1,7 +1,8 @@
>  /*
>   * Runtime locking correctness validator
>   *
> - *  Copyright (C) 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
> + *  Copyright (C) 2006,2007 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
> + *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
>   *
>   * see Documentation/lockdep-design.txt for more details.
>   */
> Index: linux-2.6/kernel/lockdep_proc.c
> ===================================================================
> --- linux-2.6.orig/kernel/lockdep_proc.c
> +++ linux-2.6/kernel/lockdep_proc.c
> @@ -5,7 +5,8 @@
>   *
>   * Started by Ingo Molnar:
>   *
> - *  Copyright (C) 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
> + *  Copyright (C) 2006,2007 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
> + *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
>   *
>   * Code for /proc/lockdep and /proc/lockdep_stats:
>   *
> @@ -498,6 +499,9 @@ static void *ls_start(struct seq_file *m
>         if (data->iter == data->stats)
>                 seq_header(m);
>
> +       if (data->iter == data->iter_end)
> +               data->iter = NULL;
> +
>         return data->iter;
>  }
>
>
> --
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
