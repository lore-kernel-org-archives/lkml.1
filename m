Return-Path: <linux-kernel-owner+w=401wt.eu-S1752538AbYKSC7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbYKSC7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 21:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbYKSC7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 21:59:32 -0500
Received: from mail-gx0-f11.google.com ([209.85.217.11]:58799 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbYKSC7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 21:59:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type
         :content-transfer-encoding:from;
        b=mvl3jUVRfiv0xwJkM0HQpZFlg6wyDVDb1Uaokj/Xsxev6EFOYTNCccGKGCDhmK0792
         pAqiUWxe8PTi0Sz+N8WR6w0fQSTc/If17dXa+f9lGd2u8bQpksdXzsJ5grhDnvd/0X4p
         +YKBcXy+N3T1LCynZKdlIvz4QxUsEXTzwQAWU=
Message-ID: <4923810B.7010201@gmail.com>
Date: Tue, 18 Nov 2008 21:59:23 -0500
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>, Kir Kolyshkin <kir@openvz.org>
CC: linux-man@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Documentation for CLONE_NEWPID
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel, Kir,

Drawing fairly heavily on your LWN.net article (http://lwn.net/Articles/259217/), plus the kernel source and some experimentation, I created the patch below to document CLONE_NEWPID for the clone(2) manual page.  Could you please review and let me know of any improvements or inaccuracies.

Thanks,

Michael

--- a/man2/clone.2
+++ b/man2/clone.2
@@ -266,6 +268,78 @@ in the same
 .BR clone ()
 call.
 .TP
+.BR CLONE_NEWPID " (since Linux 2.6.24)"
+.\" This explanation draws a lot of details from
+.\" http://lwn.net/Articles/259217/
+.\" Authors: Pavel Emelyanov <xemul@openvz.org>
+.\" and Kir Kolyshkin <kir@openvz.org>
+.\"
+.\" The primary kernel commit is 30e49c263e36341b60b735cbef5ca37912549264
+.\" Author: Pavel Emelyanov <xemul@openvz.org>
+If
+.B CLONE_PID
+is set, then create the process in a new PID namespace.
+If this flag is not set, then (as with
+.BR fork (2)),
+the process is created in the same PID namespace as
+the calling process.
+This flag is intended for the implementation of control groups.
+
+A PID namespace provides an isolated environment for PIDs:
+PIDs in a new namespace start at 1,
+somewhat like a standalone system, and calls to
+.BR fork (2),
+.BR vfork (2),
+or
+.BR clone (2)
+will produce processes whose PIDs within the namespace
+are only guaranteed to be unique within that namespace.
+
+The first process created in a new namespace
+(i.e., the process created using the
+.BR CLONE_NEWPID
+flag) has the PID 1, and is the "init" process for the namespace.
+Children that are orphaned within the namespace will be reparented
+to this process rather than
+.BR init (8).
+Unlike the traditional
+.B init
+process, the "init" process of a PID namespace can terminate,
+and if it does, all of the processes in the namespace are terminated.
+
+PID namespaces form a hierarchy.
+When a PID new namespace is created,
+the PIDs of the processes in that namespace are visible
+in the PID namespace of the process that created the new namespace;
+analogously, if the parent PID namespace is itself
+the child of another PID namespace,
+then PIDs of the child and parent PID namespaces will both be
+visible in the grandparent PID namespace.
+Conversely, the processes in the "child" PID namespace do not see
+the PIDs of the processes in the parent namespace.
+The existence of a namespace hierarchy means that each process
+may now have multiple PIDs:
+one for each namespace in which it is visible.
+(A call to
+.BR getpid (2)
+always returns the PID associated with the namespace in which
+the process was created.)
+
+After creating the new namespace,
+it is useful for the child to change its root directory
+and mount a new procfs instance at
+.I /proc
+so that tools such as
+.BR ps (1)
+work correctly.
+
+Use of this flag requires: a kernel configured with the
+.B CONFIG_PID_NS
+configuration option and requires that the process be privileged
+.RB (CAP_SYS_ADMIN ).
+This flag can't be specified in conjunction with
+.BR CLONE_THREAD .
+.TP
 .BR CLONE_PARENT " (since Linux 2.3.12)"
 If
 .B CLONE_PARENT
@@ -627,6 +701,14 @@ were specified in
 .IR flags .
 .TP
 .B EINVAL
+Both
+.BR CLONE_NEWPID
+and
+.BR CLONE_THREAD
+were specified in
+.IR flags .
+.TP
+.B EINVAL
 Returned by
 .BR clone ()
 when a zero value is specified for
@@ -639,6 +721,8 @@ copied.
 .TP
 .B EPERM
 .B CLONE_NEWNS
+or
+.B CLONE_NEWPID
 was specified by a non-root process (process without \fBCAP_SYS_ADMIN\fP).
 .TP
 .B EPERM
