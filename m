Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbXJHFM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbXJHFM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 01:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbXJHFMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 01:12:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50813 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbXJHFMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 01:12:19 -0400
Date: Mon, 8 Oct 2007 06:12:18 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, hch@lst.de
Subject: Re: [patch 0/9] compat_ioctl: introduce block/compat_ioctl.c
Message-ID: <20071008051218.GS8181@ftp.linux.org.uk>
References: <20071006181902.141862534@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071006181902.141862534@arndb.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2007 at 08:19:02PM +0200, Arnd Bergmann wrote:
> This is my block ioctl series split up into managable chunks. I'm not
> really sure about the last two of these, I'd prefer to get a second
> opinion on those.
> 
> Please apply once your tests have gone though.

BTW, one note: 0x1260 thing (
       /* The mkswap binary hard codes it to Intel value :-((( */
       case 0x1260:
       case BLKGETSIZE:
) is an ancient piece of BS.  It had appeared in 2.1.115-pre3 and AFAICS
it's a misunderstanding.

What happens here:
	* mkswap(8) used to hardcode BLKGETSIZE as 0x1260 (instead of
_IO(0x12,0x60)).  If _IO is undefined, it still does.  Several old
architectures (including i386) have the right value still equal to 0x1260
due to the way their _IO() is defined.
	* 0x1260 does *NOT* work on sparc32, exactly because its _IO()
is different.  _IO(0x12,0x60) works.
	* sparc64 for some insane reason (I suspect misreading the mkswap
source) tries to support 0x1260 for 32bit tasks.  Note that binary that
tries to pull that off will _not_ work on native sparc32.

As the matter of fact, all biarch targets old enough to have 32bit counterpart
present prior to 1.3.45 (when BLKGETSIZE went _IO(0x12,60)) either have
it still equal to 0x1260 on both 32bit and 64bit (i386/amd64) or have it
_not_ equal to 0x1260 on either (ppc/ppc64 and sparc/sparc64).  In the latter
case 0x1260 doesn't work on 32bit, so having it accepted from 32bit tasks
on 64bit is insane.

IOW, that stuff is useless and always had been.  In the current form it's
simply invalid C on e.g. amd64 - you get duplicate case there, which breaks
the build.

I'd simply kill that.
