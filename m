Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbYAQV0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbYAQV0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbYAQVZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:25:55 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48482 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999AbYAQVZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:25:54 -0500
Date: Thu, 17 Jan 2008 13:25:39 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Schwartz <davids@webmaster.com>
cc: Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       clameter@sgi.com, penberg@cs.helsinki.fi
Subject: RE: Why is the kfree() argument const?
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKIEGIJJAC.davids@webmaster.com>
Message-ID: <alpine.LFD.1.00.0801171316390.14959@woody.linux-foundation.org>
References: <MDEHLPKNGKAHNMBLJOLKIEGIJJAC.davids@webmaster.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Jan 2008, David Schwartz wrote:
> 
> Which does change the thing the pointer points to. It goes from being a
> valid object to not existing.

No. It's the *pointer* that is no longer valid.

There's definitely a difference between "exists and is changed" and 
"doesn't exist any more".

> How is ceasing to exist not a change?

It's not a change to the data behind it, it's a change to the *metadata*. 
Which is somethign that "const" doesn't talk about at all.

> >    Why? Because we want the types to be as tight as possible, and normal 
> >    code should need as few casts as possible.
>  
> Right, and that's why you are wrong.

No, it's why I'm right.

"kmalloc/kfree" (or any memory manager) by definition has to play games 
with pointers and do things like cast them. But the users shouldn't need 
to, not for something like this.

> No, it's both correct and useful. This code is the exception to a rule. The
> rule is that the object remain unchanged and this violates that rule.

No. 

You are continuing to make the mistake that you think that "const" means 
that the memory behind the pointer is not going to change.

Why do you make that mistake, when it is PROVABLY NOT TRUE!

Try this trivial program:

	int main(int argc, char **argv)
	{
	        int i;
	        const int *c;
	
	        i = 5;
	        c = &i;
	        i = 10;
	        return *c;
	}

and realize that according to the C rules, if it returns anything but 10, 
the compiler is *buggy*.

The fact is, that in spite of us having a "const int *", the data behind 
that pointer may change.

So it doesn't matter ONE WHIT if you pass in a "const *" to "kfree()": it 
does not guarantee that the data doesn't change, because the object you 
point to has other pointers pointing to it.

This isn't worth discussing. It's really simple: a conforming program 
CANNOT POSSIBLY TELL whether "kfree()" modified the data or not. As such, 
AS FAR AS THE PROGRAM IS CONCERNED, kfree() takes a const pointer, and the 
rule that "if it can be considered const, it should be marked const" comes 
and says that kfree() should take a const pointer.

In other words - anythign that could ever disagree with "const *" is BY 
DEFINITION buggy.

It really is that simple. 

		Linus
