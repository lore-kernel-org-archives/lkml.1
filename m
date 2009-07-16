Return-Path: <linux-kernel-owner+w=401wt.eu-S933107AbZGPTlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107AbZGPTlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 15:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932901AbZGPTlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 15:41:15 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.95]:46435 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454AbZGPTlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 15:41:15 -0400
Message-ID: <4A5F8257.2050709@ece.cmu.edu>
Date: Thu, 16 Jul 2009 15:41:11 -0400
From: Raj Rajkumar <raj@ece.cmu.edu>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Fwd: Re: RFC for a new Scheduling policy/class in the Linux-kernel]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.5.5.374460, Antispam-Engine: 2.7.1.369594, Antispam-Data: 2009.7.16.192716
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __MOZILLA_MSGID 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James H. Anderson wrote:
 >
 > Hi Raj,
 >
 > On Thu, 16 Jul 2009, Raj Rajkumar wrote:
 >
 >> non-preemptive critical section.    In addition, we could allow 
mutexes to either pick basic priority inheritance (desirable for local 
mutexes?) or the priority ceiling version (desirable for global mutexes 
shared across processors/cores).
 >
 > This discussion when I entered it was about using global scheduling
 > in Linux (not partitioning), so that's what I thought the focus of the
 > discussion was.  What's the definition of a local mutex in that case?
 > And how do you use ceilings under global scheduling?
 >
 > Thanks.
 >
 > -Jim

Hi Jim:   I was not aware of the global scheduling constraint from the 
earlier discussions - thanks for the clarification.   Two thoughts on 
global partitioning:

   1. I presume you and others have pointed out the anomalies and low 
processor utilization that can result from global scheduling (the Dhall 
& Liu analysis being the most famous).   In addition, there are run-time 
performance implications as the caches keep getting cold as processes 
migrate.   The Linux notion of processor affinity needs to be put to 
good use!
   2. The definition of a priority ceiling (the priority of the highest 
priority task that can access a shared resource/mutex) holds independent 
of partitioning (static binding) or global scheduling (dynamic 
binding).   The following issue still remains.  If there are m 
processors, consider m low-priority tasks sharing m mutexes to execute 
VERY long critical sections.  These mutexes are only shared with m (or 
fewer) other lower priority tasks.   If these tasks each grab a mutex on 
each processor and execute these long critical sections, higher priority 
tasks waiting to execute will be starved/delayed.  With the ceiling 
notion in place, these critical sections will be executing at a lower 
ceiling priority and can therefore be preempted.

Combining the two comments above, I would suspect that in practice, 
tasks with tight timing constraints would be bound to specific 
processors/cores (they can be spread out that they do not compete with 
each other, and hence each/many/most can get very good response times on 
their processors) and my prior comments would apply with processor 
affinities in place.   Tasks with less tight timing constraints and 
perhaps targeting other functions with their own shared mutexes will use 
ceiling execution for critical sections, without affecting the response 
times of the tighter real-time tasks.

Best,

---
Raj



