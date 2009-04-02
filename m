Return-Path: <linux-kernel-owner+w=401wt.eu-S1765466AbZDBJ4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765466AbZDBJ4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757495AbZDBJ40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:56:26 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:44644 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976AbZDBJ4Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:56:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=umFjn3JBQ9tMKIkG1OPsroCpzz7xEWAual3UQ3DjPZKnzTDu2KwgU6C8X8GM8etYyp
         zjULfE10uKlL+Qv50E+a9qfpzLnvpJdlw7FynUo58P93XdZpL37RuJZbj6nf2lBag1AY
         vmDyQOEhibMqkJZzcHQyK/Vec5FMEn1IitmLg=
MIME-Version: 1.0
In-Reply-To: <1236851912.5090.93.camel@laptop>
References: <8c5a844a0903110255q45b7cdf4u1453ce40d495ee2c@mail.gmail.com>
	 <1236851912.5090.93.camel@laptop>
Date: Thu, 2 Apr 2009 12:56:22 +0300
Message-ID: <8c5a844a0904020256r3e073d01o1991e5111127ce42@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: use list.h for vma list
From: Daniel Lowengrub <lowdanie@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been thinking for a while about the best way to implement Nick's
suggestions.  Specifically, how to implement vma_next without all the
extra conditions.  The main problem is that for vma_next to return a
vma and not a list_head it has to be know if vma->vm_list.next is
inside a vma or a mm so that it can call list_entry on it.

In the current code, something like next=vma->next runs the risk of
having next=NULL so the next pointer is usually used in a if statement
like:
vm_area_struct *next=vma->next;
if(next&&<check stuff with next>){<do stuff to next>}

What I want to do is to make vma_next return a list_head - without
calling list_entry, and a seperate function vma_entry return the
entry.  This way, vma_entry would be a simple wrapper for
vma->vm_list.next.  Then the above code snippet would read:
vm_area_struct *next;
list_head next_list =vma_next(vma);
if(in_list(mm, next_list) && next=vma_entry(next_list) && <check stuff
with next>)
{<do stuff to next>}

where in_list checks if next_list==mm->mm_vmas.
Or there could be a function called check_next which would do the
first two checks together so that we'd be able to write:

vm_area_struct *next;
if(check_next(vma, next) && <check stuff with next>){<do stuff to next>}

This does away with the redundant conditions that bothered Nick - the
check for the end of the list in vma_entry which returns NULL, and
then the check for next==NULL in the if statements.

This would lead to further optimizations based on the fact that we
could now pass around list_heads instead of vma's and only call
vma_entry after verifying that the list_head is really in the list and
not the mm_vmas list_head.  This verification would be done in the
places that the current code checks for vma==NULL - as in the example
above.

What do you think?
Daniel


On Thu, Mar 12, 2009 at 12:58 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> On Wed, 2009-03-11 at 11:55 +0200, Daniel Lowengrub wrote:
> > Use the linked list defined list.h for the list of vmas that's stored
> > in the mm_struct structure.  Wrapper functions "vma_next" and
> > "vma_prev" are also implemented.  Functions that operate on more than
> > one vma are now given a list of vmas as input.
> >
> > Signed-off-by: Daniel Lowengrub
>
> While this is the approach I've taken for a patch I'm working on, a
> better solution has come up if you keep the RB tree (I don't).
>
> It is, however, even more invasive than the this one ;-)
>
> Wolfram has been working on implementing a threaded RB-tree. This means
> rb_prev() and rb_next() will be O(1) operations, so you could simply use
> those to iterate the vmas.
>
> The only draw-back is that each and every RB-tree user in the kernel
> needs to be adapted because its not quite possible to maintain the
> current API.
>
> I was planning to help Wolfram do that, but I'm utterly swamped atm. :-(
>
> What needs to be done is introduce rb_left(), rb_right() and rb_node()
> helpers that for now look like:
>
> static inline struct rb_node *rb_left(struct rb_node *n)
> {
>        return n->rb_left;
> }
>
> static inline struct rb_node *rb_right(struct rb_node *n)
> {
>        return n->rb_right;
> }
>
> static inline struct rb_node *rb_node(struct rb_node *n)
> {
>        return n;
> }
>
> We need these because the left and right child pointers will be
> over-loaded with threading information.
>
> After that we can flip the implementation of the RB-tree.
>
>
>
>
