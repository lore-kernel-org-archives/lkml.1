Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbZAZP2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbZAZP2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 10:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbZAZP2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 10:28:08 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:44162 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZAZP2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 10:28:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=PfBLFxUhanK2Ln1bFuFQQ9RZZ69xq7k4hX4t2R6GRudLmVkvTvVepQR07g/7tXyS+j
         Ewt62kZkpKc0WqFw7uW7VgkMZaiiKn8l3eTdOLAfCRfG4+euTJWD9Yt/U1L43fTe3CK3
         eIECCY669qGA7y+r+1vrcw315Fo6ng3L7Pqrs=
Date: Mon, 26 Jan 2009 18:28:02 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH -tip] x86: ftrace - simplify wait_for_nmi
Message-ID: <20090126152802.GA12465@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of 'waited' stack variable.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/ftrace.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/ftrace.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/ftrace.c
+++ linux-2.6.git/arch/x86/kernel/ftrace.c
@@ -133,15 +133,14 @@ void ftrace_nmi_exit(void)
 
 static void wait_for_nmi(void)
 {
-	int waited = 0;
+	if (!atomic_read(&in_nmi))
+		return;
 
-	while (atomic_read(&in_nmi)) {
-		waited = 1;
+	do {
 		cpu_relax();
-	}
+	} while(atomic_read(&in_nmi));
 
-	if (waited)
-		nmi_wait_count++;
+	nmi_wait_count++;
 }
 
 static int
