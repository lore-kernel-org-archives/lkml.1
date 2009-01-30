Return-Path: <linux-kernel-owner+w=401wt.eu-S1752005AbZA3GTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbZA3GTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 01:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbZA3GS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 01:18:59 -0500
Received: from kroah.org ([198.145.64.141]:53405 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751572AbZA3GS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 01:18:58 -0500
Date: Thu, 29 Jan 2009 22:17:14 -0800
From: Greg KH <greg@kroah.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, mtk.manpages@gmail.com,
       linux-man@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: open(2) says O_DIRECT works on 512 byte boundries?
Message-ID: <20090130061714.GC31209@kroah.com>
References: <20090128213322.GA15789@kroah.com> <20090129141338.34e44a1f.kamezawa.hiroyu@jp.fujitsu.com> <20090129160826.701E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129160826.701E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 04:10:39PM +0900, KOSAKI Motohiro wrote:
> (CC to andrea)
> 
> > On Wed, 28 Jan 2009 13:33:22 -0800
> > Greg KH <greg@kroah.com> wrote:
> > 
> > > In looking at open(2), it says that O_DIRECT works on 512 byte boundries
> > > with the 2.6 kernel release:
> > > 	Under Linux 2.4, transfer sizes, and the alignment of the user
> > > 	buffer and  the file offset must all be multiples of the logical
> > > 	block size of the file system.  Under Linux 2.6, alignment  to
> > > 	512-byte  boundaries suffices.
> > > 
> > > However if you try to access an O_DIRECT opened file with a buffer that
> > > is PAGE_SIZE aligned + 512 bytes, it fails in a bad way (wrong data is
> > > read.)
> > > 
> > 
> > IIUC, it's not related to 512bytes boundary. Just a race between
> > direct-io v.s. copy-on-write. Copy-on-Write while reading a page via DIO
> > is a problem.
> 
> Yes.
> Greg's reproducer is a bit misleading.
> 
> >	    for (j = 0; j < workers; j++) {
> >		worker[j].offset = offset + j * PAGE_SIZE;
> >		worker[j].buffer = buffer + align + j * PAGE_SIZE;
> >		worker[j].length = PAGE_SIZE;
> >	    }
> 
> this code mean,
>   - if align == 0, reader thread touch only one page.
>     and the page is touched only one thread.
>   - if align != 0, reader thread touch two page.
>     and the page is touched two thread.
> 
> then, race is happend if align != 0.
> We discussed this issue with andrea last month.
> ("Corruption with O_DIRECT and unaligned user buffers" thread)
> 
> As far as I know, he is working on fixing this issue now.

Thanks for the pointers, I'll go read the thread and follow up there.

greg k-h
