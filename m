Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbYICMLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbYICMLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 08:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbYICMLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 08:11:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbYICMLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 08:11:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] utrace core
In-Reply-To: Alexey Dobriyan's message of  Thursday, 28 August 2008 00:04:13 +0400 <20080827200413.GA31324@x200.localdomain>
References: <20080826220102.89635154233@magilla.localdomain>
	<20080826220157.397C7154233@magilla.localdomain>
	<20080827200413.GA31324@x200.localdomain>
X-Zippy-Says: PEGGY FLEMING is stealing BASKET BALLS to feed the babies in VERMONT.
Message-Id: <20080903121103.232E4154228@magilla.localdomain>
Date: Wed,  3 Sep 2008 05:11:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. UTRACE_ATTACH_MATCH_DATA is not used.

I don't understand this comment.  The patch adds a new API, not users of
the API.  That flag is implemented and documented.

> 2. s/utrace_attached_engine/utrace_engine/g
> 
>    Engine which is not attached is either just allocated or scheduled
>    for freeing

In the way I've talked about things since the beginning, and probably in
some email and maybe some of the documentation text, I've used "a tracing
engine" to mean the whole coordinated body of code.  (There is no data
structure in the utrace API that corresponds to this, it's just a way of
talking about the "user of utrace" code.)  So you might talk about having
your "engine" attach to many tasks.  This is what I had in mind when I
first made it 'struct utrace_attached_engine' for the API object that's
about one attachment.

But I won't quibble about names.  I am happy to change any of the names to
whatever the consensus prefers.

> 3. get_utrace_lock() is funny.
> 
>    From name one should get valid struct utrace or -E depending only on
>    task, why engine matters is a mystery.

This "mystery" is addressed in the comments and the documentation.
(Comments above the function says exactly what it does.)  Details about
why we do that are in manual section called "Engine and task pointers"
(in the file added by the patch, Documentation/DocBook/utrace.tmpl).  
If you don't like to read the XML or wait for 'make htmldocs', I've put
a copy of the formatted tree at:
	http://people.redhat.com/roland/utrace/DocBook/

> 4. subsys_initcall
> 
>    Just use module_init() or comment why it's needed.

Since I never found much documentation about these macros, and it's not
a module, that looked like the one to use based on the other uses in the
source.  If module_init is the generic one to use in nonmodule code,
that's fine by me.

> 5. Dummy in examiner -- not used (of course!)

(Of course, that's why it's called that!)  I found I had to add that or
the kerneldoc magic would freak out.  The type name is used by users of
the API, so I wanted to have it documented with description text, but
its contents are all private to the utrace implementation.  When I had
no magic /* public: */ comment or no fields declared after it, the 'make
htmldocs' et al process would barf.

> Engine grew a refcount.
> 
> Was it added to fix some bug?
>
> Old utrace git doesn't have this, new utrace git has only two
> posted patches, so asking.

I said this is a substantially different API from the first utrace
prototype, and I was not lying.  The implementation didn't follow from
the same tree's history, because it took an entirely different merging
approach.  In the new effort I've been doing since 2.6.25, I have only
been preparing new versions of patches for posting.  (My current GIT
trees are updated using git-rebase.)

In the first utrace prototype, every caller of the utrace API had to
understand some things about RCU and/or some special rules about narrow
guarantees.  It was too easy to write code that wasn't robust when tasks
died or engines detached.  This was a failure at one of the main goals
of utrace: to make it easier not to write bugs.

The "Tear-down Races" manual section talks about everything you have to
do to handle asynchronous changes robustly.  It takes some care, but the
rules to follow are pretty straightforward and don't constrain the
calling code much (e.g. it can block).  It's easy to write sloppy code
that leaks engine refs.  But it's not especially easy to have sloppy
bugs really louse things up.


Thanks,
Roland
