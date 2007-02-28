Return-Path: <linux-kernel-owner+w=401wt.eu-S933175AbXB1RHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175AbXB1RHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 12:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933168AbXB1RHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 12:07:14 -0500
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:45723 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933173AbXB1RHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 12:07:12 -0500
To: staubach@redhat.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <45E58EB8.6030502@redhat.com> (message from Peter Staubach on
	Wed, 28 Feb 2007 09:16:24 -0500)
Subject: Re: [patch 01/22] update ctime and mtime for mmaped write
References: <20070227231442.627972152@szeredi.hu> <20070227231544.519463073@szeredi.hu> <45E58EB8.6030502@redhat.com>
Message-Id: <E1HMSGE-000886-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 28 Feb 2007 18:06:38 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> These change still have the undesirable property that although the
> modified pages may be flushed to stable storage, the metadata on
> the file will not be updated until the application takes positive
> action.  This is permissible given the current wording in the
> specifications, but it would be much more desirable if sync(2),
> fsync(P), or the inode being written out due to normal system
> activity would also cause the metadata to be updated.
> 
> Perhaps the setting of the flag could be checked in some places
> like __sync_single_inode() and do_fsync()?

I don't see the point in updating the timestamp from these functions.

The file isn't _modified_ by sync() or fsync().  Just as it's not
modified by stat().

sync() and fsync() do cache->disk, while the file itself stays the
same.

OTOH msync(MS_ASYNC) does memory->file, which is a conceptually file
modifying operation.  OK, msync(MS_ASYNC) is actually a no-op on
2.6.18+, but that's purely an implementation detail and no application
should be relying on it.

Before 2.6.18 sync() or fsync() acually didn't flush data written
through a shared mapping to disk, only msync(MS_SYNC), because the
dirty state was only available in the page tables, not in the page or
the inode.

Miklos
