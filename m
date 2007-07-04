Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbXGDGYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbXGDGYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 02:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbXGDGYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 02:24:13 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:7809 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbXGDGYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 02:24:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=Da+0YWra0PxTNHvn//fR80cc/fL6DvA6LuihLCv4jB2P8lmlJXfiwSC5UEdYrcge5p9Y3Mp/Oa6zIuaw8M89KLG3rzD0coFsfgWQXKiK/DtMejR/v0CZP/ypepRMWPAh9B9C+Q03WbX7+E6L/M+HUWZmPljdGiikKQRdAIxorEY=
Message-ID: <468B3CFF.7020903@gmail.com>
Date: Wed, 04 Jul 2007 15:23:59 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       yi.zhu@intel.com, jketreno@linux.intel.com,
       linux-wireless@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1 -- BUG - EIP: [<c01a77a1>] sysfs_addrm_finish+0x1c2/0x226
 SS:ESP 0068:c5ff9db8
References: <a44ae5cd0707030932h16a90ca3j8ad65b7a3ec64b03@mail.gmail.com> <20070703094916.e60d4df7.akpm@linux-foundation.org>
In-Reply-To: <20070703094916.e60d4df7.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------090209030609060901000508"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090209030609060901000508
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

Andrew Morton wrote:
>> EIP is at sysfs_addrm_finish+0x1c2/0x226
>> eax: 00000001   ebx: c5ff9dc0   ecx: c058aa40   edx: 00000001
>> esi: c5ff9de8   edi: c37c3240   ebp: c5ff9e1c   esp: c5ff9db8
>> ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
>> Process modprobe (pid: 3519, ti=c5ff9000 task=c5ef15e0 task.ti=c5ff9000)
>> Stack: c03a3eda c5ff9e24 00000000 00000001 dead4ead ffffffff ffffffff c0657cf0
>>        00000000 c046359d c5ff9de0 c5ff9de0 00000000 00000001 dead4ead ffffffff
>>        ffffffff c0657cf0 00000000 c046359d c5ff9de0 c5ff9de0 c37c3240 c5ff9e24
>> Call Trace:
>>  [<c01a7833>] remove_dir+0x2e/0x35
>>  [<c01a7894>] __sysfs_remove_dir+0x5a/0x61
>>  [<c01a78d1>] sysfs_remove_dir+0x2c/0x30

Hmm... That's weird.  I tried to regenerate it here but mine unloads
happily.  Can you apply the attached patch and report the resulting
messages when oops happens?

Thanks.

-- 
tejun

--------------090209030609060901000508
Content-Type: text/plain;
 name="debug"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="debug"

---
 fs/sysfs/dir.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: tree0/fs/sysfs/dir.c
===================================================================
--- tree0.orig/fs/sysfs/dir.c
+++ tree0/fs/sysfs/dir.c
@@ -268,6 +268,9 @@ static void sysfs_deactivate(struct sysf
 	DECLARE_COMPLETION_ONSTACK(wait);
 	int v;
 
+	if (sd->s_sibling || !(sd->s_flags & SYSFS_FLAG_REMOVED))
+		printk("XXX sysfs_deactivate: sd=%p s_sibling=%p s_flags=0x%x\n",
+		       sd, sd->s_sibling, sd->s_flags);
 	BUG_ON(sd->s_sibling || !(sd->s_flags & SYSFS_FLAG_REMOVED));
 	sd->s_sibling = (void *)&wait;
 
@@ -530,6 +533,9 @@ void sysfs_remove_one(struct sysfs_addrm
 		drop_nlink(acxt->parent_inode);
 
 	acxt->cnt++;
+
+	printk("XXX sysfs_remove_one: acxt=%p sd=%p s_flags=0x%x cnt=%d\n",
+	       acxt, sd, sd->s_flags, acxt->cnt);
 }
 
 /**
@@ -624,6 +630,8 @@ int sysfs_addrm_finish(struct sysfs_addr
 		acxt->removed = sd->s_sibling;
 		sd->s_sibling = NULL;
 
+		printk("XXX sysfs_addrm_finish: acxt=%p sd=%p s_sibling=%p s_flags=0x%x\n",
+		       acxt, sd, sd->s_sibling, sd->s_flags);
 		sysfs_drop_dentry(sd);
 		sysfs_deactivate(sd);
 		sysfs_put(sd);

--------------090209030609060901000508--
