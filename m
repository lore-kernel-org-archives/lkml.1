Return-Path: <linux-kernel-owner+w=401wt.eu-S1753603AbYCPOFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbYCPOFH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 10:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYCPOE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 10:04:56 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:50114 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbYCPOEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 10:04:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=D79aolpsxDPmX2K0ZiCxb/rtLOqcpqxqfenK2B2fcRaKKVzOOzjYr10nQRh/TYqx0ntd3vIZ/bvr0ehsPiaZKHIs0HEWleP/7AgVPWStlvDa12HYoSuK41fpPq/lGFvnXVvYEdRFSscE9ZvTLw+CTM9iw1Sb62D+ETkf0gmWhY8=
Message-ID: <982c94040803160704h5377c943o68612a0a5d6e4b7d@mail.gmail.com>
Date: Sun, 16 Mar 2008 10:04:49 -0400
From: "Philip Pratt-Szeliga" <pcpratts@syr.edu>
To: linux-kernel@vger.kernel.org
Subject: scheduler code/doc inconstancy
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 0e9f6b08c8074774
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Linux 2.6.24.3:

kernel/sched.c line 3663 calls sched_info_switch and line 3665 says
if(likely(prev != next)){

so it looks like this:

sched_info_switch(prev, next);

if (likely(prev != next)) {

But! In kernel/sched_stat.c the following starts at line 206. It says
we are only called when prev != next in the comment but that violates
what is happening above.

/*
* Called when tasks are switched involuntarily due, typically, to expiring
* their time slice. (This may also be called when switching to or from
* the idle task.) ___We are only called when prev != next.___
*/
static inline void
__sched_info_switch(struct task_struct *prev, struct task_struct *next)
{
struct rq *rq = task_rq(prev);

/*
* prev now departs the cpu. It's not interesting to record
* stats about how efficient we were at scheduling the idle
* process, however.
*/
if (prev != rq->idle)
sched_info_depart(prev);

if (next != rq->idle)
sched_info_arrive(next);
}
static inline void
sched_info_switch(struct task_struct *prev, struct task_struct *next)
{
if (unlikely(sched_info_on()))
__sched_info_switch(prev, next);
}


Maybe this is a bug in the code but possibly it is just a problem in
the documentation

Sincerely,
Phil Pratt-Szeliga
