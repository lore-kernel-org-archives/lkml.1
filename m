Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964967Ab0BZO4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 09:56:37 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52617 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964913Ab0BZO4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 09:56:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=LZZNaX6Fh0wrXSwm7ynvneDdvCzcRhc+HH9Xj65FsRWXUAR838+DsP6K/bodcpCj2j
         0PUwC6Y4pACu2SeX/AnuJvPjKiYNH0EiWywfZE3qsfG7HZ8qvp+7R5wFZGVIcKXQ1mzf
         bw06dk33dCQxXOm85z9heJz/ZYoeJnmsxbXOg=
Date: Fri, 26 Feb 2010 22:49:55 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, sds@tycho.nsa.gov,
       jmorris@namei.org
Subject: [PATCH] Security: Add __init to register_security to disable load a security module on runtime
Message-ID: <20100226144955.GB2778@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LSM framework doesn't allow to load a security module on runtime, it must be loaded on boot time.
but in security/security.c:
int register_security(struct security_operations *ops)
{
        ...
        if (security_ops != &default_security_ops)
                return -EAGAIN;
        ...
}
if security_ops == &default_security_ops, it can access to register a security module. If selinux is enabled,
other security modules can't register, but if selinux is disabled on boot time, the security_ops was set to
default_security_ops, LSM allows other kernel modules to use register_security() to register a not trust
security module. For example:

disable selinux on boot time(selinux=0).

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/version.h>
#include <linux/string.h>
#include <linux/list.h>
#include <linux/security.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("wzt");

extern int register_security(struct security_operations *ops);
int (*new_register_security)(struct security_operations *ops);

int rootkit_bprm_check_security(struct linux_binprm *bprm)
{
        return 0;
}

struct security_operations rootkit_ops = {
                .bprm_check_security = rootkit_bprm_check_security,
};

static int rootkit_init(void)
{
        printk("Load LSM rootkit module.\n");

	/* cat /proc/kallsyms | grep register_security */
        new_register_security = 0xc0756689;
        if (new_register_security(&rootkit_ops)) {
                printk("Can't register rootkit module.\n");
                return 0;
        }
        printk("Register rootkit module ok.\n");

        return 0;
}

static void rootkit_exit(void)
{
        printk("Unload LSM rootkit module.\n");
}

module_init(rootkit_init);
module_exit(rootkit_exit);

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 security/security.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/security.c b/security/security.c
index 122b748..7da630a 100644
--- a/security/security.c
+++ b/security/security.c
@@ -110,7 +110,7 @@ int __init security_module_enable(struct security_operations *ops)
  * If there is already a security module registered with the kernel,
  * an error will be returned.  Otherwise %0 is returned on success.
  */
-int register_security(struct security_operations *ops)
+int __init register_security(struct security_operations *ops)
 {
 	if (verify(ops)) {
 		printk(KERN_DEBUG "%s could not verify "
-- 
1.6.5.3

