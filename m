Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbZKIK7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbZKIK7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 05:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbZKIK7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 05:59:00 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45530 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbZKIK67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 05:58:59 -0500
Date: Mon, 9 Nov 2009 10:58:58 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Cc: alsa-devel@alsa-project.org, Magnus Damm <damm@igel.co.jp>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 1/2 v2] ASoC: sh: fsi: Add runtime PM
	support
Message-ID: <20091109105858.GB1245@sirena.org.uk>
References: <ud43sjtaf.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ud43sjtaf.wl%morimoto.kuninori@renesas.com>
X-Cookie: This bag is recyclable.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 11:54:47AM +0900, Kuninori Morimoto wrote:
> This patch add support runtime PM.
> Driver callbacks for Runtime PM are empty because
> the device registers are always re-initialized after
> pm_runtime_get_sync(). The Runtime PM functions replaces the
> clock framework module stop bit handling in this driver.

> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>

Hrm.  I'll have to see how this plays with ASoC core pm_runtime support
when that appears.  It should be OK as-is, I think.

> +	pm_suspend_ignore_children(&pdev->dev, true);
> +	pm_runtime_enable(&pdev->dev);
> +	pm_runtime_resume(&pdev->dev);

Why pm_suspend_ignore_all_children()?  I'd not expect the device to have
any children and if it did it doesn't seem like an entirely safe
assumption.

> +static int fsi_runtime_nop(struct device *dev)
> +{
> +	/* Runtime PM callback shared between ->runtime_suspend()
> +	 * and ->runtime_resume(). Simply returns success.
> +	 *
> +	 * This driver re-initializes all registers after
> +	 * pm_runtime_get_sync() anyway so there is no need
> +	 * to save and restore registers here.
> +	 */
> +	return 0;
> +}

This sets off alarm bells but it's perfectly reasonable, especially with
platforms able to put things into a low power state with no explicit
driver code now they can do power domain style things like SH.  I've
CCed in the PM folks since this seems like a perfectly reasonable use
case which ought to be handled more nicely.
