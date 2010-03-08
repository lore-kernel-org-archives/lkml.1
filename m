Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab0CHBZn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 20:25:43 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57859 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab0CHBZl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 20:25:41 -0500
MIME-Version: 1.0
In-Reply-To: <20100306174106.GC30031@ZenIV.linux.org.uk>
References: <20100306102919.GA2341@core.coreip.homeip.net>
	 <20100306104946.GB30031@ZenIV.linux.org.uk>
	 <20100306172727.GA13120@core.coreip.homeip.net>
	 <20100306174106.GC30031@ZenIV.linux.org.uk>
Date: Sun, 7 Mar 2010 20:25:40 -0500
Message-ID: <7e0fb38c1003071725t5b19d6bbtbedb46afd1d816f2@mail.gmail.com>
Subject: Re: Selinux going crazy in 2.6.34-rc0
From: Eric Paris <eparis@parisplace.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, James Morris <jmorris@namei.org>,
       sds@tycho.nsa.gov, davidel@xmailserver.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 6, 2010 at 12:41 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sat, Mar 06, 2010 at 09:27:27AM -0800, Dmitry Torokhov wrote:
>
>> > Interesting...  That smells like a selinux policy that needed recognition
>> > of inotify file descriptors and got b0rken by
>> > commit c44dcc56d2b5c79ba3063d20f76e5347e2e418f6
>> > that switched inotify to use of anon_inodes.  Could you check if that's the
>> > trigger?
>>
>> Yep, that was it. With this commit reverted selinux stays quiet.
>> Well, almost, it is never completely quiet ;).
>>
>> Thank you Al.
>
> Hrm...  Folks, does anybody have suggestions on what to do about that one?
> I can revert that thing, of course, but I wonder what's really going on
> in the policy that triggers that spew...

That is certainly an interesting little thing I never thought about
and I'm both an SELinux and inotify maintainer so no surprise noone
else thought about it either!  SELinux defines rules which label
different filesystem types with different default labels such as an
nfs filesystem would be nfs_t and an tmpfs would be tmpfs_t.  Inotify
was using it's own filesystem an applications which used inotify got
rules like so:

   allow policykit_t inotifyfs_t : dir { ioctl read getattr lock
search open } ;

Now that we switch inotify to use generic anon inode code rather than
duplicate creating it's own filesystem type for a single inode we
screwed up those rule types.  I'm trying to thing of a good solution
and the only two things come to mind:

a) revert the change and any others that switches things to anon
inodes from their own private fs (were there others?)
b) allow multiple anonymous inodes with differing security contexts,
possibly one inode per anon inodefs "class" would be sufficient to
allow for fine grained security controls over anon inode subsystems?
I haven't looked closely, but that seems like a reasonable trade off
between fine grained security and memory usage....

-Eric
