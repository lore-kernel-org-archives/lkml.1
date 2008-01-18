Return-Path: <linux-kernel-owner+w=401wt.eu-S1765025AbYARTKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765025AbYARTKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758860AbYARTKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:10:32 -0500
Received: from smtp1.voila.fr ([193.252.22.174]:2581 "EHLO smtp1.voila.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757124AbYARTKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:10:31 -0500
X-ME-UUID: 20080118191029908.162691C013AD@mwinf4006.voila.fr
From: ecolbus@voila.fr
Reply-To: ecolbus@voila.fr
To: linux-kernel@vger.kernel.org
Cc: "Giacomo A. Catenazzi" <cate@cateee.net>
Message-ID: <19722657.437421200683429036.JavaMail.www@wwinf4614>
Subject: Re: Why is the kfree() argument const?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.44.51.31]
X-Wum-Nature: EMAIL-NATURE
X-WUM-FROM: |~|
X-WUM-TO: |~|
X-WUM-CC: |~|
X-WUM-REPLYTO: |~|
Date: Fri, 18 Jan 2008 20:10:29 +0100 (CET)
X-me-spamlevel: not-spam
X-me-spamrating: 11.589488
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Olivier Galibert wrote:
> On Fri, Jan 18, 2008 at 05:45:49PM +0100, ecolbus@xxxxxxxx wrote:
> > The malloc attribute is exactly about this : giving the compiler the
> > indication that no other pointer aliases this object, allowing for
> > better optimizations.
> 
> If you put a malloc attribute on the allocator and no free attribute
> on the deallocator, you can get bugs indeed. GIGO.
> 
> 
> > Yes. Bad things start to happen when users add wrong indications to
> > the compiler. By adding the "const" indication to kfree(), the programmer
> > wrongly tells that it can optimize reading the values pointed to before or
> > after calling the function (if it is also sure that they cannot be
> > read/written otherwise). Current gcc implementations seem quite
> > conservative in this regard, and don't optimize that much, but what about
> > the future?
> 
> The future should be quite nice because:
> 
> - the compiler can not know that kmalloc does not have an alias to
> the pointer tucked somewhere accessible by other non-inline functions
> (as kfree is), especially since it does have aliases in practice, so
> it cannot prove to "not read/written otherwise" part without the
> malloc attribute
> 
> - if you add the (non-standard C) malloc attribute to kmalloc, then
> you also add the free attribute to kfree which tells the compiler
> that the pointer is invalid after the call, which ensures no
> accesses will be moved after it
> 
> OG.

I completely agree with you here. But, unless this page : 

http://gcc.gnu.org/onlinedocs/gcc/Function-Attributes.html

is not up-to-date anymore, there is no free attribute. Which
is quite logical, actually, as such an attribute would be
equivalent to simply marking the parameter of the function
non-const.

That's what I was alluding to, when speaking of a legitimate
change (adding attribute malloc to kmalloc()) which would break
another part of the kernel. Of course, we can also assume that
nobody would make the error of letting kfree() taking a 
const void* after that, but experience shows that programmers
are very likely to fall into such traps.

(No flame intended on anybody : in my case, I'm actually able
to fall even when there is no trap at all. That's the reason for
spotting such a weird one makes me anxious. Especially since
having kfree() take a non-const argument comes at no runtime
cost.)

Cheers,

Emmanuel


