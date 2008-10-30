Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbYJ3WTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbYJ3WTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 18:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbYJ3WTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 18:19:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141AbYJ3WTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 18:19:10 -0400
Date: Thu, 30 Oct 2008 15:18:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: wim@iguana.be, linux-kernel@vger.kernel.org,
       broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH] watchdog: Add support for the WM8350 watchdog
Message-Id: <20081030151804.bc8bd02a.akpm@linux-foundation.org>
In-Reply-To: <1225121516-23667-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1225121516-23667-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008 15:31:56 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> This driver implements support for the watchdog functionality provided
> by the Wolfson Microelectronics WM8350, a multi-function audio and
> power management subsystem intended for use in embedded systems. It is
> based on a driver originally written by Graeme Gregory, though it has
> been extensively modified since then.
> 
> Use of a GPIO to kick the watchdog is not yet supported.
> 
> ...
>
> +
> +static int wm8350_wdt_set_timeout(struct wm8350 *wm8350, u16 value)
> +{
> +	int ret;
> +	u16 reg;
> +
> +	mutex_lock(&wdt_mutex);
> +	wm8350_reg_unlock(wm8350);
> +
> +	reg = wm8350_reg_read(wm8350, WM8350_SYSTEM_CONTROL_2);
> +	reg &= ~WM8350_WDOG_TO_MASK;
> +	reg |= value;
> +	ret = wm8350_reg_write(wm8350, WM8350_SYSTEM_CONTROL_2, reg);
> +
> +	wm8350_reg_lock(wm8350);

I was curious about this wm8350_reg_lock/wm8350_reg_unlock thing, so I
went to have a look at it.  Nothing.  Obviously its authors felt there
was no benefit in having anyone else understand what it does.

> +	mutex_unlock(&wdt_mutex);
> +
> +	return ret;
> +}
>
> ...
>
> +static int wm8350_wdt_open(struct inode *inode, struct file *file)
> +{
> +	struct wm8350 *wm8350 = get_wm8350();
> +	int ret;
> +
> +	if (!wm8350)
> +		return -ENODEV;
> +
> +	if (test_and_set_bit(1, &wm8350_wdt_users))

It's odd that the driver uses bit 1 rather than bit 0.

