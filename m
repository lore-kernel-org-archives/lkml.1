Return-Path: <linux-kernel-owner+w=401wt.eu-S933682AbXLNPyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933682AbXLNPyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756691AbXLNPyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:54:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52582 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbXLNPyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:54:39 -0500
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
From: Peter Zijlstra <peterz@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: trond.myklebust@fys.uio.no, kay.sievers@vrfy.org, nickpiggin@yahoo.com.au,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, fengguang.wu@gmail.com, greg@kroah.com,
       neilb@suse.de, linuxram@us.ibm.com
In-Reply-To: <E1J3CFN-0005an-E1@pomaz-ex.szeredi.hu>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	 <3ae72650710020421t711caaa8o13d2e685a98e5fe8@mail.gmail.com>
	 <1191325226.13204.63.camel@twins>
	 <200710022205.05295.nickpiggin@yahoo.com.au>
	 <1191406506.4093.35.camel@lov.localdomain>  <1191407872.5572.7.camel@lappy>
	 <1191418525.4093.87.camel@lov.localdomain> <1193410087.6914.34.camel@twins>
	 <1193416643.7486.8.camel@heimdal.trondhjem.org>
	 <1197643856.21927.7.camel@twins>  <E1J3CFN-0005an-E1@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 16:54:26 +0100
Message-Id: <1197647666.21927.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-12-14 at 16:14 +0100, Miklos Szeredi wrote:
> > Neil suggested using device numbers which would work, however I think
> > those might not be human friendly. While its easy to find the device
> > number of a given path (eg.: stat -c %d /), its rather hard to find the
> > path belonging to a given device number.
> 
> Ram Pai had a patch which added the device number (among other things)
> to /proc/mounts:
> 
> 
> 
> Subject: [RFC2 PATCH 1/1] VFS: Augment /proc/mount with subroot and
> 	shared-subtree
> From:	Ram Pai <linuxram@us.ibm.com>
> To:	"H. Peter Anvin" <hpa@zytor.com>
> Cc:	Al Viro <viro@ftp.linux.org.uk>,
> 	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
> 	linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
> In-Reply-To: <20070625214640.GC29058@ram.us.ibm.com>
> Content-Type: text/plain
> Date:	Mon, 16 Jul 2007 11:46:48 -0700
> Content-Transfer-Encoding: 7bit
> Sender:	linux-fsdevel-owner@vger.kernel.org
> X-Mailing-List:	linux-fsdevel@vger.kernel.org
> 
> /proc/mounts in its current state fail to disambiguate bind mounts, especially 
> when the bind mount is subrooted. Also it does not capture propagation state of
> the mounts(shared-subtree). The following patch addresses the problem.
> 
> The following additional fields to /proc/mounts are added.
> 
> propagation-type in the form of <propagation_flag>[:<mntid>][,...]
> 	note: 'shared' flag is followed by the mntid of its peer mount
> 	      'slave' flag is followed by the mntid of its master mount
> 	      'private' flag stands by itself
> 	      'unbindable' flag stands by itself
>    
> mntid -- is a unique identifier of the mount
> major:minor -- is the major minor number of the device hosting the filesystem
> dir -- the subdir in the filesystem which forms the root of this mount
> parent -- the id of the parent mount
> 
> 
> Here is a sample cat /proc/mounts after execution the following commands:
> 
> mount --bind /mnt /mnt
> mount --make-shared /mnt
> mount --bind /mnt/1 /var
> mount --make-slave /var
> mount --make-shared /var
> mount --bind /var/abc /tmp
> mount --make-unbindable /proc
> 
> rootfs / rootfs rw 0 0 private 2 0:1 / 2 
> /dev/root / ext2 rw  0 0 private 16 98:0 / 2 
> /proc /proc proc rw 0 0 unbindable 17 0:3 / 16 
> devpts /dev/pts devpts rw 0 0 private 18 0:10 / 16 
> /dev/root /mnt ext2 rw  0 0 shared:19 19 98:0 /mnt 16 
> /dev/root /var ext2 rw  0 0 shared:21,slave:19 20 98:0 /mnt/1 16 
> /dev/root /tmp ext2 rw  0 0 shared:20,slave:19 21 98:0 /mnt/1/abc 16 
> 
> For example, the last line indicates that :
> 
> 1) The mount is a shared mount.
> 2) Its peer mount of mount with id 20
> 3) It is also a slave mount of the master-mount with the id  19
> 4) The filesystem on device with major/minor number 98:0 and subdirectory 
> 	mnt/1/abc makes the root directory of this mount.
> 5) And finally the mount with id 16 is its parent.
> 
> 
> Testing: symlinked /etc/mtab to /proc/mounts and did some mount and df commands. They worked normally.
> 
> 
> 
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>

OK, I guess that would work.

Ram Pai, what is the current status of that work?


