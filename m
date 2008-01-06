Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbYAFDfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbYAFDfu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 22:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbYAFDfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 22:35:42 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35519 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbYAFDfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 22:35:41 -0500
Date: Sun, 6 Jan 2008 03:35:37 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Gabor Gombas <gombasg@sztaki.hu>, Dave Young <hidave.darkstar@gmail.com>,
       linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net,
       Greg KH <greg@kroah.com>, ebiederm@xmission.com
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Message-ID: <20080106033537.GT27894@ZenIV.linux.org.uk>
References: <20071228173203.GA20690@boogie.lpds.sztaki.hu> <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com> <20080102151642.GA7273@boogie.lpds.sztaki.hu> <20080105075039.GF27894@ZenIV.linux.org.uk> <477F9481.2040505@gmail.com> <20080105194510.GK27894@ZenIV.linux.org.uk> <478037F8.8020103@gmail.com> <20080106021826.GR27894@ZenIV.linux.org.uk> <478042F3.7010002@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478042F3.7010002@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 11:54:43AM +0900, Tejun Heo wrote:
> That means sysfs_remove_dir() is called on parent while other operations
> are in progress on children, right?  sysfs has never allowed such things
> && AFAIK no one does that.  It's somewhat implied in the interface (such
> as recursive removing) but I fully agree it's problematic.  Things like
> these are why I think we need to unify/simplify locking as I wrote
> previously.

All it takes is kobject_rename() or kobject_move() called asynchronously 
wrt removal...  I don't see an explicit ban for that.

FWIW, what happens here *is* fishy, but I don't see an outright ban on
that in documentation - rfcomm_tty_open() does
                device_move(dev->tty_dev, rfcomm_get_device(dev));
when we get openers, rfcomm_tty_close() does
                device_move(dev->tty_dev, NULL);
when the number of openers hits zero.  Can happen repeatedly.

Note that device_move() with new parent being NULL is explicitly allowed
and handled, so...
