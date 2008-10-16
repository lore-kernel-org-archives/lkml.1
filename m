Return-Path: <linux-kernel-owner+w=401wt.eu-S1757982AbYJPXdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982AbYJPXdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbYJPXdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:33:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752876AbYJPXdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:33:08 -0400
Date: Thu, 16 Oct 2008 16:32:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, michael.hennerich@analog.com,
       cooloney@kernel.org
Subject: Re: [PATCH 1/1] input: AD7879 Touchscreen driver
Message-Id: <20081016163240.ee06818b.akpm@linux-foundation.org>
In-Reply-To: <1224179836-14639-1-git-send-email-cooloney@kernel.org>
References: <1224179836-14639-1-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008 01:57:16 +0800
Bryan Wu <cooloney@kernel.org> wrote:

a little thing..

> +static void ad7879_disable(struct ad7879 *ts)
> +{
> +	unsigned long flags;
> +
> +	if (ts->disabled)
> +		return;
> +
> +	spin_lock_irqsave(&ts->lock, flags);
> +	ts->disabled = 1;
> +	disable_irq(ts->bus->irq);
> +	spin_unlock_irqrestore(&ts->lock, flags);
> +
> +	cancel_work_sync(&ts->work);
> +
> +	if (del_timer_sync(&ts->timer))
> +		ad7879_ts_event_release(ts);
> +
> +	/* we know the chip's in lowpower mode since we always
> +	 * leave it that way after every request
> +	 */
> +}
> +
> +static void ad7879_enable(struct ad7879 *ts)
> +{
> +	unsigned long flags;
> +
> +	if (!ts->disabled)
> +		return;
> +
> +	spin_lock_irqsave(&ts->lock, flags);
> +	ts->disabled = 0;
> +	enable_irq(ts->bus->irq);
> +	spin_unlock_irqrestore(&ts->lock, flags);
> +}

It would looks less racy if ts->disabled was tested while the lock was held.

Also, it would be more grammatically pleasing if ad7879_destruct() was
called ad7879_destroy(), but the current spelling will still compile
and run :)


