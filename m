Return-Path: <linux-kernel-owner+w=401wt.eu-S1751093AbZL0SvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093AbZL0SvK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 13:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbZL0SvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 13:51:07 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:43162 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbZL0SvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 13:51:07 -0500
Message-ID: <4B37AC87.1070607@knaff.lu>
Date: Sun, 27 Dec 2009 19:50:47 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.33-rc1: LZMA kernel fails to decompress
References: <200912211643.18173.tvrtko.ursulin@sophos.com> <4B2FEC10.6050900@msgid.tls.msk.ru>
In-Reply-To: <4B2FEC10.6050900@msgid.tls.msk.ru>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------020208000104030209080007"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020208000104030209080007
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Michael Tokarev wrote:
> Tvrtko Ursulin wrote:
>> Hi,
>>
>> When run under VMware, LZMA compressed 2.6.33-rc1 instantly reboots in the 
>> decompression stage. At least I suppose so, because switching to GZIP makes 
>> it work.
> 
> Switch /bin/sh from dash to bash and recompile (actually relink) - it should work.
> 
> /mjt

I can confirm this. A similar issue used to exist for older kernels,
which then got fixed by replacing "echo" with "/bin/echo" in the
size_append command scripts/Makefile.lib . The reason why this was
needed is that some shells (such as dash) have a defective built-in echo
command. Specifying the full path forces to use the system echo command
rather than the broken shell builtin.

In 2.6.33, for some reason, echo has been replaced with printf. With a
_pathless_ printf! The fix is the same as in earlier kernels: add the path.

With the attached patch applied, the kernel compiles correctly even if
sh is linked to dash.

Regards,

Alain


--------------020208000104030209080007
Content-Type: text/x-diff;
 name="dash.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dash.patch"

diff -ur linux-2.6.33-rc2/scripts/Makefile.lib linux-2.6.33-rc2.fixed/scripts/Makefile.lib
--- linux-2.6.33-rc2/scripts/Makefile.lib	2009-12-24 21:09:41.000000000 +0000
+++ linux-2.6.33-rc2.fixed/scripts/Makefile.lib	2009-12-27 18:34:23.000000000 +0000
@@ -213,7 +213,7 @@
 
 # Bzip2 and LZMA do not include size in file... so we have to fake that;
 # append the size as a 32-bit littleendian number as gzip does.
-size_append = printf $(shell						\
+size_append = /usr/bin/printf $(shell						\
 dec_size=0;								\
 for F in $1; do								\
 	fsize=$$(stat -c "%s" $$F);					\

--------------020208000104030209080007--
