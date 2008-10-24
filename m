Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbYJXEsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbYJXEsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYJXEjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:39:43 -0400
Received: from kroah.org ([198.145.64.141]:51914 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751707AbYJXEj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:39:29 -0400
Date: Thu, 23 Oct 2008 21:35:00 -0700
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
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@suse.cz>, Len Brown <len.brown@intel.com>
Subject: [patch 21/27] ACPI Suspend: Enable ACPI during resume if SCI_EN is
	not set
Message-ID: <20081024043500.GV30828@kroah.com>
References: <20081024042023.054190751@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-suspend-enable-acpi-during-resume-if-sci_en-is-not-set.patch"
In-Reply-To: <20081024043303.GA30828@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Rafael J. Wysocki <rjw@sisk.pl>

commit d0c71fe7ebc180f1b7bc7da1d39a07fc19eec768 upstream.

On some machines, like for example MSI Wind U100, the BIOS doesn't
enable ACPI before returning control to the OS, which sometimes
causes resume to fail.  This is against the ACPI specification,
which clearly states that "When the platform is waking from an S1, S2
or S3 state, OSPM assumes the hardware is already in the ACPI mode
and will not issue an ACPI_ENABLE", but it won't hurt to check the
SCI_EN bit and enable ACPI during resume from S3 if this bit is not
set.

Fortunately, we already have acpi_enable() for that, so use it in the
resume code path, before executing _BFS, in analogy with the
resume-from-hibernation code path.

NOTE: We aren't supposed to set SCI_EN directly, because it's owned
by the hardware.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/sleep/main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -200,6 +200,8 @@ static int acpi_suspend_enter(suspend_st
 		break;
 	}
 
+	/* If ACPI is not enabled by the BIOS, we need to enable it here. */
+	acpi_enable();
 	/* Reprogram control registers and execute _BFS */
 	acpi_leave_sleep_state_prep(acpi_state);
 

-- 
