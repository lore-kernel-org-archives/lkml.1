Return-Path: <linux-kernel-owner+w=401wt.eu-S965855AbXCPSzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965855AbXCPSzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 14:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965864AbXCPSzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 14:55:44 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36905 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965855AbXCPSzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 14:55:43 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Hansen <hansendc@us.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, menage@google.com,
       Andrew Morton <akpm@linux-foundation.org>, xemul@sw.ru
Subject: Re: [RFC][PATCH 2/7] RSS controller core
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru>
	<20070306140036.4e85bd2f.akpm@linux-foundation.org>
	<45F3F581.9030503@sw.ru>
	<20070311045111.62d3e9f9.akpm@linux-foundation.org>
	<20070312010039.GC21861@MAIL.13thfloor.at>
	<1173724979.11945.103.camel@localhost.localdomain>
	<20070312224129.GC21258@MAIL.13thfloor.at>
	<20070312220439.677b4787.akpm@linux-foundation.org>
	<1173806793.6680.44.camel@localhost.localdomain>
	<20070313190931.1417c012@lxorguk.ukuu.org.uk>
	<m1mz2enh0u.fsf@ebiederm.dsl.xmission.com>
	<1174062660.8184.8.camel@localhost.localdomain>
Date: Fri, 16 Mar 2007 12:54:09 -0600
In-Reply-To: <1174062660.8184.8.camel@localhost.localdomain> (Dave Hansen's
	message of "Fri, 16 Mar 2007 09:31:00 -0700")
Message-ID: <m1tzwlm33i.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen <hansendc@us.ibm.com> writes:

> On Thu, 2007-03-15 at 18:55 -0600, Eric W. Biederman wrote:
>> To create a DOS attack.
>> 
>> - Allocate some memory you know your victim will want in the future,
>>   (shared libraries and the like).
>> - Wait until your victim is using the memory you allocated.
>> - Terminate your memory resource group.
>> - Victim is pushed over memory limits by your exiting.
>> - Victim can no longer allocate memory
>> - Victim dies
>> 
>> It's not quite that easy unless your victim calls mlockall(MCL_FUTURE),
>> but the potential is clearly there.
>> 
>> Am I missing something?  Or is this fundamental to any first touch scenario?
>> 
>> I just know I have problems with first touch because it is darn hard to
>> reason about.
>
> I think it's fundamental to any case where two containers share the use
> of the page, but either one _can_ be charged but does not receive a
> _full_ charge for it.

Reasonable.

> I don't think it's uniquely associated with first-touch schemes.
>
> The software zones approach where there would be a set of "shared" zones
> would not have this problem, because any sharing would have to occur on
> data on which neither one was being charged.

True.   The "shared" zones approach would simply have the problem that it
would make sharing hard and thus reduce the effectiveness of the page cache.

The "shared" zone approach also would seem to interact in very weird ways
with real NUMA and memory hotplug or process migration.  The fact that we
actually have to care about the real memory size on the machine makes me
look at it strange.

Zones should definitely be penalized in some category for the reduction
in efficiency of the page cache.  It took us decades to learn that the
most efficient page cache was one that could resize and reallocate memory
on demand based on the current usage.  Zones and possibly anything else
with the concept of page ownership seems to be trying to be ignoring
that wisdom.

> http://linux-mm.org/SoftwareZones


Looking at your page, and I'm too lazy to figure out how to update it
I have a couple of comments.

- Why do limits have to apply to the unmapped page cache?

- Could you mention proper multi process RSS limits.
  (I.e.  we count the number of pages each group of processes have mapped
   and limit that).
  It is the same basic idea as partial page ownership, but instead of
  page ownership you just count how many pages each group is using and
  strictly limit that.  There is no page owner ship or partial charges.
  The overhead is just walking the rmap list at map and unmap time to
  see if this is the first users in the container.  No additional kernel
  data structures are needed.

Eric
