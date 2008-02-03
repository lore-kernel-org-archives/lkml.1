Return-Path: <linux-kernel-owner+w=401wt.eu-S935340AbYBCGzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935340AbYBCGzf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 01:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbYBCGz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 01:55:26 -0500
Received: from smtp1.cc.lut.fi ([157.24.2.30]:57117 "EHLO smtp1.cc.lut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbYBCGzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 01:55:25 -0500
Date: Sun, 3 Feb 2008 08:55:22 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, linux-kernel@vger.kernel.org,
       Jan Beulich <jbeulich@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Pavel Roskin <proski@gnu.org>,
       pq@iki.fi
Subject: Re: [PATCH v2] x86: Add a list for custom page fault handlers.
Message-ID: <20080203085522.2b63e15b@daedalus.pq.iki.fi>
In-Reply-To: <20080131081507.5edcde10@laptopd505.fenrus.org>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
	<1201660102.8837.9.camel@brick>
	<1201660453.8837.13.camel@brick>
	<20080130200827.322c4f7d@daedalus.pq.iki.fi>
	<20080131150746.GB11996@elte.hu>
	<20080131180253.6c007852@daedalus.pq.iki.fi>
	<20080131081507.5edcde10@laptopd505.fenrus.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 08:15:07 -0800
Arjan van de Ven <arjan@infradead.org> wrote:

> On Thu, 31 Jan 2008 18:02:53 +0200
> Pekka Paalanen <pq@iki.fi> wrote:
> > 
> > Very well, first the revised custom page fault handler patch.
> > Changes since the previous submit:
> > - use spin_lock_irqsave instead of spin_lock
> > - Harvey Harrison's clean-up with the #ifdefs
> > - handler call site moved earlier
> > - remove sync RCU call

> it's overhead that's rarely used, and worse, it suffers from the LSM disease:
> it's a hook without visibility into the callers. Esp if there's only 1 user, a direct call
> is not only faster, it also shows you what is going on when you're reading the code.
> THe page fault stuff is tricky enough as it is without any "call arbitrary thing" hooks into
> it

I understand your point.

> > This is most convinient for mmiotrace as it is meant to be a module.
> 
> that's not per se mutually exclusive, there's other cases like this already
> (but even then, I don't want to go through hoops to make mmiotracing a module;
> for me I can totally see it becoming a full mature member of the kernel, and if
> that means a few things have to be changed in the normal kernel, or infrastructure
> added, I'm totally ok with that)

I have two reasons why I'd like to let it be a module:
- it's "broken", the relay buffers are cleared on module unload
- it's a lot easier to push updated version for testing to people

Ok, the first one is just a silly excuse, but the second one is to
avoid forcing non-developer users to patch their kernels. This is a
much needed tool for the Nouveau project even in it's current form.

> > I'm also using this as an excuse to let other people to get into the
> > page fault handler with their out-of-tree-today modules.
> 
> this is exactly the point.. it becomes a totally opaque thing, a random hook.

And this was the third reason I wanted a module, but I understand this
is an unacceptable justification.

What are these "othes cases" I could look at as an example of a hook,
that is meant for a single specific module? I do not understand what
could prevent out-of-tree modules from using the hook if my module can
use it (and my module is not using it at the same time).

What is the verdict?
Will the custom page fault handler patch v2 get merged as it is,
do I need to modify it (how?), do I need to rewrite it based on
some example (which?), or do I have to drop the whole idea of
mmiotrace being kernel module and make it work as built-in?

In the case of making it a built-in, I do not think I have any
chance to get it done for 2.6.25.

There's one more option. I could make kmmio.c things as builtin,
and keep the mmio-mod.c as the module. This is how things were in
the very beginning of mmiotrace, when the page fault notifiers did
not exist. This could be an acceptable compromise, no?
But I don't think I will get that ready for 2.6.25, either.

What about merging the custom page fault handler patch now, and
removing it for 2.6.26?

Looks like Beulich and Roskin will be disappointed anyway. They
were hoping for a usable page fault hook.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
