Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbZFPLjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbZFPLjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 07:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZFPLjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 07:39:33 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:29051 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbZFPLjd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 07:39:33 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432R98dR1805Mzz1202hzzz32i17ch6bh43j)
X-FB-SS: 5,13,
X-WSS-ID: 0KLBXPE-03-FKU-01
Date: Tue, 16 Jun 2009 13:39:13 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in tty ldisc and friends
Message-ID: <20090616113913.GJ5139@amd.com>
References: <alpine.DEB.2.00.0906160144340.26673@gandalf.stny.rr.com> <20090616093741.0d5b36bc@lxorguk.ukuu.org.uk> <20090616085028.GA13771@elte.hu> <20090616095706.36f01282@lxorguk.ukuu.org.uk> <20090616100015.GD6432@elte.hu> <20090616110419.14bc9485@lxorguk.ukuu.org.uk> <20090616101240.GB28204@elte.hu> <20090616102509.GA32717@elte.hu> <20090616102910.GA11011@elte.hu> <20090616103606.GA3497@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090616103606.GA3497@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 16 Jun 2009 11:39:13.0692 (UTC) FILETIME=[12931DC0:01C9EE77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 12:36:06PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > This is something we noticed recently: dma-debug uses a lot of 
> > lock classes and thus creates a really large lock-graph, depleting 
> > the reserves quickly.
> 
> yep, i think dma-debug is the culprit. It has:
> 
>  #define HASH_SIZE       1024ULL
> 
> each hash entry has a separate lock.
> 
> But this should be easily to solve: a special lock-class for these 
> locks. Patch below (warning: utterly untested!).
> 
> (Btw., that SPIN_LOCK_UNLOCKED init method should really be 
> deprecated for real.)
> 
> 	Ingo
> 
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index 3b93129..012c240 100644
> --- a/lib/dma-debug.c
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

Ok, cool. I would apply it but I don't know enough about lockdep
internals to write a meaningful commit message. Can you please provide
one so I can commit this?

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

