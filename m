Return-Path: <linux-kernel-owner+w=401wt.eu-S1752972AbXCUPTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbXCUPTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbXCUPTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:19:31 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:10059 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbXCUPTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:19:30 -0400
X-AuditID: d80ac287-9d9d4bb000000de9-3a-46014d013cc5 
Date: Wed, 21 Mar 2007 14:41:15 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc4-mm1: init hangs on tty_mutex
In-Reply-To: <m1vegvlgyx.fsf@ebiederm.dsl.xmission.com>
Message-ID: <Pine.LNX.4.64.0703211429201.21322@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0703201930060.14654@blonde.wat.veritas.com>
 <m1vegvlgyx.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 21 Mar 2007 15:19:29.0153 (UTC) FILETIME=[51B2EF10:01C76BCC]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007, Eric W. Biederman wrote:
> Hugh Dickins <hugh@veritas.com> writes:
> 
> > I get a hang at startup or shutdown: tiocsctty() holds tty_mutex, and
> > now with Eric's tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
> > it can end up calling con_close(), which tries to take tty_mutex.
> > So best revert that in hot-fixes, until Eric provides a better.
> 
> Well I'm confused I know I tested this, and I even added a printk and
> saw it trigger a couple of times.
> 
> Hmm.  Looking at the code it is clearly not safe to hold the tty_mutex
> when calling tty_vhangup.  I thought the other caller in tty_io.c was doing
> that but on a second glance it is clearly not.  And the hangup and close
> methods do seem to take the tty_mutex.
> 
> How this worked in my testing is beyond me..

I agree there's something weird about it, and wonder whether it's
exposing some other, unrelated bug e.g. something uninitialized.

What I omitted to mention is that I reliably had init hanging on
startup with my KDB kernels (on i386 UP and i386 SMP and x86_64 SMP);
but never saw my non-KDB kernels (nor my powerpc kernel) hanging
there at startup - they would hang (in the same way) at shutdown
(every time? I can't swear to that).  But I can't imagine what
KDB would have to do with it, other than shifting stuff around.

Hugh
