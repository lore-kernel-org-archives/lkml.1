Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbYDRNvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbYDRNvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 09:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbYDRNvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 09:51:07 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:6093 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbYDRNvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 09:51:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=iDyG8Sxsg296QteDZvWHQF8gNlUPxRkQpz4/FqpwEJEE7XsUIz3Swaqjql7Jw/QyhoW/G42OmL8v+lyrmlGGmxp+uaZD/eSMft2+zVDeOl5uOAJ07uodaSbAoM/upo1jo8/oqin7Lye5YhOeT2uvANbdbKGou65edSSP/chXzng=
Message-ID: <b6c5339f0804180651m2a291755ke093bda3bea1d2b4@mail.gmail.com>
Date: Fri, 18 Apr 2008 09:51:03 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Szabolcs Szakacsits" <szaka@ntfs-3g.org>
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, hch@infradead.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.61.0804181302180.29728@dhcppc2>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com>
	 <20080412170304.54f139e2.akpm@linux-foundation.org>
	 <20080413033344.GA27494@hash.localnet>
	 <20080412205544.5e12a7d4.akpm@linux-foundation.org>
	 <20080413080130.GA9622@infradead.org>
	 <20080413012001.8d7967f4.akpm@linux-foundation.org>
	 <20080413082815.GA20108@infradead.org>
	 <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
	 <20080414004521.GA30489@hash.localnet>
	 <Pine.LNX.4.61.0804181302180.29728@dhcppc2>
X-Google-Sender-Auth: 53c47661cc9660e7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 6:30 AM, Szabolcs Szakacsits <szaka@ntfs-3g.org> wrote:
>  On Sun, 13 Apr 2008, Bob Copeland wrote:
>
>  > I don't have hard numbers, but anecdotally my FUSE version is quite
>  > a bit less performant.  That's no criticism of FUSE - I just haven't
>  > put the time into optimizing and adding various caches.
>
>  Thankfully you need none, it's already there by FUSE and the kernel. The
>  trick is exactly that you can have the kernel performance and the left is
>  moved to user space with typically negligible performance overhead which is
>  usually well compensated with faster delivered new features and bug fixes.

Correct me if I'm wrong, but one place where caches seem necessary is for
lookup.  My file system already has an inode number; my understanding
is that the kernel inode cache and dcache are caching the FUSE inode by
filename and its hashed inode number.

In FUSE, on open, I'm passed a filename which I then have to resolve into an
inode # via my own lookup.  The VFS does the path_lookup as part of sys_open,
and since I get to put private data into the struct inode, I'll generally
already have the block # and various other info in the dcache by the time
open is called.

Also, if you stuff inode data into the private fh field in fuse_file_info,
you need to be sure that any subsequent lookups always return the same
inode structure, otherwise a thread doing ftruncate vs one doing truncate
will cause issues.  So I created an internal dcache to solve those two
problems.

>  I noticed that the OMFS kernel driver supports only the USB interface and
>  the FUSE one both the network and the USB one. Isn't it possible that you
>  compared the performance using the USB with the kernel vs the much slower
>  and lower latency network with FUSE?

Nope, that's not possible, sorry.  Both require use of USB.  lkarmafs and
omfs_fuse aren't the same thing.

>  If you did use the USB interface with FUSE then what exactly do you mean by
>  "quite a bit less performance" in numbers and workloads? What you did, how
>  long it took using what CPU?

Like I said it was anecdotal (copy 20 gigs of X) in both.  I'm sure a
good portion of it is my fault, such as doing unnecessary malloc & copies
in omfs_fuse.  I have put exactly zero effort into making it fast so far.

BTW, I hardly intended to start a huge VFS vs FUSE debate.  I think FUSE
is great.  I'm not sure it's the right fit for this, is all.

-- 
Bob Copeland %% www.bobcopeland.com
