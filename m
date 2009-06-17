Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbZFQIld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbZFQIld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 04:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763502AbZFQIlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 04:41:24 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:3462 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762387AbZFQIlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 04:41:23 -0400
X-SourceIP: 213.93.53.227
Subject: Re: bug in tty ldisc and friends
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Joerg Roedel <joerg.roedel@amd.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090616103606.GA3497@elte.hu>
References: <alpine.DEB.2.00.0906160144340.26673@gandalf.stny.rr.com>
	 <20090616093741.0d5b36bc@lxorguk.ukuu.org.uk>
	 <20090616085028.GA13771@elte.hu>
	 <20090616095706.36f01282@lxorguk.ukuu.org.uk>
	 <20090616100015.GD6432@elte.hu>
	 <20090616110419.14bc9485@lxorguk.ukuu.org.uk>
	 <20090616101240.GB28204@elte.hu> <20090616102509.GA32717@elte.hu>
	 <20090616102910.GA11011@elte.hu>  <20090616103606.GA3497@elte.hu>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 10:32:03 +0200
Message-Id: <1245227523.13761.21661.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-16 at 12:36 +0200, Ingo Molnar wrote:

> +++ b/lib/dma-debug.c
> @@ -62,6 +62,8 @@ struct dma_debug_entry {
>  #endif
>  };
>  
> +static struct lock_class_key hash_bucket_class;
> +
>  struct hash_bucket {
>  	struct list_head list;
>  	spinlock_t lock;
> @@ -716,7 +718,8 @@ void dma_debug_init(u32 num_entries)
>  
>  	for (i = 0; i < HASH_SIZE; ++i) {
>  		INIT_LIST_HEAD(&dma_entry_hash[i].list);
> -		dma_entry_hash[i].lock = SPIN_LOCK_UNLOCKED;
> +		spin_lock_init(&dma_entry_hash[i].lock);
> +		lockdep_set_lock_class(&dma_entry_hash[i].lock, &hash_bucket_class);
>  	}
>  
>  	if (dma_debug_fs_init() != 0) {

I don't see what you need that lockdep_set_class() for, the
spin_lock_init() would already set a class specific to the callsite. And
since all these buckets are initialized from the same place (ie, this
loop), they'd all share the same class.

Its just that the old style SPIN_LOCK_UNLOCKED doesn't set a class and
then reverts to the static address of the lock object itself that these
locks used to have different classes.

So in short, yes the above patch should fix it, but it could be done
shorter..

and..

we really should do another round of SPIN_LOCK_UNLOCKED cleanups and
finally remove that thing.

