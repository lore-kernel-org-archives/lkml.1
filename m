Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbXJCLZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbXJCLZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 07:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbXJCLY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 07:24:56 -0400
Received: from [122.1.235.145] ([122.1.235.145]:62021 "EHLO
	smtp.wine.ocn.ne.jp" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbXJCLYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 07:24:55 -0400
To: jmorris@namei.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <4701F285.5000206@nttdata.co.jp>
	<4701F419.8080103@nttdata.co.jp>
	<Xine.LNX.4.64.0710020355260.6760@us.intercode.com.au>
	<200710022144.BFF09817.VFFOOJLSFHtQMO@I-love.SAKURA.ne.jp>
	<Xine.LNX.4.64.0710020557170.21841@us.intercode.com.au>
In-Reply-To: <Xine.LNX.4.64.0710020557170.21841@us.intercode.com.au>
Message-Id: <200710032024.DJF78662.FHOLtMSFOOFJVQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Wed, 3 Oct 2007 20:24:52 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

YOSHIFUJI Hideaki wrote:
> Introducing your own list is not good.
> Please use hlist or introduce new "slist".

James Morris wrote:
> You're introducing a custom API, which is open-coded repeatedly throughout 
> your module.
> 
> All linked lists (at least, new ones) must use the standard kernel list
> API.

It seems that standard kernel list API does not have singly-linked list manipulation.
I'm considering the following list manipulation API.

--- Start of code ---
#include <stdio.h>
#include <stdlib.h>

static inline void prefetch(const void *x) {;}
#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
#define container_of(ptr, type, member) ({ const typeof( ((type *)0)->member ) *__mptr = (ptr); (type *)( (char *)__mptr - offsetof(type,member) );})

/*
 * nphlist -- hlist with no pointer to previous
 */
struct nphlist_node {
	struct nphlist_node *next;
};
struct nphlist_head {
	struct nphlist_node *first;
};

#define NPHLIST_HEAD_INIT { .first = NULL }
#define NPHLIST_HEAD(name) struct nphlist_head name = NPHLIST_HEAD_INIT
#define INIT_NPHLIST_HEAD(ptr) ((ptr)->first = NULL)
#define INIT_NPHLIST_NODE(ptr) ((ptr)->next = NULL)

static inline void nphlist_add(struct nphlist_node *entry, struct nphlist_head *list) {
	struct nphlist_node *ptr = list->first;
	if (ptr) {
		while (ptr->next)
			ptr = ptr->next;
		ptr->next = entry;
	} else {
		list->first = entry;
	}
}

#define nphlist_entry(ptr, type, member) container_of(ptr,type,member)

/**
 * nphlist_for_each_entry - iterate over list of given type
 * @tpos:       the type * to use as a loop cursor.
 * @pos:        the &struct nph_list to use as a loop cursor.
 * @head:       the head for your list.
 * @member:     the name of the nphlist_node within the struct.
 */
#define nphlist_for_each_entry(tpos, pos, head, member)			\
	for (pos = (head);						\
	     pos && ({ prefetch(pos->next); 1;}) &&			\
		     ({ tpos = nphlist_entry(pos, typeof(*tpos), member); 1;}); \
	     pos = pos->next)

struct something {
	struct nphlist_node next;
	int v;
};

static NPHLIST_HEAD(data);

int main(int argc, char *argv[]) {
	struct something *ptr;
	struct nphlist_node *p;
	int i;
	for (i = 0; i < 10; i++) {
		printf("add %d\n", i);
		ptr = malloc(sizeof(*ptr));
		INIT_NPHLIST_NODE(&(ptr->next));
		ptr->v = 10 + i;
		nphlist_add(&(ptr->next), &data);
	}
	printf("dump\n");
	nphlist_for_each_entry(ptr, p, data.first, next) {
		printf("%d\n", ptr->v);
	}
	return 0;
}
--- End of code ---

Where should I put this API, in include/linux/list.h or security/tomoyo/include/tomoyo.h ?

If I should put in include/linux/list.h , what name would be appropriate?
May I name it "slist" instead of "nphlist" ?

Regards.

