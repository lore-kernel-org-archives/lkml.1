Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbYCCG6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbYCCG6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 01:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbYCCG6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 01:58:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:28300 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbYCCG5y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 01:57:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,436,1199692800"; 
   d="scan'208";a="260534798"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: CLONE_NEWNS and bind mounts to make "chroot" jail
Date: Sun, 2 Mar 2008 22:56:40 -0800
Message-ID: <645B0EE4078B7C49A6C12F5E7B3B6C2603D3D7BF@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20080302022655.GA28450@vino.hallyn.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: CLONE_NEWNS and bind mounts to make "chroot" jail
thread-index: Ach8DVfK0fYXvmm3S2a4Kjw+QODRgwA7DkGA
References: <645B0EE4078B7C49A6C12F5E7B3B6C2603D3D607@orsmsx418.amr.corp.intel.com> <20080302022655.GA28450@vino.hallyn.com>
From: "Leibowitz, Michael" <michael.leibowitz@intel.com>
To: <serge@hallyn.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 03 Mar 2008 06:56:40.0485 (UTC) FILETIME=[BB868550:01C87CFB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I understand correctly, the following should accomplish what I'm
looking for.  However, pivot_root gives me EBUSY.  I played around with
moving the mount --bind /jail /jail to before the unshared, as well as
making old_root a bind mount to itself.  However, pivot_root always
seems to fail.  Is there something obvious that I'm doing wrong?  The
following is my test code (error checking has been removed for clarity,
except for pivot_root).  

  char *newargv[]= { "sh", NULL };

  chdir("/jail");
  unshare(CLONE_NEWNS));
  mount("/jail", "/jail", NULL, MS_BIND, NULL));
  mount("/bin", "bin", NULL, MS_BIND, NULL));
  mount("/usr", "usr", NULL, MS_BIND, NULL));
  mount("/lib", "lib", NULL, MS_BIND, NULL));
  if (pivot_root(".", "old_root")) perror("pivot_root . old_root");
  exec("./bash-static"); /* copied to /jail prior to running */

Thanks. 

>Serge replies:
 [snip...snip]
>Try a few more things.  Since you had entered /jail, you can view '/'
by
>looking at .. .  But if you look at /, you dereference your
>task->fsroot.  You never changed that, so it points to the original
>mount.  If however you 'ls ..', you should see your 'jail' directory.
>However it won't have the /bin and /lib mounted because you didn't
>	mount --rbind /jail /
>What you really want to do is
>	mount --bind /jail /jail
>to make sure it's a mountpoint, then set up the new /jail using bind
>mounts like you're doing (and likely some rbinds in some places), then
>use pivot_root() to change your root.  Then umount2("/old_root",
>MNT_DETACH).
>
>-serge

--
Michael Leibowitz
Software Engineer, UMG
Intel Corporation
michael.leibowitz at intel.com


