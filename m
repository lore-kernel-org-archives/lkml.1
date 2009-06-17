Return-Path: <linux-kernel-owner+w=401wt.eu-S1764546AbZFQIUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764546AbZFQIUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 04:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763077AbZFQIU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 04:20:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:43442 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729AbZFQIUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 04:20:25 -0400
Message-ID: <4A38A719.2030709@kernel.org>
Date: Wed, 17 Jun 2009 17:19:37 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: cl@linux-foundation.org
CC: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>, davem@davemloft.net
Subject: Re: [this_cpu_xx 01/11] Introduce this_cpu_ptr() and generic this_cpu_*
 operations
References: <20090605191819.376530498@gentwo.org> <20090605191850.441840884@gentwo.org>
In-Reply-To: <20090605191850.441840884@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 08:19:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

cl@linux-foundation.org wrote:
> +#ifndef this_cpu_write
> +# define this_cpu_write(pcp, val)	__this_cpu_write((pcp), (val))
> +#endif

Is this safe?  Write itself would always be atomic but this means that
a percpu variable may change its value while a thread is holding the
processor by disabling preemption.  ie,

0. v contains A for cpu0

1. task0 on cpu0 does this_cpu_write(v, B), looks up cpu but gets
   preemted out.

2. task1 gets scheduled on cpu1, disables preemption and does
   __this_cpu_read(v) and gets A and goes on with preemtion disabled.

3. task0 gets scheduled on cpu1 and executes the assignment.

4. task1 does __this_cpu_read(v) again and oops gets B this time.

Please note that this can also happen between addition or other
modifying ops and cause incorrect result.

Also, these macros depricate percpu_OP() macros, right?

Thanks.

-- 
tejun
