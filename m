Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbZJBBc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbZJBBc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbZJBBc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:32:56 -0400
Received: from kroah.org ([198.145.64.141]:33029 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389AbZJBBcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:54 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:11 2009
Message-Id: <20091002012410.983865030@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Johannes Berg <johannes@sipsolutions.net>,
       Mattia Dongili <malattia@linux.it>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [034/136] sony-laptop: check for rfkill hard block at load time
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=sony-laptop-check-for-rfkill-hard-block-at-load-time.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

commit 50fab0760a6c07cded229357a1351c325a575770 upstream.

"I recently (on a flight) I found out that when I boot with the hard-switch
activated, so turning off all wireless activity on my laptop, the state
is not correctly announced in /dev/rfkill (reading it with rfkill command,
or my own gnome applet)...

After turning off and on again the hard-switch the events were right."

We can fix this by querying the firmware at load time and calling
rfkill_set_hw_state().

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Tested-by: Norbert Preining <preining@logic.at>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Mattia Dongili <malattia@linux.it>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/sony-laptop.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -1081,6 +1081,8 @@ static int sony_nc_setup_rfkill(struct a
 	struct rfkill *rfk;
 	enum rfkill_type type;
 	const char *name;
+	int result;
+	bool hwblock;
 
 	switch (nc_type) {
 	case SONY_WIFI:
@@ -1108,6 +1110,10 @@ static int sony_nc_setup_rfkill(struct a
 	if (!rfk)
 		return -ENOMEM;
 
+	sony_call_snc_handle(0x124, 0x200, &result);
+	hwblock = !(result & 0x1);
+	rfkill_set_hw_state(rfk, hwblock);
+
 	err = rfkill_register(rfk);
 	if (err) {
 		rfkill_destroy(rfk);


