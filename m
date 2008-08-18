Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbYHRACQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbYHRACQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 20:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYHRACA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 20:02:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37190 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbYHRAB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 20:01:59 -0400
Date: Mon, 18 Aug 2008 10:01:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, David Fries <david@fries.net>,
       David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: origin tree build failure
Message-Id: <20080818100151.c2e9e508.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

As expected (reported by David Fries), today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from include/linux/tracehook.h:52,
                 from arch/powerpc/kernel/signal.c:13:
include/linux/security.h: In function 'security_ptrace_traceme':
include/linux/security.h:1760: error: 'parent' undeclared (first use in this function)

Caused by commit 5cd9c58fbe9ec92b45b27e131719af4f2bd9eb40 ("security: Fix
setting of PF_SUPERPRIV by __capable()").  The version of this commit
that has been in the linux-next tree from Aug 8 to Aug 15 is correct, so
I have no idea what happened.

More care needed ...

I applied the following patch from David Fries.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

Date: Sat, 16 Aug 2008 20:17:11 -0500
From: David Fries <david@fries.net>
To: David Howells <dhowells@redhat.com>
Cc: sfr@canb.auug.org.au, jmorris@namei.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Fix setting of PF_SUPERPRIV by __capable()

The first two submissions this patch had parent for the argument, the third
one has child then parent and fails to compile with SECURITY disabled.
Please apply the following patch.

> +static inline int security_ptrace_traceme(struct task_struct *child)
>  {
> -	return cap_ptrace(parent, child, mode);
> +	return cap_ptrace_traceme(parent);
>  }

    security_ptrace_traceme error: 'parent' undeclared

    s/child/parent/

    Signed-off-by: David Fries <david@fries.net>

diff --git a/include/linux/security.h b/include/linux/security.h
index 2ee5ecf..80c4d00 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1755,7 +1755,7 @@ static inline int security_ptrace_may_access(struct task_struct *child,
 	return cap_ptrace_may_access(child, mode);
 }
 
-static inline int security_ptrace_traceme(struct task_struct *child)
+static inline int security_ptrace_traceme(struct task_struct *parent)
 {
 	return cap_ptrace_traceme(parent);
 }

