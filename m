Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbYJGMVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbYJGMVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 08:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYJGMVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 08:21:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:51765 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159AbYJGMVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 08:21:46 -0400
Message-ID: <48EB53B8.5020309@kernel.org>
Date: Tue, 07 Oct 2008 21:19:04 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sysfs: tagged directories not merged completely yet
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com>	<48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org>	<20081003101331.GH28946@ZenIV.linux.org.uk>	<48EB27FE.2090009@kernel.org> <m1zllgzki0.fsf@frodo.ebiederm.org>
In-Reply-To: <m1zllgzki0.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Oct 2008 12:20:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>> If the filler is a real concern, I think it's better to just decouple
>> it rather than making sysfs locking fine-grained.  sysfs metadata
>> might as well be protected by a single spinlock if it can be decoupled
>> from vfs locking and stuff.  It's just an in-memory tree which isn't
>> used too often.
> 
> I think with a little care we can make the sysfs read side rcu
> protected which would remove any real locking from lookup
> and readdir.

IIRC, the original readdir implementation put a cursor entry to walk
through the children list.  The implementation was horribly broken in
a number of different ways (ISTR problems with locking and multiple
and different type of walkers) and I just gutted out all the
complexity out and made it simple as getting it correct was far more
important and there seemed to be little need for optimization.

Yeah, using RCU sounds like a plan.

>> Generally, the VFS layer isn't too easy for sysfs which is a bit like
>> distributed filesystem but has more strict here-and-now rule (all
>> changes should be visible instantaneously).  At the beginning, sysfs
>> didn't have much metadata itself, it just used the VFS data structures
>> but that was too large so sysfs_dirent got introduced and it tried to
>> update VFS data structures as necessary and (this is when I started
>> working on it) the current code and Eric's patcheset evolved from
>> there.
>>
>> Maybe it can be done better by taking more traditional distributed
>> filesystem approach - re/invalidation on access.  I don't know whether
>> it will fit sysfs's needs but if it can be done, sysfs would be able
>> to ride along with other distributed filesystems and become much more
>> conventional in its interfacing with VFS.
> 
> The revalidate on access model doesn't appear to have a way to track
> remote renames.  Something sysfs supports.

Yeap, IIRC, one of the reasons why sysfs wasn't converted over to
sysfs was because sysfs guarantees inode doesn't change over rename or
move so that notifications keep working over renames.

> I have just spent a little bit of time thinking it through.  I had
> previously thought that we could take advantage of the fact that
> sysfs only allows VFS reads we could fix our backwards lock ordering
> by optimizing the read side with rcu.  Unfortunately the VFS still
> takes locks on rename and similar paths despite the fact sysfs does
> not implement those paths functions.  Therefore whatever we do has
> to be handle all VFS operations even if we don't support them.
> Weird, but true.
> 
> We may need to delay dentry unhashing until revalidate.  I think I see
> some issues if we don't do that.

Ah... okay.  It shouldn't be difficult, right?

Thanks.

-- 
tejun
