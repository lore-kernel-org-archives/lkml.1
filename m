Return-Path: <linux-kernel-owner+w=401wt.eu-S1760162AbYARNyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162AbYARNyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758226AbYARNyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:54:00 -0500
Received: from main.gmane.org ([80.91.229.2]:42185 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758882AbYARNx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:53:59 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andy Lutomirski <luto@myrealbox.com>
Subject: Re: Why is the kfree() argument const?
Date: Fri, 18 Jan 2008 08:53:44 -0500
Message-ID: <4790AF68.8040403@myrealbox.com>
References: <MDEHLPKNGKAHNMBLJOLKOEIPJJAC.davids@webmaster.com> <alpine.LFD.1.00.0801171710160.2957@woody.linux-foundation.org> <47905A95.4030500@cateee.net> <47906133.6010301@cateee.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Schwartz <davids@webmaster.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       clameter@sgi.com, penberg@cs.helsinki.fi
X-Gmane-NNTP-Posting-Host: sydneypacific-one-fifty-nine.mit.edu
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
In-Reply-To: <47906133.6010301@cateee.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giacomo Catenazzi wrote:
> And to demostrate that Linus is not the only person
> with this view, I copy some paragraphs from C99 rationale
> (you can find standard, rationale and other documents
> in http://clc-wiki.net/wiki/C_standardisation:ISO )
> 
> Page 75 of C99 rationale:
> 
> Type qualifiers were introduced in part to provide greater control over optimization. Several
> important optimization techniques are based on the principle of "cacheing": under certain
> circumstances the compiler can remember the last value accessed (read or written) from a
> location, and use this retained value the next time that location is read. (The memory, or
> "cache", is typically a hardware register.) If this memory is a machine register, for instance, the
> code can be smaller and faster using the register rather than accessing external memory.
> The basic qualifiers can be characterized by the restrictions they impose on access and
> cacheing:
> 
> const          No writes through this lvalue. In the absence of this qualifier, writes may occur
>                through this lvalue.
> 

I'd say this implies the exact opposite.  It almost sounds like the 
compiler is free to change:

void foo(const int *x);
foo(x);
printf("%d", x);

to:

void foo(const int *x);
printf("%d", x);
foo(x);

especially if it can prove that the pointer to x doesn't otherwise 
escape or that foo doesn't call anything that could see the pointer (and 
given that gcc has special magical markings for malloc, one way this 
could be "proven" is to have x be some freshly malloced object.

If foo is kfree, then the above transformation is clearly invalid.

(Note that this isn't just a problem for optimizers -- a programmer 
might expect that passing a pointer to a function that takes a const 
pointer argument does not, in and of itself, change the pointed-to 
value.  Given that const certainly does not mean that no one else 
changes the object, I'm not sure what else it could mean.  kfree does 
not have either property, so I'm don't think it makes sense for it to 
take a const argument.)

--Andy

> volatile       No cacheing through this lvalue: each operation in the abstract semantics must
>                be performed (that is, no cacheing assumptions may be made, since the location
>                is not guaranteed to contain any previous value). In the absence of this qualifier,
>                the contents of the designated location may be assumed to be unchanged except
>                for possible aliasing.
> 
> restrict       Objects referenced through a restrict-qualified pointer have a special
>                association with that pointer. All references to that object must directly or
>                indirectly use the value of this pointer. In the absence of this qualifier, other
>                pointers can alias this object. Cacheing the value in an object designated through
>                a restrict-qualified pointer is safe at the beginning of the block in which the
>                pointer is declared, because no pre-existing aliases may also be used to reference
>                that object. The cached value must be restored to the object by the end of the
>                block, where pre-existing aliases again become available. New aliases may be
>                formed within the block, but these must all depend on the value of the
>                restrict-qualified pointer, so that they can be identified and adjusted to refer
>                to the cached value. For a restrict-qualified pointer at file scope, the block
>                is the body of main.
> 
> ciao
> 	cate
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

