Return-Path: <linux-kernel-owner+w=401wt.eu-S1759574AbZFWQcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574AbZFWQcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758707AbZFWQbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:31:50 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42324 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758788AbZFWQbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:31:49 -0400
To: dhowells@redhat.com
CC: alan@lxorguk.ukuu.org.uk, dhowells@redhat.com, miklos@szeredi.hu,
       hch@infradead.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       viro@ZenIV.linux.org.uk, adilger@sun.com, akpm@linux-foundation.org
In-reply-to: <16755.1245773452@redhat.com> (message from David Howells on Tue,
	23 Jun 2009 17:10:52 +0100)
Subject: Re: [RFC] O_NOACC: open without any access
References: <20090623170610.7fd8a3f8@lxorguk.ukuu.org.uk> <E1MJ7gC-0007mx-CY@pomaz-ex.szeredi.hu> <E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu> <20090623134640.GA13831@infradead.org> <E1MJ6jW-0007cz-Mp@pomaz-ex.szeredi.hu> <20090623143408.GA2147@infradead.org> <16370.1245772337@redhat.com> <16755.1245773452@redhat.com>
Message-Id: <E1MJ8u3-00083c-TD@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 23 Jun 2009 18:31:23 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, David Howells wrote:
> Reference count on which module?  This would not take a reference on
> the device driver as it would not refer to it, but would still have
> a file struct, an inode struct and a dentry struct on the underlying
> fs.

So how about the following: provide a new open flag O_FILESYSTEM,
meaning it opens the file on the underlying filesystem instead of the
device/socket/symlink/etc...

Add a new inode->i_filesystem_fop pointer which is used instead of
inode->i_fop in case if O_FILESYSTEM.  If ->i_filesystem_fop isn't set
by the filesystem, fall back to a default which returns -EBADF for all
operations (except open).

Define O_NOACC as 3.  On open(..., O_FILESYSTEM | O_NOACC) require no
privileges on the file.

AFS would set up i_filesystem_fop with its ->ioctl() function. No
special handling needed for revoke()...

That would work, no?

Thanks,
Miklos

