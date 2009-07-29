Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbZG2W5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbZG2W5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 18:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbZG2W5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 18:57:50 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:60242 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753038AbZG2W5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 18:57:50 -0400
From: Frans Pop <elendil@planet.nl>
To: cedric@belbone.be, linux-kernel@vger.kernel.org
Subject: Re: [Bug 13865] Can only resume with HP_WMI selected on compaq nc6000 when 4c395bdd3f2ca8f7e8efad881e16071182c3b8ca is reverted
Date: Thu, 30 Jul 2009 00:57:47 +0200
User-Agent: KMail/1.9.9
Cc: bugzilla-daemon@bugzilla.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <bug-13865-10028@http.bugzilla.kernel.org/> <200907292257.41573.rjw@sisk.pl> <200907292331.34214.elendil@planet.nl>
In-Reply-To: <200907292331.34214.elendil@planet.nl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200907300057.48669.elendil@planet.nl>
X-OriginalArrivalTime: 29 Jul 2009 22:57:49.0556 (UTC) FILETIME=[FEE22B40:01CA109F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 July 2009, Frans Pop wrote:
> The strange thing is that the resume function does not do anything
> that's not also done in hp_wmi_input_setup(). The only thing I can
> think of is that we might need to test for
> wmi_has_guid(HPWMI_EVENT_GUID) because that model simply does not
> support input events.

If that is the problem, the following patch will hopefully fix it.
This patch is against .31-rc4 but will need only minor changes to
apply against .30.

Subject: hp-wmi: check that an input device exists in resume handler

Some systems may not support input events, or registering the input
handler may have failed. So check that an input device exists before
trying to set the docking and tablet mode state during resume.

Fixes: http://bugzilla.kernel.org/show_bug.cgi?id=13865

Reported-by: cedric@belbone.be
Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 369bd43..63c9214 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -540,11 +540,13 @@ static int hp_wmi_resume_handler(struct device *device)
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
 
 	if (wifi_rfkill)
 		rfkill_set_states(wifi_rfkill,
