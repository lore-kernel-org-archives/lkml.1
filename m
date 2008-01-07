Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbYAGCiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbYAGCiF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 21:38:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYAGChx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 21:37:53 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:44563 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbYAGChw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 21:37:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Lu2otrpU4lUxbONl5lRvGRjCG69lINoy8S2B2FVxiX0W5cG9PM+GAfu0vw1gDg33MnLNj9eiLP9XHVK3aj8/zD6RZJLASAby2QXpO99za4fuFtvYOYElsMTDPgvO7o3+0+JllSoYowUChyfoKoX/wtLOmwiXNXVR7wQ3eedVfZ0=
Message-ID: <47819079.3000606@gmail.com>
Date: Mon, 07 Jan 2008 11:37:45 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Gabor Gombas <gombasg@sztaki.hu>, Dave Young <hidave.darkstar@gmail.com>,
       linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net,
       Greg KH <greg@kroah.com>, ebiederm@xmission.com
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
References: <20071228173203.GA20690@boogie.lpds.sztaki.hu> <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com> <20080102151642.GA7273@boogie.lpds.sztaki.hu> <20080105075039.GF27894@ZenIV.linux.org.uk> <477F9481.2040505@gmail.com> <20080105194510.GK27894@ZenIV.linux.org.uk> <478037F8.8020103@gmail.com>
In-Reply-To: <478037F8.8020103@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Tejun Heo wrote:
> Al Viro wrote:
>> On Sat, Jan 05, 2008 at 11:30:25PM +0900, Tejun Heo wrote:
>>>> Assuming that this is what we get, everything looks explainable - we
>>>> have sysfs_rename_dir() calling sysfs_get_dentry() while the parent
>>>> gets evicted.  We don't have any exclusion, so while we are playing
>>>> silly buggers with lookups in sysfs_get_dentry() we have parent become
>>>> negative; the rest is obvious...
>>> That part of code is walking down the sysfs tree from the s_root of
>>> sysfs hierarchy and on each step parent is held using dget() while being
>>> referenced, so I don't think they can turn negative there.
>> Turn?  Just what stops you from getting a negative (and unhashed) from
>> lookup_one_noperm() and on the next iteration being buggered on mutex_lock()?
> 
> Right, I haven't thought about that.  When sysfs_get_dentry() is called,
> @sd is always valid so unless there was existing negative dentry, lookup
> is guaranteed to return positive dentry, but by populating dcache with
> negative dentry before a node is created, things can go wrong.  I don't
> think that's what's going on here tho.  If that was the case, the
> while() loop looking up the next sd to lookup (@cur) should have blown
> up as negative dentry will have NULL d_fsdata which doesn't match any sd.
> 
> I guess what's needed here is d_revalidate() as other distributed
> filesystems do.  I'll test whether this can be actually triggered and
> prepare a fix.  Thanks a lot for pointing out the problem.

This can't happen because lookup of non-existent entry doesn't create a
negative dentry.  The new dentry is never hashed and killed after lookup
failure, the above scenario can't happen.

That said, the mechanism is a bit too fragile.  sysfs currently ensures
that dentry/inode point to the associated sysfs_dirent.  This is mainly
remanent of conversion from previous VFS based implementation.  I think
the right thing to do here is to make sysfs behave like other proper
distributed filesystems using d_revalidate.

Thanks.

-- 
tejun
