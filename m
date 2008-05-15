Return-Path: <linux-kernel-owner+w=401wt.eu-S932254AbYEOOqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254AbYEOOqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 10:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbYEOOq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 10:46:28 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45160 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753473AbYEOOq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 10:46:26 -0400
Subject: Re: 2.6.26-rc2-mm1 (SCSI_DH build errors)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hare@suse.de, scsi <linux-scsi@vger.kernel.org>,
       Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20080514141348.e71feed6.randy.dunlap@oracle.com>
References: <20080514010129.4f672378.akpm@linux-foundation.org>
	 <20080514141348.e71feed6.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Thu, 15 May 2008 15:46:19 +0100
Message-Id: <1210862779.15852.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-14 at 14:13 -0700, Randy Dunlap wrote:
> On Wed, 14 May 2008 01:01:29 -0700 Andrew Morton wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc2/2.6.26-rc2-mm1/
> 
> SCSI_DH has some problems when CONFIG_SCSI=n:
> 
> drivers/built-in.o: In function `activate_path':
> dm-mpath.c:(.text+0x18a292): undefined reference to `scsi_dh_activate'
> drivers/built-in.o: In function `multipath_ctr':
> dm-mpath.c:(.text+0x18a6f0): undefined reference to `scsi_dh_handler_exist'
> make[1]: *** [.tmp_vmlinux1] Error 1
> 
> 
> #
> # SCSI device support
> #
> CONFIG_RAID_ATTRS=y
> # CONFIG_SCSI is not set
> # CONFIG_SCSI_DMA is not set
> # CONFIG_SCSI_NETLINK is not set
> CONFIG_SCSI_DH=y
> CONFIG_SCSI_DH_RDAC=y
> CONFIG_SCSI_DH_HP_SW=y
> CONFIG_SCSI_DH_EMC=y

This is one more of those annoying selects.  The SCSI_DH Kconfig file is
correctly dependent on SCSI:

menuconfig SCSI_DH
	tristate "SCSI Device Handlers"
	depends on SCSI
	default n
	help

but we've also got a select in md/Kconfig:

config DM_MULTIPATH
	tristate "Multipath target"
	depends on BLK_DEV_DM
	select SCSI_DH

Which ignores the dependency.

My best guess for fixing this is either to make the select a depends or
just drop it altogether (after all, it's possible to have multipath on
non-SCSI devices).

James


