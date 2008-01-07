Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbYAGIWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbYAGIWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 03:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbYAGIWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 03:22:38 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42123 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbYAGIWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 03:22:38 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <htejun@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Gabor Gombas <gombasg@sztaki.hu>,
       Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, Greg KH <greg@kroah.com>,
       ebiederm@xmission.com
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
References: <20071228173203.GA20690@boogie.lpds.sztaki.hu>
	<a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com>
	<20080102151642.GA7273@boogie.lpds.sztaki.hu>
	<20080105075039.GF27894@ZenIV.linux.org.uk>
	<477F9481.2040505@gmail.com>
	<20080105194510.GK27894@ZenIV.linux.org.uk>
	<478037F8.8020103@gmail.com> <47819079.3000606@gmail.com>
Date: Mon, 07 Jan 2008 01:21:40 -0700
In-Reply-To: <47819079.3000606@gmail.com> (Tejun Heo's message of "Mon, 07 Jan
	2008 11:37:45 +0900")
Message-ID: <m1abnikpuz.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> writes:

> Hello,
>
> Tejun Heo wrote:
>> Al Viro wrote:
>>> On Sat, Jan 05, 2008 at 11:30:25PM +0900, Tejun Heo wrote:
>>>>> Assuming that this is what we get, everything looks explainable - we
>>>>> have sysfs_rename_dir() calling sysfs_get_dentry() while the parent
>>>>> gets evicted.  We don't have any exclusion, so while we are playing
>>>>> silly buggers with lookups in sysfs_get_dentry() we have parent become
>>>>> negative; the rest is obvious...
>>>> That part of code is walking down the sysfs tree from the s_root of
>>>> sysfs hierarchy and on each step parent is held using dget() while being
>>>> referenced, so I don't think they can turn negative there.
>>> Turn?  Just what stops you from getting a negative (and unhashed) from
>>> lookup_one_noperm() and on the next iteration being buggered on mutex_lock()?
>> 
>> Right, I haven't thought about that.  When sysfs_get_dentry() is called,
>> @sd is always valid so unless there was existing negative dentry, lookup
>> is guaranteed to return positive dentry, but by populating dcache with
>> negative dentry before a node is created, things can go wrong.  I don't
>> think that's what's going on here tho.  If that was the case, the
>> while() loop looking up the next sd to lookup (@cur) should have blown
>> up as negative dentry will have NULL d_fsdata which doesn't match any sd.
>> 
>> I guess what's needed here is d_revalidate() as other distributed
>> filesystems do.  I'll test whether this can be actually triggered and
>> prepare a fix.  Thanks a lot for pointing out the problem.
>
> This can't happen because lookup of non-existent entry doesn't create a
> negative dentry.  The new dentry is never hashed and killed after lookup
> failure, the above scenario can't happen.
>
> That said, the mechanism is a bit too fragile.  sysfs currently ensures
> that dentry/inode point to the associated sysfs_dirent.  This is mainly
> remanent of conversion from previous VFS based implementation.  I think
> the right thing to do here is to make sysfs behave like other proper
> distributed filesystems using d_revalidate.

Huh?  We still need something like sysfs_get_dentry to find the dentries
for the rename or move operation.  So we can call d_move.  

Further we should be talking about sysfs_move_dir not sysfs_rename_dir
as only the networking code calls sysfs_rename_dir.  Not that it is
significantly different.

I think I saw a change in lock ordering recently to help distributed
filesystems, and maybe that will simplify some of this.

Anyway I figure if I am to understand this I better go look and see if
I can find the start of this thread.  I don't have a clue
where we are blowing up.

Eric
