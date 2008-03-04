Return-Path: <linux-kernel-owner+w=401wt.eu-S1762929AbYCDVsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762929AbYCDVsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:48:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbYCDVrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:47:52 -0500
Received: from smtp101.sbc.mail.re2.yahoo.com ([68.142.229.104]:33741 "HELO
	smtp101.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752586AbYCDVrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:47:52 -0500
X-YMail-OSG: xUlTmdYVM1mmFxjqn.xJyLD9EI4cKVWAPktdD24RJA9U8XKmEzLKqrfDN.HFt4S.ljRG40PVn3PTSNzTybHImi1jchT.2YYWDAHtVDh94kC99nZatCFJYA--
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 4 Mar 2008 15:45:00 -0600
From: serge@hallyn.com
To: "Leibowitz, Michael" <michael.leibowitz@intel.com>
Cc: serge@hallyn.com, linux-kernel@vger.kernel.org
Subject: Re: CLONE_NEWNS and bind mounts to make "chroot" jail
Message-ID: <20080304214500.GA7035@vino.hallyn.com>
References: <645B0EE4078B7C49A6C12F5E7B3B6C2603D3D607@orsmsx418.amr.corp.intel.com> <20080302022655.GA28450@vino.hallyn.com> <645B0EE4078B7C49A6C12F5E7B3B6C2603D3D7BF@orsmsx418.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <645B0EE4078B7C49A6C12F5E7B3B6C2603D3D7BF@orsmsx418.amr.corp.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Leibowitz, Michael (michael.leibowitz@intel.com):
> If I understand correctly, the following should accomplish what I'm
> looking for.  However, pivot_root gives me EBUSY.  I played around with
> moving the mount --bind /jail /jail to before the unshared, as well as
> making old_root a bind mount to itself.  However, pivot_root always
> seems to fail.  Is there something obvious that I'm doing wrong?  The

Yes, you
	cd /jail
	mount --bind /jail /jail
	pivot_root . old_root

but . is now mounted over.

-serge

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
> 
> Thanks. 
> 
> >Serge replies:
>  [snip...snip]
> >Try a few more things.  Since you had entered /jail, you can view '/'
> by
> >looking at .. .  But if you look at /, you dereference your
> >task->fsroot.  You never changed that, so it points to the original
> >mount.  If however you 'ls ..', you should see your 'jail' directory.
> >However it won't have the /bin and /lib mounted because you didn't
> >	mount --rbind /jail /
> >What you really want to do is
> >	mount --bind /jail /jail
> >to make sure it's a mountpoint, then set up the new /jail using bind
> >mounts like you're doing (and likely some rbinds in some places), then
> >use pivot_root() to change your root.  Then umount2("/old_root",
> >MNT_DETACH).
> >
> >-serge
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
