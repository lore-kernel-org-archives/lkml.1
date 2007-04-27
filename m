Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbXD0JJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbXD0JJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 05:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbXD0JJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 05:09:21 -0400
Received: from colin.muc.de ([193.149.48.1]:3808 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503AbXD0JJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 05:09:20 -0400
Date: 27 Apr 2007 11:09:17 +0200
Date: Fri, 27 Apr 2007 11:09:17 +0200
From: Andi Kleen <ak@muc.de>
To: Tim Hockin <thockin@google.com>
Cc: vojtech@suse.cz, linux-kernel@vger.kernel.org, akpm@google.com
Subject: Re: [PATCH] x86_64: dynamic MCE poll interval
Message-ID: <20070427090917.GA24922@muc.de>
References: <cc96a5040704261802v2bcb3a59k9d44da8d615a6779@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc96a5040704261802v2bcb3a59k9d44da8d615a6779@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 06:02:52PM -0700, Tim Hockin wrote:
> Description:
>  This patch makes the MCE poller adjust the polling interval dynamically.
>  If we find an MCE, poll 2x faster (down to 10 ms).  When we stop finding
>  MCEs, poll 2x slower (up to check_interval seconds).  The check_interval
>  tunable becomes the max polling interval.

Can you please fix the documentation then?

> 
> Result:
>  If you start to take a lot of correctable errors (not exceptions), you
>  log them faster and more accurately (less chance of overflowing the MCA
>  registers).  If you don't take a lot of errors, you will see no change.

Makes sense.

AMD RevF can do this using the threshold interrupts too for DIMM errors
too without any delays -- perhaps it would also make sense to configure 
this by default that it always triggers on all DIMM errors. 
Right now it is just an option in /sys

> @@ -349,17 +349,24 @@ static void mcheck_timer(struct work_str
> 	 * writes.
> 	 */
> 	if (notify_user && console_logged) {
> +		/* if we logged an MCE, reduce the polling interval */
> +		next_interval = max(next_interval/2, HZ/100);
> 		notify_user = 0;
> 		clear_bit(0, &console_logged);
> 		printk(KERN_INFO "Machine check events logged\n");

The printk should not happen too often. Can you add some hardcoded
limit there than it doesn't happen more often than every hour or so
(or perhaps use a exponential backoff here too?)
It is only to tell users to check mcelog output.


-Andi
