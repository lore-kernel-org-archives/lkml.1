Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbYILLGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbYILLGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 07:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbYILLGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 07:06:46 -0400
Received: from el-out-1112.google.com ([209.85.162.179]:51068 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbYILLGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 07:06:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sjkRIbCFiI+XvFbB62nS9caaZPQw2x1SruK1vbxuvBgYnw4/gTDEmYZDymIR0lEMtC
         QqXppInO+mJ5Pu6kaHfPoWuZTw7hbun860+yvk/h8y9KjqDwkfaoqkkYSBpaol6qjUcn
         yrlJVhyqyfW99CgkVbS2/5/qItRNiq6lw4JRg=
Date: Fri, 12 Sep 2008 13:06:39 +0200
From: Adam Tkac <vonsch@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: [PATCH 2.6.27-rc5] Allow set RLIMIT_NOFILE to RLIM_INFINITY
Message-ID: <20080912110639.GA2706@traged.atkac.englab.brq.redhat.com>
References: <20080909071406.GA3814@traged.atkac.englab.brq.redhat.com> <20080910143141.a3bc8258.akpm@linux-foundation.org> <20080911075438.GA2882@traged.atkac.englab.brq.redhat.com> <20080911122219.fd5fdf4c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080911122219.fd5fdf4c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a process wants to set the limit of open files to RLIM_INFINITY it
gets EPERM even if it has CAP_SYS_RESOURCE capability.
 
For example, BIND does:

...
#elif defined(NR_OPEN) && defined(__linux__)
        /*
         * Some Linux kernels don't accept RLIM_INFINIT; the maximum
         * possible value is the NR_OPEN defined in linux/fs.h.
         */
        if (resource == isc_resource_openfiles && rlim_value == RLIM_INFINITY) {
                rl.rlim_cur = rl.rlim_max = NR_OPEN;
                unixresult = setrlimit(unixresource, &rl);
                if (unixresult == 0)
                        return (ISC_R_SUCCESS);
        }
#elif ...

If we allow setting RLIMIT_NOFILE to RLIM_INFINITY we increase portability
- you don't have to check if OS is linux and then use different schema for
limits.

The spec says "Specifying RLIM_INFINITY as any resource limit value on a
successful call to setrlimit() shall inhibit enforcement of that resource
limit." and we're presently not doing that.

Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Adam Tkac <vonsch@gmail.com>
Tested-by: Adam Tkac <vonsch@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN kernel/sys.c~rlimit-permit-setting-rlimit_nofile-to-rlim_infinity kernel/sys.c
--- a/kernel/sys.c~rlimit-permit-setting-rlimit_nofile-to-rlim_infinity
+++ a/kernel/sys.c
@@ -1532,8 +1532,14 @@ asmlinkage long sys_setrlimit(unsigned i
 	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
 	    !capable(CAP_SYS_RESOURCE))
 		return -EPERM;
-	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
-		return -EPERM;
+	if (resource == RLIMIT_NOFILE) {
+		if (new_rlim.rlim_max == RLIM_INFINITY)
+			new_rlim.rlim_max = sysctl_nr_open;
+		if (new_rlim.rlim_cur == RLIM_INFINITY)
+			new_rlim.rlim_cur = sysctl_nr_open;
+		if (new_rlim.rlim_max > sysctl_nr_open)
+			return -EPERM;
+	}
 
 	retval = security_task_setrlimit(resource, &new_rlim);
 	if (retval)
