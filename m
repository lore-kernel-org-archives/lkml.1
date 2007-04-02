Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbXDBHMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbXDBHMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbXDBHMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:12:10 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:23387 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbXDBHMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:12:08 -0400
Date: Mon, 2 Apr 2007 09:10:18 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Rene Herman <rene.herman@gmail.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
Message-ID: <20070402071018.GE11996@kernel.dk>
References: <460D7F70.3090702@gmail.com> <20070331064711.GF6246@kernel.dk> <460EA727.8070306@gmail.com> <84144f020704010306q600f58ddge1d42753362cf4e2@mail.gmail.com> <4610481D.8000102@gmail.com> <46104954.50608@gmail.com> <Pine.LNX.4.64.0704020949160.23099@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704020949160.23099@sbz-30.cs.Helsinki.FI>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02 2007, Pekka J Enberg wrote:
> On Mon, 2 Apr 2007, Rene Herman wrote:
> > +       if (!blk_fs_request(req)) {
> > +               spin_lock_irq(q->queue_lock);
> 
> Contrary to what I said, this spin_lock_irq() is wrong...
> 
> > +               end_request(req, 0);
> > +               goto again;
> > +       }
> > +
> > +       spin_unlock_irq(q->queue_lock);
> 
> ...because we drop the lock here.

well you did make it overly complex, you should just have dropped the
lock around

        spin_unlock_irq(q->queue_lock);
        i = mcdx_transfer(...);
        spin_lock_irq(q->queue_lock);

and be done with it. But as I wrote earlier, it'll take lots more to
make this driver close to functional. For one, most of the return
statements in do_mcdx_request() really want to be goto again's.

Updated patch attached :-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 0bc8b0b..cff761a 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -324,3 +324,10 @@ Why:	the i8xx_tco watchdog driver has been replaced by the iTCO_wdt
 Who:	Wim Van Sebroeck <wim@iguana.be>
 
 ---------------------------
+
+What:	The legacy CDROM drivers (drivers/cdrom/, except cdrom.c)
+When:	In 2.6.23
+Why:	They are all terminally broken (most don't even compile)
+Who:	Jens Axboe <jens.axboe@oracle.com>
+
+---------------------------

-- 
Jens Axboe

