Return-Path: <linux-kernel-owner+w=401wt.eu-S1760265AbYARNap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265AbYARNap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757594AbYARNah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:30:37 -0500
Received: from smtp1.voila.fr ([193.252.22.174]:23272 "EHLO smtp1.voila.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757016AbYARNag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:30:36 -0500
X-Greylist: delayed 2712 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jan 2008 08:30:35 EST
X-ME-UUID: 20080118124521909.162D6D800081@mwinf4007.voila.fr
From: ecolbus@voila.fr
Reply-To: ecolbus@voila.fr
To: linux-kernel@vger.kernel.org
Message-ID: <303169.30591200660321083.JavaMail.www@wwinf4620>
Subject: Re: Why is the kfree() argument const?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [160.92.7.68]
X-Wum-Nature: EMAIL-NATURE
X-WUM-FROM: |~|
X-WUM-TO: |~|
X-WUM-REPLYTO: |~|
Date: Fri, 18 Jan 2008 13:45:21 +0100 (CET)
X-me-spamlevel: not-spam
X-me-spamrating: 8.938718
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giacomo Catenazzi wrote:

> const No writes through this lvalue. In the absence of this qualifier, writes may occur
> through this lvalue.
> 
> volatile No cacheing through this lvalue: each operation in the abstract semantics must
> be performed (that is, no cacheing assumptions may be made, since the location
> is not guaranteed to contain any previous value). In the absence of this qualifier,
> the contents of the designated location may be assumed to be unchanged except
> for possible aliasing.

Well, I'm still wondering if there is not something dangerous or weird about
declaring the argument of kfree() to be const... 

Since the content of the referenced object is unlikely to be declared volatile, the
compiler should be allowed to assume that its content was not changed, except
for possible aliasing. But what happens if the compiler can also prove there is 
no aliasing? In that case, he should be allowed to assume that the content
pointed to was not modified at all, right?

Consider the following code : 

struct something {
        int i;
};

...

struct something *s1, *s2;
extern int val;

s1 = kmalloc(sizeof(*s1), SOME_FLAGS);
if (s1 == NULL)
        return -ENOMEM;

s1->i = do_something();
do_some_other_thing();

s2 = kmalloc(sizeof(*s2), SOME_FLAGS);
if (s2 == NULL){
        val = s1->i; /* XXX */
        kfree(s1);
        return -ENOMEM;
}

Fortunately, kmalloc is not declared with attribute malloc in the kernel,
so there should be no problem, but if it were (and, actually, I've not found
why it wasn't), the compiler would be able to tell that *s1 *cannot* 
be aliased, and therefore decide to move val = s1->i *after* having
called kfree(). In that case, we would clearly have a bug...

So, although this should currently work, code which breaks if you do
a legitimate modification somewere else looks quite dangerous to me.

Or maybe there is a rationale for never declaring kmalloc to have the
attribute malloc in the first place...

Or is there simply something that I still don't understand, Giacomo?

Cheers,

Emmanuel Colbus


