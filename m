Return-Path: <linux-kernel-owner+w=401wt.eu-S1030270AbXBGEPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030270AbXBGEPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 23:15:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965615AbXBGEPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 23:15:13 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33496 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965639AbXBGEPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 23:15:11 -0500
Date: Tue, 6 Feb 2007 20:15:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ken.cole@bownetworks.com
Cc: "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 7955] New: rootfstype used with linuxrc of
 different fs type fails to start
Message-Id: <20070206201503.2391ab54.akpm@linux-foundation.org>
In-Reply-To: <200702070252.l172qDEY018115@fire-2.osdl.org>
References: <200702070252.l172qDEY018115@fire-2.osdl.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Feb 2007 18:52:13 -0800 bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=7955
> 
>            Summary: rootfstype used with linuxrc of different fs type fails
>                     to start
>     Kernel Version: 2.6.12
>             Status: NEW
>           Severity: normal
>              Owner: fs_other@kernel-bugs.osdl.org
>          Submitter: ken.cole@bownetworks.com
> 
> 
> Most recent kernel where this bug did *NOT* occur:
> Distribution:
> Mandriva Corporate 3.0
> Hardware Environment:
> x86
> Software Environment:
> Mandriva Corp 30
> Problem Description:
> 
> Steps to reproduce:
> (1) Create initial ram disk image file using one filesystem (say, for eg. ext2)
> (2) Create linuxrc file that redirects /dev/root to other filesystem (say ext3)
>          ...
>          echo Mounting /proc filesystem
>          mount -t proc /proc /proc
>          echo Creating device files
>          mkdevices /dev
>          echo Mounting sysfs
>          mount -t sysfs none /sys
>          echo Creating root device
>          echo 0x0306 > /proc/sys/kernel/real-root-dev
>          mkrootdev /dev/root
>          umount /sys
>          umount /proc
> (3) Set bootloader append line to include "root=3:6 rootfstype=ext3"
>    where 3:6 is the real root filesystem
> (4) Boot with the above initrd image and append line.
> Result:
> VFS: Cannot open root device "ram" or unknown_block(1,0)
> 
> My expectation was that initrd would be mounted ext2 followed by execution of
> linuxrc nash script followed by mounting device "3:6" using ext3 type.  However,
> the initrd was detected and loaded as ext2 but then gave error listed above.
> 
> The 'rootfstype' option seems to confuse the initial RAM disk load which had
> previously loaded the "ext2" RAM disk image.  The following patch to
> init/do_mounts.c allows the initrd image to remain ext2 while the real file
> system type obeys 'rootfstype' append line option.
> 
>  void __init mount_block_root(char *name, int flags)
>  {
> +static char const default_fs[] = "ext2\000\000";
>         char *fs_names = __getname();
>         char *p;
>         char b[BDEVNAME_SIZE];
> 
> -       get_fs_names(fs_names);
> +        if (   strstr(name, ".old") )
> +            memcpy(fs_names, default_fs, sizeof(default_fs));
> +        else
> +           get_fs_names(fs_names);
>  retry:
>         for (p = fs_names; *p; p += strlen(p)+1) {
>                 int err = do_mount_root(name, p, flags, root_mount_data);
> 

We'd of course prefer to not hardcode the fstype like this.  Perhaps someone
else has time to look into this, or to suggest a solution?
