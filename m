Return-Path: <linux-kernel-owner+w=401wt.eu-S1758407AbYAFCSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407AbYAFCSj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 21:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756176AbYAFCSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 21:18:31 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57799 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053AbYAFCSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 21:18:31 -0500
Date: Sun, 6 Jan 2008 02:18:26 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Gabor Gombas <gombasg@sztaki.hu>, Dave Young <hidave.darkstar@gmail.com>,
       linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net,
       Greg KH <greg@kroah.com>, ebiederm@xmission.com
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Message-ID: <20080106021826.GR27894@ZenIV.linux.org.uk>
References: <20071228173203.GA20690@boogie.lpds.sztaki.hu> <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com> <20080102151642.GA7273@boogie.lpds.sztaki.hu> <20080105075039.GF27894@ZenIV.linux.org.uk> <477F9481.2040505@gmail.com> <20080105194510.GK27894@ZenIV.linux.org.uk> <478037F8.8020103@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478037F8.8020103@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 11:07:52AM +0900, Tejun Heo wrote:

> Right, I haven't thought about that.  When sysfs_get_dentry() is called,
> @sd is always valid so unless there was existing negative dentry, lookup
> is guaranteed to return positive dentry, but by populating dcache with
> negative dentry before a node is created, things can go wrong.  I don't
> think that's what's going on here tho.  If that was the case, the
> while() loop looking up the next sd to lookup (@cur) should have blown
> up as negative dentry will have NULL d_fsdata which doesn't match any sd.

No.  What happens if sd gets unlinked while we are on the way to
sysfs_get_dentry() and so does its parent?  The parent is off the
sibling list, we get negative dentry from lookup.  It's not hashed,
so won't stick around in dcache (which is apparently what you are
thinking about).  However, _THIS_ lookup has returned you a dentry
with NULL ->d_inode and you are well and truly buggered.
