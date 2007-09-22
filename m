Return-Path: <linux-kernel-owner+w=401wt.eu-S1761048AbXIVICe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761048AbXIVICe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 04:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbXIVICW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 04:02:22 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:60729 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbXIVICV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 04:02:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=crhV2r6mZOnnSZb+5M2BQvVgDgqGe/wNEcciHtqB+gpTidUYPciEEBOrYULEm+Vq2sdVRDOrvQLxMKoDjvkx9ouNKRQ0+mS7NLc/kjzCi3HZd2DmNO/PhdSDZfFau2TeV28fS0mfkavjpflFaAMdpgYgrpognVtbZ2RFM83kEaM=
Date: Sat, 22 Sep 2007 16:01:24 +0800
From: lepton <ytht.net@gmail.com>
To: jdike@karaya.com
Cc: lkm <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] 2.6.22.6 user-mode linux: before abort, we make it sure all children quit
Message-ID: <20070922080124.GA7431@router.lepton.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  In a stock 2.6.22.6 kernel, poweroff a user mode linux guest
(2.6.22.6 running in skas0 mode) will halt the host linux. I
think the reason is the kernel thread abort because of a bug.
Then the sys_reboot in process of user mode linux guest is
not trapped by the user mode linux kernel and is executed by host.
  I think it is better to make sure all of our children process
to quit when user mode linux kernel abort.

Signed-off-by: Lepton Wu <ytht.net@gmail.com>

diff -X linux-2.6.22.6/Documentation/dontdiff -pru linux-2.6.22.6/arch/um/os-Linux/util.c linux-2.6.22.6-lepton/arch/um/os-Linux/util.c
--- linux-2.6.22.6/arch/um/os-Linux/util.c	2007-09-14 17:41:10.000000000 +0800
+++ linux-2.6.22.6-lepton/arch/um/os-Linux/util.c	2007-09-22 13:56:05.000000000 +0800
@@ -106,5 +106,6 @@ int setjmp_wrapper(void (*proc)(void *, 
 void os_dump_core(void)
 {
 	signal(SIGSEGV, SIG_DFL);
+	kill(0, SIGTERM);
 	abort();
 }
