Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbYBMHBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbYBMHBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYBMHBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:01:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41846
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752587AbYBMHBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:01:24 -0500
Date: Tue, 12 Feb 2008 23:01:56 -0800 (PST)
Message-Id: <20080212.230156.33759433.davem@davemloft.net>
To: rdreier@cisco.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: Strange hang on ia64 with CONFIG_PRINTK_TIME=y
From: David Miller <davem@davemloft.net>
In-Reply-To: <adazlu5tlve.fsf@cisco.com>
References: <adazlu5tlve.fsf@cisco.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 12 Feb 2008 22:24:05 -0800

> I'm seeing a strange hang with current git (head 96b5a46e) on an ia64
> box -- an Intel SDV with 2 dual core hyperthreaded Itanium 2 CPUs (so
> 8 logical CPUs to the kernel).  It hangs without printing anything
> ("Uncompressing Linux... done" from ELILO is the last thing I see) if
> I have CONFIG_PRINTK_TIME=y; it works fine with CONFIG_PRINTK_TIME=n.
> 
> The really strange thing is that I have bisected this down to 326e96b9
> ("printk: revert ktime_get() timestamps"), and verified that if revert
> this one patch on top of my current git tree, then the kernel boots
> fine with CONFIG_PRINTK_TIME=y.  The strange thing is that I have also
> checked that the real v2.6.24 kernel boots fine on this system, and as
> far as I can tell, 2.6.24 didn't have the commit that 326e96b9 reverts
> (19ef9309), so there is some interaction with another patch that made
> 19ef9309 necessary on my system.
> 
> Any good idea how to debug this, given that the broken kernels don't
> give any output at all?

The kernel now derefernces per-cpu variables very early, essentially
in the very first printk() (via printk()'s call to cpu_clock()).

This bit me on sparc64 because of how I do the per-cpu address
formation.  If I booted on a non-zero cpuid things would explode.

You might be hitting something similar.
