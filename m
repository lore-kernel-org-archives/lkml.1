Return-Path: <linux-kernel-owner+w=401wt.eu-S1760494AbZEMQyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760494AbZEMQyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 12:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758798AbZEMQyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 12:54:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46513 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757060AbZEMQyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 12:54:38 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH] TPM: get_event_name stack corruption
To: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com,
       m.selhorst@sirrix.com, tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org, eparis@redhat.com
Date: Wed, 13 May 2009 12:50:40 -0400
Message-ID: <20090513165040.16180.77289.stgit@dhcp231-142.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_event_name uses sprintf to fill a buffer declared on the stack.  It fills
the buffer 2 bytes at a time.  What the code doesn't take into account is that
sprintf(buf, "%02x", data) actually writes 3 bytes.  2 bytes for the data and
then it nul terminates the string.  Since we declare buf to be 40 characters
long and then we write 40 bytes of data into buf sprintf is going to write 41
characters.  The fix is to leave room in buf for the nul terminator.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 drivers/char/tpm/tpm_bios.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tpm/tpm_bios.c b/drivers/char/tpm/tpm_bios.c
index ed306eb..0c2f55a 100644
--- a/drivers/char/tpm/tpm_bios.c
+++ b/drivers/char/tpm/tpm_bios.c
@@ -212,7 +212,8 @@ static int get_event_name(char *dest, struct tcpa_event *event,
 			unsigned char * event_entry)
 {
 	const char *name = "";
-	char data[40] = "";
+	/* 41 so there is room for 40 data and 1 nul */
+	char data[41] = "";
 	int i, n_len = 0, d_len = 0;
 	struct tcpa_pc_event *pc_event;
 

