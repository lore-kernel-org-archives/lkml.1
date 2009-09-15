Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbZIOPwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbZIOPwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 11:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbZIOPwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 11:52:34 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:43222 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbZIOPwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 11:52:33 -0400
From: Louis Rilling <louis.rilling@kerlabs.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Louis Rilling <louis.rilling@kerlabs.com>
Subject: [PATCH] Let gdb assume that kgdb supports extended mode
Date: Tue, 15 Sep 2009 17:52:27 +0200
Message-Id: <1253029947-670-1-git-send-email-louis.rilling@kerlabs.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When looking for ways to reboot my target machine from gdb, I had to implement
the patch below.

Then, from gdb, one has to attach as extended-remote target, and the
'run' command will reboot the target machine.

The behavior is not perfect since gdb will complain afterwards, and the user
has to interrupt it and detach to recover usage. But AFAICS, gdb's remote
protocol only uses the 'RXX' remote command in extended mode, which makes the
current implementation of the 'R0' command in kgdb unreachable from gdb.

So, are there reasons not to include such a patch?

Thanks,

Louis

-------------------------------------------------->
Subject: [PATCH] Let gdb assume that kgdb supports extended mode

... and allow users to reboot the target machine from gdb.

Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
---
 kernel/kgdb.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 5f15d33..e39f886 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -829,6 +829,12 @@ static int kgdb_io_ready(int print_wait)
  * where KGDB is communicating with an external debugger
  */
 
+/* Handle the '!' extended mode request */
+static void gdb_cmd_extended(struct kgdb_state *ks)
+{
+	strcpy(remcom_out_buffer, "OK");
+}
+
 /* Handle the '?' status packets */
 static void gdb_cmd_status(struct kgdb_state *ks)
 {
@@ -1252,6 +1258,9 @@ static int gdb_serial_stub(struct kgdb_state *ks)
 		get_packet(remcom_in_buffer);
 
 		switch (remcom_in_buffer[0]) {
+		case '!': /* extended mode */
+			gdb_cmd_extended(ks);
+			break;
 		case '?': /* gdbserial status */
 			gdb_cmd_status(ks);
 			break;
-- 
1.5.6.5

