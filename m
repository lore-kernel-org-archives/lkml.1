Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbYCEOGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbYCEOGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 09:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbYCEOGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 09:06:32 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:48477 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYCEOGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 09:06:31 -0500
Date: Wed, 5 Mar 2008 08:06:24 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Andrew G. Morgan" <morgan@kernel.org>, Serge Hallyn <serue@us.ibm.com>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Paul Moore <paul.moore@hp.com>
Subject: Re: prctl(0x8) -> EINVAL [Was: 2.6.25-rc3-mm1]
Message-ID: <20080305140624.GA9128@sergelap.austin.ibm.com>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <47CE7B1F.3000208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CE7B1F.3000208@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Jiri Slaby (jirislaby@gmail.com):
> On 03/04/2008 10:19 AM, Andrew Morton wrote:
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc3/2.6.25-rc3-mm1/
>> +capabilities-implement-per-process-securebits.patch
>
> This probably causes userspace damage:
>
> dbus:
> prctl(0x8, 0x1, 0, 0, 0)                = -1 EINVAL (Invalid argument)
>
> named:
> named: -u with Linux threads not supported: requires kernel support for 
> prctl(PR_SET_KEEPCAPS)
> prctl(0x8, 0x1, 0, 0, 0)          = -1 EINVAL (Invalid argument)
>
> ntpd:
> prctl(0x8, 0x1, 0xffffffffffffffa8, 0x1, 0) = -1 EINVAL (Invalid argument)
> prctl(0x8, 0x1, 0, 0, 0)          = -1 EINVAL (Invalid argument)
>
> $ grep CONFIG_SECURITY .config
> # CONFIG_SECURITY is not set
> # CONFIG_SECURITY_FILE_CAPABILITIES is not set

Thanks, Jiri.  Does the following patch work for you?

This patch address the !CONFIG_SECURITY case, but not the case of
using the dummy LSM.  The default these days is to have capabilities
compiled in no matter what, but it is still possible to have
CONFIG_SECURITY=y and CONFIG_SECURITY_CAPABILITIES=n, in which
case prctl(0x8) will return -EINVAL.  Do we want dummy to call
cap_prctl() as well, or are we ok with userspace getting -EINVAL
given that there are in fact no capabilities at that point and
the userspace code is clearly expecting them?

thanks,
-serge

>From 4a66f19580489a3ac84f0a145e4585c09e65c88e Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Wed, 5 Mar 2008 06:02:32 -0800
Subject: [PATCH 1/1] capabilities: use cap_task_prctl when !CONFIG_SECURITY

capabilities-implement-per-process-securebits.patch introduced
cap_task_prctl() and moved the handling of capability-related
prctl into it.  So when !CONFIG_SECURITY, the default
security_task_prctl() needs to call cap_task_prctl() the way
other default hooks call capability helpers when they exist.

This fixes a slew of userspace breakages when
CONFIG_SECURITY=n.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 include/linux/security.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 83763b0..861d6da 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2228,7 +2228,7 @@ static inline int security_task_prctl (int option, unsigned long arg2,
 				       unsigned long arg4,
 				       unsigned long arg5, long *rc_p)
 {
-	return 0;
+	return cap_task_prctl(option, arg2, arg3, arg3, arg5, rc_p);
 }
 
 static inline void security_task_reparent_to_init (struct task_struct *p)
-- 
1.5.1

