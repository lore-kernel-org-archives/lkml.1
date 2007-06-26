Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbXFZIBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbXFZIBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 04:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbXFZIBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 04:01:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbXFZIBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 04:01:22 -0400
Date: Tue, 26 Jun 2007 10:01:04 +0200
From: Karel Zak <kzak@redhat.com>
To: Ram Pai <linuxram@us.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] VFS: Augment /proc/mount with subroot and shared-subtree
Message-ID: <20070626080104.GB4099@petra.dvoda.cz>
References: <20070620210343.GQ21478@ftp.linux.org.uk> <46799A31.10301@zytor.com> <1182442837.3342.13.camel@ram.us.ibm.com> <467AB5EE.3030909@zytor.com> <1182494654.2812.22.camel@ram.us.ibm.com> <467B7509.8010106@zytor.com> <1182497690.2812.54.camel@ram.us.ibm.com> <467B7F6F.4030007@zytor.com> <20070625214640.GC29058@ram.us.ibm.com> <1182808816.2816.7.camel@ram.us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182808816.2816.7.camel@ram.us.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 03:00:15PM -0700, Ram Pai wrote:
> Please check if the following modified patch meets the requirements.
> 
> It augments /proc/mount with additional information to
> 	(1) disambiguate bind mounts with subroot information.
> 	(2) display shared-subtree information using which one can
> 		determine the propagation trees.
> 
> 
> The following additional fields are appended to each record
> in /proc/mounts

 Can you append the new fields at real end of records? Now you have
 the new fields between "options" and "freq, passno".

 (BTW, maybe we can completely remove "freq, passno" from
 /proc/mounts, especially if we don't have care about compatibility
 with /etc/{mtab,fstab} format. The freq and passno are always zero in
 /proc/mounts).

> mntid=id    ->  The unique id associated with that mount.
> fsid=id:dir ->  The filesystem's id and directory in that filesystem
> that
> 		makes the root directory of this mount.
> parent=id   ->  The id of the mount's parent; on which it is mounted.

 Do we really need a "<name>=" (mntid=, fsid=, parent=) prefixes? I
 think your new fields are always in the same column (on same
 position).

> also flags are augmented with new information to indicate the mount's 
> propagation type.
> 
> Here is a sample 'cat /proc/mounts' after executing the following
> commands:
> mount --bind /mnt /mnt
> mount --make-shared /mnt
> mount --bind /mnt/1 /var
> mount --make-slave /var
> mount --make-shared /mnt
> mount --make-unbindable /proc
> 
> rootfs / rootfs rw PRIVATE mntid=c1708c30 fsid=1:/ parent=c1708c30 0 0
> /dev/root / ext2 rw  PRIVATE mntid=c1208c08 fsid=6200:/ parent=c1708c30
> 0 0
> /proc /proc proc rw UNBINDABLE mntid=c1108c90 fsid=3:/ parent=c1208c08 0
> 0
> devpts /dev/pts devpts rw PRIVATE mntid=c1108c18 fsid=a:/
> parent=c1208c08 0 0
> /dev/root /mnt ext2 rw  SHARED:peer=c1e08cb0 mntid=c1e08cb0
> fsid=6200:/mnt parent=c1208c08 0 0
> /dev/root /var ext2 rw  SHARED:peer=c1f08c28 SLAVE:master=c1e08cb0
> mntid=c1f08c28 fsid=6200:/mnt/1 parent=c1208c08 0 0

 You needn't "peer" or "master" keywords and it would be nice
 to use one column for all propagation flags (separated by comma).

    <FLAG>[:id>][,...]

 for example:

   SHARED:c1f08c28,SLAVE:c1e08cb0

 Full example:

 <fsname> <dir> <type> <opts> <freq> <passno> \
           <propflags> <mntid> <fsid> <parentid>

 rootfs / rootfs rw  0 0 PRIVATE c1708c30 1:/ c1708c30
 /dev/root / ext2 rw 0 0 PRIVATE 1208c08 6200:/ c1708c30
 /proc /proc proc rw  0 0 UNBINDABLE c1108c90 3:/ c1208c08
 devpts /dev/pts devpts rw  0 0 PRIVATE c1108c18 a:/ c1208c08
 /dev/root /mnt ext2 rw 0 0 SHARED:c1e08cb0 c1e08cb0 6200:/mnt c1208c08
 /dev/root /var ext2 rw 0 0 SHARED:c1f08c28,SLAVE:c1e08cb0 c1f08c28 6200:/mnt/1 c1208c08

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
