Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbYKMI7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbYKMI7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 03:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYKMI73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 03:59:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:39425 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbYKMI72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 03:59:28 -0500
Message-ID: <491BEC4E.9030505@kernel.org>
Date: Thu, 13 Nov 2008 17:58:54 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] char_dev: add cdev->release() and convert	cdev_alloc()
 to use it
References: <48B6D428.2020308@kernel.org> <20080828164741.GA17475@kroah.com> <48B6D8D0.6080506@kernel.org> <20080828173813.GC18097@kroah.com> <48B6E417.5030605@kernel.org> <20080828174807.GA18461@kroah.com> <48B6E69B.1090800@kernel.org> <20080828181720.GB23898@kroah.com>
In-Reply-To: <20080828181720.GB23898@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 13 Nov 2008 08:58:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

I'm now trying to convert the cdev thing for CUSE and it just ain't
feel right.

Greg KH wrote:
>> Ah.. right, but taking cdev refcount out of the picture requires adding
>> 'severing' operation on cdev f_ops, which certainly is doable but isn't
>> it just cleaner to make cdev follow the usual lifetime management rules?
>>  An object which is referenced counted requires ->release if it's gonna
>> be used in any non-simplistic way.
> 
> Yes, but as you "normally" tie the cdev to the module itself, that
> handles the lifetime rules.

That "normally" is from the days when only a single or fixed number of
devices are associated with single module or driver.

> Now I really dont' like the current cdev interface, it's a bit too
> complex as it needed to support the old-style interfaces without any
> build time changes, but I think your change isn't needed as somehow all
> the current drivers that support dynamic devices don't need it.

Yes, it requires all drivers to have global device table and check
whether the device is still available at ->open.  For most, drivers
usually have certain fixed number of devices which can directly be
indexed with minor.  For CUSE, it gotta be a hash table or a b-tree.
I don't really see any point in not adding ->release.  Time has
changed and everybody is playing with reference counts and ->release
methods.  Plus, cdev_alloc() interface is half-baked anyway (no free
function for cases where cdev_add() fails, drivers call cdev_del() in
those cases risking unregistering other driver's map).  It's perfectly
okay to keep it around for compatibility but there just is no reason
to cling to it.

> Actually, the kobject in cdev shouldn't be an kobject, it's not used for
> registering with sysfs at all, it should just be a kref.  I sweep the
> tree for code that sets the name of the cdev every few months as people
> don't seem to realize this :)

Heh... CUSE did that too.  Removing it.

Thanks.

-- 
tejun
