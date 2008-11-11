Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbYKKH6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbYKKH6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 02:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYKKH6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 02:58:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982AbYKKH6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 02:58:24 -0500
Date: Mon, 10 Nov 2008 23:57:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: I2C from interrupt context?
Message-Id: <20081110235734.f7666725.akpm@linux-foundation.org>
In-Reply-To: <m3bpwrbjxs.fsf@maximus.localdomain>
References: <m3bpws8ln3.fsf@maximus.localdomain>
	<20081106.154754.02648408.davem@davemloft.net>
	<20081107101118.286f3713@hyperion.delvare>
	<m3bpwrbjxs.fsf@maximus.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2008 17:05:35 +0100 Krzysztof Halasa <khc@pm.waw.pl> wrote:

> Jean Delvare <khali@linux-fr.org> writes:
> 
> > The situation is far from perfect though. For one thing, I seem to
> > recall that Andrew Morton didn't like the approach taken in
> > i2c_transfer(). For another, i2c_smbus_xfer() was not yet modified so
> > at this point only I2C-level transactions can be non-sleeping,
> > SMBus-level transactions can't. But all this could be fixed by anyone
> > who cares about these specific issues.
> 
> Thanks, I'll look at it.

The problem (well: bug) is that in_atomic() returns false inside a
spinlock when CONFIG_PREEMPT=n.  The code as it stands can sleep
inside a spinlock, which is deadlockable if a scheduled-to task
tries to take the same spinlock.

There is no means like this by which a piece of code can determine
whether it can call schedule().  The pattern which we use in many many
places (most especially GFP_KERNEL/GFP_ATOMIC) is to pass a flag down
to callees telling them in some manner which context they were called from.
