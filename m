Return-Path: <linux-kernel-owner+w=401wt.eu-S1762114AbZDBWd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762114AbZDBWd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 18:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758607AbZDBWdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 18:33:20 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37525 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756163AbZDBWdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 18:33:19 -0400
Message-ID: <49D53D2B.30108@linux.vnet.ibm.com>
Date: Thu, 02 Apr 2009 15:33:15 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] perf_counter: move the event overflow output bits
 to record_type
References: <20090402091158.291810516@chello.nl> <20090402091319.151921176@chello.nl>
In-Reply-To: <20090402091319.151921176@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Per suggestion from Paul, move the event overflow bits to record_type
> and sanitize the enums a bit.
> 
> Breaks the ABI -- again ;-)
> 
[snip]

With this patch, the definitions look like this now:

[snip]
/*
  * Bits that can be set in hw_event.record_type to request information
  * in the overflow packets.
  */
enum perf_counter_record_format {
         PERF_RECORD_IP          = 1U << 0,
         PERF_RECORD_TID         = 1U << 1,
         PERF_RECORD_GROUP       = 1U << 2,
         PERF_RECORD_CALLCHAIN   = 1U << 3,
};

[snip]
enum perf_event_type {

         PERF_EVENT_MMAP                 = 1,
         PERF_EVENT_MUNMAP               = 2,

         /*
          * Half the event type space is reserved for the counter overflow
          * bitfields, as found in hw_event.record_type.
          *
          * These events will have types of the form:
          *   PERF_EVENT_COUNTER_OVERFLOW { | __PERF_EVENT_* } *
          */
         PERF_EVENT_COUNTER_OVERFLOW     = 1UL << 31,
         __PERF_EVENT_IP                 = PERF_RECORD_IP,
         __PERF_EVENT_TID                = PERF_RECORD_TID,
         __PERF_EVENT_GROUP              = PERF_RECORD_GROUP,
         __PERF_EVENT_CALLCHAIN          = PERF_RECORD_CALLCHAIN,
};
[snip]


Unless I'm misreading something here, there's overlap in the enum values 
of perf_event_type enum. PERF_EVENT_MMAP has the same value as 
__PERF_EVENT_IP, and PERF_EVENT_MUNMAP has the same value as 
__PERF_EVENT_TID.

Are these lower bits being reused when PERF_EVENT_COUNTER_OVERFLOW is 
OR'd in, which would imply that PERF_EVENT_MMAP and PERF_EVENT_MUNMAP 
are mutually exclusive with all of the PERF_EVENT_COUNTER_OVERFLOW values.

Actually, I don't really understand the purpose of the PERF_EVENT_MMAP 
and PERF_EVENT_MUNMAP bits. My hazy understanding is that they are used 
for finding the file, function and line number at overflow interrupt 
time, but it's unclear to me what that has to do with mmap.  I'll go 
back and try to find the relevant patch notes again.

- Corey



