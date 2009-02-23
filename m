Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbZBWVWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbZBWVWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 16:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZBWVWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 16:22:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:4347 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbZBWVWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 16:22:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :content-type:content-transfer-encoding:message-id;
        b=gk+NhAbZ0cS5FWtZfeJbS5Xq3TO/Lo/5NEKYPzJ+TEtgj5SRHcy/GQ4pYURRlZA9bq
         LuAD6SEtAb/ypiPAcYAVkLoVk5XWry/L5ctS/llAtGRmPtURHuMvz23x+mU2EoHJfTyR
         BOSehnOVH/RzomzfHalqo/Uq7XqfBHpOaexP4=
From: Krzysztof Sachanowicz <analyzer1@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] proc: proc_get_inode should de_put when inode already initialized
Date: Mon, 23 Feb 2009 22:21:55 +0100
User-Agent: KMail/1.9.9
Cc: Marcin Pilipczuk <marcin.pilipczuk@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200902232221.55714.analyzer1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

de_get is called before every proc_get_inode, but corresponding de_put is 
called only when dropping last reference to an inode. This might cause 
something like
remove_proc_entry: /proc/stats busy, count=14496
to be printed to the syslog.

The fix is to call de_put in case of an already initialized inode in 
proc_get_inode.

Signed-off-by: Krzysztof Sachanowicz <analyzer1@gmail.com>
Tested-by: Marcin Pilipczuk <marcin.pilipczuk@gmail.com>
---
--- linux-2.6.29-rc6.orig/fs/proc/inode.c	2009-02-23 20:43:32.000000000 +0100
+++ linux-2.6.29-rc6/fs/proc/inode.c	2009-02-23 20:46:37.000000000 +0100
@@ -485,8 +485,10 @@ struct inode *proc_get_inode(struct supe
 			}
 		}
 		unlock_new_inode(inode);
-	} else
+	} else {
 	       module_put(de->owner);
+	       de_put(de);
+	}
 	return inode;
 
 out_ino:
