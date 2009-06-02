Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbZFBVYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbZFBVYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 17:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbZFBVXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 17:23:54 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57740 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbZFBVXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 17:23:53 -0400
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Tejun Heo <tj@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@maxwell.aristanetworks.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 18/23] vfs: Teach epoll to use file_hotplug_lock
References: <m1oct739xu.fsf@fess.ebiederm.org>
	<1243893048-17031-18-git-send-email-ebiederm@xmission.com>
	<alpine.DEB.1.10.0906020944540.12866@makko.or.mcafeemobile.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 02 Jun 2009 14:23:47 -0700
In-Reply-To: <alpine.DEB.1.10.0906020944540.12866@makko.or.mcafeemobile.com> (Davide Libenzi's message of "Tue\, 2 Jun 2009 09\:51\:42 -0700 \(PDT\)")
Message-ID: <m1eiu2qqho.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: davidel@xmailserver.org, ebiederm@aristanetworks.com, ebiederm@maxwell.aristanetworks.com, hch@infradead.org, akpm@linux-foundation.org, npiggin@suse.de, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, adobriyan@gmail.com, tj@kernel.org, hugh@veritas.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi <davidel@xmailserver.org> writes:

> On Mon, 1 Jun 2009, Eric W. Biederman wrote:
>
>> From: Eric W. Biederman <ebiederm@maxwell.aristanetworks.com>
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>> ---
>>  fs/eventpoll.c |   39 ++++++++++++++++++++++++++++++++-------
>>  1 files changed, 32 insertions(+), 7 deletions(-)
>
> This patchset gives me the willies for the amount of changes and possible 
> impact on many subsystems.

It both is and is not that bad.  It is the cost of adding a lock.
For the VFS except for nfsd the I have touched everything that needs to be
touched.

Other subsystems that open read/write close files should be able to use
existing vfs helpers so they don't need to know about the new locking
explicitly.

Actually taking advantage of this infrastructure in a subsystem is
comparatively easy.  It took me about an hour to get uio using it.
That part is not deep by any means and is opt in.

> Without having looked at the details, are you aware that epoll does not 
> act like poll/select, and fds are not automatically removed (as in, 
> dequeued from the poll wait queue) in any foreseeable amount of time after 
> a POLLERR is received?

Yes I am aware of how epoll acts differently.

> As far as the usespace API goes, they have the right to remain there.

I absolutely agree.

Currently I have the code acting like close() with respect to epoll and
just having the file descriptor vanish at the end of the revoke.  While
we the revoke is in progress you get an EIO.

The file descriptor is not freed by a revoke operation so you can happily
hang unto it as long as you want.

I thought of doing something more uniform to user space.  But I observed
that the existing epoll punts on the case of a file descriptor being closed
and locking to go from a file to the other epoll datastructures is pretty
horrid I said forget it and used the existing close behaviour.

Eric
