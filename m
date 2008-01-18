Return-Path: <linux-kernel-owner+w=401wt.eu-S1762462AbYARQqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762462AbYARQqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756965AbYARQpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:45:53 -0500
Received: from smtp1.voila.fr ([193.252.22.174]:64745 "EHLO smtp1.voila.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744AbYARQpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:45:52 -0500
X-ME-UUID: 20080118164549666.A2B697000082@mwinf4019.voila.fr
From: ecolbus@voila.fr
Reply-To: ecolbus@voila.fr
To: "Giacomo A. Catenazzi" <cate@cateee.net>
Cc: linux-kernel@vger.kernel.org
Message-ID: <2895123.436161200674749664.JavaMail.www@wwinf4611>
Subject: Re: Why is the kfree() argument const?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [160.92.7.69]
X-Wum-Nature: EMAIL-NATURE
X-WUM-FROM: |~|
X-WUM-TO: |~|
X-WUM-CC: |~|
X-WUM-REPLYTO: |~|
Date: Fri, 18 Jan 2008 17:45:49 +0100 (CET)
X-me-spamlevel: not-spam
X-me-spamrating: 17.425857
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giacomo A. Catenazzi wrote : 
> ecolbus@voila.fr wrote:
> > Giacomo Catenazzi wrote:
> > 
> >> const No writes through this lvalue. In the absence of this qualifier, writes may occur
> >> through this lvalue.
> >>
> >> volatile No cacheing through this lvalue: each operation in the abstract semantics must
> >> be performed (that is, no cacheing assumptions may be made, since the location
> >> is not guaranteed to contain any previous value). In the absence of this qualifier,
> >> the contents of the designated location may be assumed to be unchanged except
> >> for possible aliasing.
> > 
> > Well, I'm still wondering if there is not something dangerous or weird about
> > declaring the argument of kfree() to be const... 
> 
> It should be only cosmetic thing (and few warnings in some
> not yet identified cases).
> 
> 
> > Since the content of the referenced object is unlikely to be declared volatile, the
> > compiler should be allowed to assume that its content was not changed, except
> > for possible aliasing. But what happens if the compiler can also prove there is 
> > no aliasing? In that case, he should be allowed to assume that the content
> > pointed to was not modified at all, right?
> 
> I doesn't follow it. Anyway C has the "as-if" rule, which it mean:
> the compiler could optimize as far the result doesn't change
> (time are not issues, and result could change if a valid compiler
> could give the same results). 

As long as the code is correct, yes. If the code is wrong in the first
place (like adding or removing a required type qualifier), the compiler
optimization can break your code. I'm arguing that having at the same
time kfree() declared as taking a const pointer and kmalloc() with
attribute malloc would be incorrect.

Let me rephrase my argumentation : if the compiler knows a) that a
variable is never modified through a given lvalue (because this pointer
is declared as const), and b) that it is also never modified through any
other lvalues (because it *knows* that no pointer can point to it, and it
can see all other uses), THEN it knows it is not modified at all.

And it can use this knowledge to do all optimizations it wants.

The malloc attribute is exactly about this : giving the compiler the
indication that no other pointer aliases this object, allowing for
better optimizations.

> 
> > Fortunately, kmalloc is not declared with attribute malloc in the kernel,
> > so there should be no problem, but if it were (and, actually, I've not found
> > why it wasn't), the compiler would be able to tell that *s1 *cannot* 
> > be aliased, and therefore decide to move val = s1->i *after* having
> > called kfree(). In that case, we would clearly have a bug...
> 
> IIRC kmalloc(0) return an alias (but not so relevant in this
> discussion).
> 
> Hmm. C is used not to do much optimization. One thing to remember
> is that function could have a lot of side effects, so compiler
> will/should never optimize in your way (but if compiler know exactly
> how kfree work internally).
> 
> C "const" is a lot weaker to C++ "const".
> 
> BTW, I doesn't like const in kfree, but I was talking about
> weak "const" in C.
> 
> 
> > So, although this should currently work, code which breaks if you do
> > a legitimate modification somewere else looks quite dangerous to me.
> 
> for sure!  But C is anal in: "users know better than compiler on what
> they want to do", so compiler cannot do big optimizations C, without
> breaking C rules, and used can do nasty things playing with hidden
> pointers.

Yes. Bad things start to happen when users add wrong indications to
the compiler. By adding the "const" indication to kfree(), the programmer
wrongly tells that it can optimize reading the values pointed to before or
after calling the function (if it is also sure that they cannot be
read/written otherwise). Current gcc implementations seem quite
conservative in this regard, and don't optimize that much, but what about
the future?

Cheers,

Emmanuel Colbus

> 
> PS: use lkml rule: "do CC: to all relevant people!"

Sorry, actually, I'm not subscribed myself, I was just
following this discussion through hypermail.



