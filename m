Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbZCRU5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbZCRU5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 16:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbZCRU5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 16:57:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34686 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZCRU5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 16:57:21 -0400
To: Vernon Mauery <vernux@us.ibm.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: High contention on the sk_buff_head.lock
From: Andi Kleen <andi@firstfloor.org>
References: <49C12E64.1000301@us.ibm.com>
Date: Wed, 18 Mar 2009 21:54:37 +0100
In-Reply-To: <49C12E64.1000301@us.ibm.com> (Vernon Mauery's message of "Wed, 18 Mar 2009 10:24:52 -0700")
Message-ID: <87prge1rhu.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vernon Mauery <vernux@us.ibm.com> writes:
>
> So while this issue really hits -rt kernels hard, it has a real effect on
> mainline kernels as well.  The contention of the spinlocks is amplified
> when they get turned into rt-mutexes, which causes a double context switch.

The new adaptive spin heuristics that have been discussed some time
ago didn't help? Unsurprisingly making locks a lot more expensive
has drawbacks as you discovered.

>    &list->lock#3:      24517307       24643791           0.71        1286.62      56516392.42       34834296       44904018           0.60        164.79    31314786.02
>     -------------
>    &list->lock#3       15596927    [<ffffffff812474da>] dev_queue_xmit+0x2ea/0x468

The real "fix" would be probably to use a multi queue capable NIC
and a NIC driver that sets up multiple queues for TX (normally they
only do for RX). Then cores or a set of cores (often the number
of cores is larger than the number of NIC queues) could avoid this
problem. Disadvantage: more memory use.

But then again I'm not sure it's  worth it if the problem only
happens in out of tree RT.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
