Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbYDLVKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbYDLVKZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 17:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYDLVKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 17:10:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:5913 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbYDLVKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 17:10:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=qSSs1LPHYLXpsuMC4Yv8+SOPZJioznjI1Xn7YNfpStzjLFzG2XjnbIJojZWw9I6dUoUPvvd/Fp39i3eyFlgpLMn/BW1C1sUb9uAhQ9L8jnxOzCjhonjG+aMCKs07//SZHfSUneN39xoMqKXPNujTwJk339lEMOtWAxb1FNF2spA=
Date: Sun, 13 Apr 2008 01:05:46 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: minyard@acm.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ipmi: remove ->write_proc code
Message-ID: <20080412210546.GE9151@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IPMI code theoretically allows ->write_proc users, but nobody used this by far.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/char/ipmi/ipmi_msghandler.c |    9 ++++-----
 drivers/char/ipmi/ipmi_si_intf.c    |    6 +++---
 include/linux/ipmi_smi.h            |    2 +-
 3 files changed, 8 insertions(+), 9 deletions(-)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -1941,7 +1941,7 @@ static int stat_file_read_proc(char *page, char **start, off_t off,
 #endif /* CONFIG_PROC_FS */
 
 int ipmi_smi_add_proc_entry(ipmi_smi_t smi, char *name,
-			    read_proc_t *read_proc, write_proc_t *write_proc,
+			    read_proc_t *read_proc,
 			    void *data, struct module *owner)
 {
 	int                    rv = 0;
@@ -1968,7 +1968,6 @@ int ipmi_smi_add_proc_entry(ipmi_smi_t smi, char *name,
 	} else {
 		file->data = data;
 		file->read_proc = read_proc;
-		file->write_proc = write_proc;
 		file->owner = owner;
 
 		mutex_lock(&smi->proc_entry_lock);
@@ -1997,17 +1996,17 @@ static int add_proc_entries(ipmi_smi_t smi, int num)
 
 	if (rv == 0)
 		rv = ipmi_smi_add_proc_entry(smi, "stats",
-					     stat_file_read_proc, NULL,
+					     stat_file_read_proc,
 					     smi, THIS_MODULE);
 
 	if (rv == 0)
 		rv = ipmi_smi_add_proc_entry(smi, "ipmb",
-					     ipmb_file_read_proc, NULL,
+					     ipmb_file_read_proc,
 					     smi, THIS_MODULE);
 
 	if (rv == 0)
 		rv = ipmi_smi_add_proc_entry(smi, "version",
-					     version_file_read_proc, NULL,
+					     version_file_read_proc,
 					     smi, THIS_MODULE);
 #endif /* CONFIG_PROC_FS */
 
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2892,7 +2892,7 @@ static int try_smi_init(struct smi_info *new_smi)
 	}
 
 	rv = ipmi_smi_add_proc_entry(new_smi->intf, "type",
-				     type_file_read_proc, NULL,
+				     type_file_read_proc,
 				     new_smi, THIS_MODULE);
 	if (rv) {
 		printk(KERN_ERR
@@ -2902,7 +2902,7 @@ static int try_smi_init(struct smi_info *new_smi)
 	}
 
 	rv = ipmi_smi_add_proc_entry(new_smi->intf, "si_stats",
-				     stat_file_read_proc, NULL,
+				     stat_file_read_proc,
 				     new_smi, THIS_MODULE);
 	if (rv) {
 		printk(KERN_ERR
@@ -2912,7 +2912,7 @@ static int try_smi_init(struct smi_info *new_smi)
 	}
 
 	rv = ipmi_smi_add_proc_entry(new_smi->intf, "params",
-				     param_read_proc, NULL,
+				     param_read_proc,
 				     new_smi, THIS_MODULE);
 	if (rv) {
 		printk(KERN_ERR
--- a/include/linux/ipmi_smi.h
+++ b/include/linux/ipmi_smi.h
@@ -229,7 +229,7 @@ static inline void ipmi_free_smi_msg(struct ipmi_smi_msg *msg)
    directory for this interface.  Note that the entry will
    automatically be dstroyed when the interface is destroyed. */
 int ipmi_smi_add_proc_entry(ipmi_smi_t smi, char *name,
-			    read_proc_t *read_proc, write_proc_t *write_proc,
+			    read_proc_t *read_proc,
 			    void *data, struct module *owner);
 
 #endif /* __LINUX_IPMI_SMI_H */
-- 
1.5.3.7


