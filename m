Return-Path: <linux-kernel-owner+w=401wt.eu-S1752464AbYKXG4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbYKXG4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 01:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbYKXG4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 01:56:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:34382 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbYKXG4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 01:56:37 -0500
Message-ID: <492A500C.9090200@kernel.org>
Date: Mon, 24 Nov 2008 15:56:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>,
       Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/2] md: make devices disappear when they are no longer
 needed.
References: <20081124035516.3465.66413.stgit@notabene.brown> <20081124035530.3465.26724.stgit@notabene.brown> <492A2B2B.7030606@kernel.org> <18730.14324.830648.449469@notabene.brown> <492A3CE6.4010206@kernel.org> <20081124062417.GZ28946@ZenIV.linux.org.uk>
In-Reply-To: <20081124062417.GZ28946@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 24 Nov 2008 06:56:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
>> I suppose so.  Maybe just void (*release)(struct gendisk *) but Jens is
>> the maintainer.  Jens, what do you think?
> 
> First of all, release is already taken (with exactly that argument, BTW).

Right.  :-(

> And doing that at freeing gendisk is a bad idea - md.ko might have been
> long gone by the time you've got there, not to mention anything else...
> IOW, it's too late; once the damn thing is not opened anymore (and nobody
> is the middle of trying to open it), the module might be dead and gone,
> so all uses of ->private_data and ->fops are illegal aftenr that point.

mddev holds module reference and till the gendisk is gone mddev won't
be gone, so as long as gendisk is around the respective mddev and
md.ko are around.

This is because creation and deletion of md devices are managed by
userland and the module is kept referenced as long as there are active
devices.  The current block interface only verifies ops availability
before open and asks drivers to verify object validity separately in
->open, which makes sense if the intention is to allow rmmod while
devices are hot, but it also requires the low level driver to
implement index of all active devices and look them up atomically
during ->open, which sometimes is unnatural to implement as it's
unnecesary for any other purpose and can create subtle races as shown
by md.

I don't think it's necessary to allow modules to unload while devices
are hot.  SCSI doesn't follow it (at least not at the block layer),
nor does md.  It's seldom necessary to unload those modules in the
first place and when necessary active devices can be killed via sysfs
or mdadm (which BTW makes more sense to me - kill the users before
unloading the module).  Without such requirement, both block and
character devices can stick with more regular reference counting like
the rest of the kernel.

Thanks.

-- 
tejun
