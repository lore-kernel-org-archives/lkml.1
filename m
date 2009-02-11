Return-Path: <linux-kernel-owner+w=401wt.eu-S1758960AbZBKAd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960AbZBKAd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757616AbZBKA2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:28:21 -0500
Received: from kroah.org ([198.145.64.141]:51125 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757552AbZBKA2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:18 -0500
Date: Tue, 10 Feb 2009 16:24:50 -0800
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
       alan@lxorguk.ukuu.org.uk, Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 17/56] ieee1394: ohci1394: increase AT req. retries, fix
	ack_busy_X from Panasonic camcorders and others
Message-ID: <20090211002450.GR14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ieee1394-ohci1394-increase-at-req.-retries-fix-ack_busy_x-from-panasonic-camcorders-and-others.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Commit 64c634ef83991b390ec0503e61f16efb0ba3c60b upstream.

Camcorders have a tendency to fail read requests to their config ROM and
write request to their FCP command register with ack_busy_X.  This has
become a problem with newer kernels and especially Panasonic camcorders,
causing AV/C in dvgrab and kino to fail.  Dvgrab for example frequently
logs "send oops"; kino reports loss of AV/C control.  I suspect that
lower CPU scheduling latencies in newer kernels made this issue more
prominent now.

According to
https://sourceforge.net/tracker/?func=detail&atid=114103&aid=2492640&group_id=14103
this can be fixed by configuring the FireWire controller for more
hardware retries for request transmission; these retries are evidently
more successful than libavc1394's own retry loop (typically 3 tries on
top of hardware retries).

Presumably the same issue has been reported at
https://bugzilla.redhat.com/show_bug.cgi?id=449252 and
https://bugzilla.redhat.com/show_bug.cgi?id=477279 .

Tested-by: Mathias Beilstein
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ieee1394/ohci1394.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ieee1394/ohci1394.h
+++ b/drivers/ieee1394/ohci1394.h
@@ -26,7 +26,7 @@
 
 #define OHCI1394_DRIVER_NAME      "ohci1394"
 
-#define OHCI1394_MAX_AT_REQ_RETRIES	0x2
+#define OHCI1394_MAX_AT_REQ_RETRIES	0xf
 #define OHCI1394_MAX_AT_RESP_RETRIES	0x2
 #define OHCI1394_MAX_PHYS_RESP_RETRIES	0x8
 #define OHCI1394_MAX_SELF_ID_ERRORS	16

