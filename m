Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbXCLTy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbXCLTy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 15:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbXCLTy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 15:54:56 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:39278 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbXCLTyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 15:54:55 -0400
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Mar 2007 15:54:55 EDT
X-IronPort-AV: i="4.14,275,1170662400"; 
   d="scan'208"; a="400348820:sNHT89594496"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Clarification required about select vs wake_up race condition
Date: Mon, 12 Mar 2007 12:44:34 -0700
Message-ID: <FA6FB5FA4DA6BF4386D129273B2E3EC30183A411@xmb-sjc-214.amer.cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Clarification required about select vs wake_up race condition
thread-index: Acdk3tvrQuTn608jSoqFmKKZFLit7Q==
From: "Ravinandan Arakali \(rarakali\)" <rarakali@cisco.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Mar 2007 19:44:34.0286 (UTC) FILETIME=[DC2DE0E0:01C764DE]
Authentication-Results: sj-dkim-3; header.From=rarakali@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I am facing following problem and was wondering if somebody could help
me out.
Our char driver(pretty much like all other char drivers) does a
poll_wait() 
and returns status depending on whether data is available to be read.
Even though some data is available to be read(verified using one of our
internal
commands), the select() never wakes up, inspite of any no. of messages
sent.

To understand this, I was looking at the code of select vs
wake_up_interruptible().
I feel I am misunderstanding some part of the kernel code but will be
glad if
somebody can point it out.

My understanding:
The do_select() sets the state of task to TASK_INTERRUPTIBLE and calls
the driver's
poll entry point. In our poll(), let's say immediately after we
determine that there's 
nothing to be read, some data arrives causing a wake_up_interruptible()
on another CPU. 
The wake up happens in the context of process sending the data. Since
the receiving 
process was already added to the list of listeners, from looking at the
code of 
try_to_wake_up(), it looks like it can set the state of the receiving
process to 
TASK_RUNNING(I don't see any lock preventing this). After this happens,
the receiving
process goes to sleep (because of schedule_timeout called by do_select)
but
state is still set to TASK_RUNNING. In this state, when another message
arrives,
the wake_up_interruptible will not wake the process because of following
code in
try_to_wake_up() ?

old_state = p->state;
if (!(old_state & state))
   goto out;

The above situation seems simplistic so I'm wondering what I am missing
here ?
Advice from gurus is highly appreciated.

Thanks,
Ravi
