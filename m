Return-Path: <linux-kernel-owner+w=401wt.eu-S1760208AbXK1UHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208AbXK1UHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 15:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758355AbXK1UHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 15:07:00 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55707 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757620AbXK1UG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 15:06:58 -0500
Date: Wed, 28 Nov 2007 12:05:53 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: Tejun Heo <teheo@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
Subject: Re: Error returns not handled correctly by
	sysfs.c:subsys_attr_store()
Message-ID: <20071128200553.GB22111@kroah.com>
References: <1195683419.16019.225.camel@grinch> <20071126203116.0c93cdb9.akpm@linux-foundation.org> <20071127053321.GA975@kroah.com> <474D1BD4.2050805@suse.de> <1196278300.5431.9.camel@grinch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196278300.5431.9.camel@grinch>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 12:31:40PM -0700, Andrew Patterson wrote:
> On Wed, 2007-11-28 at 16:42 +0900, Tejun Heo wrote:
> > Greg KH wrote:
> > > On Mon, Nov 26, 2007 at 08:31:16PM -0800, Andrew Morton wrote:
> > >> On Wed, 21 Nov 2007 15:16:59 -0700 Andrew Patterson <andrew.patterson@hp.com> wrote:
> > >>
> > >>> The buf in fs/sysfs.c:subsys_attr_store() does not seem to be updated
> > >>> correctly when returning a negative value (indicating that an error
> > >>> condition has occurred) is returned.  If a negative value is returned,
> > >>> the next subsequent call to subsys_attr_store will have the contents of
> > >>> buf appended to the previous call.
> > >> subsys_attr_store() gets deleted by
> > >> http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver/kset-kill-subsys-attr.patch
> > >>
> > >> So maybe we will soon accidentally fix whatever-this-is?  Or maybe we will
> > >> faithfully maintain it.
> > > 
> > > Yes, subsys attributes go away, but this is showing a bug in the sysfs
> > > core with attributes, not in the "middle" layers of attributes.
> > > 
> > > I bounced the original bug report to Tejun, who has been changing the
> > > logic around this area to see if he sees anything that might be
> > > different now.
> > > 
> > > Tejun?
> > 
> > Weird, the problem is not reproducible here.
> > 
> > # echo a > allow_restart
> > -bash: echo: write error: Invalid argument
> > [  437.518024] buf_ptr = 0xffff810005e20000, buf = x
> > [  437.518027] , count = 2
> > # echo b > allow_restart
> > -bash: echo: write error: Invalid argument
> > [  438.972973] buf_ptr = 0xffff81001be6f000, buf = y
> > [  438.972976] , count = 2
> > # echo c > allow_restart
> > -bash: echo: write error: Invalid argument
> > [  440.539747] buf_ptr = 0xffff81001d4ba000, buf = z
> > [  440.539750] , count = 2
> > 
> > Which is expected.  On each open, sysfs_buffer is allocated with kzalloc
> > and the buffer is freed on close, so I don't see how it can happen.
> > Behavior for multiple write can be considered peculiar in that ppos is
> > essentially ignored and each write is passed just like brand new write
> > to ->store method but this too is the expected behavior.
> > 
> > # (echo a; echo b; echo c) > allow_restart
> > [  765.257132] buf_ptr = 0xffff81001be4f000, buf = a
> > [  765.257135] , count = 2
> > [  765.285474] buf_ptr = 0xffff81001be4f000, buf = b
> > [  765.285484] , count = 2
> > [  765.314002] buf_ptr = 0xffff81001be4f000, buf = c
> > [  765.314004] , count = 2
> > -bash: echo: write error: Invalid argument
> > -bash: echo: write error: Invalid argument
> > -bash: echo: write error: Invalid argument
> > 
> > Andrew Petterson, can you please build 2.6.24-rc3 from clean source tree
> > and retry?
> > 
> 
> I tried with clean 2.6.24-rc3 and get the same bad behavior.  This is on
> an ia64 box, so maybe that is an issue. I can try on an x86 box as well.

Please do so.

> Oh, one other thing.  I tried a "uname -r" to make sure I had the
> correct kernel booted and got:
> 
> # uname -r
> 2.6.24-rc3
> x
> y
> z

Heh, that's not good, try a clean tree :)

thanks,

greg k-h
