Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbZCLGMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbZCLGMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 02:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbZCLGMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 02:12:17 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:42285 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247AbZCLGMQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 02:12:16 -0400
Message-ID: <49B8A75E.6040409@cosmosbay.com>
Date: Thu, 12 Mar 2009 07:10:38 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jeff Moyer <jmoyer@redhat.com>, Avi Kivity <avi@redhat.com>,
       linux-aio <linux-aio@kvack.org>, zach.brown@oracle.com, bcrl@kvack.org,
       linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] fs: fput() can be called from interrupt context
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com>	<49B54143.1010607@redhat.com>	<x49sklmd1fo.fsf@segfault.boston.devel.redhat.com>	<49B57CB0.5020300@cosmosbay.com>	<49B875F7.3030305@cosmosbay.com>	<49B87CFE.4000701@cosmosbay.com>	<49B89B22.7080303@cosmosbay.com> <20090311224712.fb8db075.akpm@linux-foundation.org>
In-Reply-To: <20090311224712.fb8db075.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 12 Mar 2009 07:10:39 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton a écrit :
> On Thu, 12 Mar 2009 06:18:26 +0100 Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
>> Eric Dumazet wrote :
>>> Path could be :
>>>
>>> 1) fput() changes so that calling it from interrupt context is possible
>>>    (Using a working queue to make sure __fput() is called from process context)
>>>
>>> 2) Changes aio to use fput() as is (and zap its internal work_queue and aio_fput_routine() stuff)
>>>
>>> 3) Once atomic_long_dec_and_test(&filp->f_count) only performed in fput(),
>>>    SLAB_DESTROY_BY_RCU for "struct file" get back :)
>>>
>> Please find first patch against linux-2.6
>>
>> Next patch (2) can cleanup aio code, but it probably can wait linux-2.6.30
>>
>> Thank you
>>
>> [PATCH] fs: fput() can be called from interrupt context
>>
>> Current aio/eventfd code can call fput() from interrupt context, which is
>> not allowed.
> 
> The changelog forgot to tell us where this happens, and under what
> circumstances.
> 
> See, there might be other ways of fixing the bug,

Sure

> 
>> In order to fix the problem and prepare SLAB_DESTROY_BY_RCU use for "struct file"
>> allocation/freeing in 2.6.30, we might extend existing workqueue infrastructure and
>> allow fput() to be called from interrupt context.
>>
>> This unfortunalty adds a pointer to 'struct file'.
>>
>> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
>> ---
>>  fs/file.c               |   55 ++++++++++++++++++++++++++------------
>>  fs/file_table.c         |   10 +++++-
>>  include/linux/fdtable.h |    1
>>  include/linux/fs.h      |    1
>>  4 files changed, 49 insertions(+), 18 deletions(-)
> 
> which might not have some or all of the above problems.
> 
> 
> I assume you're referring to really_put_req(), and commit
> 9c3060bedd84144653a2ad7bea32389f65598d40.
> 
>>From the above email straggle I extract "If user program closes
> eventfd, then inflight AIO requests can trigger a bug" and I don't
> immediately see anything in there which would prevent this.
> 
> Did you reproduce the bug, and confirm that the patch fixes it?

take Davide program : http://www.xmailserver.org/eventfd-aio-test.c

and add at line 318 :
close(afd);

It should produce the kernel bug...
> 
> Are there simpler ways of fixing it?  Maybe sneak a call to
> wait_for_all_aios() into the right place?  I doubt if it's performance
> critical, as nobody seems to have ever hit the bug.

Take the time to check how fs/aio.c handle the fput(req->ki_filp) case
(or read my 2nd patch, it should spot the thing)

If you want to add another kludge to properly fput(req->ki_eventfd),
be my guest :-(

> 
> Bear in mind that if the bug _is_ real then it's now out there, and
> we would like a fix which is usable by 2.6.<two-years-worth>.
> 
> etcetera..




