Return-Path: <linux-kernel-owner+w=401wt.eu-S1762139AbYARQKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762139AbYARQKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757611AbYARQKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:10:44 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56946 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758080AbYARQKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:10:43 -0500
Date: Fri, 18 Jan 2008 08:10:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Schwartz <davids@webmaster.com>
cc: Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       clameter@sgi.com, penberg@cs.helsinki.fi
Subject: RE: Why is the kfree() argument const?
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKKEKDJJAC.davids@webmaster.com>
Message-ID: <alpine.LFD.1.00.0801180754050.2957@woody.linux-foundation.org>
References: <MDEHLPKNGKAHNMBLJOLKKEKDJJAC.davids@webmaster.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Jan 2008, David Schwartz wrote:
> 
> Nonsense. The 'kfree' function *destroys* the object pointer to by the
> pointer. How can you describe that as not doing anything to the object?

Here's an idea. Think it through. 

Why don't we need write permissions to a file to unlink it?

Here's a hint: because unlinking doesn't *write* to it. In fact, it 
doesn't read from it either. It doesn't do any access at all to that 
object, it just *removes* it.

Is the file gone after you unlink it? Yes (modulo refcounting for aliasing 
"pointers" aka filenames, but that's the same for any memory manager - 
malloc/free just doesn't have any, so you could think of it as a 
non-hardlinking filesystem).

So you're the one who are speaking nonsense. Making something "not exist" 
is not at all the same thing as accessing it for a write (or a read). It 
is a metadata operation that doesn't conceptually change the data in any 
way, shape or form - it just makes it go away.

And btw, exactly as with kfree(), a unlink() may well do something like 
"disk scrubbing" for security purposes, or cancel pending writes to the 
backing store. But even though it may write (or, by undoing a pending 
write, effectively "change the state") to the disk sectors that used to 
contain the file data, ONLY AN IDIOT would call it "writing to the file". 
Because "the file" is gone. Writing to the place where the file used to be 
is a different thing.

So give it up. You're wrong. Freeing a memory area is not "writing to it" 
or accessing it in *any* manner, it's an operation on another level 
entirely.

			Linus
