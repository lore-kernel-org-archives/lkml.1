Return-Path: <linux-kernel-owner+w=401wt.eu-S1752902AbZG3KmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbZG3KmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 06:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZG3KmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 06:42:10 -0400
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:51295 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752602AbZG3KmJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 06:42:09 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug 13865] [PATCH] hp-wmi: check that an input device exists in resume handler
Date: Thu, 30 Jul 2009 12:42:05 +0200
User-Agent: KMail/1.9.9
Cc: bugzilla-daemon@bugzilla.kernel.org, Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       =?utf-8?q?C=C3=A9dric_Godin?= <cedric@belbone.be>
References: <bug-13865-10028@http.bugzilla.kernel.org/> <200907292257.41573.rjw@sisk.pl>
In-Reply-To: <200907292257.41573.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907301242.07973.elendil@planet.nl>
X-OriginalArrivalTime: 30 Jul 2009 10:42:08.0696 (UTC) FILETIME=[634B3380:01CA1102]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 July 2009, Rafael J. Wysocki wrote:
> On Wednesday 29 July 2009, you wrote:
> > http://bugzilla.kernel.org/show_bug.cgi?id=13865
> >
> > Just for testing I enabled HP_WMI. But from then, I could not resume
> > anymore. I just reverted the last git commit on the
> > 'drivers/platform/x86/hp-wmi.c' code
> > (4c395bdd3f2ca8f7e8efad881e16071182c3b8ca) and now I can resume. The
> > problem still persists on .31-rc serie

Here's the final patch, tested by Cédric. (And properly against mainline.)

From: Frans Pop <elendil@planet.nl>
Subject: hp-wmi: check that an input device exists in resume handler

Some systems may not support input events, or registering the input
handler may have failed. So check that an input device exists before
trying to set the docking and tablet mode state during resume.

Fixes: http://bugzilla.kernel.org/show_bug.cgi?id=13865

Reported-and-tested-by: Cédric Godin <cedric@belbone.be>
Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index ca50856..a2ad53e 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -520,11 +520,13 @@ static int hp_wmi_resume_handler(struct platform_device *device)
 	 * the input layer will only actually pass it on if the state
 	 * changed.
 	 */
-
-	input_report_switch(hp_wmi_input_dev, SW_DOCK, hp_wmi_dock_state());
-	input_report_switch(hp_wmi_input_dev, SW_TABLET_MODE,
-			    hp_wmi_tablet_state());
-	input_sync(hp_wmi_input_dev);
+	if (hp_wmi_input_dev) {
+		input_report_switch(hp_wmi_input_dev, SW_DOCK,
+				    hp_wmi_dock_state());
+		input_report_switch(hp_wmi_input_dev, SW_TABLET_MODE,
+				    hp_wmi_tablet_state());
+		input_sync(hp_wmi_input_dev);
+	}
 
 	return 0;
 }
