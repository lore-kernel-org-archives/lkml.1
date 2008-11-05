Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbYKETQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbYKETQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbYKETQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:16:41 -0500
Received: from lazybastard.de ([212.112.238.170]:51273 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053AbYKETQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:16:40 -0500
Date: Wed, 5 Nov 2008 20:16:29 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Always include <linux/types.h>
Message-ID: <20081105191628.GC6561@logfs.org>
References: <491073BB.4000900@panasas.com> <1225817069-5969-1-git-send-email-bharrosh@panasas.com> <20081104180347.GA9818@uranus.ravnborg.org> <20081105163941.GB6561@logfs.org> <20081105172312.GA10585@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081105172312.GA10585@x200.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Threading should have been broken.  Doh! ]

On Wed, 5 November 2008 20:23:12 +0300, Alexey Dobriyan wrote:
> On Wed, Nov 05, 2008 at 05:39:41PM +0100, Jörn Engel wrote:
> > Hardly any file in the kernel can be compiled without including
> > <linux/types.h>, directly or indirectly.  And I'd wager a beer that
> > noone can find a non-trivial example.  I couldn't.
> 
> This is only going to slow down compilation and types.h is not causing much
> compilation problems, in fact, I can't recall a compilation problem due to
> types.h. Contary to config.h situation which was a pain.

My hope was actually to speed up compilation.  If the average c file
includes 10 headers, on types.h will get included by most of them,
possibly multiple times.  Each run after the first still has to parse
the whole file, just to drop everything between  #ifndef _LINUX_TYPES_H
and #endif.

By passing types.h on the command line we can drop it from all headers
and only have to parse it once.  Just the intermediate step of parsing
types.h 11 times instead of 10 will slow things down.  By about .4% on
my not very beefy notebook.

Before:
real    4m33.241s
user    3m58.524s
sys     0m18.539s

After:
real    4m29.707s
user    3m59.674s
sys     0m18.182s

And while testing this I noticed that a_flags shouldn't include the
file.  Updated patch below.

Jörn

-- 
to show off how geeky they were.
-- Rob Enderle

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index ea48b82..328f345 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -121,7 +121,8 @@ endif
 
 c_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(KBUILD_CPPFLAGS) \
 		 $(__c_flags) $(modkern_cflags) \
-		 -D"KBUILD_STR(s)=\#s" $(basename_flags) $(modname_flags)
+		 -D"KBUILD_STR(s)=\#s" $(basename_flags) $(modname_flags) \
+                 -include include/linux/types.h
 
 a_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(KBUILD_CPPFLAGS) \
 		 $(__a_flags) $(modkern_aflags)
