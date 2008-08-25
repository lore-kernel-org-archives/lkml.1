Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbYHYMLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbYHYMLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 08:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbYHYMK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 08:10:59 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:53031 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbYHYMK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 08:10:58 -0400
Subject: Re: [PATCH 1/1] selinux: add support for installing a dummy policy
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: James Morris <jmorris@namei.org>, lkml <linux-kernel@vger.kernel.org>,
       SELinux <selinux@tycho.nsa.gov>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>
In-Reply-To: <20080823023812.GA30915@us.ibm.com>
References: <20080822193413.GA8401@us.ibm.com>
	 <alpine.LRH.1.10.0808230852320.24779@tundra.namei.org>
	 <20080823023812.GA30915@us.ibm.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 25 Aug 2008 08:10:01 -0400
Message-Id: <1219666201.2721.29.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-08-22 at 21:38 -0500, Serge E. Hallyn wrote:
> --- /dev/null
> +++ b/scripts/selinux/install_policy.sh
> @@ -0,0 +1,44 @@
> +#!/bin/sh
> +if [ `id -u` -ne 0 ]; then
> +	echo "$0: must be root to install the selinux policy"
> +	exit 1
> +fi
> +SF=`which setfiles`
> +if [ $? -eq 1 ]; then
> +	if [ -f /usr/sbin/setfiles ]; then
> +		SF="/usr/sbin/setfiles"

/sbin/setfiles on modern Fedora releases.

> +	else
> +		echo "no selinux tools installed: setfiles"
> +		exit 1
> +	fi
> +fi
> +
> +cd mdp
> +
> +CP=`which checkpolicy`
> +./mdp policy.conf file_contexts
> +$CP -o policy.`checkpolicy -V | awk '{print $1}'` policy.conf

Save version to a variable and reuse below.

> +
> +mkdir -p /etc/selinux/dummy/policy
> +mkdir -p /etc/selinux/dummy/contexts/files
> +
> +cp file_contexts /etc/selinux/dummy/contexts/files
> +cp dbus_contexts /etc/selinux/dummy/contexts
> +cp policy.`checkpolicy -V | awk '{print $1}'` /etc/selinux/dummy/policy
> +FC_FILE=/etc/selinux/dummy/contexts/files/file_contexts
> +
> +cd /etc/selinux/dummy/contexts/files
> +$SF file_contexts /
> +
> +mounts=`cat /proc/$$/mounts | egrep "ext2|ext3|xfs|jfs" | awk '{ print $2 '}`

ext4, ext4dev, gfs2 too.
See /sbin/fixfiles for an example.  Or run it.

> +for line in $mounts; do
> +	$SF file_contexts $line
> +done

You can pass them all to setfiles at once; it takes a list of mount
points after the file_contexts file. Or run fixfiles instead as it does
much the same.

However, I don't believe this step will work if you are doing this on an
existing SELinux-enabled system - the kernel will check the contexts
upon setxattr against the active policy and reject them, and you haven't
loaded the new policy yet.  Also, this is a "destructive" operation,
i.e. if they were running SELinux before, they are hereby clobbering all
their file labels.  Possibly you should bail out if selinuxenabled
(utility that can be used as a boolean in shell conditionals).
if /usr/sbin/selinuxenabled; then
	echo"SELinux already enabled with a policy loaded; exiting."
	exit 1
fi

> +
> +dodev=`cat /proc/$$/mounts | grep "/dev "`
> +if [ "eq$dodev" != "eq" ]; then
> +	mount --move /dev /mnt
> +	$SF file_contexts /dev
> +	mount --move /mnt /dev
> +fi

Not sure what you are doing here.  If /dev is udev-managed, then it will
handle labeling at boot.  But it still shows up as a tmpfs mount
in /proc/self/mounts.

Where do you set up /etc/selinux/config to refer to this dummy policy so
it will get loaded at boot?

-- 
Stephen Smalley
National Security Agency

