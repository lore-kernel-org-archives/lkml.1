Return-Path: <linux-kernel-owner+w=401wt.eu-S1762157AbZENXGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762157AbZENXGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762267AbZENW6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:58:43 -0400
Received: from kroah.org ([198.145.64.141]:46040 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762264AbZENW6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:58:37 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:52:38 2009
Message-Id: <20090514225238.374798374@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:51:38 -0700
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
       alan@lxorguk.ukuu.org.uk, linux-fsdevel@vger.kernel.org,
       linux-mm@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>,
       Nick Piggin <npiggin@suse.de>
Subject: [patch 12/28] GFS2: Fix page_mkwrite() return code
References: <20090514225126.907908936@mini.kroah.org>
Content-Disposition: inline; filename=gfs2-fix-page_mkwrite-return-code.patch
In-Reply-To: <20090514225413.GA705@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steven Whitehouse <swhiteho@redhat.com>

commit e56985da455b9dc0591b8cb2006cc94b6f4fb0f4 upstream

This allows for the possibility of returning VM_FAULT_OOM as
well as VM_FAULT_SIGBUS. This ensures that the correct action
is taken.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/gfs2/ops_file.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -412,7 +412,9 @@ out_unlock:
 	gfs2_glock_dq(&gh);
 out:
 	gfs2_holder_uninit(&gh);
-	if (ret)
+	if (ret == -ENOMEM)
+		ret = VM_FAULT_OOM;
+	else if (ret)
 		ret = VM_FAULT_SIGBUS;
 	return ret;
 }


