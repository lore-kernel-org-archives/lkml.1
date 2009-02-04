Return-Path: <linux-kernel-owner+w=401wt.eu-S1759476AbZBDS5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbZBDS5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758894AbZBDStY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:24 -0500
Received: from kroah.org ([198.145.64.141]:60958 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761367AbZBDStQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:16 -0500
Date: Wed, 4 Feb 2009 10:46:22 -0800
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
       alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 17/41] sata_nv: ck804 has borked hardreset too
Message-ID: <20090204184622.GR25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sata_nv-ck804-has-borked-hardreset-too.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 8d993eaa9c3c61b8a5929a7f695078a1fcfb4869 upstream.

While playing with nvraid, I found out that rmmoding and insmoding
often trigger hardreset failure on the first port (the second one was
always okay).  Seriously, how diverse can you get with hardreset
behaviors?  Anyways, make ck804 use noclassify variant too.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/sata_nv.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -436,11 +436,16 @@ static struct ata_port_operations nv_nf2
 	.hardreset		= nv_noclassify_hardreset,
 };
 
-/* CK804 finally gets hardreset right */
+/* For initial probing after boot and hot plugging, hardreset mostly
+ * works fine on CK804 but curiously, reprobing on the initial port by
+ * rescanning or rmmod/insmod fails to acquire the initial D2H Reg FIS
+ * in somewhat undeterministic way.  Use noclassify hardreset.
+ */
 static struct ata_port_operations nv_ck804_ops = {
 	.inherits		= &nv_common_ops,
 	.freeze			= nv_ck804_freeze,
 	.thaw			= nv_ck804_thaw,
+	.hardreset		= nv_noclassify_hardreset,
 	.host_stop		= nv_ck804_host_stop,
 };
 

