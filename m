Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbZKDTQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbZKDTQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757906AbZKDTQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:16:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757900AbZKDTQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:16:12 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 03/20] blkio: Introduce the notion of weights
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
	<1257291837-6246-4-git-send-email-vgoyal@redhat.com>
	<x498wemuy6v.fsf@segfault.boston.devel.redhat.com>
	<20091104154135.GA2870@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 04 Nov 2009 14:15:47 -0500
In-Reply-To: <20091104154135.GA2870@redhat.com> (Vivek Goyal's message of
	"Wed, 4 Nov 2009 10:41:35 -0500")
Message-ID: <x49skcurti4.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Wed, Nov 04, 2009 at 10:06:16AM -0500, Jeff Moyer wrote:
>> Vivek Goyal <vgoyal@redhat.com> writes:
>> 
>> > o Introduce the notion of weights. Priorities are mapped to weights internally.
>> >   These weights will be useful once IO groups are introduced and group's share
>> >   will be decided by the group weight.
>> 
>> I'm sorry, but I need more background to review this patch.  Where do
>> the min and max come from?  Why do you scale 7-0 from 200-900?  How does
>> this map to what was there before (exactly, approximately)?
>> 
>
> Well, So far we only have the notion of iopriority for the process and
> based on that we determine time slice length.
>
> Soon we will throw cfq groups also in the mix. Because cpu IO controller
> is weight driven, people have shown preference that group's share should
> be decided based on its weight and not introduce the notion of ioprio for
> groups.

I certainly agree with that.

> Hence, to begin with I wanted to limit the range of weights allowed because
> wider range opens up lot of interesting corner cases. That's why limited
> minimum weight to 100. So at max user can expect the 1000/100=10 times service
> differentiation between highest and lower weight groups. If folks need more
> than that, we can look into it once things stablize.
>
> Priority and weights follow reverse order. Higher priority means low
> weight and vice-versa.
>
> Currently we support 8 priority levels and prio "4" is the middle point.
> Anything higher than prio 4 gets 20% less slice as compared to prio 4 and
> priorities lower than 4, get 20% higher slice of prio 4 (20% higher/lower
> for each priority level).
>
> For weight range 100 - 1000, 500 can be considered as mid point. Now this
> is how priority mapping looks like.
>
> 	100 200 300 400 500 600 700 800 900 1000  (Weights) 
> 	     7   6   5   4   3   2  1   0         (io prio).
>
> Once priorities are converted to weights, we are able to retain the notion
> of 20% difference between prio levels by choosing 500 as the mid point and
> mapping prio 0-7 to weights 900-200, hence this mapping. 

I see.  So when using the old ioprio mechanism, we get a smaller range
of possible values than with the cgroup configuration.

> I am all ears if you have any suggestions on how this ca be handled
> better.

I think that's a fine way to handle it.  I just needed to be spoon-fed.
It would be nice if you included a write-up of how service is
differentiated in your documentation patch.  In other words, from the
point of view of the sysadmin, how does he use the thing?  Simple math
would likely help, too.

Cheers,
Jeff
