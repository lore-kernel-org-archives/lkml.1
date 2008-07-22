Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbYGVXaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbYGVXaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570AbYGVXU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:20:27 -0400
Received: from mx1.suse.de ([195.135.220.2]:53288 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757286AbYGVXUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:20:25 -0400
Date: Tue, 22 Jul 2008 16:16:53 -0700
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
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Layton <jlayton@redhat.com>, Steven French <sfrench@us.ibm.com>
Subject: [patch 35/47] cifs: fix wksidarr declaration to be big-endian
	friendly
Message-ID: <20080722231653.GJ8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cifs-fix-wksidarr-declaration-to-be-big-endian-friendly.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jeff Layton <jlayton@redhat.com>

commit 536abdb0802f3fac1b217530741853843d63c281 upstream

The current definition of wksidarr works fine on little endian arches
(since cpu_to_le32 is a no-op there), but on big-endian arches, it fails
to compile with this error:

error: braced-group within expression allowed only inside a function

The problem is that this static declaration has cpu_to_le32 embedded
within it, and that expands into a function macro.  We need to use
__constant_cpu_to_le32() instead.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/cifsacl.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -34,11 +34,11 @@
 static struct cifs_wksid wksidarr[NUM_WK_SIDS] = {
 	{{1, 0, {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0} }, "null user"},
 	{{1, 1, {0, 0, 0, 0, 0, 1}, {0, 0, 0, 0, 0} }, "nobody"},
-	{{1, 1, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(11), 0, 0, 0, 0} }, "net-users"},
-	{{1, 1, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(18), 0, 0, 0, 0} }, "sys"},
-	{{1, 2, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(32), cpu_to_le32(544), 0, 0, 0} }, "root"},
-	{{1, 2, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(32), cpu_to_le32(545), 0, 0, 0} }, "users"},
-	{{1, 2, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(32), cpu_to_le32(546), 0, 0, 0} }, "guest"} }
+	{{1, 1, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(11), 0, 0, 0, 0} }, "net-users"},
+	{{1, 1, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(18), 0, 0, 0, 0} }, "sys"},
+	{{1, 2, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(32), __constant_cpu_to_le32(544), 0, 0, 0} }, "root"},
+	{{1, 2, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(32), __constant_cpu_to_le32(545), 0, 0, 0} }, "users"},
+	{{1, 2, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(32), __constant_cpu_to_le32(546), 0, 0, 0} }, "guest"} }
 ;
 
 

-- 
