Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbXCLXt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbXCLXt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 19:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbXCLXt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 19:49:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44542
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752347AbXCLXtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 19:49:25 -0400
Date: Mon, 12 Mar 2007 16:49:21 -0700 (PDT)
Message-Id: <20070312.164921.71090866.davem@davemloft.net>
To: samuel@sortiz.org
Cc: davej@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: irda rmmod lockdep trace.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070312003843.GA3394@sortiz.org>
References: <20070308225436.GA25184@redhat.com>
	<20070310174326.GA3816@sortiz.org>
	<20070312003843.GA3394@sortiz.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <samuel@sortiz.org>
Date: Mon, 12 Mar 2007 02:38:43 +0200

> On Sat, Mar 10, 2007 at 07:43:26PM +0200, Samuel Ortiz wrote:
> > Hi Dave,
> > 
> > On Thu, Mar 08, 2007 at 05:54:36PM -0500, Dave Jones wrote:
> > > modprobe irda ; rmmod irda in 2.6.21rc3 gets me the spew below..
> > Well it seems that we call __irias_delete_object() from hashbin_delete(). Then
> > __irias_delete_object() calls itself hashbin_delete() again. We're trying to
> > get the lock recursively.
> Looking at the code more carefully, this seems to be a false positive:
> iriap_cleanup and and __irias_delete_object are taking 2 different locks from
> 2 different hashbin instances. The locks belong to the same lock class but
> they are hierarchically different. We need to tell the validator about it and
> the following patch does that. Comments are welcomed as I'm planning to push
> it to netdev soon:

I would strongly caution against adding any run-time overhead just to
cure a false lockdep warning.  Even adding a new function argument
is too much IMHO.

Make the cost show up for lockdep only, perhaps by putting each
hashbin lock into a seperate locking class?

