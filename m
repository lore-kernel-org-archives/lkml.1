Return-Path: <linux-kernel-owner+w=401wt.eu-S1946120AbXDLKcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946120AbXDLKcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 06:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946121AbXDLKcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 06:32:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58367 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946120AbXDLKcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 06:32:01 -0400
Date: Thu, 12 Apr 2007 11:32:00 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: jjohansen@suse.de
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [AppArmor 40/41] AppArmor: all the rest
Message-ID: <20070412103200.GE4095@ftp.linux.org.uk>
References: <20070412090809.917795000@suse.de> <20070412090849.824835000@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412090849.824835000@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 02:08:49AM -0700, jjohansen@suse.de wrote:
> +	} else if (profile1 > profile2) {
> +		/* profile1 cannot be NULL here. */
> +		spin_lock_irqsave(&profile1->lock, profile1->int_flags);
> +		if (profile2)
> +			spin_lock(&profile2->lock);
> +
> +	} else {
> +		/* profile2 cannot be NULL here. */
> +		spin_lock_irqsave(&profile2->lock, profile2->int_flags);
> +		spin_lock(&profile1->lock);
> +	}

Ahem...

profile2 is locked individually.  profile1 > profile2.  profile1 is not
locked.  We try to lock both.  profile1 is locked OK, flags (with interrupts
disabled) are stored into it.  We spin trying to lock profile2.  Eventually,
whoever had held profile2 unlocks it, restoring the flags from profile2.
We happily grab the spinlock and move on.  When we unlock the pair, we
restore flags from profile1.  I.e. we are left with interrupts disabled.
