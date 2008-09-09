Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbYIIHOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbYIIHOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbYIIHOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:14:14 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:21128 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbYIIHON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:14:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=De9uYNi8Hdk/XcfcFt1M8HsrL3GPwnt0KV9KTS8jfJEpCNx1IHbQRAikV3sEOKW9HI
         yEoZ1p9MJOqOS2DmJbhJFW2RCRpmNGuzK4fjvRs3ighnJFMefOC6wHtptOpan6Subacv
         lYDFAtOfpaDgSuhr68zF0VR0hsevjBMS0gWMw=
Date: Tue, 9 Sep 2008 09:14:07 +0200
From: Adam Tkac <vonsch@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc5] Allow set RLIMIT_NOFILE to RLIM_INFINITY
Message-ID: <20080909071406.GA3814@traged.atkac.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

when process wants set limit of open files to RLIM_INFINITY it gets
EPERM even if it has CAP_SYS_RESOURCE capability. Attached patch
should fix the problem. Please add me to CC of your responses because
I'm not member of list.

Regards, Adam

-- 
Adam Tkac

--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux26-openfiles.patch"

--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1458,8 +1458,14 @@ asmlinkage long sys_setrlimit(unsigned i
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

--RnlQjJ0d97Da+TV1--
