Return-Path: <linux-kernel-owner+w=401wt.eu-S1751811AbZJQGkC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbZJQGkC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 02:40:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZJQGkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 02:40:01 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:46776 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbZJQGj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 02:39:59 -0400
Date: Sat, 17 Oct 2009 08:40:02 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org,
       linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 7/14] drivers/mmc: Move dereference after NULL test
Message-ID: <Pine.LNX.4.64.0910170839430.9213@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test on mrq is needed, then the derefernce should be after the
NULL test.

A simplified version of the semantic match that detects this problem is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mmc/host/s3cmci.c           |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index 99b74a3..5be6962 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -820,7 +820,7 @@ fail_request:
 static void finalize_request(struct s3cmci_host *host)
 {
 	struct mmc_request *mrq = host->mrq;
-	struct mmc_command *cmd = host->cmd_is_stop ? mrq->stop : mrq->cmd;
+	struct mmc_command *cmd;
 	int debug_as_failure = 0;
 
 	if (host->complete_what != COMPLETION_FINALIZE)
@@ -828,6 +828,7 @@ static void finalize_request(struct s3cmci_host *host)
 
 	if (!mrq)
 		return;
+	cmd = host->cmd_is_stop ? mrq->stop : mrq->cmd;
 
 	if (cmd->data && (cmd->error == 0) &&
 	    (cmd->data->error == 0)) {
