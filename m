Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbYLALeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbYLALeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 06:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbYLALdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 06:33:52 -0500
Received: from mga12.intel.com ([143.182.124.36]:10257 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751337AbYLALdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 06:33:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,694,1220252400"; 
   d="scan'208";a="84881223"
Message-ID: <4933CBB0.2060003@linux.intel.com>
Date: Mon, 01 Dec 2008 12:34:08 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Jonathan Corbet <corbet@lwn.net>, Al Viro <viro@zeniv.linux.org.uk>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: BUG? "Call fasync() functions without the BKL" is racy
References: <20081128192508.GA21369@redhat.com>
In-Reply-To: <20081128192508.GA21369@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> Hi.
> 
> Let's suppose we have the tasks T1, T2, T3 which share the same file,
> all do sys_fcntl(file, F_SETFL) in parallel. file->f_flags == 0.
> 
> setfl(arg) does:
> 
> 	if ((arg ^ filp->f_flags) & FASYNC)
> // --- WINDOW_1 ---
> 		filp->f_op->fasync(fd, filp, (arg & FASYNC) != 0)
> // --- WINDOW_2 ---
> 	filp->f_flags = arg;
> 
> T1 calls setfl(FASYNC), preempted in WINDOW_1.
> 
> T2 calls setfl(FASYNC), does all job and returns.
> 
> T3 calls setfl(0), sees ->f_flags & FASYNC, does ->fasync(on => 0),
> preempted in WINDOW_2.
> 
> T1 resumes, does ->fasync(on => 1) again, update ->f_flags (it
> already has FASYNC) and returns.
> 
> T3 resumes, and clears FASYNC from ->f_flags.
> 
> 
> 
> Now, this file was added into some "struct fasync_struct", but
> ->f_flags doesn't have FASYNC. This means __fput() will skip
> ->fasync(on => 0) and the next kill_fasync() can crash because
> fa_file points to the freed/reused memory.

Nasty. Thanks for catching.
> 
> I think a238b790d5f99c7832f9b73ac8847025815b85f7 should be reverted.
> Or do you see the better fix?

Hmm, about checking for this case and retrying?

Or put a fasync mutex into files_struct.

-Andi

