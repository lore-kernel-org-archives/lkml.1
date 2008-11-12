Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbYKLAks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbYKLAks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbYKLA0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:53 -0500
Received: from kroah.org ([198.145.64.141]:42574 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753855AbYKLA0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:52 -0500
Date: Tue, 11 Nov 2008 16:24:13 -0800
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
       alan@lxorguk.ukuu.org.uk, Andrey Borzenkov <arvidjaar@mail.ru>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 38/49] cpqarry: fix return value of cpqarray_init()
Message-ID: <20081112002413.GM10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cpqarry-fix-return-value-of-cpqarray_init.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrey Borzenkov <arvidjaar@mail.ru>

commit 2197d18ded232ef6eef63cce57b6b21eddf1b7b6 upstream.

As reported by Dick Gevers on Compaq ProLiant:

Oct 13 18:06:51 dvgcpl kernel: Compaq SMART2 Driver (v 2.6.0)
Oct 13 18:06:51 dvgcpl kernel: sys_init_module: 'cpqarray'->init
suspiciously returned 1, it should follow 0/-E convention
Oct 13 18:06:51 dvgcpl kernel: sys_init_module: loading module anyway...
Oct 13 18:06:51 dvgcpl kernel: Pid: 315, comm: modprobe Not tainted
2.6.27-desktop-0.rc8.2mnb #1
Oct 13 18:06:51 dvgcpl kernel:  [<c0380612>] ? printk+0x18/0x1e
Oct 13 18:06:51 dvgcpl kernel:  [<c0158f85>] sys_init_module+0x155/0x1c0
Oct 13 18:06:51 dvgcpl kernel:  [<c0103f06>] syscall_call+0x7/0xb
Oct 13 18:06:51 dvgcpl kernel:  =======================

Make it return 0 on success and -ENODEV if no array was found.

Reported-by: Dick Gevers <dvgevers@xs4all.nl>
Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/cpqarray.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -567,7 +567,12 @@ static int __init cpqarray_init(void)
 			num_cntlrs_reg++;
 	}
 
-	return(num_cntlrs_reg);
+	if (num_cntlrs_reg)
+		return 0;
+	else {
+		pci_unregister_driver(&cpqarray_pci_driver);
+		return -ENODEV;
+	}
 }
 
 /* Function to find the first free pointer into our hba[] array */

-- 
