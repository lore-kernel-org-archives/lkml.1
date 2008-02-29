Return-Path: <linux-kernel-owner+w=401wt.eu-S933117AbYB2Q1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117AbYB2Q1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 11:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932669AbYB2Q1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 11:27:12 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932563AbYB2Q1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 11:27:10 -0500
Date: Fri, 29 Feb 2008 08:26:14 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 ia32 syscall restart fix
In-Reply-To: <20080229155207.GC27248@elte.hu>
Message-ID: <alpine.LFD.1.00.0802290814320.17889@woody.linux-foundation.org>
References: <20080229035707.EAE862700FD@magilla.localdomain> <20080229155207.GC27248@elte.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Feb 2008, Ingo Molnar wrote:
> 
> * Roland McGrath <roland@redhat.com> wrote:
> 
> > The code to restart syscalls after signals depends on checking for a 
> > negative orig_ax, and for particular negative -ERESTART* values in ax. 
> > These fields are 64 bits and for a 32-bit task they get zero-extended. 
> > The syscall restart behavior is lost, a regression from a native 
> > 32-bit kernel and from 64-bit tasks' behavior.  This patch fixes the 
> > problem by doing sign-extension where it matters.  For orig_ax, the 
> > only time the value should be -1 but winds up as 0x0ffffffff is via a 
> > 32-bit ptrace call.  So the patch changes ptrace to sign-extend the 
> > 32-bit orig_eax value when it's stored; it doesn't change the checks 
> > on orig_ax, though it uses the new current_syscall() inline to better 
> > document the subtle importance of the used of signedness there.  The 
> > ax value is stored a lot of ways and it seems hard to get them all 
> > sign-extended at their origins.  So for that, we use the 
> > current_syscall_ret() to sign-extend it only for 32-bit tasks at the 
> > time of the -ERESTART* comparisons.
> 
> thanks, applied.

Btw, can we please try to keep commit log messages readable?

The above "blob of text" could/should have more structure than being just 
one big block, and could have been structured as a few shorter paragraphs 
to make it easier to read: (1) problem description (2) patch description 
and (3) explanation of why patch was done it was done.

I don't know about you guys, but I read a *lot* of emails (and commit 
messages), and I hate seeing big blobs of text without structure. Give it 
a few breaks to make it easier to read, like just making new paragraphs, 
ie something like:

> The code to restart syscalls after signals depends on checking for a 
> negative orig_ax, and for particular negative -ERESTART* values in ax. 
> These fields are 64 bits and for a 32-bit task they get zero-extended. 
> The syscall restart behavior is lost, a regression from a native 32-bit 
> kernel and from 64-bit tasks' behavior.
>
> This patch fixes the problem by doing sign-extension where it matters.  
> For orig_ax, the only time the value should be -1 but winds up as 
> 0x0ffffffff is via a 32-bit ptrace call.  So the patch changes ptrace to 
> sign-extend the 32-bit orig_eax value when it's stored; it doesn't 
> change the checks on orig_ax, though it uses the new current_syscall() 
> inline to better document the subtle importance of the used of 
> signedness there.
>
> The ax value is stored a lot of ways and it seems hard to get them all 
> sign-extended at their origins.  So for that, we use the 
> current_syscall_ret() to sign-extend it only for 32-bit tasks at the 
> time of the -ERESTART* comparisons.

and now you have a bit of a breather space and some visual cues for whare 
you are in the text.

Yeah, maybe it's just me, but I like my whitespace. Ihaveareallyhardtime
readingtextthatdoesn'thavethepropermarkersforwhereconceptsstartandbegin, 
andthatreallydoesincludetheverticalwhitespacetoo.

Now, the only reason I mention this is that normally I would probably just 
have fixed this up myself without even a comment (because it's such a tiny 
detail that it's not not worth one), but when Ingo merges it I'll now get 
it through git and it will be fixed.

			Linus "yeah, I can be anal" Torvalds
