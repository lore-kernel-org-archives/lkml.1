Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbZBCXad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbZBCXad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbZBCXaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:30:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753905AbZBCXaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:30:10 -0500
Date: Tue, 3 Feb 2009 15:29:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: mpm@selenic.com, dada1@cosmosbay.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, oleg@redhat.com, viro@ZenIV.linux.org.uk,
       davidel@xmailserver.org, davem@davemloft.net, hch@lst.de,
       linux-api@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/4] Convert epoll to a bitlock
Message-Id: <20090203152908.355699e0.akpm@linux-foundation.org>
In-Reply-To: <20090203161931.4054a25e@bike.lwn.net>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net>
	<1233598811-6871-3-git-send-email-corbet@lwn.net>
	<20090203133942.2ecec281.akpm@linux-foundation.org>
	<4988BD4E.8080206@cosmosbay.com>
	<20090203140543.6e915f97.akpm@linux-foundation.org>
	<1233699722.3243.127.camel@calx>
	<20090203153740.363d0a04@bike.lwn.net>
	<20090203145346.8df40277.akpm@linux-foundation.org>
	<20090203161931.4054a25e@bike.lwn.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009 16:19:31 -0700
Jonathan Corbet <corbet@lwn.net> wrote:

> On Tue, 3 Feb 2009 14:53:46 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Well.  We _could_ whack part of this nut with my usual hammer: protect
> > f_flags with file->f_dentry->d_inode->i_lock.  IIRC there was some
> > objection to that - performance?
> 
> Andi has objected to the addition of locks, but i_lock is maybe
> sufficiently dispersed to pass muster there.

Hope so.

I'd wrap it in a lock_file_flags(file*) thing so we can change it later
on (add a lock to struct file, take a global, lock, etc).

>  I had an instinctive
> reaction to using a lock which is three pointers away, but I can get
> over that.  I'll admit a bit of ignorance, though: if a given struct
> file exists, do we know for sure that file->f_dentry->d_inode exists?

It should.  A NULL ->d_inode especially signifies a negative dentry.

> > One problem here seems to be that we're trying to change multiple
> > things at the same time.  We can blame the BKL for that.
> > 
> > Can we break the problem into manageable chunks?  Your patchset did
> > that, I guess.  What were those chunks again? ;)
> 
> I'm not really sure how to break it down any further.  If we take the
> i_lock approach, the chunks would be something like:
> 
>  1) Use i_lock to protect accesses to f_flags.  This would enable some 
>     BKL usage to be removed, but would not fix fasync.
> 
>  2) Move responsibility for the FASYNC bit into ->fasync(), with
>     fasync_helper() doing it in almost all situations.  The remaining
>     BKL usage would then go away.
> 
>  3) The same optional fasync() return values cleanup.
> 
> Make sense?

yup.

If the ->i_lock think is no good then we can trivially switch over to a
global lock.  Heck, we could even go back to lock_kernel() ;)

