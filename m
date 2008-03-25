Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbYCYHPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbYCYHPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 03:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYCYHPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 03:15:44 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:34705 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbYCYHPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 03:15:43 -0400
Date: Tue, 25 Mar 2008 03:15:40 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: list splicing and list POISONing
Message-ID: <alpine.LFD.1.00.0803250307110.29947@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  based on a conversation we've been having on the newbies list, i'm
curious about the rationale behind list "POISON"ing.

  from <linux/list.h>, when you splice one list into another, the
head element from the original list is left hanging in space with its
original prev and next pointer values unchanged:

===
static inline void __list_splice(struct list_head *list,
                                 struct list_head *head)
{
        struct list_head *first = list->next;
        struct list_head *last = list->prev;
        struct list_head *at = head->next;

        first->prev = head;
        head->next = first;

        last->next = at;
        at->prev = last;
}
===

  notice how neither list->prev nor list->next is set to, say, NULL to
represent that that list head now represents an empty list.  instead,
those pointers are left (rather dangerously) pointing into the
newly-spliced list, which means that, if you erroneously try to
traverse the list represented by the "list" list head, you'll end up
immediately over in the new list and loop there forever.  it would
seem to make more sense to set those pointers to either NULL or
LIST_POISON{1,2}, would it not?  just for safety's sake?

  it seems like that's what's done when an element is *deleted* (that
is, unlinked) from a list:

===
static inline void list_del(struct list_head *entry)
{
        __list_del(entry->prev, entry->next);
        entry->next = LIST_POISON1;
        entry->prev = LIST_POISON2;
}
===

  so shouldn't the same reasoning apply in the splicing example?

rday
--


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
