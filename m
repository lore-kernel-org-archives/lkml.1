Return-Path: <linux-kernel-owner+w=401wt.eu-S1758321AbYCUWRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321AbYCUWRD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYCUWQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:16:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:37276 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbYCUWQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:16:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=Ad9RZffRhdeeaYR3Rxw5DtSuMgbGPdySGCU5LltRD3XiKEjYgy4qQj40QPGSu/c+WM1nliSTqxoZgO9ie0RlsGwXvvcVMPD6J5mhXOsrMJ2U40cbUZm1oCSRsS8c/Y31qzIERCkC665n+B7TAeAcMfRJKglIO0ad4oBKuLTCex8=
Date: Fri, 21 Mar 2008 23:16:46 +0100 (CET)
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: Patrick Mochel <mochel@osdl.org>,
       Patrick Mochel <mochelp@infinity.powertie.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH][RFC] fix small mem leak in driver_add_kobj()
Message-ID: <alpine.LNX.1.00.0803212309520.10052@dragon.funnycrock.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

The Coverity checker spotted that we leak the storage allocated to 'name' 
in int driver_add_kobj().
The leak looks legit to me - this is the code : 

int driver_add_kobj(struct device_driver *drv, struct kobject *kobj,
                    const char *fmt, ...)
{
        va_list args;
        char *name;
        int ret;

        va_start(args, fmt);
        name = kvasprintf(GFP_KERNEL, fmt, args);
        ^^^^^^^^ This dynamically allocates space...

        va_end(args);

        if (!name)
                return -ENOMEM;

        return kobject_add(kobj, &drv->p->kobj, "%s", name);
	^^^^^^^^ This neglects to free the space allocated
}

Inside kobject_add() a copy of 'name' will be made and used. 
As far as I can see, Coverity is correct in flagging this as a leak, but 
I'd like some configmation before the patch is applied.

This should fix it : 


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 driver.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index bf31a01..9a6537f 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -133,6 +133,7 @@ int driver_add_kobj(struct device_driver *drv, struct kobject *kobj,
 {
 	va_list args;
 	char *name;
+	int ret;
 
 	va_start(args, fmt);
 	name = kvasprintf(GFP_KERNEL, fmt, args);
@@ -141,7 +142,9 @@ int driver_add_kobj(struct device_driver *drv, struct kobject *kobj,
 	if (!name)
 		return -ENOMEM;
 
-	return kobject_add(kobj, &drv->p->kobj, "%s", name);
+	ret = kobject_add(kobj, &drv->p->kobj, "%s", name);
+	kfree(name);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(driver_add_kobj);
 


