Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbYHFS1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbYHFS1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 14:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbYHFS11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 14:27:27 -0400
Received: from mail.atheros.com ([12.36.123.2]:24280 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbYHFS10 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 14:27:26 -0400
Date: Wed, 6 Aug 2008 11:27:24 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Jochen =?iso-8859-1?B?Vm/f?= <jochen.voss@googlemail.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [PATCH 2/4] list.h: add list_cut_position()
Message-ID: <20080806182724.GI5605@tesla>
References: <1217890089-12100-1-git-send-email-lrodriguez@atheros.com> <20080804160011.ec964f1f.randy.dunlap@oracle.com> <20080804231320.GG6447@tesla> <ef1cd66f0808050152g1dd8b96cl2df820607d480f0f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <ef1cd66f0808050152g1dd8b96cl2df820607d480f0f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 01:52:22AM -0700, Jochen Voß wrote:
> Hi,
> 
> 2008/8/5 Luis R. Rodriguez <lrodriguez@atheros.com>:
> > +static inline void __list_cut_position(struct list_head *list,
> > +               struct list_head *head, struct list_head *entry)
> > +{
> > +       struct list_head *new_first =
> > +               (entry->next != head) ? entry->next : head;
> 
> Isn't this just an over-complicated way of writing "new_first = entry->next"?

Sorry, yes.

> > +       list->next = head->next;
> > +       list->next->prev = list;
> > +       list->prev = entry;
> > +       entry->next = list;
> > +       head->next = new_first;
> > +       new_first->prev = head;
> > +}
> > +
> > +/**
> > + * list_cut_position - cut a list into two
> > + * @list: a new list to add all removed entries
> > + * @head: a list with entries
> > + * @entry: an entry within head, could be the head itself
> > + *     and if so we won't cut the list
> > + */
> 
> I think it would be helpful if the comment explained what the function
> actually does, i.e. that it moves the inital part of 'head' (up to and
> including 'entry' from 'head' to 'list'.

Will do.

> > +static inline void list_cut_position(struct list_head *list,
> > +               struct list_head *head, struct list_head *entry)
> > +{
> > +       BUG_ON(list_empty(head));
> > +       if (list_is_singular(head))
> > +               BUG_ON(head->next != entry && head != entry);
> 
> No other list function in "list.h" has BUG_ONs.  Why this one?

Alright, I'll just make some small note on the documentation and exit early
on these.

> > +       if (entry == head)
> > +               INIT_LIST_HEAD(list);
> 
> If there was data in 'list' before the call, it will be lost now.  Is
> this intended behaviour?

Yes, the user of this call should not care if we wipe @list for them as
it is just a reference. This lets you, for example, use @list on
list_cut_position() it in a loop. I'll extend the documentation to
clarify this.

> > +       else
> > +               __list_cut_position(list, head, entry);
> > +}
> > +
> 
> I hope this helps,

It certainly has, thanks for reviewing. How's this:

This adds list_cut_position() which lets you cut a list into
two lists given a pivot in the list.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

diff --git a/include/linux/list.h b/include/linux/list.h
index 453916b..6c02a83 100644
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
+ *
+ * This helper moves the initial part of @head, up to and
+ * including @entry, from @head to @list. You should
+ * pass on @entry an element you know is on @head. @list
+ * should be an empty list or a list you do not care about
+ * losing its data.
+ *
+ * @list: a new list to add all removed entries
+ * @head: a list with entries
+ * @entry: an entry within head, could be the head itself
+ *	and if so we won't cut the list
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
 				 struct list_head *head)
 {
