Return-Path: <linux-kernel-owner+w=401wt.eu-S1757634AbYG3Vnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbYG3Vnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbYG3VnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:43:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:4178 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbYG3VnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:43:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=dYtwkUvBJqV46i8v3CVzKVEuoA8gIUCnBDQ/3Ymal4utjY4720qaihsDFeVsTcwAka
         W3IMGK37O71o8lSCd+7A3lLXc4X2naonr+7A0YYo0GJoeGeCeD5QHFePDBnA1hW1eDpy
         AqpLm/g9GALWwhyTJM8ekOfWLesU+G+iEnSho=
Message-ID: <4890E077.30507@gmail.com>
Date: Wed, 30 Jul 2008 23:43:19 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Anders Johansson <ajohansson@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] making /proc/<pid>/limits writable
References: <200807302157.46261.ajohansson@suse.de>
In-Reply-To: <200807302157.46261.ajohansson@suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2008 09:57 PM, Anders Johansson wrote:
> (For any replies, please cc. me, because I'm not subscribed)
> 
> Attached is a patch making the limits for a process writable, so it is 
> possible to change the limits of a task other than current.
> 
> There are many reasons why this is desirable. The core limit is to me the most 
> important. If a process hangs, because of some sort of race condition that 
> happens once in a blue moon, and ulimit -c is set to 0, it might take forever 
> to reproduce. It would be nice to be able to change that limit dynamically, to 
> be able to get a core dump.
> 
> Other limits should also be settable, but for now I've only done core size.
> 
> The patch is against 2.6.27-rc1
> 
> btw, in case it isn't painfully obvious: this is my very first kernel patch 
> that isn't a simple one-or-two-line bug fix


diff -ur a/fs/proc/base.c b/fs/proc/base.c
--- a/fs/proc/base.c	2008-07-30 21:44:44.000000000 +0200
+++ b/fs/proc/base.c	2008-07-30 21:53:07.000000000 +0200
@@ -423,6 +423,76 @@

  #endif

+static ssize_t pid_limits_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *offs)
+{
+	int ret = 0;
+	struct task_struct *task;
+
+	if (!count)
+		goto out_no_task;

Mixing decls with code causes warnings.

+	char c;
+	char *s = buf, *tmp;

This is sparse unfriendly. Try to build with C=1. This must have generate a 
compiler warning too (about the const).

+	char buffer[256];
+	unsigned long softlim, hardlim;
+	char hardlim_set = 0;
+
+	task = get_proc_task(file->f_dentry->d_inode);
+	if (!task) {
+		ret = -ESRCH;
+		goto out_no_task;
+	}
+	if (get_user(c, s)) {
+		ret = -EFAULT;
+		goto out;
+	}
+	s += 2;
+	switch (c) {
+		case 'c': {

I think this indent is not scripts/checkpatch.pl compliant as suggested by some 
people already.

+			if (copy_from_user(buffer, s, 255)) {

Hmm, does this work? It should return unable-to-copy bytes which would mean to 
return 255-count-2. Some kind of min(count-2, 255U); is needed here, I think.

+				ret = -EFAULT;
+				goto out;
+			}
+			if (strncmp(buffer, "unlimited", 9) == 0)
+				softlim = RLIM_INFINITY;
+			else {
+				softlim = strict_strtoul(buffer, &tmp, 10);

This doesn't compile, I suppose? Anyway you need buffer[255] = '\0'; somewhere 
before this.

+				if (tmp == buffer) {
+					ret = -EFAULT;
+					goto out;
+				}
+				softlim *= 1024;
+			}
+			if ((tmp - buffer) < count) {

"Use of unitialized value" here? tmp & unlimited path.

