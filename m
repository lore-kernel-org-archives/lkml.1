Return-Path: <linux-kernel-owner+w=401wt.eu-S1759867AbXKLWXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759867AbXKLWXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 17:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbXKLWXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 17:23:22 -0500
Received: from ozlabs.org ([203.10.76.45]:35750 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757947AbXKLWXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 17:23:21 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: Re: [PATCH] module loader should not complain about unknown symbol
Date: Tue, 13 Nov 2007 09:23:12 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@openvz.org>,
       Andi Kleen <andi@firstfloor.org>, Jon Masters <jonathan@jonmasters.org>
References: <1194877107.5656.31.camel@localhost.localdomain>
In-Reply-To: <1194877107.5656.31.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711130923.12616.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007 01:18:27 Jan Glauber wrote:
> If module A depends on module B and module B has not yet finished its
> init() the module loader may print a warning about an unknown symbol.
>
> This happens if module B is still in state MODULE_STATE_COMING,
> as module A runs into resolve_symbol() for a symbol from module B.
> resolve_symbol() return 0 in that case and causes the warning.

It also happens when a symbol is undefined, so this patch is a bad idea.

To do this properly you would change strong_try_module_get to return -EBUSY 
and -ENOENT, then change use_module(), then finally resolve_symbol(), then 
only print a warning when it returns something other than -EBUSY.

Better might be to put in a waitqueue and wake it up whenever a module is 
deleted or changes status.  Then use_module() can wait if 
strong_try_module_get() returns -EBUSY (up to 30 seconds, then print a 
warning and fail).

Hope that helps,
Rusty.
