Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbYAFDzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbYAFDzE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 22:55:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbYAFDyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 22:54:54 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:55011 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbYAFDyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 22:54:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=fb/TZZvEPOjZLjrmKseyKA5vyT4R0yr7p7rphNTCXodX0zokPiMw9HSkj3dRCahNmliFjhzIOQ/XnKYVzdaT2ciJlkTxAJIRu8cqEHQmaixLJ7RToJw5Fl04HAtbcx5Q8XuYgDbouEdTpwk0KHWduvwV3ij9HRdfknE0eY4mel4=
Message-ID: <47805106.70607@gmail.com>
Date: Sun, 06 Jan 2008 12:54:46 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Gabor Gombas <gombasg@sztaki.hu>, Dave Young <hidave.darkstar@gmail.com>,
       linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net,
       Greg KH <greg@kroah.com>, ebiederm@xmission.com, kay.sievers@vrfy.org
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
References: <20071228173203.GA20690@boogie.lpds.sztaki.hu> <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com> <20080102151642.GA7273@boogie.lpds.sztaki.hu> <20080105075039.GF27894@ZenIV.linux.org.uk> <477F9481.2040505@gmail.com> <20080105194510.GK27894@ZenIV.linux.org.uk> <478037F8.8020103@gmail.com> <20080106021826.GR27894@ZenIV.linux.org.uk> <478042F3.7010002@gmail.com> <20080106033537.GT27894@ZenIV.linux.org.uk>
In-Reply-To: <20080106033537.GT27894@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Al Viro wrote:
> On Sun, Jan 06, 2008 at 11:54:43AM +0900, Tejun Heo wrote:
>> That means sysfs_remove_dir() is called on parent while other operations
>> are in progress on children, right?  sysfs has never allowed such things
>> && AFAIK no one does that.  It's somewhat implied in the interface (such
>> as recursive removing) but I fully agree it's problematic.  Things like
>> these are why I think we need to unify/simplify locking as I wrote
>> previously.
> 
> All it takes is kobject_rename() or kobject_move() called asynchronously 
> wrt removal...  I don't see an explicit ban for that.

There really hasn't been any stone-set rules for how sysfs can be used
and what operations are allowed simultaneously although sysfs
implementation always had a lot of assumptions about which ops can and
can't be done simultaneously.

The general assumption is that the caller is responsible for its and its
children's lifetime management which is usually followed as sysfs nodes
are removed when a device goes away or driver detaches at which point no
other ops should be in progress anyway.

I think this stems partially from tight coupling with kobject / driver
model.  kobject and driver model have certain rules about how they can
be used (again not explicit enough) and sysfs implementation kind of
piggy backed on those rules and added its own assumptions on top of it.
 After a while, it's hard to track what's assumed where and implementing
or changing one feature somewhere breaks some assumption elsewhere.
This is the primary reason why I think sysfs should be an independent
component which the driver model uses not something intertwined into
driver model while having mostly separate implementation.

> FWIW, what happens here *is* fishy, but I don't see an outright ban on
> that in documentation - rfcomm_tty_open() does
>                 device_move(dev->tty_dev, rfcomm_get_device(dev));
> when we get openers, rfcomm_tty_close() does
>                 device_move(dev->tty_dev, NULL);
> when the number of openers hits zero.  Can happen repeatedly.
> 
> Note that device_move() with new parent being NULL is explicitly allowed
> and handled, so...

(cc'ing Kay Sievers) IIRC, that's device class compatibility thing.
Overlapping move's are okay tho as they're protected from each other by
sysfs_rename_mutex.  I'll take a look at the rfcomm code and see what's
going on tomorrow.  Gotta hit the road now.

Thanks.

-- 
tejun
