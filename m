Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbXIWM2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbXIWM2B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 08:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbXIWM1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 08:27:54 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:53415 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbXIWM1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 08:27:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=cYN87QRcCu3Edt3YisMC2Fmjfvr4U1lPeN284Q9M9PPSXnyxpDC/dPYUQGke7V8styFN16My5KcX8hyBFR3orXPlMY8dU4weGKV7w4TC/rQ+sJFRcNvVFiGWUQOXaKVtpZ7SZ1Ku5UV4m2+TVOnkbZplraLIXjE/RIwedELQlGc=
Date: Sun, 23 Sep 2007 20:26:53 +0800
From: lepton <ytht.net@gmail.com>
To: jdike@karaya.com
Cc: lkm <linux-kernel@vger.kernel.org>
Subject: [PATCH] 2.6.22.6 user-mode linux: fix error in check_sysemu
Message-ID: <20070923122653.GA17386@router.lepton.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  it is a error do count++ here, it will let the following compare (after 8 lines)   " if (!count)" always be false.

Signed-off-by: Lepton Wu <ytht.net@gmail.com>

diff -X linux-2.6.22.6/Documentation/dontdiff -pr -U 8 linux-2.6.22.6/arch/um/os-Linux/start_up.c linux-2.6.22.6-uml/arch/um/os-Linux/start_up.c
--- linux-2.6.22.6/arch/um/os-Linux/start_up.c	2007-09-14 17:41:10.000000000 +0800
+++ linux-2.6.22.6-uml/arch/um/os-Linux/start_up.c	2007-09-23 20:14:08.000000000 +0800
@@ -250,17 +250,16 @@ static void __init check_sysemu(void)
 	non_fatal("Checking advanced syscall emulation patch for ptrace...");
 	pid = start_ptraced_child(&stack);
 
 	if((ptrace(PTRACE_OLDSETOPTIONS, pid, 0,
 		   (void *) PTRACE_O_TRACESYSGOOD) < 0))
 		fatal_perror("check_ptrace: PTRACE_OLDSETOPTIONS failed");
 
 	while(1){
-		count++;
 		if(ptrace(PTRACE_SYSEMU_SINGLESTEP, pid, 0, 0) < 0)
 			goto fail;
 		CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
 		if(n < 0)
 			fatal_perror("check_ptrace : wait failed");
 
 		if(WIFSTOPPED(status) && (WSTOPSIG(status) == (SIGTRAP|0x80))){
 			if (!count)
