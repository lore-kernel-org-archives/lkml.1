Return-Path: <linux-kernel-owner+w=401wt.eu-S1762570AbZCQHi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762570AbZCQHi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 03:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbZCQHiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 03:38:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42093 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbZCQHiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 03:38:50 -0400
Subject: Re: [PATCH/RFC 2/2] perfcounters: add an mmap method to allow
 userspace to read hardware counters
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <18879.14431.733358.248755@drongo.ozlabs.ibm.com>
References: <18879.14431.733358.248755@drongo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 08:38:35 +0100
Message-Id: <1237275515.5189.71.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-17 at 16:42 +1100, Paul Mackerras wrote:
> Impact: new feature giving performance improvement
> 
> This adds the ability for userspace to do an mmap on a hardware counter
> fd and get access to a read-only page that contains the information
> needed to translate a hardware counter value to the full 64-bit
> counter value that would be returned by a read on the fd.  This is
> useful on architectures that allow user programs to read the hardware
> counters, such as PowerPC.
> 
> The mmap will only succeed if the counter is a hardware counter
> monitoring the current process.
> 
> On my quad 2.5GHz PowerPC 970MP machine, userspace can read a counter
> and translate it to the full 64-bit value in about 30ns using the
> mmapped page, compared to about 830ns for the read syscall on the
> counter, so this does give a significant performance improvement.

While I think mmap'ed counters is a great idea, I really dont like this
patch. It adds a second output format unrelated to the regular output
format, and it doesn't appear to honor the regular output rules either.
PERF_RECORD_GROUP thingies won't work for example.

Nor is there any kind of queuing, one might want to have multiple events
in the mmap buffer..

I was planning to do this after cleaning up the normal output bits, as
our current output stuff is a mess:
 - its spread out over arch code (seems daft to me, we should all output
   the same)
 - its useless for pretty much anything but the two apps we currently
   have

In particular, it lacks the tid information for sampled data I hinted to
in the previous email.

Furthermore, in order to reliably profile userspace we need mmap
information in the output stream as well.



