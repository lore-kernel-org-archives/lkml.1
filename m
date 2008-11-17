Return-Path: <linux-kernel-owner+w=401wt.eu-S1758704AbYKQHfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbYKQHfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYKQHVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:44 -0500
Received: from kroah.org ([198.145.64.141]:38690 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755595AbYKQHVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:37 -0500
Date: Sun, 16 Nov 2008 23:16:55 -0800
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
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 39/46] USB: EHCI: fix divide-by-zero bug
Message-ID: <20081117071655.GN29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-ehci-fix-divide-by-zero-bug.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 372dd6e8ed924e876f3beb598721e813ad7fa323 upstream.

This patch (as1164) fixes a bug in the EHCI scheduler.  The interval
value it uses is already in linear format, not logarithmically coded.
The existing code can sometimes crash the system by trying to divide
by zero.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -918,7 +918,7 @@ iso_stream_init (
 		 */
 		stream->usecs = HS_USECS_ISO (maxp);
 		bandwidth = stream->usecs * 8;
-		bandwidth /= 1 << (interval - 1);
+		bandwidth /= interval;
 
 	} else {
 		u32		addr;
@@ -951,7 +951,7 @@ iso_stream_init (
 		} else
 			stream->raw_mask = smask_out [hs_transfers - 1];
 		bandwidth = stream->usecs + stream->c_usecs;
-		bandwidth /= 1 << (interval + 2);
+		bandwidth /= interval << 3;
 
 		/* stream->splits gets created from raw_mask later */
 		stream->address = cpu_to_hc32(ehci, addr);

-- 
