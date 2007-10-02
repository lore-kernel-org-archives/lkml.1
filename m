Return-Path: <linux-kernel-owner+w=401wt.eu-S1752685AbXJBMpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbXJBMpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 08:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbXJBMpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 08:45:03 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:58788 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbXJBMpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 08:45:01 -0400
To: jmorris@namei.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <4701F285.5000206@nttdata.co.jp>
	<4701F419.8080103@nttdata.co.jp>
	<Xine.LNX.4.64.0710020355260.6760@us.intercode.com.au>
In-Reply-To: <Xine.LNX.4.64.0710020355260.6760@us.intercode.com.au>
Message-Id: <200710022144.BFF09817.VFFOOJLSFHtQMO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Tue, 2 Oct 2007 21:44:57 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Thank you for your comment.

James Morris wrote:
> Why do you need to avoid spinlocks for these manipulations?

I don't need to use spinlocks here.
What I need to do here is avoid read/write reordering,
so mb() will be appropriate here.

struct something {
  struct something *next;
  void *data;
};

struct something *prev_ptr = ...;
struct something *new_ptr = kmalloc(sizeof(*new_ptr), GFP_KERNEL);
new_ptr->next = NULL;
new_ptr->data = some_value;
mb();
prev_ptr->next = new_ptr;

TOMOYO Linux doesn't use locks for reading singly-linked list.
Thus, new_ptr->data has to be made visible to other CPUs
before new_ptr is appended at the tail of singly-linked list.
Otherwise, other CPU may read undefined new_ptr->data values.

Performance is not critical because this mb() is called
only when appending new entry to the singly-linked list.

> Please use standard kernel list handling, per include/linux/list.h

Since new_ptr never be removed, new_ptr needn't to know
it's previous element's address, thus having only ->next pointer is enough.
new_ptr->next is assigned *only once*
(initialized with NULL, and assigned non-NULL later),
indicating "if ptr->next == NULL, ptr is the last element" and
"if ptr->next != NULL, ptr is not the last element".

If I use "struct hlist_node" which has two pointers,
it needs more memory than "struct something" which has one pointer.
It is possible to use API defined in include/linux/list.h ,
but to reduce memory usage, I dare not use these API.
Singly-linked list's rule in TOMOYO Linux is quite simple,
"ptr->next is NULL if the last element" and "non-NULL if not".

Regards.

