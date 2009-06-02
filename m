Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbZFBV64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbZFBV64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 17:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZFBV6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 17:58:46 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:42841 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZFBV6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 17:58:45 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 2 Jun 2009 14:52:41 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>,
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
In-Reply-To: <m1eiu2qqho.fsf@fess.ebiederm.org>
Message-ID: <alpine.DEB.1.10.0906021429570.12866@makko.or.mcafeemobile.com>
References: <m1oct739xu.fsf@fess.ebiederm.org> <1243893048-17031-18-git-send-email-ebiederm@xmission.com> <alpine.DEB.1.10.0906020944540.12866@makko.or.mcafeemobile.com> <m1eiu2qqho.fsf@fess.ebiederm.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jun 2009, Eric W. Biederman wrote:

> Davide Libenzi <davidel@xmailserver.org> writes:
> 
> > On Mon, 1 Jun 2009, Eric W. Biederman wrote:
> >
> >> From: Eric W. Biederman <ebiederm@maxwell.aristanetworks.com>
> >> 
> >> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> >> ---
> >>  fs/eventpoll.c |   39 ++++++++++++++++++++++++++++++++-------
> >>  1 files changed, 32 insertions(+), 7 deletions(-)
> >
> > This patchset gives me the willies for the amount of changes and possible 
> > impact on many subsystems.
> 
> It both is and is not that bad.  It is the cost of adding a lock.

We both know that it is not only the cost of a lock, but also the 
sprinkling over a pretty vast amount of subsystems, of another layer of 
code.



> I thought of doing something more uniform to user space.  But I observed
> that the existing epoll punts on the case of a file descriptor being closed
> and locking to go from a file to the other epoll datastructures is pretty
> horrid I said forget it and used the existing close behaviour.

Well, you cannot rely on the caller to tidy up the epoll fd by issuing an 
epoll_ctl(DEL), so you do *need* to "punt" on close in order to not leave 
lingering crap around. You cannot even hold a reference of the file, since 
otherwise the epoll hooking will have to trigger not only at ->release() 
time, but at every close, where you'll have to figure out if this is the 
last real userspace reference or not. Plus all the issues related to 
holding permanent extra references to userspace files.
And since a file can be added in many epoll devices, you need to 
unregister it from all of them (hence the other datastructures lookup). 
Better this, on the slow path, with locks acquired only in the epoll usage 
case, than some other thing and on the fast path, for every file.



- Davide


