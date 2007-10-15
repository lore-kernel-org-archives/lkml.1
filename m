Return-Path: <linux-kernel-owner+w=401wt.eu-S1764681AbXJOMJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764681AbXJOMJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 08:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758789AbXJOMJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 08:09:15 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:59451 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758237AbXJOMJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 08:09:14 -0400
To: jmorris@namei.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200710022144.BFF09817.VFFOOJLSFHtQMO@I-love.SAKURA.ne.jp>
	<Xine.LNX.4.64.0710020557170.21841@us.intercode.com.au>
	<200710032024.DJF78662.FHOLtMSFOOFJVQ@I-love.SAKURA.ne.jp>
	<20071003.204356.05853536.yoshfuji@linux-ipv6.org>
	<Xine.LNX.4.64.0710030529580.6431@us.intercode.com.au>
In-Reply-To: <Xine.LNX.4.64.0710030529580.6431@us.intercode.com.au>
Message-Id: <200710152109.FCE78118.QVLJFOFOtSHMFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 15 Oct 2007 21:09:10 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

James Morris wrote:
> > > It seems that standard kernel list API does not have singly-linked list manipulation.
> > > I'm considering the following list manipulation API.
> 
> I'm pretty sure that the singly linked list idea has been rejected a few 
> times.  Just use the existing API.
> 
OK. I posted new one that uses existing API at http://lkml.org/lkml/2007/10/11/140 .

By the way, what do you think of new primitives shown below?
I'd like to use list_for_each_cookie() and list_add_tail_mb() if acceptable.

----- Start of code -----
/********** Existing API **********/

#include <stdio.h>
#include <stdlib.h>

static inline void mb(void) {;}
static inline void prefetch(void *p) {;}
#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
#define container_of(ptr, type, member) ({ const typeof( ((type *)0)->member ) *__mptr = (ptr); (type *)( (char *)__mptr - offsetof(type,member) );})
#define list_entry(ptr, type, member) container_of(ptr, type, member)

struct list_head {
	struct list_head *next, *prev;
};
#define LIST_HEAD_INIT(name) { &name, &name }
#define LIST_HEAD(name) struct list_head name = LIST_HEAD_INIT(name)

/********** Proposed API **********/

/**
 * list_for_each_cookie - iterate over a list with cookie.
 * @pos:        the &struct list_head to use as a loop cursor.
 * @cookie:     the &struct list_head to use as a cookie.
 * @head:       the head for your list.
 *
 * Same with list_for_each except that this primitive uses cookie
 * so that we can continue iteration.
 */
#define list_for_each_cookie(pos, cookie, head) \
	for ((cookie) || ((cookie) = (head)), pos = (cookie)->next; \
	     prefetch(pos->next), pos != (head) || ((cookie) = NULL); \
	     (cookie) = pos, pos = pos->next)

/**
 * list_add_tail_mb - add a new entry with memory barrier.
 * @new: new entry to be added.
 * @head: list head to add it before.
 *
 * Same with list_add_tail_rcu() except that this primitive uses mb()
 * so that we can traverse forwards using list_for_each() and
 * list_for_each_cookie().
 */
static inline void list_add_tail_mb(struct list_head *new,
                                    struct list_head *head)
{
	struct list_head *prev = head->prev;
	struct list_head *next = head;
	new->next = next;
	new->prev = prev;
	mb();
	next->prev = new;
	prev->next = new;
}

/********** Usage example **********/

struct something {
	struct list_head list;
	int v;
};

static LIST_HEAD(something_list);

int main(int argc, char *argv[]) {
	struct something *ptr;
	struct list_head *pos;
	struct list_head *cookie = NULL;
	int i;
	for (i = 0; i < 10; i++) {
		printf("add %d\n", i);
		ptr = malloc(sizeof(*ptr));
		ptr->v = 10 + i;
		list_add_tail_mb(&(ptr->list), &something_list);
	}
	printf("dump\n");
	i = 0;
	do {
		list_for_each_cookie(pos, cookie, &something_list) {
			ptr = list_entry(pos, struct something, list);
			if (++i % 4 == 0) { /* Interrupt such as buffer-full. */
				printf("break\n");
				break;
			}
			printf("%d\n", ptr->v);
		}
	} while (cookie);
	return 0;
}
----- End of code -----

Regards.

