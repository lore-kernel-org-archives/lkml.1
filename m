Return-Path: <linux-kernel-owner+w=401wt.eu-S937426AbXFHEzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937426AbXFHEzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 00:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbXFHEy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 00:54:57 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:51235 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbXFHEy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 00:54:56 -0400
Message-ID: <4668E106.9040509@cosmosbay.com>
Date: Fri, 08 Jun 2007 06:54:30 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/8] fdmap v2 - fdmap core
References: <send-serie.davidel@xmailserver.org.4625.1181169031.1>
In-Reply-To: <send-serie.davidel@xmailserver.org.4625.1181169031.1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Fri, 08 Jun 2007 06:54:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi a écrit :
> +struct fd_map {
> +	struct fd_map *next;
> +	struct rcu_head rcu;
> +	unsigned int base;
> +	unsigned int size;
> +	struct list_head slist;
> +	struct list_head *slots;
> +	unsigned int fdnext;
> +	unsigned long *map;
> +	void (*freecb)(void *, struct fd_map *);
> +	void *freecb_priv;
> +};


On x86_64 that would mean folowing offsets

struct fd_map {
	struct fd_map *next;  /* 0 */
	struct rcu_head rcu; /* 8 */
	unsigned int base;   /* 0x18 */
	unsigned int size;   /* 0x1c */
	struct list_head slist; /* 0x20 */
	struct list_head *slots; /* 0x30 */
	unsigned int fdnext; /* 0x38 */
	unsigned long *map; /* 0x40 */
	void (*freecb)(void *, struct fd_map *); /* 0x48 */
	void *freecb_priv; /* 0x50 */
}; /* size 0x58 */

As L1_CACHE_BYTES is 64, two cache lines are necessary to get base,size,map
And a change of fdnext dirties one cache line that should be kept read only to 
avoid false sharing.

I suggest to reorder to move rcu and next at the end (since they are seldom 
used). Also move fdnext on a separate cache line on SMP

struct fd_map {
	/*
	 * read mostly part
	 */
	unsigned int base;   /* 0x00 */
	unsigned int size;   /* 0x04 */
	struct list_head slist; /* 0x08 */
	struct list_head *slots; /* 0x18 */
	unsigned long *map; /* 0x28 */
	void (*freecb)(void *, struct fd_map *); /* 0x30 */
	void *freecb_priv; /* 0x38 */

	/*
	 * written part on a separate cache line in SMP
	 */
	unsigned int fdnext ____cacheline_aligned_in_smp; /* 0x40 */

	struct fd_map *next;  /* 0x48 */
	struct rcu_head rcu; /* 0x50 */
};

Thank you
