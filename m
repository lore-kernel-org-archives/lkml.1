Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbYCCPya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbYCCPya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 10:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbYCCPyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 10:54:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49560 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbYCCPyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 10:54:21 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: RE: CLONE_NEWNS and bind mounts to make "chroot" jail
To: Leibowitz@vger.kernel.org, Michael <michael.leibowitz@intel.com>,
       serge@hallyn.com, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Mon, 03 Mar 2008 16:54:15 +0100
References: <a2DnP-4KR-9@gated-at.bofh.it> <a2M7M-1rM-5@gated-at.bofh.it> <a3cOQ-1eQ-3@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JWCzY-0003zx-1z@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+f2XPlEmyia9Bxw37Deo6sgnrXChRfSNjJT7B
 SJtXPRkW5wbxi7xS87LTb1soXIoG+CfssujHGF2EM+2OnFsjaY
 B5xnNyjun5oVH5OxoJ9Iw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leibowitz, Michael <michael.leibowitz@intel.com> wrote:

> If I understand correctly, the following should accomplish what I'm
> looking for.  However, pivot_root gives me EBUSY.  I played around with
> moving the mount --bind /jail /jail to before the unshared, as well as
> making old_root a bind mount to itself.  However, pivot_root always
> seems to fail.  Is there something obvious that I'm doing wrong?  The
> following is my test code (error checking has been removed for clarity,
> except for pivot_root).
> 
>   char *newargv[]= { "sh", NULL };
> 
>   chdir("/jail");
>   unshare(CLONE_NEWNS));
>   mount("/jail", "/jail", NULL, MS_BIND, NULL));
>   mount("/bin", "bin", NULL, MS_BIND, NULL));
>   mount("/usr", "usr", NULL, MS_BIND, NULL));
>   mount("/lib", "lib", NULL, MS_BIND, NULL));
>   if (pivot_root(".", "old_root")) perror("pivot_root . old_root");
>   exec("./bash-static"); /* copied to /jail prior to running */

This works for me:

#include <sys/mount.h>
#include <unistd.h>

#define _GNU_SOURCE
#include <sched.h>

#define MNT_DETACH      2       /* Detach from tree only */

int main()
{
  unshare(CLONE_NEWNS);
  mount("jail", "jail", NULL, MS_BIND, NULL);
  mount("/bin", "jail/bin", NULL, MS_BIND, NULL);
  mount("/usr", "jail/usr", NULL, MS_BIND, NULL);
  mount("/lib", "jail/lib", NULL, MS_BIND, NULL);
  /* abuse bin as the temporary old root directory */
  if (pivot_root("jail", "jail/bin"))
    perror("pivot_root");
  chdir("/");
  umount2("bin", MNT_DETACH);
  execl("./sash", NULL); /* copied to /jail prior to running */
}


