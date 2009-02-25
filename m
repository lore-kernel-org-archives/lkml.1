Return-Path: <linux-kernel-owner+w=401wt.eu-S1763031AbZBYWTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763031AbZBYWTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:19:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759539AbZBYWSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:18:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58582 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759360AbZBYWSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:18:54 -0500
Date: Wed, 25 Feb 2009 17:18:51 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       fweisbec@gmail.com, srostedt@redhat.com
Subject: [PATCH][git pull] uaccess: add example to copy_word_from_user in
 comment
In-Reply-To: <20090225133929.f67163e3.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0902251716570.12697@gandalf.stny.rr.com>
References: <20090225203007.582030664@goodmis.org> <20090225203427.382137706@goodmis.org> <20090225133929.f67163e3.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (1):
      uaccess: add example to copy_word_from_user in comment

----
 lib/uaccess.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 38 insertions(+), 1 deletions(-)
---------------------------
commit bdec54d5f42a6e702a35687ab110751968c9a4d9
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Feb 25 17:14:40 2009 -0500

    uaccess: add example to copy_word_from_user in comment
    
    Andrew Morton suggested an example of use for copy_word_from_user.
    This patch adds an example in the kernel doc of the function.
    It also clears up what is returned.
    
    Reported-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/lib/uaccess.c b/lib/uaccess.c
index 5b9a4ac..2dda756 100644
--- a/lib/uaccess.c
+++ b/lib/uaccess.c
@@ -30,8 +30,45 @@
  * Note, if skip is not set, and white space exists at the beginning
  *  it will return immediately.
  *
+ * Example of use:
+ *
+ *  in user space a write(fd, "foo  bar zot", 12) is done. We want to
+ *  read three words.
+ *
+ *  len = 12;  - length of user buffer
+ *  ret = copy_word_from_user(buf, ubuf, 100, len, @copied, 1);
+ *    ret will equal 4 ("foo " read)
+ *    buf will contain "foo"
+ *    copied will equal 3 ("foo" copied)
+ *    Note, @skip could be 1 or zero and the same would have happened
+ *          since there was no leading white space.
+ *
+ *  len -= ret;  - 4 bytes was read
+ *  read = ret;
+ *  ret = copy_word_from_user(buf, ubuf+read, 100, len, @copied, 1);
+ *    ret will equal 5 (" bar " read, notice the double space between
+ *                       foo and bar in the original write.)
+ *    buf will contain "bar"
+ *    copied will equal 3 ("bar" copied)
+ *    Note, @skip is 1, if it was zero the results would be different.
+ *          (see below)
+ *
+ *  len -= ret; - 5 bytes read
+ *  read += ret;
+ *  ret = copy_word_from_user(buf, ubuf+read, 100, len, @copied, 1);
+ *   ret = -EAGAIN (no space after "zot")
+ *   buf will contain "zot"
+ *   copied will equal 3 ("zot" copied)
+ *
+ * If the second copy_word_from_user above had 0 for @skip, where we
+ * did not want to skip leading white space (" bar zot")
+ *   ret will equal 1 (" " read)
+ *   buf will not be modified
+ *   copied will equal 0 (nothing copied).
+ *
  * Returns:
- *  The number of bytes read from user space
+ *  The number of bytes read from user space (@from). This may or may not
+ *  be the same as what was copied into @to.
  *
  *  -EAGAIN, if we copied a word successfully, but never hit
  *    ending white space. The number of bytes copied will be the same

