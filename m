Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbYCGIj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbYCGIj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 03:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbYCGIjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 03:39:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:13948 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbYCGIjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:39:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type;
        b=MxyH2FLqWZrLda9OmpKOCN6XYmhwUi0Rp5uL95NLgNuBSa/brB7I5AfoQgnoy5017KTur5TlKuTkKka/8Ol+wYGUbLW0IdMzZ2AuzK8xh7RBJRNCFvT8g28wADA1W0RK4iF+uZ/Sbzxgpy/JYK4tXk3alR2JkHUGLBUm/6uFJb8=
Message-ID: <47D101E0.6040802@gmail.com>
Date: Fri, 07 Mar 2008 16:50:40 +0800
From: Peter Teoh <htmldeveloper@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Removing kernel_thread() from stop_machine.c
Content-Type: multipart/mixed;
 boundary="------------070900040103060102020904"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070900040103060102020904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


I replaced the kernel_thread() API in stop_machine.c as per document:   
Documentation/feature-removal-schedule.txt.

Please comment.





--------------070900040103060102020904
Content-Type: text/x-patch;
 name="remove_kernel_thread_stop_machine.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="remove_kernel_thread_stop_machine.patch"

Signed-off-by: Peter Teoh <htmldeveloper@gmail.com>

--- kernel/stop_machine.c.orig	2008-03-07 13:20:00.000000000 +0800
+++ kernel/stop_machine.c	2008-03-07 16:45:30.000000000 +0800
@@ -9,6 +9,7 @@
 #include <linux/stop_machine.h>
 #include <linux/syscalls.h>
 #include <linux/interrupt.h>
+#include <linux/kthread.h>
 
 #include <asm/atomic.h>
 #include <asm/semaphore.h>
@@ -92,6 +93,7 @@ static void stopmachine_set_state(enum s
 static int stop_machine(void)
 {
 	int i, ret = 0;
+	struct task_struct *task;
 
 	atomic_set(&stopmachine_thread_ack, 0);
 	stopmachine_num_threads = 0;
@@ -100,7 +102,8 @@ static int stop_machine(void)
 	for_each_online_cpu(i) {
 		if (i == raw_smp_processor_id())
 			continue;
-		ret = kernel_thread(stopmachine, (void *)(long)i,CLONE_KERNEL);
+		task = kthread_create(stopmachine, (void *)(long)i,"stopmachine");
+		ret = PTR_ERR(task);
 		if (ret < 0)
 			break;
 		stopmachine_num_threads++;

--------------070900040103060102020904--
