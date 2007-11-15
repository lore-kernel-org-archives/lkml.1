Return-Path: <linux-kernel-owner+w=401wt.eu-S933452AbXKOVYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452AbXKOVYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765269AbXKOVYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:24:15 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:56042 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757445AbXKOVYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:24:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AV0/nQnE4dpLkONilCfFKNRc/4eyQLP5np9+xIOXSUzPnQ2psUoqTUUhaXNdmeYg7VXdtuqE7vVIsqpQ0/qzA9UONTmG+DrINGHFRuEFbNbq9k5NYkIVz1E4s6VWNm2pIrtSTcK3Dkm9BEoUZ/SLEhAZPzNeZAJo9wAuXzdXvl4=
Message-ID: <64bb37e0711151324k2a10e683k506c50126ad1978f@mail.gmail.com>
Date: Thu, 15 Nov 2007 22:24:12 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Jan Blunck" <jblunck@suse.de>
Subject: Re: 2.6.24-rc2-mm1
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>
In-Reply-To: <20071115173627.GG25521@hasse.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	 <64bb37e0711141116h5ea9ed8cs7f2afbabe73f07bb@mail.gmail.com>
	 <20071114122939.7b4ee194.akpm@linux-foundation.org>
	 <64bb37e0711141448h15c667dbn4496870dd64a0457@mail.gmail.com>
	 <20071115173627.GG25521@hasse.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 15, 2007 6:36 PM, Jan Blunck <jblunck@suse.de> wrote:
> On Wed, Nov 14, Torsten Kaiser wrote:
>
> > > > So I can create new directories, but not new files. Reading files works normal.
> > > >>
> > > > The client is 2.6.24-rc2-mm1, the server 2.6.22-gentoo-r9.
> >
> > I added Jan Blunck to the recipents, as he wrote
> > use-struct-path-in-struct-svc_expkey and
> > use-struct-path-in-struct-svc_export
>
> These patches only change the server code. Hard to imagine how this could
> break the client. The other patches are pure cleanups only.

While the next bisect proved that these patches are innocent, I'm
still blaming you for my problems. ;)

The problem with the first bisect-try was, that everything between
bisect-good: r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename
and
bisect-bad: use-struct-path-in-struct-svc_export
did not compile like this:

  CC [M]  fs/nfsd/vfs.o
fs/nfsd/vfs.c: In function 'nfsd_rename':
fs/nfsd/vfs.c:1695: error: request for member 'mnt' in something not a
structure or union
make[2]: *** [fs/nfsd/vfs.o] Error 1
make[1]: *** [fs/nfsd] Error 2
make: *** [fs] Error 2

This is cause by: nfsd-fix-wrong-mnt_writer-count-in-rename

With this patch reverted I was able to finish the bisect:

Good: move-struct-path-into-its-own-header
...: embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt
Bad: embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes

As you also wrote
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt , I
would like to ask you to take another look at it.

The only thing that looks suspicious to me in that patch is the
following change in nfs4_atomic_open(), nfs4_open_revalidate() and
nfs4_proc_create()

-	struct path path = {
-		.mnt = nd->mnt,
-		.dentry = dentry,
-	};
+	struct path path = nd->path;

This changes the path.dentry from the explizit parameter 'dentry' to
the embedded dentry from the parameter 'nd'.

Hope this helps.

Torsten
