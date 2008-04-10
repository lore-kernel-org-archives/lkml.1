Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbYDJS55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbYDJS55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 14:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbYDJS5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 14:57:51 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:56366 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbYDJS5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 14:57:50 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 10 Apr 2008 11:57:44 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: [patch] signalfd fix for incorrect SI_QUEUE user data reporting
Message-ID: <Pine.LNX.4.64.0804101152090.9668@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk found out that signalfd was not reporting back user data 
pushed using sigqueue:

http://groups.google.com/group/linux.kernel/msg/9397cab8551e3123

The following patch makes signalfd to report back the ssi_ptr and ssi_int 
members of the signalfd_siginfo structure.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/signalfd.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6.mod/fs/signalfd.c
===================================================================
--- linux-2.6.mod.orig/fs/signalfd.c	2008-04-09 11:53:37.000000000 -0700
+++ linux-2.6.mod/fs/signalfd.c	2008-04-09 12:05:46.000000000 -0700
@@ -111,9 +111,14 @@
 		err |= __put_user(kinfo->si_uid, &uinfo->ssi_uid);
 		err |= __put_user((long) kinfo->si_ptr, &uinfo->ssi_ptr);
 		break;
-	default: /* this is just in case for now ... */
+	default:
+		/*
+		 * This case catches also the signals queued by sigqueue().
+		 */
 		err |= __put_user(kinfo->si_pid, &uinfo->ssi_pid);
 		err |= __put_user(kinfo->si_uid, &uinfo->ssi_uid);
+		err |= __put_user((long) kinfo->si_ptr, &uinfo->ssi_ptr);
+		err |= __put_user(kinfo->si_int, &uinfo->ssi_int);
 		break;
 	}
 
