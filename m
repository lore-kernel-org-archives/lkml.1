Return-Path: <linux-kernel-owner+w=401wt.eu-S1751993AbYJRLz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbYJRLz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 07:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYJRLzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 07:55:20 -0400
Received: from gcore.biz ([212.69.172.75]:58623 "HELO gcore.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751399AbYJRLzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 07:55:19 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Oct 2008 07:55:18 EDT
Date: Sat, 18 Oct 2008 13:49:31 +0200
From: Wolfgang Kroworsch <wolfgang@kroworsch.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] vt: incomplete initialization of vc_tab_stop
Message-ID: <20081018114929.GA25554@kroworsch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem 1 (see patch below):
  vc_tab_stop is declared as an array of 8 unsigned ints in struct
  vc_data in include/linux/console_struct.h .
  In drivers/char/vt.c only 5 of these 8 unsigned ints get initialized
  leading to unintended tabulator placement on displays with more than
  160 columns text.

Problem 2 (open):
  Upcoming displays will have more than 256 columns of text leading to
  invalid memory access in drivers/char/vt.c during tabulator
  calculations:
    if (vc->vc_tab_stop[vc->vc_x >> 5] & (1 << (vc->vc_x & 31)))
	break;

---

 drivers/char/vt.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index d8f83e2..a5af607 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -1644,7 +1644,10 @@ static void reset_terminal(struct vc_data *vc, int do_clear)
 	vc->vc_tab_stop[1]	=
 	vc->vc_tab_stop[2]	=
 	vc->vc_tab_stop[3]	=
-	vc->vc_tab_stop[4]	= 0x01010101;
+	vc->vc_tab_stop[4]	=
+	vc->vc_tab_stop[5]	=
+	vc->vc_tab_stop[6]	=
+	vc->vc_tab_stop[7]	= 0x01010101;
 
 	vc->vc_bell_pitch = DEFAULT_BELL_PITCH;
 	vc->vc_bell_duration = DEFAULT_BELL_DURATION;
@@ -1935,7 +1938,10 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 					vc->vc_tab_stop[1] =
 					vc->vc_tab_stop[2] =
 					vc->vc_tab_stop[3] =
-					vc->vc_tab_stop[4] = 0;
+					vc->vc_tab_stop[4] =
+					vc->vc_tab_stop[5] =
+					vc->vc_tab_stop[6] =
+					vc->vc_tab_stop[7] = 0;
 			}
 			return;
 		case 'm':
