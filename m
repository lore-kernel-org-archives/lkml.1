Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759872AbYLQAKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872AbYLQAKV (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759738AbYLQAGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:06:15 -0500
Received: from kroah.org ([198.145.64.141]:41368 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759607AbYLQAGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:06:11 -0500
Date: Tue, 16 Dec 2008 16:04:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
        Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
        Chris Wedgwood <reviews@ml.cw.f00f.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Chuck Ebbert <cebbert@redhat.com>,
        Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
        Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 17/22] ieee1394: add quirk fix for Freecom HDD
Message-ID: <20081217000433.GR4504@kroah.com>
References: <20081216235704.347182084@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ieee1394-add-quirk-fix-for-freecom-hdd.patch"
In-Reply-To: <20081217000306.GA4504@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit 25a41b280083259d05d68f61633194344a1f8a9f upstream.

According to http://bugzilla.kernel.org/show_bug.cgi?id=12206, Freecom
FireWire Hard Drive 1TB reports max_rom=2 but returns garbage if block
read requests are used to read the config ROM.  Force max_rom=0 to limit
them to quadlet read requests.

Reported-by: Christian Mueller <cm1@mumac.de>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ieee1394/nodemgr.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -115,8 +115,14 @@ static int nodemgr_bus_read(struct csr12
 	return error;
 }
 
+#define OUI_FREECOM_TECHNOLOGIES_GMBH 0x0001db
+
 static int nodemgr_get_max_rom(quadlet_t *bus_info_data, void *__ci)
 {
+	/* Freecom FireWire Hard Drive firmware bug */
+	if (be32_to_cpu(bus_info_data[3]) >> 8 == OUI_FREECOM_TECHNOLOGIES_GMBH)
+		return 0;
+
 	return (be32_to_cpu(bus_info_data[2]) >> 8) & 0x3;
 }
 

