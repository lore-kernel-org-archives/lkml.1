Return-Path: <linux-kernel-owner+w=401wt.eu-S1761839AbZFPUM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761839AbZFPUM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755422AbZFPUMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:12:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58516 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759296AbZFPUMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:12:48 -0400
Date: Tue, 16 Jun 2009 22:07:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Eugene Teo <eugene@redhat.com>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>,
       solar@openwall.com, linux-kernel@vger.kernel.org
Subject: [PATCH] shift current_cred() from __f_setown() to f_modown()
Message-ID: <20090616200746.GA28663@redhat.com>
References: <4A36532E.3050006@redhat.com> <20090615174544.GA10467@redhat.com> <4A36E555.80206@redhat.com> <20090616183829.GA10027@redhat.com> <alpine.LFD.2.01.0906161224110.3282@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906161224110.3282@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shift current_cred() from __f_setown() to f_modown(). This reduces
the number of arguments and saves 48 bytes from fs/fcntl.o.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- a/fs/fcntl.c~f_modown	2009-04-06 00:03:41.000000000 +0200
+++ b/fs/fcntl.c	2009-06-16 21:41:18.000000000 +0200
@@ -196,15 +196,19 @@ static int setfl(int fd, struct file * f
 }
 
 static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
-                     uid_t uid, uid_t euid, int force)
+                     int force)
 {
 	write_lock_irq(&filp->f_owner.lock);
 	if (force || !filp->f_owner.pid) {
 		put_pid(filp->f_owner.pid);
 		filp->f_owner.pid = get_pid(pid);
 		filp->f_owner.pid_type = type;
-		filp->f_owner.uid = uid;
-		filp->f_owner.euid = euid;
+
+		if (pid) {
+			const struct cred *cred = current_cred();
+			filp->f_owner.uid = cred->uid;
+			filp->f_owner.euid = cred->euid;
+		}
 	}
 	write_unlock_irq(&filp->f_owner.lock);
 }
@@ -212,14 +216,13 @@ static void f_modown(struct file *filp, 
 int __f_setown(struct file *filp, struct pid *pid, enum pid_type type,
 		int force)
 {
-	const struct cred *cred = current_cred();
 	int err;
-	
+
 	err = security_file_set_fowner(filp);
 	if (err)
 		return err;
 
-	f_modown(filp, pid, type, cred->uid, cred->euid, force);
+	f_modown(filp, pid, type, force);
 	return 0;
 }
 EXPORT_SYMBOL(__f_setown);
@@ -245,7 +248,7 @@ EXPORT_SYMBOL(f_setown);
 
 void f_delown(struct file *filp)
 {
-	f_modown(filp, NULL, PIDTYPE_PID, 0, 0, 1);
+	f_modown(filp, NULL, PIDTYPE_PID, 1);
 }
 
 pid_t f_getown(struct file *filp)

