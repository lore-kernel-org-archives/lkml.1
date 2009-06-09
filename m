Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbZFIFvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbZFIFvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 01:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbZFIFu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 01:50:58 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55067 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbZFIFu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 01:50:57 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, hugh@veritas.com, tj@kernel.org,
       adobriyan@gmail.com, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, gregkh@suse.de, npiggin@suse.de,
       akpm@linux-foundation.org, hch@infradead.org
In-reply-to: <20090608175018.GM8633@ZenIV.linux.org.uk> (message from Al Viro
	on Mon, 8 Jun 2009 18:50:18 +0100)
Subject: Re: [PATCH 0/23] File descriptor hot-unplug support v2
References: <m1skkf761y.fsf@fess.ebiederm.org> <m1oct739xu.fsf@fess.ebiederm.org> <20090606080334.GA15204@ZenIV.linux.org.uk> <E1MDbLz-0003wm-Db@pomaz-ex.szeredi.hu> <20090608162913.GL8633@ZenIV.linux.org.uk> <E1MDhxh-0004nz-Qm@pomaz-ex.szeredi.hu> <20090608175018.GM8633@ZenIV.linux.org.uk>
Message-Id: <E1MDuEI-0006BC-1C@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 09 Jun 2009 07:50:38 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009, Al Viro wrote:
> On Mon, Jun 08, 2009 at 06:44:41PM +0200, Miklos Szeredi wrote:
> 
> > I'm still not getting what the problem is.  AFAICS file operations are
> > either
> > 
> >  a) non-interruptible but finish within a short time or
> >  b) may block indefinitely but are interruptible (or at least killable).
> > 
> > Anything else is already problematic, resulting in processes "stuck in
> > D state".
> 
> Welcome to reality...
> 
> * bread() is non-interruptible
> * so's copy_from_user()/copy_to_user()

And why should revoke(2) care?  Just wait for the damn thing to
finish.  Why exactly do these need to be interruptible?

Okay, if we want revoke or umount -f to be instantaneous then all that
needs to be taken care of.  But does it *need* to be?

My idea of revoke is something like below:

  - make sure no new operations are started on the file
  - check state of tasks for ongoing operations, if interruptible send signal
  - wait for all pending operations to finish
  - kill file

Thanks,
Miklos
