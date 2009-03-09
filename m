Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbZCIR5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbZCIR5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 13:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZCIR5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 13:57:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52253 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbZCIR5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 13:57:24 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-aio <linux-aio@kvack.org>, zach.brown@oracle.com, bcrl@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] aio: remove aio-max-nr and instead use the memlock rlimit to limit the number of pages pinned for the aio completion ring
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com>
	<49B54143.1010607@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 09 Mar 2009 13:57:15 -0400
In-Reply-To: <49B54143.1010607@redhat.com> (Avi Kivity's message of "Mon, 09
	Mar 2009 18:18:11 +0200")
Message-ID: <x49sklmd1fo.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> writes:

> Jeff Moyer wrote:
>> Hi,
>>
>> Believe it or not, I get numerous questions from customers about the
>> suggested tuning value of aio-max-nr.  aio-max-nr limits the total
>> number of io events that can be reserved, system wide, for aio
>> completions.  Each time io_setup is called, a ring buffer is allocated
>> that can hold nr_events I/O completions.  That ring buffer is then
>> mapped into the process' address space, and the pages are pinned in
>> memory.  So, the reason for this upper limit (I believe) is to keep a
>> malicious user from pinning all of kernel memory.  Now, this sounds like
>> a much better job for the memlock rlimit to me, hence the following
>> patch.
>>   
>
> Is it not possible to get rid of the pinning entirely?  Pinning
> interferes with page migration which is important for NUMA, among
> other issues.

aio_complete is called from interrupt handlers, so can't block faulting
in a page.  Zach mentions there is a possibility of handing completions
off to a kernel thread, with all of the performance worries and extra
bookkeeping that go along with such a scheme (to help frame my concerns,
I often get lambasted over .5% performance regressions).

I'm happy to look into such a scheme, should anyone show me data that
points to this NUMA issue as an actual performance problem today.  In
the absence of such data, I simply can't justify the work at the moment.

Thanks for taking a look!

-Jeff
