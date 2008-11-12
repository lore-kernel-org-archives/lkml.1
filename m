Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYKLA12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYKLA12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbYKLA0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:04 -0500
Received: from kroah.org ([198.145.64.141]:42063 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752377AbYKLA0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:01 -0500
Date: Tue, 11 Nov 2008 16:22:57 -0800
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
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>
Subject: [patch 03/49] x86: reserve low 64K on AMI and Phoenix BIOS boxen
Message-ID: <20081112002257.GD10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-reserve-low-64k-on-ami-and-phoenix-bios-boxen.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ingo Molnar <mingo@elte.hu>

commit 1e22436eba84edfec9c25e5a25d09062c4f91ca9 upstream

there's multiple reports about suspend/resume related low memory
corruption in this bugzilla:

  http://bugzilla.kernel.org/show_bug.cgi?id=11237

the common pattern is that the corruption is caused by the BIOS,
and that it affects some portion of the first 64K of physical RAM.

So add a DMI quirk

This will waste 64K RAM on 'good' systems too, but without knowing
the exact nature of this BIOS memory corruption this is the safest
approach.

This might as well solve a wide range of suspend/resume breakages
under Linux.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/setup.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -581,10 +581,10 @@ struct x86_quirks *x86_quirks __initdata
 static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE
-		"%s detected: BIOS corrupts 0xc000, working it around.\n",
+		"%s detected: BIOS may corrupt low RAM, working it around.\n",
 		d->ident);
 
-	reserve_early(0xc000, 0xc400, "BIOS quirk");
+	reserve_early(0x0, 0x10000, "BIOS quirk");
 
 	return 0;
 }
@@ -598,6 +598,13 @@ static struct dmi_system_id __initdata b
 			DMI_MATCH(DMI_BIOS_VENDOR, "American Megatrends Inc."),
 		},
 	},
+	{
+		.callback = dmi_low_memory_corruption,
+		.ident = "Phoenix BIOS",
+		.matches = {
+			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies, LTD"),
+		},
+	},
 	{}
 };
 

-- 
