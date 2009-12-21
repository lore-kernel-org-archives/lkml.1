Return-Path: <linux-kernel-owner+w=401wt.eu-S1751680AbZLUNbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbZLUNbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 08:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbZLUNbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 08:31:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:50312 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbZLUNbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 08:31:34 -0500
Message-ID: <4B2F7879.2080901@kernel.org>
Date: Mon, 21 Dec 2009 22:30:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
References: <1261141088-2014-1-git-send-email-tj@kernel.org>	 <1261143924.20899.169.camel@laptop>  <4B2EE5A5.2030208@kernel.org> <1261387377.4314.37.camel@laptop>
In-Reply-To: <1261387377.4314.37.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On 12/21/2009 06:22 PM, Peter Zijlstra wrote:
> On Mon, 2009-12-21 at 12:04 +0900, Tejun Heo wrote:
>> When IO goes wrong, in extreme
>> cases, it can easily take over thirty secs to recover and that's
>> required by the hardware specifications, so anything which ends up
>> waiting on IO can take a pretty long time.  The only piece of code
>> which is necessary to support that is the code necessary to migrate
>> back tasks to CPUs when they come online again.  It's not a lot of
>> ugly code. 
> 
> Why does it need to get migrated back, there are no affinity promises if
> you allow hotplug to continue, so it might as well complete and continue
> on the other cpu.
> 
> And yes, it is a lot of very ugly code.

Migrating to online but !active CPU is necessary to call rescuers
during CPU_DOWN_PREPARE which is necessary to guarantee forward
progress during cpu down operation.  Given that, the only extra code
which is necessary purely for migrating back when a CPU comes back
online is a few tens of lines of code which handles TRUSTEE_RELEASE
case.  That's not a lot.  If we do it differently (ie. let unbound
workers not process new works, just drain and let them die), it will
take more code.

I think you're primarily concerned with the scheduler modifications
and think that the choose-between-two-masks on migration is ugly.  I
agree it's not the prettiest thing in this world but then again it's
not a lot of code.  The reason why it looks ugly is because the way
migration is implemented and parameter is passed in.  API-wise, I
think making kthread_bind() synchronized against cpu onliness should
be pretty clean.

Thanks.

-- 
tejun
