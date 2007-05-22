Return-Path: <linux-kernel-owner+w=401wt.eu-S935467AbXEVWK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935467AbXEVWK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760485AbXEVWKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:10:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51620 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758936AbXEVWKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:10:47 -0400
Date: Tue, 22 May 2007 23:10:46 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] file as directory
Message-ID: <20070522221045.GH4095@ftp.linux.org.uk>
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 08:48:49PM +0200, Miklos Szeredi wrote:
> Why do we want this?
> --------------------
> 
> That depends on who you ask.  My answer is this:
> 
>   'foo.tar.gz/foo/bar' or
>   'foo.tar.gz/contents/foo/bar'
> 
> or something similar.
> 
> Others might suggest accessing streams, resource forks or extended
> attributes through such an interface.  However this patch only deals
> with the non-directory case, so directories would be excluded from
> that interface.
> 
> But otherwise this patch doesn't limit the uses of the "file as
> directory" concept in any way.  It just adds the infrastructure to
> support these whacky beasts.
> 
> How is it done?
> ---------------
> 
> (See this [1] thread for more discussion on the subject)
> 
> When a non-directory object is accessed without a trailing slash, then
> path resolution returns the object itself as usual.
> 
> If a non-directory object is accessed with a trailing slash, then the
> filesystem may opt to let the file be accessed as a directory.  In
> this case "something" (as supplied by the filesystem) is mounted on
> top of the non-directory object.
> 
> This mount will have special properties:
> 
>  - If there's no trailing slash is after the file name, the mount
>    won't be followed, even if the path resolution would otherwise
>    follow mounts.
> 
>  - The mount only stays there while it is referenced by some external
>    object, like a pwd or an open file.  When it is no longer
>    referenced, it is automatically unmounted.
> 
>  - Unlike "real" mounts, this won't block unlink(2) or rename(2) on
>    the underlying object.

Interesting...  How do you deal with mount propagation and things like
mount --move?  As for unlink...  How do you deal with having that thing
mounted, mounting something _under_ it (so that vfsmount would be kept
busy) and then unlinking that sucker?

I'll look through the patch tonight; it sounds interesting, assuming that
we don't run into serious crap with locking and <shudder> revalidation
logics.
