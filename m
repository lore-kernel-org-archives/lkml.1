Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab0CEAWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 19:22:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:48703 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178Ab0CEAWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 19:22:46 -0500
Message-ID: <4B904EA8.3050709@kernel.org>
Date: Fri, 05 Mar 2010 09:22:00 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Dimitri Sivanich <sivanich@sgi.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] improve stop_machine performance
References: <20100304212034.GA3171@sgi.com>
In-Reply-To: <20100304212034.GA3171@sgi.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Mar 2010 00:22:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/05/2010 06:20 AM, Dimitri Sivanich wrote:
> On systems with large cpu counts, we've been seeing long bootup times
> associated with stop_machine operations.  I've noticed that by simply
> removing the creation of the workqueue and associated percpu variables
> in subsequent stop_machine calls, we can reduce boot times on a
> 1024 processor SGI UV system from 25-30 (or more) minutes down to 12
> minutes.
> 
> The attached patch does this in a simple way by removing the
> stop_machine_destroy interface, thereby by leaving the workqueues and
> percpu variables for later use once they are created.
> 
> If people are against having these areas around after boot, maybe there
> are some alternatives that will still allow for this optimization:
> 
>  - Set a timer to go off after a configurable number of minutes, at
>    which point the workqueue areas will be deleted.
> 
>  - Keep the stop_machine_destroy function, but somehow run it at the tail
>    end of boot (after modules have loaded), rather than running it at
>    every stop_machine call.

Yeah, I can indeed imagine that creating and destroying all those
workers on every module load during boot would be very costly if there
are lots of CPUs.  How about sharing the migration thread so that it
serves as one-per-cpu uninterruptible RT simple thread pool?  It's not
like these things can run taking their turns anyway.  I'll go ahead
and make something up.

Thanks.

-- 
tejun
