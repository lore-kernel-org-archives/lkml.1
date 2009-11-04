Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbZKDTZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbZKDTZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbZKDTZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:25:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbZKDTZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:25:55 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 11/20] blkio: Some CFQ debugging Aid
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
	<1257291837-6246-12-git-send-email-vgoyal@redhat.com>
	<x49hbtat94s.fsf@segfault.boston.devel.redhat.com>
	<20091104191232.GI2870@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 04 Nov 2009 14:25:04 -0500
In-Reply-To: <20091104191232.GI2870@redhat.com> (Vivek Goyal's message of
	"Wed, 4 Nov 2009 14:12:32 -0500")
Message-ID: <x49ocnirt2n.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Wed, Nov 04, 2009 at 01:52:51PM -0500, Jeff Moyer wrote:
>> > +config DEBUG_BLK_CGROUP
>> > +	bool
>> > +	depends on BLK_CGROUP
>> > +	default n
>> > +	---help---
>> > +	Enable some debugging help. Currently it stores the cgroup path
>> > +	in the blk group which can be used by cfq for tracing various
>> > +	group related activity.
>> > +
>> >  endif # BLOCK
>> >  
>> 
>> > +config DEBUG_CFQ_IOSCHED
>> > +	bool "Debug CFQ Scheduling"
>> > +	depends on CFQ_GROUP_IOSCHED
>> > +	select DEBUG_BLK_CGROUP
>> 
>> This seems wrong.  DEBUG_CFQ_IOSCHED sounds like it enables debugging of
>> CFQ.  In your implementation, though, it only enables this in tandem
>> with the blkio cgroup infrastructure.  Please decouple these things.
>> 
>
> What's wrong with this? We are emitting more debugging information for
> CFQ like cgroup name and paths in blktrace output. That's a different
> thing that internally that information is also dependent debugging being
> enabled in blk io controller.
>
> Important thing here is that blk io controller and its debugging option is
> automatically selected depending on what user wants from end policies.
>
> So I really can't see that what's wrong if CFQ debugging option internally
> selects some other config option also.

Sorry, I wasn't very clear.  DEBUG_CFQ_IOSCHED implies that we are
debugging CFQ.  However, in this case, we're only debugging the
BLKIO_CGROUP bits in the CFQ I/O scheduler.  I would prefer if maybe you
did the following:

#ifdef DEBUG_CFQ_IOSCHED
#ifdef DEBUG_BLK_CGROUP

#endif
#endif

Then, if there was later some debugging stuff added to CFQ that was not
specific to the cgroup infrastructure, it could be put in.

Maybe it's not worth worrying about right now.  I'll leave it to Jens.

>> > +#ifdef CONFIG_DEBUG_BLK_CGROUP
>> > +	/* Store cgroup path */
>> > +	char path[128];
>> > +#endif
>> 
>> Where does 128 come from?  What's wrong with PATH_MAX?
>
> CFS influence (kernel/sched_debug.c)
>
> Actually PATH_MAX will be 4096 bytes. Too long to display in blktrace
> output? I have not check what's the blktrace limit but we don't want too
> long a lines in output. 

OK, you're right.  I wouldn't want to embed 4k in there anyway.

Cheers,
Jeff
