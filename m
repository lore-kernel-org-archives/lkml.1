Return-Path: <linux-kernel-owner+w=401wt.eu-S1761554AbXGMNCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761554AbXGMNCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 09:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758209AbXGMNCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 09:02:24 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:56561 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758003AbXGMNCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 09:02:23 -0400
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Paul Mackerras <paulus@samba.org>, Jens Axboe <axboe@kernel.dk>,
       Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Geoff Levand <geoffrey.levand@am.sony.com>
In-Reply-To: <20070704132346.591348000@pademelon.sonytel.be>
References: <20070704132212.726923000@pademelon.sonytel.be>
	 <20070704132346.591348000@pademelon.sonytel.be>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 09:02:21 -0400
Message-Id: <1184331741.3402.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-04 at 15:22 +0200, Geert Uytterhoeven wrote:
> +                       kaddr = kmap_atomic(sgpnt->page, KM_USER0);
> +                       if (!kaddr)
> +                               return -1;
> +                       len = sgpnt->length;
> +                       if ((req_len + len) > buflen) {
> +                               active = 0;
> +                               len = buflen - req_len;
> +                       }
> +                       memcpy(kaddr + sgpnt->offset, buf + req_len,
> len);
> +                       kunmap_atomic(kaddr, KM_USER0);

This isn't a SCSI objection, but this sequence appears several times in
this driver.  It's wrong for a non-PIPT architecture (and I believe the
PS3 is VIPT) because you copy into the kernel alias for the page, which
dirties the line in the cache of that alias (the user alias cache line
was already invalidated).  However, unless you flush the kernel alias to
main memory, the user could read stale data.  The way this is supposed
to be done is to do a 

flush_kernel_dcache_page(kaddr)

before doing the kunmap.

Otherwise it looks OK from the SCSI point of view.

James


