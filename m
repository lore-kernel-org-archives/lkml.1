Return-Path: <linux-kernel-owner+w=401wt.eu-S1761701AbYLKTor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761701AbYLKTor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757914AbYLKTTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:30 -0500
Received: from kroah.org ([198.145.64.141]:56699 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756525AbYLKTT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:27 -0500
Date: Thu, 11 Dec 2008 11:16:35 -0800
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
       alan@lxorguk.ukuu.org.uk, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Jeff Dike <jdike@addtoit.com>
Subject: [patch 74/83] uml: boot broken due to buffer overrun
Message-ID: <20081211191635.GV5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="uml-boot-broken-due-to-buffer-overrun.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Balbir Singh <balbir@linux.vnet.ibm.com>

commit 361371201b60ffd686a694c848c1d5ad6061725f upstream.

mconsole_init() passed 256 bytes as length in os_create_unix_socket, while
the sizeof UNIX_PATH_MAX is 108. This patch fixes that problem and avoids
a big overrun bug reported on UML bootup.

sockaddr_un.sun_path is UNIX_PATH_MAX long which causes the problem.
Reported-by: Vikas K Managutte <vikki.km@gmail.com>
Reported-by: Sarvesh Kumar Lal Das <skldas@gmail.com>
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Reviewed-by: WANG Cong <wangcong@zeuux.org>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/drivers/mconsole_kern.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -16,6 +16,8 @@
 #include <linux/slab.h>
 #include <linux/syscalls.h>
 #include <linux/utsname.h>
+#include <linux/socket.h>
+#include <linux/un.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
@@ -785,7 +787,7 @@ static int __init mconsole_init(void)
 	/* long to avoid size mismatch warnings from gcc */
 	long sock;
 	int err;
-	char file[256];
+	char file[UNIX_PATH_MAX];
 
 	if (umid_file_name("mconsole", file, sizeof(file)))
 		return -1;

