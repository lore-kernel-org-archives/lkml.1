Return-Path: <linux-kernel-owner+w=401wt.eu-S1761385AbZEFUk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385AbZEFUk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761037AbZEFUjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:39:04 -0400
Received: from kroah.org ([198.145.64.141]:33884 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761036AbZEFUjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:39:01 -0400
X-Mailbox-Line: From greg@blue.kroah.org Wed May  6 13:31:29 2009
Message-Id: <20090506203129.206953435@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 13:30:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Cedric Hombourger <chombourger@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 07/18] kbuild: fix Module.markers permission error under cygwin
References: <20090506203010.615363711@blue.kroah.org>
Content-Disposition: inline; filename=kbuild-fix-module.markers-permission-error-under-cygwin.patch
In-Reply-To: <20090506203353.GA14624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Cedric Hombourger <chombourger@gmail.com>

commit 99e3a1eb3c22bb671c6f3d22d8244bfc9fad8185 upstream.

While building the kernel, we end-up calling modpost with -K and -M
options for the same file (Modules.markers).  This is resulting in
modpost's main function calling read_markers() and then write_markers() on
the same file.

We then have read_markers() mmap'ing the file, and writer_markers()
opening that same file for writing.

The issue is that read_markers() exits without munmap'ing the file and is
as a matter holding a reference on Modules.markers.  When write_markers()
is opening that very same file for writing, we still have a reference on
it and cygwin (Windows?) is then making fopen() fail with EPERM.

Calling release_file() before exiting read_markers() clears that reference
(and memory leak) and fopen() then succeeds.

Tested on both cygwin (1.3.22) and Linux.  Also ran modpost within
valgrind on Linux to make sure that the munmap'ed file was not accessed
after read_markers()

Signed-off-by: Cedric Hombourger <chombourger@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 scripts/mod/modpost.c |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1997,6 +1997,7 @@ static void read_markers(const char *fna
 		if (!mod->skip)
 			add_marker(mod, marker, fmt);
 	}
+	release_file(file, size);
 	return;
 fail:
 	fatal("parse error in markers list file\n");


