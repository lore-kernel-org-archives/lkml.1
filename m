Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbYJ1XNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbYJ1XNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 19:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbYJ1XNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 19:13:05 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57154 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbYJ1XNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 19:13:04 -0400
To: ncunningham@crca.org.au
CC: miklos@szeredi.hu, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-reply-to: <1225235054.9661.37.camel@nigel-laptop> (message from Nigel
	Cunningham on Wed, 29 Oct 2008 10:04:14 +1100)
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for
	frozen	filesystems.
References: <1224886068.6478.21.camel@nigel-laptop>
	 <E1KuQ1J-0002Vw-9Q@pomaz-ex.szeredi.hu>
	 <1225106427.26724.5.camel@nigel-laptop> <200810271237.40049.rjw@sisk.pl>
	 <1225107607.26724.9.camel@nigel-laptop>
	 <E1KuRN4-0002gS-Hq@pomaz-ex.szeredi.hu>
	 <1225141168.26724.23.camel@nigel-laptop>
	 <E1KuZKt-0003jl-2N@pomaz-ex.szeredi.hu>
	 <1225145607.26724.54.camel@nigel-laptop>
	 <E1Kuv87-00064p-Lk@pomaz-ex.szeredi.hu> <1225235054.9661.37.camel@nigel-laptop>
Message-Id: <E1Kuxk4-0006NT-Ie@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 29 Oct 2008 00:12:52 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008, Nigel Cunningham wrote:
> > However it does not fix the freezing of tasks which are waiting for
> > VFS locks (i.e. inode->i_mutex) held by the outstanding fuse requests.
> > This is the tricky part...
> 
> Okay. Looking back on our conversation brought me back to this message,
> which I think needs another reply.
> 
> If we take the strategy of holding new requests and allowing existing
> ones to complete, then am I right in thinking that we only need to worry
> about where inode->i_mutex is taken in fs/fuse/file.c (I don't see it
> taken in other fs/fuse/*.c files).

Nope, i_mutex is usually taken by the VFS not the filesystem.  That
means that the filesystem is called with the mutex already held.  Try
"grep i_mutex fs/*.c".  There's also sb->s_vfs_rename_mutex, for all
the gory details see Documentation/filesystems/Locking.

So it's not just having to fix fuse, it's having to "fix" the VFS as
well.

Miklos
