Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbZFEJDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbZFEJDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbZFEJDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:03:42 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52859 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbZFEJDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:03:41 -0400
To: ebiederm@xmission.com
CC: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, hugh@veritas.com, tj@kernel.org,
       adobriyan@gmail.com, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, gregkh@suse.de, npiggin@suse.de,
       akpm@linux-foundation.org, hch@infradead.org, ebiederm@xmission.com,
       ebiederm@aristanetworks.com
In-reply-to: <1243893048-17031-4-git-send-email-ebiederm@xmission.com>
Subject: Re: [PATCH 04/23] vfs: Introduce infrastructure for revoking a file
References: <m1oct739xu.fsf@fess.ebiederm.org> <1243893048-17031-4-git-send-email-ebiederm@xmission.com>
Message-Id: <E1MCVKj-0007O3-Rp@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 05 Jun 2009 11:03:29 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Very interesting work.

On Mon,  1 Jun 2009, Eric W. Biederman wrote:
> The file_hotplug_lock has a very unique implementation necessitated by
> the need to have no performance impact on existing code.  Classic locking
> primitives and reference counting cause pipeline stalls, except for rcu
> which provides no ability to preventing reading a data structure while
> it is being updated.

Well, the simple solution to that is to add another level of indirection:

old:

  fdtable -> file

new:

  fdtable -> persistent_file -> file

Then it is possible to replace persistent_file->file with a revoked
one under RCU.  This has the added advantage that it supports
arbitrary file replacements, not just ones which return EIO.

Another advantage is that dereferencing can normally be done "under
the hood" in fget()/fget_light().  Only code which wants to
permanently store a file pointer (like the SCM_RIGHTS thing) would
need to be aware of the extra complexity.

Would that work, do you think?

Thanks,
Miklos
