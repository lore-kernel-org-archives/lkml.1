Return-Path: <linux-kernel-owner+w=401wt.eu-S1761266AbYC0Mkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761266AbYC0Mkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758036AbYC0Mie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:38:34 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55645 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759879AbYC0MiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:38:11 -0400
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       "=?utf-8?q?Ilpo=20J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>,
       Vlad Yasevich <vladislav.yasevich@hp.com>
Subject: [PATCH 7/7] [SCTP]: Remove sctp_add_cmd_sf wrapper bloat
Date: Thu, 27 Mar 2008 14:38:06 +0200
Message-Id: <1206621486-5408-8-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: git-send-email 1.5.4.2.156.ge3c5
In-Reply-To: <1206621486-5408-7-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1206621486-5408-1-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1206621486-5408-2-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1206621486-5408-3-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1206621486-5408-4-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1206621486-5408-5-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1206621486-5408-6-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1206621486-5408-7-git-send-email-ilpo.jarvinen@helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a was number of callsites sctp_add_cmd_sf wrapper bloats
kernel by some amount. Due to unlikely tracking allyesconfig,
with the initial result were around ~7kB (thus caught my
attention) while a non-debug config produced only ~2.3kB effect.

I (ij) proposed first a patch to uninline it but Vlad responded
with a patch that removed the only sctp_add_cmd call which is
wrapped by sctp_add_cmd_sf (I wasn't sure if I could do that).
I did minor cleanup to Vlad's patch.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 include/net/sctp/command.h |    3 +--
 include/net/sctp/sm.h      |    8 --------
 net/sctp/command.c         |   10 ++--------
 net/sctp/sm_statefuns.c    |    8 ++------
 4 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/include/net/sctp/command.h b/include/net/sctp/command.h
index 10ae2da..4263af8 100644
--- a/include/net/sctp/command.h
+++ b/include/net/sctp/command.h
@@ -205,12 +205,11 @@ typedef struct {
 int sctp_init_cmd_seq(sctp_cmd_seq_t *seq);
 
 /* Add a command to an sctp_cmd_seq_t.
- * Return 0 if the command sequence is full.
  *
  * Use the SCTP_* constructors defined by SCTP_ARG_CONSTRUCTOR() above
  * to wrap data which goes in the obj argument.
  */
-int sctp_add_cmd(sctp_cmd_seq_t *seq, sctp_verb_t verb, sctp_arg_t obj);
+void sctp_add_cmd_sf(sctp_cmd_seq_t *seq, sctp_verb_t verb, sctp_arg_t obj);
 
 /* Return the next command structure in an sctp_cmd_seq.
  * Return NULL at the end of the sequence.
diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index ef9e7ed..2481173 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -385,14 +385,6 @@ static inline int ADDIP_SERIAL_gte(__u16 s, __u16 t)
 	return (((s) == (t)) || (((t) - (s)) & ADDIP_SERIAL_SIGN_BIT));
 }
 
-
-/* Run sctp_add_cmd() generating a BUG() if there is a failure.  */
-static inline void sctp_add_cmd_sf(sctp_cmd_seq_t *seq, sctp_verb_t verb, sctp_arg_t obj)
-{
-	if (unlikely(!sctp_add_cmd(seq, verb, obj)))
-		BUG();
-}
-
 /* Check VTAG of the packet matches the sender's own tag. */
 static inline int
 sctp_vtag_verify(const struct sctp_chunk *chunk,
diff --git a/net/sctp/command.c b/net/sctp/command.c
index bb97733..c004401 100644
--- a/net/sctp/command.c
+++ b/net/sctp/command.c
@@ -52,18 +52,12 @@ int sctp_init_cmd_seq(sctp_cmd_seq_t *seq)
 /* Add a command to a sctp_cmd_seq_t.
  * Return 0 if the command sequence is full.
  */
-int sctp_add_cmd(sctp_cmd_seq_t *seq, sctp_verb_t verb, sctp_arg_t obj)
+void sctp_add_cmd_sf(sctp_cmd_seq_t *seq, sctp_verb_t verb, sctp_arg_t obj)
 {
-	if (seq->next_free_slot >= SCTP_MAX_NUM_COMMANDS)
-		goto fail;
+	BUG_ON(seq->next_free_slot >= SCTP_MAX_NUM_COMMANDS);
 
 	seq->cmds[seq->next_free_slot].verb = verb;
 	seq->cmds[seq->next_free_slot++].obj = obj;
-
-	return 1;
-
-fail:
-	return 0;
 }
 
 /* Return the next command structure in a sctp_cmd_seq.
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 6545b5f..b534dbe 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3135,12 +3135,8 @@ sctp_disposition_t sctp_sf_operr_notify(const struct sctp_endpoint *ep,
 		if (!ev)
 			goto nomem;
 
-		if (!sctp_add_cmd(commands, SCTP_CMD_EVENT_ULP,
-				  SCTP_ULPEVENT(ev))) {
-			sctp_ulpevent_free(ev);
-			goto nomem;
-		}
-
+		sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP,
+				SCTP_ULPEVENT(ev));
 		sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_OPERR,
 				SCTP_CHUNK(chunk));
 	}
-- 
1.5.2.2

