Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab0CCEiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 23:38:52 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:55703 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab0CCEiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 23:38:51 -0500
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
References: <20100302230933.GA32287@kroah.com>
	<1267572541-410-19-git-send-email-gregkh@suse.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 02 Mar 2010 20:38:45 -0800
In-Reply-To: <1267572541-410-19-git-send-email-gregkh@suse.de> (Greg Kroah-Hartman's message of "Tue\,  2 Mar 2010 15\:28\:18 -0800")
Message-ID: <m1635eow8a.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>, Linus Torvalds
	<torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 19/62] Driver-Core: devtmpfs - remove EXPERIMENTAL and enable it by default
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@suse.de> writes:

> From: Kay Sievers <kay.sievers@vrfy.org>
>
> All major distros enable devtmpfs on recent systems, so remove
> the EXPERIMENTAL flag, and enable it by default to reflect how it
> is used today.

Default y?

Default y is the wrong thing for DEVTMPFS_MOUNT.  It changes the
userspace semantics so I can't see how this is safe in the general
case.

I also looked and the most recent bleeding edge distro I have fedora
core 12 doesn't even compile in devtmpfs so this extraordinary claim
that all major distros are using devtmpfs is far from true today.  It
is certainly rare enough that changing there is not yet justification
for changing the default.

Eric

>
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/base/Kconfig |   45 ++++++++++++++++++++++++++++-----------------
>  1 files changed, 28 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index ee37727..8497ce9 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -9,29 +9,40 @@ config UEVENT_HELPER_PATH
>  	  every uevent.
>  
>  config DEVTMPFS
> -	bool "Create a kernel maintained /dev tmpfs (EXPERIMENTAL)"
> +	bool "Maintain a devtmpfs filesystem to mount at /dev"
>  	depends on HOTPLUG && SHMEM && TMPFS
> +	default y
>  	help
> -	  This creates a tmpfs filesystem, and mounts it at bootup
> -	  and mounts it at /dev. The kernel driver core creates device
> -	  nodes for all registered devices in that filesystem. All device
> -	  nodes are owned by root and have the default mode of 0600.
> -	  Userspace can add and delete the nodes as needed. This is
> -	  intended to simplify bootup, and make it possible to delay
> -	  the initial coldplug at bootup done by udev in userspace.
> -	  It should also provide a simpler way for rescue systems
> -	  to bring up a kernel with dynamic major/minor numbers.
> -	  Meaningful symlinks, permissions and device ownership must
> -	  still be handled by userspace.
> -	  If unsure, say N here.
> +	  This creates a tmpfs filesystem instance early at bootup.
> +	  In this filesystem, the kernel driver core maintains device
> +	  nodes with their default names and permissions for all
> +	  registered devices with an assigned major/minor number.
> +	  Userspace can modify the filesystem content as needed, add
> +	  symlinks, and apply needed permissions.
> +	  It provides a fully functional /dev directory, where usually
> +	  udev runs on top, managing permissions and adding meaningful
> +	  symlinks.
> +	  In very limited environments, it may provide a sufficient
> +	  functional /dev without any further help. It also allows simple
> +	  rescue systems, and reliably handles dynamic major/minor numbers.
> +	  If unsure, say Y here.
>  
>  config DEVTMPFS_MOUNT
> -	bool "Automount devtmpfs at /dev"
> +	bool "Automount devtmpfs at /dev, after the kernel mounted the rootfs"
>  	depends on DEVTMPFS
> +	default y
>  	help
> -	  This will mount devtmpfs at /dev if the kernel mounts the root
> -	  filesystem. It will not affect initramfs based mounting.
> -	  If unsure, say N here.
> +	  This will instruct the kernel to automatically mount the
> +	  devtmpfs filesystem at /dev, directly after the kernel has
> +	  mounted the root filesystem. The behavior can be overridden
> +	  with the commandline parameter: devtmpfs.mount=0|1.
> +	  This option does not affect initramfs based booting, here
> +	  the devtmpfs filesystem always needs to be mounted manually
> +	  after the roots is mounted.
> +	  With this option enabled, it allows to bring up a system in
> +	  rescue mode with init=/bin/sh, even when the /dev directory
> +	  on the rootfs is completely empty.
> +	  If unsure, say Y here.
>  
>  config STANDALONE
>  	bool "Select only drivers that don't need compile-time external firmware" if EXPERIMENTAL
> -- 
> 1.7.0.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
