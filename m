Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbZKESZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbZKESZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758210AbZKESZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:25:37 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59783 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757705AbZKESZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:25:36 -0500
Date: Thu, 5 Nov 2009 18:25:48 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       dhowells@redhat.com, hch@infradead.org, adilger@sun.com,
       mtk.manpages@gmail.com, torvalds@linux-foundation.org,
       drepper@gmail.com, jamie@shareable.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 resend] vfs: new O_NODE open flag
Message-ID: <20091105182548.07ca4bff@lxorguk.ukuu.org.uk>
In-Reply-To: <E1N65Zt-0003L5-84@pomaz-ex.szeredi.hu>
References: <E1N60RV-0002ed-FX@pomaz-ex.szeredi.hu>
	<20091105131545.72b4e319@lxorguk.ukuu.org.uk>
	<E1N63Io-000353-KX@pomaz-ex.szeredi.hu>
	<20091105145054.11f36b35@lxorguk.ukuu.org.uk>
	<E1N64Ch-0003C6-Rn@pomaz-ex.szeredi.hu>
	<20091105155648.4329f5b7@lxorguk.ukuu.org.uk>
	<E1N65Zt-0003L5-84@pomaz-ex.szeredi.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Take a step back and look at what would be required for this to be
> exploitable:

Oh I realise its very minor but care is needed, and its the cases that
haven't been considered that I worry about far more - eg the way you
missed the device stuff.

>  1) a file which is readable and writable by some user
>  2) but is not reachable by said user (because of permissions on path)
>  3) a privileged process opening this file with O_RDONLY
>  4) sending the fd it to an unprivileged process owned by user
>  5) assuming that user won't be able to write it (even though the file
>     has write permission)

The case I found examples of is this

	normal uid process
	exec setuid process
	chdir into locked away directory
	setreuid back

That case is safe because the process is undumpable/unptraceable (which
also keeps /proc/*/fd covered)

The case where it then execs unpriviledged code is interesting. It would
then open up the proc hole but its also true that dumpable would be false
so ptrace could also be used. So its not adding a hole.

> If I was a system designer, I'd think of that as a very fragile
> assumption.

Agreed. Read app code for an afternoon ;)

> Right, that's a valid point.
> 
> So re-opening a device node opened with O_NODE is not safe, I agree.
> Which means, I'll either have to remove the possibilty of re-opening
> O_NODE files through proc, or limit it to non-device nodes.
> 
> I'd really prefer just limiting it, since that would leave re-opening
> a useful feature, while having minimal risk (especially if documented)
> of it causing trouble.

It's certainly a better starting point. See why I said it should default
to unsupported and get added as you review each case ?

> But I can be convinced either way with sufficiently good arguments :)

Basically you need revoke(). That isn't new news either

> > open O_NODE
> > remote file moves
> > new one appears
> > reopen
> 
> Consider
> 
>  open O_RDONLY
>  remote file moves
>  new one appears
>  fstat
> 
> What's the difference?

CIFS in the second case gets a handle to the remote object I believe. NFS
certainly gets it right.

> > Now what should happen and what does happen ?

You stat the wrong file, the O_RDONLY case should stat the right file.
Similar for NFS as NFS will acquire a handle to the file. There isn't any
reason any of these shouldn't work but the moment you start going into
the fs you disappear back into the murky world of unmount

Possibly Christoph is broken as designed ;)

The unix worldview is essentially that a name is an unreliable reference
- it's a lookup directory that changes all the time. A file handle is an
object reference. It persists with the object, its effectively even
refcounted. The handle *is* the thing itself, the name is a transient
momentary thing.

> > That doesn't seem to be the case testing it, but its fixable trivially if
> > so and its fixable without API breakage.
> 
> No it's not.  While a node is looked up, it will pin the mount, albeit
> for just a short time.  And permission on the inode itself are not
> required for lookup, only permissions on the parent.
> 
> I think you are being paranoid here.  If the user has access to the
> path leading up the mountpoint, he might as well pin that mount.
> Permissions on the mount itself shouldn't really make a difference.

Which gets us back to revoke() strangely enough. I am being paranoid. But
security is about being paranoid because you have to out-think all the
bad guys all the time.
