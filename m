Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab0BKSIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 13:08:24 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:36463 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359Ab0BKSIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 13:08:22 -0500
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
	<4B73671E.2050105@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 11 Feb 2010 10:08:16 -0800
In-Reply-To: <4B73671E.2050105@kernel.org> (Tejun Heo's message of "Thu\, 11 Feb 2010 11\:10\:38 +0900")
Message-ID: <m1mxzfzlv3.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
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

> Hello,
>
> On 02/11/2010 10:31 AM, Eric W. Biederman wrote:
>>> I think some code dynamically creates attributes today, as this has
>>> never been a restriction.
>>>
>>> So I don't know if this is going to work :(
>> 
>> I need to see how locks do this, but they face the same problem.  For
>> normal locks this is resolved by having a requirement to call a special
>> initializer in the dynamic case.  Adding that requirement for the
>> rare dynamically allocated sysfs attributes seems reasonable.
>
> Yeah, this is the same problem all other constructus face too and the
> reason why different variants of initializers are introduced for
> lockdep support.  For dynamic ones, making the initializer declare
> static key and using it to initialize lockdep_map should work.
>
>> Additionally sysfs attributes are exactly the right granularity for
>> lock classes because that is where the behavior is the same or
>> changes.
>
> Yeap.
>
>> We have 845 instances of static struct attributes which certainly makes
>> that the dominant case and worth aiming at.
>
> Yeah, and sysfs will be following the usual convention of dealing with
> these issues, which is the right thing to do.

I have been playing with it and so far the code doesn't seem too bad. I have
however come across another misfeature of sysfs.  sysfs_get_active_two appears
to be unnecessary overkill.

The purpose of the active references are to allows us to block when
removing sysfs entries that have custom methods so we don't remove
modules or those custom methods don't remove access data structures
after the files have been removed.  Further sysfs_remove_dir remove
all elements in the directory before removing the directory itself, so
there is no chance we will remove a directory with active children.

Tejun do you know of any other reason we want sysfs_get_active_two?

If not I think we can make active references apply exclusively to attributes.

Eric
