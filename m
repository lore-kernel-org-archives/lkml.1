Return-Path: <linux-kernel-owner+w=401wt.eu-S1759046AbYBMArw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759046AbYBMArw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:47:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbYBMArm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:47:42 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:39898 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751230AbYBMArk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:47:40 -0500
Date: Tue, 12 Feb 2008 19:45:41 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: David Miller <davem@davemloft.net>
Cc: jengelh@computergmbh.de, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       btrfs-devel@oss.oracle.com
Subject: Re: BTRFS partition usage...
Message-ID: <20080213004541.GB11911@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Miller <davem@davemloft.net>, jengelh@computergmbh.de,
	chris.mason@oracle.com, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
References: <20080212.001104.172517283.davem@davemloft.net> <200802120849.34477.chris.mason@oracle.com> <Pine.LNX.4.64.0802121458420.21102@fbirervta.pbzchgretzou.qr> <20080212.152826.243855481.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212.152826.243855481.davem@davemloft.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 03:28:26PM -0800, David Miller wrote:
> From: Jan Engelhardt <jengelh@computergmbh.de>
> Date: Tue, 12 Feb 2008 15:00:20 +0100 (CET)
> 
> > Something looks wrong here. Why would btrfs need to zero at all?
> 
> So that existing superblocks on the partition won't
> be interpreted as correct by other filesystems.  It's
> a safety measure many mkfs programs use.
> 
> > Superblock at 0, and done. Just like xfs.
> 
> No, we won't do stupid things like that and make an entire
> cylinder of our disks unusable.  See my other reply.

The reason why we don't put the superblock at 0 is not because it
screws over the sparc, but because on many systems (including x86) the
bootsector is stored at 0.  It's not hard for mke2fs to zap the boot
sector which we do on all architectures *except* sparc, to avoid
nuking the disk label.  (Chris just missed the "#ifndef __sparc //
#define ZAP_BOOTBLOCK // #endif" at the beginning of mke2fs.c)

This is the best of all words; it makes sparc happy; it allows boot
loaders to put the x86 standard initial stage 0 boot loader in the
first 446 bytes of the disk; and by zapping sector 0 on all
architectures except the sparc, it solves the previous filesystem
"ghost traces" detection problem for filesystems like xfs that put the
superblock at 0.

						- Ted
