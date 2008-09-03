Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbYICRdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbYICRdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbYICRdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:33:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:54877 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbYICRdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:33:05 -0400
Date: Wed, 3 Sep 2008 10:25:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Pavel Emelyanov <xemul@openvz.org>
Subject: [patch 05/42] binfmt_misc: fix false -ENOEXEC when coupled with
	other binary handlers
Message-ID: <20080903172525.GF7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="binfmt_misc-fix-false-enoexec-when-coupled-with-other-binary-handlers.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Pavel Emelyanov <xemul@openvz.org>

commit ff9bc512f198eb47204f55b24c6fe3d36ed89592 upstream

Date: Wed, 20 Aug 2008 14:09:10 -0700
Subject: [patch 05/42] binfmt_misc: fix false -ENOEXEC when coupled with other binary handlers

In case the binfmt_misc binary handler is registered *before* the e.g.
script one (when for example being compiled as a module) the following
situation may occur:

1. user launches a script, whose interpreter is a misc binary;
2. the load_misc_binary sets the misc_bang and returns -ENOEVEC,
   since the binary is a script;
3. the load_script_binary loads one and calls for search_binary_hander
   to run the interpreter;
4. the load_misc_binary is called again, but refuses to load the
   binary due to misc_bang bit set.

The fix is to move the misc_bang setting lower - prior to the actual
call to the search_binary_handler.

Caused by the commit 3a2e7f47 (binfmt_misc.c: avoid potential kernel
stack overflow)

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Reported-by: Kirill A. Shutemov <kirill@shutemov.name>
Tested-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/binfmt_misc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -119,8 +119,6 @@ static int load_misc_binary(struct linux
 	if (bprm->misc_bang)
 		goto _ret;
 
-	bprm->misc_bang = 1;
-
 	/* to keep locking time low, we copy the interpreter string */
 	read_lock(&entries_lock);
 	fmt = check_file(bprm);
@@ -198,6 +196,8 @@ static int load_misc_binary(struct linux
 	if (retval < 0)
 		goto _error;
 
+	bprm->misc_bang = 1;
+
 	retval = search_binary_handler (bprm, regs);
 	if (retval < 0)
 		goto _error;

-- 
