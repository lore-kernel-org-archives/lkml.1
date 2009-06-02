Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbZFBWvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbZFBWvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756543AbZFBWvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:51:24 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56639 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333AbZFBWvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:51:22 -0400
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
	<m1eiu2qqho.fsf@fess.ebiederm.org>
	<alpine.DEB.1.10.0906021429570.12866@makko.or.mcafeemobile.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 02 Jun 2009 15:51:14 -0700
In-Reply-To: <alpine.DEB.1.10.0906021429570.12866@makko.or.mcafeemobile.com> (Davide Libenzi's message of "Tue\, 2 Jun 2009 14\:52\:41 -0700 \(PDT\)")
Message-ID: <m13aaintb1.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: davidel@xmailserver.org, ebiederm@aristanetworks.com, ebiederm@maxwell.aristanetworks.com, hch@infradead.org, akpm@linux-foundation.org, npiggin@suse.de, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, adobriyan@gmail.com, tj@kernel.org, hugh@veritas.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi <davidel@xmailserver.org> writes:

> On Tue, 2 Jun 2009, Eric W. Biederman wrote:
>
>> Davide Libenzi <davidel@xmailserver.org> writes:
>> 
>> > On Mon, 1 Jun 2009, Eric W. Biederman wrote:
>> >
>> >> From: Eric W. Biederman <ebiederm@maxwell.aristanetworks.com>
>> >> 
>> >> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>> >> ---
>> >>  fs/eventpoll.c |   39 ++++++++++++++++++++++++++++++++-------
>> >>  1 files changed, 32 insertions(+), 7 deletions(-)
>> >
>> > This patchset gives me the willies for the amount of changes and possible 
>> > impact on many subsystems.
>> 
>> It both is and is not that bad.  It is the cost of adding a lock.
>
> We both know that it is not only the cost of a lock, but also the 
> sprinkling over a pretty vast amount of subsystems, of another layer of 
> code.

I am not clear what problem you have.

Is it the sprinkling the code that takes and removes the lock?  Just
the VFS needs to be involved with that.  It is a slightly larger
surface area than doing the work inside the file operations as we
sometimes call the same method from 3-4 different places but it is
definitely a bounded problem.

Is it putting in the handful lines per subsystem to actually use this
functionality?  At that level something generic that is maintained
outside of the subsystem is better than the mess we have with 4-5
different implementations in the subsystems that need it, each having
a different assortment of bugs.

>> I thought of doing something more uniform to user space.  But I observed
>> that the existing epoll punts on the case of a file descriptor being closed
>> and locking to go from a file to the other epoll datastructures is pretty
>> horrid I said forget it and used the existing close behaviour.
>
> Well, you cannot rely on the caller to tidy up the epoll fd by issuing an 
> epoll_ctl(DEL), so you do *need* to "punt" on close in order to not leave 
> lingering crap around. You cannot even hold a reference of the file, since 
> otherwise the epoll hooking will have to trigger not only at ->release() 
> time, but at every close, where you'll have to figure out if this is the 
> last real userspace reference or not. Plus all the issues related to 
> holding permanent extra references to userspace files.
> And since a file can be added in many epoll devices, you need to 
> unregister it from all of them (hence the other datastructures lookup). 
> Better this, on the slow path, with locks acquired only in the epoll usage 
> case, than some other thing and on the fast path, for every file.

Sure, and that is largely and I am preserving those semantics.

Eric
