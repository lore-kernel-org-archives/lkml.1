Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbYJNUDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbYJNUDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 16:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbYJNUDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 16:03:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753906AbYJNUDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 16:03:03 -0400
Date: Tue, 14 Oct 2008 13:02:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Vrabel <david.vrabel@csr.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] UWB, WUSB, and WLP subsystems for 2.6.28
Message-Id: <20081014130251.aa008a5e.akpm@linux-foundation.org>
In-Reply-To: <48EF45BC.1020805@csr.com>
References: <48EF45BC.1020805@csr.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 10 Oct 2008 13:08:28 +0100 David Vrabel <david.vrabel@csr.com> wrote:
> Please pull the new UWB, WUSB and WLP subsystems from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dvrabel/uwb.git for-upstream

didn't happen?

What is the review status of this work?  I don't remember seeing it on any
of the lists where I lurk - perhaps a full resend will help things along.

<quick scan>

Code looks reasonable.

It has lots of comments which start with /**, which is the
this-is-kerneldoc token.  Only they're not kerneldoc comments.  These
should all be converted to kerneldoc, or replace the /** with /*.

uwb_beca_purge() should use time_after() or time_before().

In uwb_bce_print_IEs(), the cast of
uwb_rc_evt_beacon_WUSB_0100.BeaconInfo[] into a struct uwb_rc_evt_beacon*
looks really worrisome from an alignment POV.  Can it result in misaligned
accesses on architectures which don't like that?  (ia64, alpha, ...)

Code does kzalloc(a * b, ..) in some places.  kcalloc() is preferred, so
readers don't have to worry whether the code is vulnerable to
multiplicative overflows.

The code has a random mixture of
zero-lines-between-end-of-locals-and-start-of-code and
one-line-between-end-of-locals-and-start-of-code (and two line).  The
latter is usually preferred.

The person who misnamed DEFINE_BITMAP as DECLARE_BITMAP instead gets a
wedgie.

It seems strange that uwb_drp_ie_update(UWB_RSV_STATE_NONE) will free
rsv->drp_ie then reallocate it.

printk_ratelimit() is a bit silly because it shares state with other
unrelated subsystems which might be using it.  Direct use of __ratelimit()
would be better.


All minor stuff - I didn't spend long looking...
