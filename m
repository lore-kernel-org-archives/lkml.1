Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab0BLBVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 20:21:06 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:55283 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847Ab0BLBVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 20:21:01 -0500
To: Tejun Heo <tj@kernel.org>
Cc: Greg KH <gregkh@suse.de>,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: differentiate between locking links and non-links
References: <19314.1869.847327.15190@notabene.brown>
	<2375c9f91002091808n713275dsc9ace8f51871364e@mail.gmail.com>
	<4B7217CF.2080702@kernel.org> <m1vde57c11.fsf@fess.ebiederm.org>
	<4B728CFE.40208@kernel.org> <m1sk992bji.fsf@fess.ebiederm.org>
	<20100210230544.GA678@suse.de> <m1ocjwwob1.fsf@fess.ebiederm.org>
	<4B73671E.2050105@kernel.org> <m1mxzfzlv3.fsf@fess.ebiederm.org>
	<4B74A7F3.9000001@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
In-Reply-To: <4B74A7F3.9000001@kernel.org> (Tejun Heo's message of "Fri\, 12 Feb 2010 09\:59\:31 +0900")
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
Date: Thu, 11 Feb 2010 17:20:57 -0800
Message-ID: <m1r5oruu4m.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello, Eric.
>
> On 02/12/2010 03:08 AM, Eric W. Biederman wrote:
>> I have been playing with it and so far the code doesn't seem too bad. I have
>> however come across another misfeature of sysfs.  sysfs_get_active_two appears
>> to be unnecessary overkill.
>>
>> The purpose of the active references are to allows us to block when
>> removing sysfs entries that have custom methods so we don't remove
>> modules or those custom methods don't remove access data structures
>> after the files have been removed.  Further sysfs_remove_dir remove
>> all elements in the directory before removing the directory itself, so
>> there is no chance we will remove a directory with active children.
>> 
>> Tejun do you know of any other reason we want sysfs_get_active_two?
>> 
>> If not I think we can make active references apply exclusively to
>> attributes.
>
> Yeah, it's necessary for something which I can't remember from the top
> of my head ATM.  It maybe has something to do with attributes not
> holding reference to the owning module while the parent kobj does.
> I'll dig in but IIRC it's not there just for fun.  Is it difficult to
> do the lockdep annotation without removing get_active_two?

Probably double the code and testing, plus.  I could not figure out
where to stash a lock_class_key for directories.  So it certainly would
be a pain to keep get_active_two just because.

If you can figure out what the value of an active reference on a directory
is we can keep them.

My reasoning is that we effectively get an active reference on directories
for free because we have to delete the children before we can delete a
directory.

I do know we have to go up to the directory to get the kobject.  So
from that perspective it makes sense.

It would not surprise me if there was a reason that is now gone
that required the active references on directories.  sysfs has gone through
a lot of cleanups since that code was added.

Eric
