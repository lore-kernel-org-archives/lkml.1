Return-Path: <linux-kernel-owner+w=401wt.eu-S932123AbYHFU3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbYHFU3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757719AbYHFU25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:28:57 -0400
Received: from mail.atheros.com ([12.36.123.2]:31919 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756512AbYHFU2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:28:55 -0400
Date: Wed, 6 Aug 2008 13:28:54 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@atheros.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Jochen =?iso-8859-1?B?Vm/f?= <jochen.voss@googlemail.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/4] list.h: add list_cut_position()
Message-ID: <20080806202854.GP5605@tesla>
References: <1217890089-12100-1-git-send-email-lrodriguez@atheros.com> <20080804160011.ec964f1f.randy.dunlap@oracle.com> <20080804231320.GG6447@tesla> <ef1cd66f0808050152g1dd8b96cl2df820607d480f0f@mail.gmail.com> <20080806182724.GI5605@tesla> <23052053.1218047754579.JavaMail.oracle@acsmt304.oracle.com> <20080806184520.GK5605@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080806184520.GK5605@tesla>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 11:45:20AM -0700, Luis Rodriguez wrote:
> 
> OK here's the new one.
> --
> 
> This adds list_cut_position() which lets you cut a list into
> two lists given a pivot in the list.
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Here it is again but this time one which applies cleanly ontop of the
list_cut_tail() patch I just reposted.

--
list.h: add list_cut_position()

This adds list_cut_position() which lets you cut a list into
two lists given a pivot in the list.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/linux/list.h |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 61034a6..78e5f1c 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -214,6 +214,46 @@ static inline int list_is_singular(const struct list_head *head)
 	return !list_empty(head) && (head->next == head->prev);
 }
 
+static inline void __list_cut_position(struct list_head *list,
+		struct list_head *head, struct list_head *entry)
+{
+	struct list_head *new_first = entry->next;
+	list->next = head->next;
+	list->next->prev = list;
+	list->prev = entry;
+	entry->next = list;
+	head->next = new_first;
+	new_first->prev = head;
+}
+
+/**
+ * list_cut_position - cut a list into two
+ * @list: a new list to add all removed entries
+ * @head: a list with entries
+ * @entry: an entry within head, could be the head itself
+ *	and if so we won't cut the list
+ *
+ * This helper moves the initial part of @head, up to and
+ * including @entry, from @head to @list. You should
+ * pass on @entry an element you know is on @head. @list
+ * should be an empty list or a list you do not care about
+ * losing its data.
+ *
+ */
+static inline void list_cut_position(struct list_head *list,
+		struct list_head *head, struct list_head *entry)
+{
+	if (list_empty(head))
+		return;
+	if (list_is_singular(head) &&
+		(head->next != entry && head != entry))
+		return;
+	if (entry == head)
+		INIT_LIST_HEAD(list);
+	else
+		__list_cut_position(list, head, entry);
+}
+
 static inline void __list_splice(const struct list_head *list,
 				 struct list_head *prev,
 				 struct list_head *next)
-- 
1.5.6.rc2.15.g457bb.dirty

