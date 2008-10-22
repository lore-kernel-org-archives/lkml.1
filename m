Return-Path: <linux-kernel-owner+w=401wt.eu-S1756479AbYJVRNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbYJVRNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYJVRNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:13:23 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:62949 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752250AbYJVRNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:13:22 -0400
Date: Wed, 22 Oct 2008 19:13:21 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: Subject: [PATCH 01/16] Squashfs: inode operations
In-Reply-To: <E1KqrTW-0001xC-9M@dylan>
Message-ID: <Pine.LNX.4.64.0810221907080.20919@vixen.sonytel.be>
References: <E1KqrTW-0001xC-9M@dylan>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1797153628-1224695601=:20919"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1797153628-1224695601=:20919
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 17 Oct 2008, Phillip Lougher wrote:
> --- /dev/null
> +++ b/fs/squashfs/inode.c

> +	case SQUASHFS_BLKDEV_TYPE:
> +	case SQUASHFS_CHRDEV_TYPE: {
> +		struct squashfs_dev_inode *inodep = &id.dev;
> +		unsigned int rdev;
> +
> +		if (!squashfs_read_metadata(s, inodep, block, offset,
> +				sizeof(*inodep), &next_block, &next_offset))
> +			goto failed_read;
> +
> +		i->i_nlink = le32_to_cpu(inodep->nlink);
> +		i->i_mode |= (type == SQUASHFS_CHRDEV_TYPE) ? S_IFCHR : S_IFBLK;
> +		rdev = le32_to_cpu(inodep->rdev);
> +		init_special_inode(i, le16_to_cpu(i->i_mode),
                                      ^^^^^^^^^^^
> +					new_decode_dev(rdev));
> +
> +		TRACE("Device inode %x:%x, rdev %x\n",
> +				SQUASHFS_INODE_BLK(inode), offset, rdev);
> +		break;
> +	}
> +	case SQUASHFS_FIFO_TYPE:
> +	case SQUASHFS_SOCKET_TYPE: {
> +		struct squashfs_ipc_inode *inodep = &id.ipc;
> +
> +		if (!squashfs_read_metadata(s, inodep, block, offset,
> +				sizeof(*inodep), &next_block, &next_offset))
> +			goto failed_read;
> +
> +		i->i_nlink = le32_to_cpu(inodep->nlink);
> +		i->i_mode |= (type == SQUASHFS_FIFO_TYPE) ? S_IFIFO : S_IFSOCK;
> +		init_special_inode(i, le16_to_cpu(i->i_mode), 0);
                                      ^^^^^^^^^^^
> +		break;

Sparse with endian checking (make C=2 CHECKFLAGS="-D__CHECK_ENDIAN__") complains
about these:

| fs/squashfs/inode.c:306:25: warning: cast to restricted __le16
| fs/squashfs/inode.c:324:25: warning: cast to restricted __le16

and it seems to be right, as inode.i_mode is not __le16. I think the le16_to_cpu()
should be removed.

BTW, there are also a few sparse warnings about different signednesses, so you
probably want to run sparse yourself, too.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-1797153628-1224695601=:20919--
