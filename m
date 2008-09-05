Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbYIEMlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbYIEMlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 08:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbYIEMlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 08:41:08 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:35639 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbYIEMlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 08:41:07 -0400
Date: Fri, 5 Sep 2008 06:40:46 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Ben Hutchings <bhutchings@solarflare.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] PCI: vpd handle longer delays in access
Message-ID: <20080905124046.GP2772@parisc-linux.org>
References: <20080904205636.130211023@vyatta.com> <20080904205718.543005986@vyatta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904205718.543005986@vyatta.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 01:56:37PM -0700, Stephen Hemminger wrote:
> -		udelay(10);
> +		if (signal_pending(current))
> +			return -EINTR;

If you're going to use _killable instead of _interruptible, this needs
to be fatal_signal_pending().  Otherwise the one who owns the lock can
be interrupted by _any_ signal while those waiting for the lock can only
be interrupted by fatal signals.  Which seems daft to me.

> -	spin_lock_irq(&vpd->lock);
> +	ret = mutex_lock_killable(&vpd->lock);
> +	if (ret)
> +		return ret;

What's wrong with the shorter:

	if (mutex_lock_killable(&vpd->lock))
		return -EINTR;
?

The actual error is irrelevant here since userspace will never consume it.

(I agree with Peter about use of yield())

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
