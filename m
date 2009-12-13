Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbZLMTQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbZLMTQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 14:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbZLMTQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 14:16:16 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:36198 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753959AbZLMTQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 14:16:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lco1i27Ky7eiyvi8g9nqhpMDbst5pt6yOudWV/g6v80Y09lf3igLN0bbxyY5mi1Ol1
         mMjLVSziW7kzXylfULDWZnFEQNeQnbVfXFGWKjehFzAMuwcoWxT6Xgua6Zp0BLCPi07Q
         ooHilpg206w6s3DMZeZHuHvRgEx9bd8Hjlvc8=
Date: Sun, 13 Dec 2009 20:16:08 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
Message-ID: <20091213191606.GB7297@nowhere>
References: <20091212101032.GB25286@elte.hu> <20091212023603.93768833.akpm@linux-foundation.org> <alpine.LFD.2.00.0912120915390.3526@localhost.localdomain> <alpine.LFD.2.00.0912120920190.3526@localhost.localdomain> <20091212214235.31429790@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0912121418490.3526@localhost.localdomain> <alpine.LFD.2.00.0912122331200.3089@localhost.localdomain> <alpine.LFD.2.00.0912121513190.3535@localhost.localdomain> <20091213065844.GA20244@elte.hu> <20091213095534.58051536@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091213095534.58051536@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 09:55:34AM -0800, Arjan van de Ven wrote:
> On Sun, 13 Dec 2009 07:58:44 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > We've had quite a bit of BKL work this merge-window. Maybe we'll
> > > even get rid of it one of these days. There are "only" about 600
> > > instances of "lock_kernel()" in the tree right now ;)
> > 
> > I tend to use unlock_kernel() as the metric. (as it's more precisely
> > greppable and it is also more indicative of the underlying complexity
> > of locking, as it gets used more in more complex scenarios)
> 
> another metric is... how many times do we take the BKL for some
> workload. (For example booting or compiling a kernel).
> A counter like "BKLs-per-second" would be nice to expose
> (and then we can track that number going up as a regression etc)



We have the bkl tracepoints for that, attaching an example below,
blkdev_get/bkldev_put is among the highest consumer for me.

Then after we have (not sorted in order) tty, __blkdev_driver_ioctl(),
etc...


# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
 hald-addon-stor-4285  [000]   413.952233: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [001]   413.969331: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [001]   413.969343: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001]   413.989339: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001]   413.989349: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [001]   413.992067: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [001]   415.953350: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [001]   415.970537: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [001]   415.970552: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001]   415.990404: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001]   415.990414: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [001]   415.993139: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
            less-5147  [001]   416.155702: lock_kernel: depth=0 file:line=drivers/char/tty_io.c:1847 func=tty_open()
            less-5147  [001]   416.155712: unlock_kernel: depth=-1 file:line=drivers/char/tty_io.c:1849 func=tty_open()
        lesspipe-5149  [001]   416.159402: lock_kernel: depth=0 file:line=drivers/char/tty_io.c:1847 func=tty_open()
        lesspipe-5149  [001]   416.159412: unlock_kernel: depth=-1 file:line=drivers/char/tty_io.c:1849 func=tty_open()
        lesspipe-5149  [001]   416.159418: lock_kernel: depth=0 file:line=drivers/char/tty_io.c:1870 func=tty_release()
        lesspipe-5149  [001]   416.159419: lock_kernel: depth=1 file:line=drivers/char/tty_io.c:1911 func=tty_fasync()
        lesspipe-5149  [001]   416.159421: unlock_kernel: depth=0 file:line=drivers/char/tty_io.c:1943 func=tty_fasync()
        lesspipe-5149  [001]   416.159423: unlock_kernel: depth=-1 file:line=drivers/char/tty_io.c:1872 func=tty_release()
            less-5147  [001]   420.459944: lock_kernel: depth=0 file:line=drivers/char/tty_io.c:1870 func=tty_release()
            less-5147  [001]   420.459949: lock_kernel: depth=1 file:line=drivers/char/tty_io.c:1911 func=tty_fasync()
            less-5147  [001]   420.459954: unlock_kernel: depth=0 file:line=drivers/char/tty_io.c:1943 func=tty_fasync()
            less-5147  [001]   420.459960: unlock_kernel: depth=-1 file:line=drivers/char/tty_io.c:1872 func=tty_release()
 hald-addon-stor-4285  [001]   421.954357: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [001]   421.971499: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [001]   421.971510: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001]   421.991585: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001]   421.991604: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [001]   421.994321: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22215.805856: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22215.823023: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22215.823035: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22215.842989: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22215.843001: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22215.845718: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22217.805987: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22217.823165: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22217.823178: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22217.843182: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22217.843194: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [001] 22217.845932: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
            less-10802 [000] 22218.162060: lock_kernel: depth=0 file:line=drivers/char/tty_io.c:1847 func=tty_open()
            less-10802 [000] 22218.162078: unlock_kernel: depth=-1 file:line=drivers/char/tty_io.c:1849 func=tty_open()
        lesspipe-10804 [001] 22218.169025: lock_kernel: depth=0 file:line=drivers/char/tty_io.c:1847 func=tty_open()
        lesspipe-10804 [001] 22218.169043: unlock_kernel: depth=-1 file:line=drivers/char/tty_io.c:1849 func=tty_open()
        lesspipe-10804 [001] 22218.169052: lock_kernel: depth=0 file:line=drivers/char/tty_io.c:1870 func=tty_release()
        lesspipe-10804 [001] 22218.169054: lock_kernel: depth=1 file:line=drivers/char/tty_io.c:1911 func=tty_fasync()
        lesspipe-10804 [001] 22218.169059: unlock_kernel: depth=0 file:line=drivers/char/tty_io.c:1943 func=tty_fasync()
        lesspipe-10804 [001] 22218.169062: unlock_kernel: depth=-1 file:line=drivers/char/tty_io.c:1872 func=tty_release()
            less-10802 [001] 22255.644555: lock_kernel: depth=0 file:line=drivers/char/tty_io.c:1870 func=tty_release()
            less-10802 [001] 22255.644560: lock_kernel: depth=1 file:line=drivers/char/tty_io.c:1911 func=tty_fasync()
            less-10802 [001] 22255.644565: unlock_kernel: depth=0 file:line=drivers/char/tty_io.c:1943 func=tty_fasync()
            less-10802 [001] 22255.644571: unlock_kernel: depth=-1 file:line=drivers/char/tty_io.c:1872 func=tty_release()
 hald-addon-stor-4285  [001] 22255.808942: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22255.826113: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22255.826126: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22255.846022: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22255.846034: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [001] 22255.848822: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
            less-10810 [001] 22256.438465: lock_kernel: depth=0 file:line=drivers/char/tty_io.c:1847 func=tty_open()
            less-10810 [001] 22256.438476: unlock_kernel: depth=-1 file:line=drivers/char/tty_io.c:1849 func=tty_open()
        lesspipe-10812 [001] 22256.442197: lock_kernel: depth=0 file:line=drivers/char/tty_io.c:1847 func=tty_open()
        lesspipe-10812 [001] 22256.442209: unlock_kernel: depth=-1 file:line=drivers/char/tty_io.c:1849 func=tty_open()
        lesspipe-10812 [001] 22256.442215: lock_kernel: depth=0 file:line=drivers/char/tty_io.c:1870 func=tty_release()
        lesspipe-10812 [001] 22256.442217: lock_kernel: depth=1 file:line=drivers/char/tty_io.c:1911 func=tty_fasync()
        lesspipe-10812 [001] 22256.442220: unlock_kernel: depth=0 file:line=drivers/char/tty_io.c:1943 func=tty_fasync()
        lesspipe-10812 [001] 22256.442223: unlock_kernel: depth=-1 file:line=drivers/char/tty_io.c:1872 func=tty_release()
            less-10810 [001] 22288.556512: lock_kernel: depth=0 file:line=drivers/char/tty_io.c:1870 func=tty_release()
            less-10810 [001] 22288.556518: lock_kernel: depth=1 file:line=drivers/char/tty_io.c:1911 func=tty_fasync()
            less-10810 [001] 22288.556523: unlock_kernel: depth=0 file:line=drivers/char/tty_io.c:1943 func=tty_fasync()
            less-10810 [001] 22288.556528: unlock_kernel: depth=-1 file:line=drivers/char/tty_io.c:1872 func=tty_release()
 hald-addon-stor-4285  [001] 22289.811558: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22289.828644: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22289.828655: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22289.848642: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22289.848654: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [001] 22289.851377: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [001] 22291.811651: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22291.828861: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22291.828873: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22291.848808: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22291.848820: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [001] 22291.851539: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [001] 22293.811865: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22293.829005: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22293.829018: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22293.848924: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22293.848939: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [001] 22293.851648: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22295.812598: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22295.829710: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22295.829729: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22295.849774: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22295.849793: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22295.852533: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22297.812827: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22297.830066: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22297.830080: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22297.850050: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22297.850063: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [001] 22297.852787: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [001] 22299.813048: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22299.830191: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22299.830202: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22299.850124: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22299.850139: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [001] 22299.852861: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [001] 22301.813131: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22301.830331: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22301.830344: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22301.850322: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22301.850336: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22301.853056: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22303.813335: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22303.830509: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22303.830524: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22303.850524: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22303.850536: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [001] 22303.853252: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22305.812998: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22305.830173: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22305.830187: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22305.850228: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22305.850240: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [001] 22305.852977: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [001] 22307.813260: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22307.830358: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22307.830370: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22307.850336: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22307.850348: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [001] 22307.853092: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22309.812671: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22309.829824: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22309.829838: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22309.849862: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22309.849876: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [001] 22309.852593: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [001] 22311.813880: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22311.830955: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22311.830969: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22311.850934: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22311.850947: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22311.853683: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22313.813953: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22313.831033: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22313.831044: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22313.850994: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22313.851008: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22313.853724: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22315.814036: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22315.831141: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22315.831152: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22315.851149: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22315.851164: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22315.853885: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22317.814201: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22317.831298: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22317.831311: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22317.851279: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22317.851293: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22317.854013: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22319.814300: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22319.831452: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22319.831464: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22319.851428: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22319.851442: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22319.854164: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22321.814478: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22321.831562: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22321.831574: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22321.851544: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22321.851558: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22321.854283: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22323.814548: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22323.831653: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22323.831664: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22323.851570: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22323.851619: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22323.854349: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22325.814617: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22325.831827: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22325.831840: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22325.851802: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22325.851815: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22325.854538: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22327.814807: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22327.831958: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22327.831971: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22327.851955: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22327.851966: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22327.854674: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22329.814947: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22329.832137: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22329.832148: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22329.852105: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22329.852117: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22329.854842: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22331.815111: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22331.832302: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22331.832317: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22331.852379: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22331.852396: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22331.855122: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22333.814527: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22333.831013: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22333.831025: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22333.850780: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22333.850815: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [001] 22333.853545: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [001] 22335.814932: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22335.831815: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22335.831833: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22335.851497: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22335.851506: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22335.854229: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22337.816545: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22337.833716: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22337.833727: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22337.853705: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22337.853718: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22337.856494: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22339.815783: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22339.832582: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22339.832594: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22339.852607: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22339.852619: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22339.855342: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [001] 22341.815543: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22341.832662: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [001] 22341.832674: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22341.852565: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [001] 22341.852578: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [001] 22341.855297: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [001] 22343.816613: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22343.833956: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22343.833975: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22343.853966: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22343.853981: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22343.856700: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22345.816971: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22345.834130: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22345.834143: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22345.854081: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22345.854095: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22345.856815: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22347.817085: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22347.834270: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22347.834284: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22347.854281: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22347.854295: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22347.857011: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22349.817281: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22349.834499: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22349.834512: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22349.854373: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22349.854387: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22349.857103: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22351.817387: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22351.834567: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22351.834580: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22351.854612: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22351.854627: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22351.857350: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22353.817639: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22353.834644: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22353.834658: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22353.854721: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22353.854735: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22353.857476: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22355.817753: lock_kernel: depth=0 file:line=fs/block_dev.c:1192 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22355.834840: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1278 func=__blkdev_get()
 hald-addon-stor-4285  [000] 22355.834854: lock_kernel: depth=0 file:line=block/ioctl.c:171 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22355.854832: unlock_kernel: depth=-1 file:line=block/ioctl.c:173 func=__blkdev_driver_ioctl()
 hald-addon-stor-4285  [000] 22355.854852: lock_kernel: depth=0 file:line=fs/block_dev.c:1358 func=__blkdev_put()
 hald-addon-stor-4285  [000] 22355.857591: unlock_kernel: depth=-1 file:line=fs/block_dev.c:1383 func=__blkdev_put()

