Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbZI1OH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbZI1OH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 10:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbZI1OH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 10:07:58 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42437 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbZI1OH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 10:07:57 -0400
To: Jamie Lokier <jamie@shareable.org>
CC: miklos@szeredi.hu, Valdis.Kletnieks@vt.edu, linux@treblig.org,
       agruen@suse.de, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20090928132845.GC19778@shareable.org> (message from Jamie Lokier
	on Mon, 28 Sep 2009 14:28:45 +0100)
Subject: Re: [PATCH] vfs: new O_NODE open flag
References: <E1Mqpfq-0003uZ-Pw@pomaz-ex.szeredi.hu> <200909250223.58664.agruen@suse.de> <E1Mr3jF-0005G4-Sf@pomaz-ex.szeredi.hu> <20090925123747.GA31228@gallifrey> <9988.1253899252@turing-police.cc.vt.edu> <20090925183523.GA6065@gallifrey> <19645.1253913514@turing-police.cc.vt.edu> <E1MsDQ6-0001cY-92@pomaz-ex.szeredi.hu> <20090928132845.GC19778@shareable.org>
Message-Id: <E1MsGtJ-0001xy-5T@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 28 Sep 2009 16:07:49 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Sep 2009, Jamie Lokier wrote:
> Miklos Szeredi wrote:
> > BTW I just checked, and it is possible to re-open or promote an fd
> > opened with O_NODE like this:
> > 
> > 	char tmp[64];
> > 
> > 	fd = open(filename, O_NODE | O_NOACCESS);
> > 	/* ... */
> > 	sprintf(tmp, "/proc/self/fd/%i", fd);
> > 	fd_rw = open(tmp, O_RDWR);
> > 
> > Now fd_rw is guaranteed to refer to the same inode as fd.
> 
> If someone passes you a file descriptor opened with O_RDONLY, you
> shouldn't be able to upgrade it to O_RDWR unless you have access to
> the file and could do a normal open() on the file.
> 
> I hope the above cannot convert O_NOACCESS to O_RDWR without checking
> that you have access to the file.

The permissions are checked on the inode at open.  It doesn't matter
how the inode came to be looked up, via a normal path or via a file
descriptor in proc, the results are the same.

> Hmm.  I have just tried, and you _can _use open("/proc/self/fd/%d",
> O_RDWR) to re-open with more permissions when you can't access the
> path which /proc/self/fd/%d pretends to link to.  It looks a bit
> dubious, as you might have been passed an O_RDONLY descriptor with the
> intention that you can't write to it...  Oh well!

True, /proc gives you access to the underlying "path" of an open file
descriptor.  If you don't want that, don't mount /proc in your limited
namespace.

Thanks,
Miklos
