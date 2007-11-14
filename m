Return-Path: <linux-kernel-owner+w=401wt.eu-S1764813AbXKNWvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764813AbXKNWvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 17:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbXKNWu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 17:50:56 -0500
Received: from mail.fieldses.org ([66.93.2.214]:58937 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755863AbXKNWuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 17:50:55 -0500
Date: Wed, 14 Nov 2007 17:50:50 -0500
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, richterd@citi.umich.edu
Subject: Re: generic_setlease and tmpfs -- LTP fcntl failure
Message-ID: <20071114225050.GA14772@fieldses.org>
References: <4DACDAEF-A2B4-438D-A330-85FD5E65E3DE@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DACDAEF-A2B4-438D-A330-85FD5E65E3DE@kernel.crashing.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 03:19:31PM -0600, Kumar Gala wrote:
> In debugging a LTP failure related to fcntl on tmpfs it appears that we 
> aren't able to use fcntl(fd, F_SETLEASE, F_WRLCK).  In the debugging it 
> looks like we artificial increase the dentry->d_count and so 
> generic_setlease() always fails with -EAGAIN since it appears 
> dentry->d_count will be 2.
>
> This is my first time delving into fs code so I'm not that familiar with 
> why tmpfs is artificially increasing the d_count.  I was wondering what a 
> possible solution would be.
>
> Maybe something like:
>
> shmem_setlease(...) {
> 	if (arg == F_WRLCK) {
> 		dput(dentry)
> 		generic_setlease(...)
> 		dget(dentry)
> 	} else {
> 		generic_setlease(...)
> 	}
> }
>
> Not sure what harm doing the dput() / dget() will have.

I guess if you *know* for whatever reason that you hold two references
on the dentry, then that might be safe.

I'd be happier if we could come up with some better way for the setlease
code to determine whether someone has the file open for writing.  The
current tests seem incredibly fragile.

Would it be at all reasonable, for example, to keep a count of the
number of readers stored in the inode?

--b.
