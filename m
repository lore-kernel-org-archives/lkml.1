Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbZJLImX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbZJLImX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 04:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbZJLImW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 04:42:22 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:56598 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799AbZJLImV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 04:42:21 -0400
Message-ID: <4AD2EBC6.1000505@msgid.tls.msk.ru>
Date: Mon, 12 Oct 2009 12:41:42 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [GIT PULL] kbuild fixes
References: <20091011221818.GA2833@merkur.ravnborg.org>
In-Reply-To: <20091011221818.GA2833@merkur.ravnborg.org>
Content-Type: multipart/mixed;
 boundary="------------050304010905010605010400"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050304010905010605010400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Sam Ravnborg wrote:
> Hi Linus.
> 
> A few kbuild related fixes.
[]
> - Fix use of echo -ne. Is caused issues for ubuntu (IIRC) users

As has been discussed previously (and Sam has been CC'ed), the fix
is still incorrect.  It replaces "echo -ne" with "/bin/echo -ne",
but neither of the two are guaranteed to support the necessary
arguments and necessary (hexadecimal) escape sequences.  What should
be used here is printf(1).  The trivial patch below (on top of these
kbuild changes) fixes this issue.

Thanks.

/mjt

Signed-Off-By: Michael Tokarev <mjt@tls.msk.ru>

--------------050304010905010605010400
Content-Type: text/x-patch;
 name="echo-vs-printf.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="echo-vs-printf.diff"

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index ffdafb2..d9f0cb8 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -208,7 +208,7 @@ cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -f -9 > $@) || \
 
 # Bzip2 and LZMA do not include size in file... so we have to fake that;
 # append the size as a 32-bit littleendian number as gzip does.
-size_append = /bin/echo -ne $(shell					\
+size_append = printf $(shell						\
 dec_size=0;								\
 for F in $1; do								\
 	fsize=$$(stat -c "%s" $$F);					\

--------------050304010905010605010400--
