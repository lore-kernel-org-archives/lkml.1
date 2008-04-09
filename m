Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbYDIT7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbYDIT7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 15:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbYDIT7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 15:59:43 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:53707 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbYDIT7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 15:59:42 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 9 Apr 2008 12:59:37 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: signalfd() not handling sigqueue() sigval data correctly
In-Reply-To: <47FBDF12.8090400@gmail.com>
Message-ID: <Pine.LNX.4.64.0804091256490.6235@alien.or.mcafeemobile.com>
References: <47FBDF12.8090400@gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2008, Michael Kerrisk wrote:

> Hi Davide,
> 
> I was doing some playing about with signalfd(), and seem to have encountered a
> bug: when a signalfd read() fetches data for a signal that was sent by
> sigqueue(), the data accompanying the signal is not returned.  Instead
> ssi_int/ssi_ptr is zero.

Michael, can you give the patch below a spin? I tested it on my x86_64 box 
and seems to be working fine:

Got signal 44
   ssi_code= -1
   ssi_pid = 6314
   ssi_uid = 1000
   ssi_int = 123
   ssi_ptr = 7b




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
 
