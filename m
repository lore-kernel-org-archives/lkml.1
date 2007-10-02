Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbXJBNHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbXJBNHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 09:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbXJBNHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 09:07:25 -0400
Received: from namei.org ([69.55.235.186]:51503 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752958AbXJBNHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 09:07:24 -0400
Date: Tue, 2 Oct 2007 06:07:08 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
In-Reply-To: <200710022144.BFF09817.VFFOOJLSFHtQMO@I-love.SAKURA.ne.jp>
Message-ID: <Xine.LNX.4.64.0710020557170.21841@us.intercode.com.au>
References: <4701F285.5000206@nttdata.co.jp> <4701F419.8080103@nttdata.co.jp>
 <Xine.LNX.4.64.0710020355260.6760@us.intercode.com.au>
 <200710022144.BFF09817.VFFOOJLSFHtQMO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007, Tetsuo Handa wrote:

> Hello.
> 
> Thank you for your comment.
> 
> James Morris wrote:
> > Why do you need to avoid spinlocks for these manipulations?
> 
> I don't need to use spinlocks here.
> What I need to do here is avoid read/write reordering,
> so mb() will be appropriate here.
> 
> struct something {
>   struct something *next;
>   void *data;
> };
> 
> struct something *prev_ptr = ...;
> struct something *new_ptr = kmalloc(sizeof(*new_ptr), GFP_KERNEL);
> new_ptr->next = NULL;
> new_ptr->data = some_value;
> mb();
> prev_ptr->next = new_ptr;

You're introducing a custom API, which is open-coded repeatedly throughout 
your module.

All linked lists (at least, new ones) must use the standard kernel list
API.

> Performance is not critical because this mb() is called
> only when appending new entry to the singly-linked list.

Most of these uses appear to be slow path or nested inside other locks, 
while overall, performance is likely to be dominated by your string 
matching and permission checking.  Use of mb(), which is typically 
considered less understandable, in this case does not appear to be 
justified vs. normal locking, and you also need to use the standard list 
API.  If performance really is an issue, then consider RCU.


- James
-- 
James Morris
<jmorris@namei.org>
