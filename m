Return-Path: <linux-kernel-owner+w=401wt.eu-S1030856AbXAZQui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030856AbXAZQui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030804AbXAZQu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:50:29 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:35488 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030854AbXAZQtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:49:47 -0500
Date: Fri, 26 Jan 2007 17:49:44 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Subject: [S390] Fix FCP dump feature detection.
Message-ID: <20070126164944.GJ11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] Fix FCP dump feature detection.

FCP dump feature detection works only if the sclp command in head.S
was succesful. Since the sclp command is skipped if diag260 works,
we don't have any dump feature detection anymore.
Bug was introduced with d57de5a36791cb1b7285649c62f183b0d3505f7d.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/head64.S |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletion(-)

diff -urpN linux-2.6/arch/s390/kernel/head64.S linux-2.6-patched/arch/s390/kernel/head64.S
--- linux-2.6/arch/s390/kernel/head64.S	2007-01-26 17:27:27.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/head64.S	2007-01-26 17:27:55.000000000 +0100
@@ -81,7 +81,6 @@ startup_continue:
 	aghi	%r1,1			# size is one more than end
 	larl	%r2,memory_chunk
 	stg	%r1,8(%r2)		# store size of chunk
-	j	.Ldonemem
 
 .Lslowmemdetect:
 	l	%r2,.Lrcp-.LPG1(%r13)	# Read SCP forced command word
@@ -156,6 +155,11 @@ startup_continue:
 #
 # find memory chunks.
 #
+	larl	%r9,memory_chunk	# skip tprot loop if diag260
+	lg	%r9,8(%r9)		# memory detection was successful
+	ltgr	%r9,%r9
+	jne	.Ldonemem
+
 	lgr	%r9,%r3			# end of mem
 	larl	%r1,.Lchkmem		# set program check address
 	stg	%r1,__LC_PGM_NEW_PSW+8
