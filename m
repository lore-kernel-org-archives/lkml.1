Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbZKRRuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbZKRRuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:50:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757944AbZKRRuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:50:05 -0500
Received: from mail2.shareable.org ([80.68.89.115]:49800 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757939AbZKRRuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:50:04 -0500
Date: Wed, 18 Nov 2009 17:50:03 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jan Blunck <jblunck@suse.de>,
       linux-fsdevel@vger.kernel.org,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
       Christoph Hellwig <hch@infradead.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] BKL: Remove BKL from default_llseek()
Message-ID: <20091118175003.GF28723@shareable.org>
References: <1258560457-15129-1-git-send-email-jblunck@suse.de> <20091118171524.4d2f8cec@lxorguk.ukuu.org.uk> <20091118172730.GD28723@shareable.org> <200911181835.55007.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911181835.55007.oliver@neukum.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Mittwoch, 18. November 2009 18:27:30 schrieb Jamie Lokier:
> > > No. Your logic is flawed
> > > 
> > > The BKL is protected something here - it protects the change of offset
> > > with respect to other BKL users within drivers. The question is what if
> > > anything in any other driver code depends upon the BKL and uses it to
> > > protect f_pos. Probably very little if anything but a grep for f_pos
> > > through the drivers might not be a bad idea before assuming this. Very
> > > few touch f_pos except in their own llseek method.
> > 
> > Of course, drivers shouldn't be using f_pos outside their llseek
> > method, as they should all behave the same with pread/pwrite as with
> > llseek+read/write.
> 
> Might not a driver update f_pos after read/write?

It could indirectly, through *ppos.  

There should be no direct accesses to f_pos outseek llseek.  If there
are still, those might indicate driver bugs.  (I'm not 100% sure about
this - hence asking).

Drivers used to update f_pos indirectly through *ppos, and for this,
Alan's observation about BKL protecting the value from changing does apply.

But nowadays, even that doesn't happen.  sys_read() and sys_write()
make a copy of f_pos using file_pos_read(), so drivers cannot see the
value change during the call - except for their own change.

I find myself wondering why the VFS isn't responsible for the position
update instead of the driver...  Would it be a valid cleanup to move
it from the driver to VFS?

-- Jamie
