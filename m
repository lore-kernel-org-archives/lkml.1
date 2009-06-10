Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbZFJDdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbZFJDdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbZFJDdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:33:07 -0400
Received: from kroah.org ([198.145.64.141]:56529 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714AbZFJDdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:33:06 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 17:23:40 2009
Message-Id: <20090610002340.308555042@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 17:13:31 -0700
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
       alan@lxorguk.ukuu.org.uk, Eric Paris <eparis@redhat.com>,
       James Morris <jmorris@namei.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 03/60] TPM: get_event_name stack corruption
References: <20090610001328.251476848@blue.kroah.org>
Content-Disposition: inline; filename=tpm-get_event_name-stack-corruption.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Paris <eparis@redhat.com>

commit fbaa58696cef848de818768783ef185bd3f05158 upstream.

get_event_name uses sprintf to fill a buffer declared on the stack.  It fills
the buffer 2 bytes at a time.  What the code doesn't take into account is that
sprintf(buf, "%02x", data) actually writes 3 bytes.  2 bytes for the data and
then it nul terminates the string.  Since we declare buf to be 40 characters
long and then we write 40 bytes of data into buf sprintf is going to write 41
characters.  The fix is to leave room in buf for the nul terminator.

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tpm/tpm_bios.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/char/tpm/tpm_bios.c
+++ b/drivers/char/tpm/tpm_bios.c
@@ -214,7 +214,8 @@ static int get_event_name(char *dest, st
 			unsigned char * event_entry)
 {
 	const char *name = "";
-	char data[40] = "";
+	/* 41 so there is room for 40 data and 1 nul */
+	char data[41] = "";
 	int i, n_len = 0, d_len = 0;
 	struct tcpa_pc_event *pc_event;
 


