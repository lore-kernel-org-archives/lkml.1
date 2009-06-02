Return-Path: <linux-kernel-owner+w=401wt.eu-S1760711AbZFBHOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760711AbZFBHOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760490AbZFBHON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:14:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53183 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760600AbZFBHOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:14:11 -0400
Date: Tue, 2 Jun 2009 09:14:11 +0200
From: Nick Piggin <npiggin@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Tejun Heo <tj@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 04/23] vfs: Introduce infrastructure for revoking a file
Message-ID: <20090602071411.GE31556@wotan.suse.de>
References: <m1oct739xu.fsf@fess.ebiederm.org> <1243893048-17031-4-git-send-email-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243893048-17031-4-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 02:50:29PM -0700, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Introduce the file_hotplug_lock to protect file->f_op, file->private,
> file->f_path from revoke operations.
> 
> The file_hotplug_lock is used typically as:
> error = -EIO;
> if (!file_hotplug_read_trylock(file))
> 	goto out;
> ....
> file_hotplug_read_unlock(file);

Why is it called hotplug? Does it have anything to do with hardware?
Because every concurrently changed software data structure in the
kernel can be "hot"-modified, right?

Wouldn't file_revoke_lock be more appropriate?


> In addition for a complete solution we need:
> - A reliable way the file structures that we need to revoke.
> - To wait for but not tamper with ongoing file creation and cleanup.
> - A guarantee that all with user space controlled duration are removed.
> 
> The file_hotplug_lock has a very unique implementation necessitated by
> the need to have no performance impact on existing code.  Classic locking

Well, it isn't no performance impact. Function calls, branches, icache
and dcache...

