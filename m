Return-Path: <linux-kernel-owner+w=401wt.eu-S1760342AbYARPVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760342AbYARPVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 10:21:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbYARPU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 10:20:56 -0500
Received: from orion2.pixelized.ch ([195.190.190.13]:50172 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbYARPUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 10:20:55 -0500
Message-ID: <4790C3CB.7020602@cateee.net>
Date: Fri, 18 Jan 2008 16:20:43 +0100
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: ecolbus@voila.fr
CC: linux-kernel@vger.kernel.org
Subject: Re: Why is the kfree() argument const?
References: <303169.30591200660321083.JavaMail.www@wwinf4620>
In-Reply-To: <303169.30591200660321083.JavaMail.www@wwinf4620>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ecolbus@voila.fr wrote:
> Giacomo Catenazzi wrote:
> 
>> const No writes through this lvalue. In the absence of this qualifier, writes may occur
>> through this lvalue.
>>
>> volatile No cacheing through this lvalue: each operation in the abstract semantics must
>> be performed (that is, no cacheing assumptions may be made, since the location
>> is not guaranteed to contain any previous value). In the absence of this qualifier,
>> the contents of the designated location may be assumed to be unchanged except
>> for possible aliasing.
> 
> Well, I'm still wondering if there is not something dangerous or weird about
> declaring the argument of kfree() to be const... 

It should be only cosmetic thing (and few warnings in some
not yet identified cases).


> Since the content of the referenced object is unlikely to be declared volatile, the
> compiler should be allowed to assume that its content was not changed, except
> for possible aliasing. But what happens if the compiler can also prove there is 
> no aliasing? In that case, he should be allowed to assume that the content
> pointed to was not modified at all, right?

I doesn't follow it. Anyway C has the "as-if" rule, which it mean:
the compiler could optimize as far the result doesn't change
(time are not issues, and result could change if a valid compiler
could give the same results).  So a very smart compiler (which
should compile all units at the same time) could do good things
without need of explicit register, static (with some exceptions),
const, volatile (if it very smart it know about system, signals,
and it can set "volatile" on need), restrict, ...

> Fortunately, kmalloc is not declared with attribute malloc in the kernel,
> so there should be no problem, but if it were (and, actually, I've not found
> why it wasn't), the compiler would be able to tell that *s1 *cannot* 
> be aliased, and therefore decide to move val = s1->i *after* having
> called kfree(). In that case, we would clearly have a bug...

IIRC kmalloc(0) return an alias (but not so relevant in this
discussion).

Hmm. C is used not to do much optimization. One thing to remember
is that function could have a lot of side effects, so compiler
will/should never optimize in your way (but if compiler know exactly
how kfree work internally).

C "const" is a lot weaker to C++ "const".

BTW, I doesn't like const in kfree, but I was talking about
weak "const" in C.


> So, although this should currently work, code which breaks if you do
> a legitimate modification somewere else looks quite dangerous to me.

for sure!  But C is anal in: "users know better than compiler on what
they want to do", so compiler cannot do big optimizations C, without
breaking C rules, and used can do nasty things playing with hidden
pointers.

ciao
	cate

PS: use lkml rule: "do CC: to all relevant people!"

