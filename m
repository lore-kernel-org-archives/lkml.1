Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYH1Rrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYH1Rrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756224AbYH1Rqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:46:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:59239 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342AbYH1RqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:46:16 -0400
Message-ID: <48B6E417.5030605@kernel.org>
Date: Thu, 28 Aug 2008 19:44:55 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] char_dev: add cdev->release() and convert	cdev_alloc()
 to use it
References: <48B6D428.2020308@kernel.org> <20080828164741.GA17475@kroah.com> <48B6D8D0.6080506@kernel.org> <20080828173813.GC18097@kroah.com>
In-Reply-To: <20080828173813.GC18097@kroah.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 17:46:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Aug 28, 2008 at 06:56:48PM +0200, Tejun Heo wrote:
>> Greg KH wrote:
>>> Ick, I really don't want struct cdev to be used for lifecycle
>>> management, as it is only for major:minor stuff.  Why do you want to
>>> make this change?
>> Well, as cdev can be referenced from userspace, ->release is required
>> for most purposes.  The reason why devices have been getting by without
>> it is because most chardevs are created on module load and destroyed on
>> module unload and in the meantime cdev refcount virtually equals module
>> refcnt, but I'm fairly sure we have cases where cdev can be destroyed
>> for other reasons then module unloading and it's very likely those cases
>> are buggy in the current code (backing structure gone bug cdev still
>> hanging around).
> 
> Hm, I thought Al covered that when he created the cdev interface, I
> would be a bit supprised if this was the case.

Hmmm.... I've never actually audited the code so... it could be that no
chardev is created and destroyed that way, I guess.

>> As CUSE can create and destroy devices regardless of module reference
>> count, it falls in the second category and needs cdev->release() to make
>> sure the backing structure doesn't go away till cdev is released.
> 
> But CUSE should be it's own module, right?  And it would "own" the cdev,
> so the module and cdev count should be fine and matching.  The userspace
> code could go away but the CUSE code should handle that with a different
> reference count.  This is the way that hardware drivers handle the
> issue.

The problem is not the device to talk to CUSE (/dev/cuse as in
/dev/fuse), for which module refcount and device refcount match fine.
But the whole point of CUSE is allowing CUSE clients to create arbitrary
character devices, so in addition to /dev/cuse which clients use to talk
to CUSE, CUSE hosts character devices for its clients and they come and
go dynamically and thus requires proper lifetime management.

Thanks.

-- 
tejun
