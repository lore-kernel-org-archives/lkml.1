Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbXH1Sgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbXH1Sgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 14:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbXH1SgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 14:36:20 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:44785 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbXH1SgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 14:36:19 -0400
Date: Tue, 28 Aug 2007 20:37:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       Olaf Hering <olh@suse.de>, netdev@vger.kernel.org
Subject: Re: [-mm patch] make types.h usable for non-gcc C parsers
Message-ID: <20070828183739.GA31836@uranus.ravnborg.org>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46CC3B27.10604@googlemail.com> <20070827212743.GN4121@stusta.de> <20070828003704.deed71ae.akpm@linux-foundation.org> <20070828144248.GR26410@stusta.de> <20070828170604.GA31284@uranus.ravnborg.org> <20070828175904.GS26410@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070828175904.GS26410@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 07:59:04PM +0200, Adrian Bunk wrote:
> On Tue, Aug 28, 2007 at 07:06:04PM +0200, Sam Ravnborg wrote:
> > > 
> > > It fixes a bug exposed by a -mm only patch, not by the net tree
> > > (and 2.6.23-rc3-mm1 doesn't contain the net tree at all).
> > > 
> > > > But I'd like a better description, please.  Which "non-gcc parser" are we
> > > > talking about here?  Something under ./scripts/.  Well, please identify it,
> > > > and describe what the problem is, and how the proposed patch will address
> > > > it.
> > > >...
> > > 
> > > It's about parsers like the Sun C compiler and the C parser shipped 
> > > with genksyms.
> > 
> > So it is about two bugs.
> > 1) kbuild (genksyms) fails to generate CRC for some symbols
> > 2) allow userspace to parse the header
> > 
> > As for 2 we already use sed to remove a lot of stuff in our headers
> > so why do we use another approach here?
> 
> This time it's the other way round:
> 
> We need __extension__ only in userspace.
> 
> > As for 1 I will try to teach genksyms to accept __extension__ but
> > it seems leess trivial than I expected (most be fooling myself somehow).
> 
> We anyway need a way to hide __extension__ from non-gcc userspace C 
> compilers, and it can be hidden from genksyms the same way.

OK.
I have anyway added support for __extension__ in genksyms.
See below patch.

Note: To try this patch out do the following in a fresh tree (no generated files):
$ rm scripts/genksyms/*_shipped
$ apply patch
$ make GENERATE_PARSER=1 ...

In kbuild.git the _shipped files are updated but that would just be noise here.

	Sam

>From 26132bc829651acce2f124f78dfea43120e52c31 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Tue, 28 Aug 2007 20:28:55 +0200
Subject: [PATCH] kbuild: __extension__ support in genksyms (fix unknown CRC warning)

Recently the __extension__ keyword has been introduced in the kernel.
Teach genksyms about this keyword so it can generate correct CRC for
exported symbols that uses a symbol marked __extension__.
For now only the typedef variant:

	__extension__ typedef ...

is supported.
Later we may add more variants as needed.

This patch contains the actual source file changes. The
following patch will hold modifications to the generated
files (*_shipped) and only after the second patch the fix
has effect.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/genksyms/keywords.gperf |    1 +
 scripts/genksyms/parse.y        |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/scripts/genksyms/keywords.gperf b/scripts/genksyms/keywords.gperf
index c75e0c8..5ef3733 100644
--- a/scripts/genksyms/keywords.gperf
+++ b/scripts/genksyms/keywords.gperf
@@ -11,6 +11,7 @@ __attribute, ATTRIBUTE_KEYW
 __attribute__, ATTRIBUTE_KEYW
 __const, CONST_KEYW
 __const__, CONST_KEYW
+__extension__, EXTENSION_KEYW
 __inline, INLINE_KEYW
 __inline__, INLINE_KEYW
 __signed, SIGNED_KEYW
diff --git a/scripts/genksyms/parse.y b/scripts/genksyms/parse.y
index ca04c94..408cdf8 100644
--- a/scripts/genksyms/parse.y
+++ b/scripts/genksyms/parse.y
@@ -61,6 +61,7 @@ remove_list(struct string_list **pb, struct string_list **pe)
 %token DOUBLE_KEYW
 %token ENUM_KEYW
 %token EXTERN_KEYW
+%token EXTENSION_KEYW
 %token FLOAT_KEYW
 %token INLINE_KEYW
 %token INT_KEYW
@@ -110,7 +111,9 @@ declaration:
 	;
 
 declaration1:
-	TYPEDEF_KEYW { is_typedef = 1; } simple_declaration
+	EXTENSION_KEYW TYPEDEF_KEYW { is_typedef = 1; } simple_declaration
+		{ $$ = $4; }
+	| TYPEDEF_KEYW { is_typedef = 1; } simple_declaration
 		{ $$ = $3; }
 	| simple_declaration
 	| function_definition
-- 
1.5.1.rc3.2928.g8e573-dirty

