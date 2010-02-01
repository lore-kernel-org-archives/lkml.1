Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab0BAWDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 17:03:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752642Ab0BAWC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 17:02:59 -0500
Date: Mon, 1 Feb 2010 14:02:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Blanchard <anton@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] panic: Fix panic_timeout accuracy when running on a
 hypervisor
Message-Id: <20100201140245.faeec398.akpm@linux-foundation.org>
In-Reply-To: <20100201041430.GQ2996@kryten>
References: <20100201041430.GQ2996@kryten>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Feb 2010 15:14:30 +1100
Anton Blanchard <anton@samba.org> wrote:

> 
> I've had some complaints about panic_timeout being wildly innacurate on
> shared processor PowerPC partitions (a 3 minute panic_timeout taking 30
> minutes).
> 
> The problem is we loop on mdelay(1) and with a 1ms in 10ms hypervisor
> timeslice each of these will take 10ms (ie 10x) longer. I expect other
> platforms with shared processor hypervisors will see the same issue.
> 
> This patch keeps the old behaviour if we have a panic_blink (only keyboard
> LEDs right now) and does 1 second mdelays if we don't.
> 
> ...
>
> +static void panic_blink_one_second(void)
> +{
> +	static long i = 0, end;

I assumed the `static' was a brainfart and removed it?

> +	if (panic_blink) {
> +		end = i + MSEC_PER_SEC;
> +
> +		while (i < end) {
> +			i += panic_blink(i);
> +			mdelay(1);
> +			i++;
> +		}
> +	} else {
> +		/*
> +		 * When running under a hypervisor a small mdelay may get
> +		 * rounded up to the hypervisor timeslice. For example, with
> +		 * a 1ms in 10ms hypervisor timeslice we might inflate a
> +		 * mdelay(1) loop by 10x.
> +		 *
> +		 * If we have nothing to blink, spin on 1 second calls to
> +		 * mdelay to avoid this.
> +		 */
> +		mdelay(MSEC_PER_SEC);
> +	}
> +}

In fact we can simplify it a bit:

--- a/kernel/panic.c~panic-fix-panic_timeout-accuracy-when-running-on-a-hypervisor-fix
+++ a/kernel/panic.c
@@ -42,12 +42,10 @@ EXPORT_SYMBOL(panic_blink);
 
 static void panic_blink_one_second(void)
 {
-	static long i = 0, end;
-
 	if (panic_blink) {
-		end = i + MSEC_PER_SEC;
+		long i = 0;
 
-		while (i < end) {
+		while (i < MSEC_PER_SEC) {
 			i += panic_blink(i);
 			mdelay(1);
 			i++;
_

Why does it do the mdelay() as well as calling panic_blink()?  hm,
because the old code did.  I guess it doesn't trust panic_blink().


