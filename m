Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbYE1F0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbYE1F0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 01:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbYE1F0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 01:26:37 -0400
Received: from smtp.nokia.com ([192.100.122.230]:23533 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbYE1F0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 01:26:36 -0400
Message-ID: <483CED9A.4070102@yandex.ru>
Date: Wed, 28 May 2008 08:28:58 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Lennert Buytenhek <buytenh@wantstofly.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: bad example in Documentation/atomic_ops.txt ?
References: <4836DC57.1020101@yandex.ru>
In-Reply-To: <4836DC57.1020101@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 May 2008 05:26:27.0282 (UTC) FILETIME=[6087CB20:01C8C083]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

do you have any comments on this? I paste the example below for
convenience.

Artem Bityutskiy wrote:
> I it looks like the example in the Documentation/atomic_ops.txt
> file at line 232 is not quite right. The obj->active = 0 will
> be delayed, but not further than spin_unlock() in obj_timeout().
> Becaus spin_unlock() has a memory barrier.
> 
> I guess you would need to move spin_lock(&global_list_lock) to
> obj_list_del() to make the example valid.
> 
> This confused me when I read the file.

static void obj_list_add(struct obj *obj)
{
        obj->active = 1;
        list_add(&obj->list);
}

static void obj_list_del(struct obj *obj)
{
        list_del(&obj->list);
        obj->active = 0;
}

static void obj_destroy(struct obj *obj)
{
        BUG_ON(obj->active);
        kfree(obj);
}

struct obj *obj_list_peek(struct list_head *head)
{
        if (!list_empty(head)) {
                struct obj *obj;

                obj = list_entry(head->next, struct obj, list);
                atomic_inc(&obj->refcnt);
                return obj;
        }
        return NULL;
}

void obj_poke(void)
{
        struct obj *obj;

        spin_lock(&global_list_lock);
        obj = obj_list_peek(&global_list);
        spin_unlock(&global_list_lock);

        if (obj) {
                obj->ops->poke(obj);
                if (atomic_dec_and_test(&obj->refcnt))
                        obj_destroy(obj);
        }
}

void obj_timeout(struct obj *obj)
{
        spin_lock(&global_list_lock);
        obj_list_del(obj);
        spin_unlock(&global_list_lock);

        if (atomic_dec_and_test(&obj->refcnt))
                obj_destroy(obj);
}

(This is a simplification of the ARP queue management in the
 generic neighbour discover code of the networking.  Olaf Kirch
 found a bug wrt. memory barriers in kfree_skb() that exposed
 the atomic_t memory barrier requirements quite clearly.)

Given the above scheme, it must be the case that the obj->active
update done by the obj list deletion be visible to other processors
before the atomic counter decrement is performed.

Otherwise, the counter could fall to zero, yet obj->active would still
be set, thus triggering the assertion in obj_destroy().  The error
sequence looks like this:

        cpu 0                           cpu 1
        obj_poke()                      obj_timeout()
        obj = obj_list_peek();
        ... gains ref to obj, refcnt=2
                                        obj_list_del(obj);
                                        obj->active = 0 ...
                                        ... visibility delayed ...
                                        atomic_dec_and_test()
                                        ... refcnt drops to 1 ...
        atomic_dec_and_test()
        ... refcount drops to 0 ...
        obj_destroy()
        BUG() triggers since obj->active
        still seen as one
                                        obj->active update visibility occurs

With the memory barrier semantics required of the atomic_t operations
which return values, the above sequence of memory visibility can never
happen.  Specifically, in the above case the atomic_dec_and_test()
counter decrement would not become globally visible until the
obj->active update does.


-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
