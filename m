Return-Path: <linux-kernel-owner+w=401wt.eu-S933502AbXCOLw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502AbXCOLw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 07:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933504AbXCOLw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 07:52:58 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:64064 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933502AbXCOLw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 07:52:57 -0400
Subject: Re: [PATCH take3 16/20] acpi files switched
From: Steven Rostedt <rostedt@goodmis.org>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <200703150236.43214.lenb@kernel.org>
References: <20070315051337.488091591@goodmis.org>
	 <20070315051532.400874263@goodmis.org> <200703150236.43214.lenb@kernel.org>
Content-Type: text/plain
Date: Thu, 15 Mar 2007 07:51:02 -0400
Message-Id: <1173959462.7922.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-15 at 02:36 -0400, Len Brown wrote:
> On Thursday 15 March 2007 01:13, Steven Rostedt wrote:
> > Moved the shared files that were in arch/i386/kernel/acpi to the common
> > area.
> 
> When I do a "make cscope" on an i386 or an x86_64 box,
> will it find these files in the common area?

At the moment, "no".

With this quick hack, it will work, and I'm sure someone can come up
with a better idea.

Currently, the "make cscope" and "make TAGS" only get the files that are
physically located in the arch. As I mentioned to Ingo, it took me an
hour when I first looked for early_printk. Since it wasn't in the TAGS
and my own search scripts were also arch specific.  I was working in
i386, and early_printk is not.

But here's a hack that will let both x86_64 and i386 see the same code
in the common area for a "make cscope" or "make TAGS".

-- Steve

diff --git a/Makefile b/Makefile
index 6393738..974c05b 100644
--- a/Makefile
+++ b/Makefile
@@ -1265,8 +1265,16 @@ endif
 
 ifeq ($(ALLSOURCE_ARCHS),)
 ifeq ($(ARCH),um)
+ALLSOURCE_ARCHS := $(ARCH)
 ALLINCLUDE_ARCHS := $(ARCH) $(SUBARCH)
+else ifeq ($(ARCH),x86_64)
+ALLSOURCE_ARCHS := $(ARCH) x86
+ALLINCLUDE_ARCHS := $(ARCH) x86
+else ifeq ($(ARCH),i386)
+ALLSOURCE_ARCHS := $(ARCH) x86
+ALLINCLUDE_ARCHS := $(ARCH) x86
 else
+ALLSOURCE_ARCHS := $(ARCH)
 ALLINCLUDE_ARCHS := $(ARCH)
 endif
 else
@@ -1274,8 +1282,6 @@ else
 ALLINCLUDE_ARCHS := $(ALLSOURCE_ARCHS)
 endif
 
-ALLSOURCE_ARCHS := $(ARCH)
-
 define find-sources
         ( find $(__srctree) $(RCS_FIND_IGNORE) \
 	       \( -name include -o -name arch \) -prune -o \


