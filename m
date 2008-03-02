Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYCBC3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYCBC3t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 21:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYCBC3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 21:29:42 -0500
Received: from smtp112.sbc.mail.re2.yahoo.com ([68.142.229.93]:23995 "HELO
	smtp112.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751541AbYCBC3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 21:29:42 -0500
X-YMail-OSG: e2k4UksVM1kq7FyQAHMvYKt0w.Qikk0t4jkiK.PWqmc9dKNyAdBMVLv4eZSEbaQQ8xWHtaSPLbWMjlGtcWqmcrIX9e1j89YTSdF56LokDp2qwKrLNu9RXOtX111y7cluxHpQhsrBn0D6Dok-
X-Yahoo-Newman-Property: ymail-3
Date: Sat, 1 Mar 2008 20:26:56 -0600
From: serge@hallyn.com
To: "Leibowitz, Michael" <michael.leibowitz@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CLONE_NEWNS and bind mounts to make "chroot" jail
Message-ID: <20080302022655.GA28450@vino.hallyn.com>
References: <645B0EE4078B7C49A6C12F5E7B3B6C2603D3D607@orsmsx418.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <645B0EE4078B7C49A6C12F5E7B3B6C2603D3D607@orsmsx418.amr.corp.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Leibowitz, Michael (michael.leibowitz@intel.com):
> I have been trying to use the combination of CLONE_NEWNS and bind mounts
> to create a better (than) chroot jail.  I wish to have the ability to
> bind (ro will be possible in the future, I understand) certain
> directories into the jail (perhaps /bin, /lib, /usr), but not have
> parallel directories in the jail (no /etc, ..., /home). 
> 
> I have heard that this should be possible, but have yet to get a working
> solution.
> 
> I have tried something analogous to:

Try a few more things.  Since you had entered /jail, you can view '/' by
looking at .. .  But if you look at /, you dereference your
task->fsroot.  You never changed that, so it points to the original
mount.  If however you 'ls ..', you should see your 'jail' directory.
However it won't have the /bin and /lib mounted because you didn't
	mount --rbind /jail /
What you really want to do is
	mount --bind /jail /jail
to make sure it's a mountpoint, then set up the new /jail using bind
mounts like you're doing (and likely some rbinds in some places), then
use pivot_root() to change your root.  Then umount2("/old_root",
MNT_DETACH).

-serge

> chdir("/jail");
> unshare(CLONE_NEWNS);
> /* mount(8) syntax given for simplicity, but mount(2) used below */
> mount --bind / /jail/old_root
> mount --bind /jail/old_root/bin /jail/bin
> mount --bind /jail/old_root/usr /jail/usr
> mount --bind /jail/old_root/lib /jail/lib
> mount --bind /jail /               # does nothing?
> umount2("/old_root", MNT_DETACH);  # never happens.
> exec("bin/sh");
> 
> When bin/sh runs, I can still see old_root from /jail and the bind of
> /jail over / seems to have not done anything.  
> 
> Is it possible to create such a jail with bind mounts?  Is there a
> recommended method for doing so?  Thank you for your time.
> 
> --
> Michael Leibowitz
> Software Engineer, UMG
> Intel Corporation
> michael.leibowitz at intel.com
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
