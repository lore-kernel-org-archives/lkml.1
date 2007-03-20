Return-Path: <linux-kernel-owner+w=401wt.eu-S1751411AbXCTWQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411AbXCTWQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 18:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbXCTWQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 18:16:25 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59540 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752022AbXCTWQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 18:16:24 -0400
Date: Tue, 20 Mar 2007 23:16:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] swsusp: fix error paths in snapshot_open
Message-ID: <20070320221615.GO3545@elf.ucw.cz>
References: <200703122214.02657.rjw@sisk.pl> <20070319173127.72c3419d.akpm@linux-foundation.org> <200703202218.16820.rjw@sisk.pl> <200703202226.42673.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703202226.42673.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> We forget to increase device_available if there's an error in
> snapshot_open(), so the snapshot device cannot be open at all after
> snapshot_open() has returned an error.

Actually, this should go to the beggining of series, as it is
(non-critical) bugfix.

							Pavel
> @@ -49,12 +49,14 @@ static int snapshot_open(struct inode *i
>  	if (!atomic_add_unless(&device_available, -1, 0))
>  		return -EBUSY;
>  
> -	if ((filp->f_flags & O_ACCMODE) == O_RDWR)
> +	if ((filp->f_flags & O_ACCMODE) == O_RDWR) {
> +		atomic_inc(&device_available);
>  		return -ENOSYS;
> -
> -	if(create_basic_memory_bitmaps())
> +	}
> +	if(create_basic_memory_bitmaps()) {
> +		atomic_inc(&device_available);
>  		return -ENOMEM;
> -
> +	}
>  	nonseekable_open(inode, filp);
>  	data = &snapshot_state;
>  	filp->private_data = data;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
