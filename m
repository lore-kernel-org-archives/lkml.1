Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbYGFILn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbYGFILn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 04:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYGFILa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 04:11:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40483 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbYGFIL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 04:11:29 -0400
Date: Sun, 6 Jul 2008 09:11:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH] parport/ppdev: fix registration of sysctl entries
Message-ID: <20080706081126.GA28946@ZenIV.linux.org.uk>
References: <20080705131924.GA2083@joi> <20080705235148.GW28946@ZenIV.linux.org.uk> <20080706001148.GX28946@ZenIV.linux.org.uk> <20080706040519.GZ28946@ZenIV.linux.org.uk> <m1hcb31p8p.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hcb31p8p.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2008 at 11:49:26PM -0700, Eric W. Biederman wrote:
> So our choices appear to be.
> - Change the name in sysctl so each parport device always has a unique name.
> - Only allow one opener of ppdev for a given port.

Can't do - it's a legitimate use of ppdev (several userland programs
multiplexing the sucker).

> - Take the approach of the initial patch and export to sysctl when we claim
>   the port and unexport when we release the port.

You do realize that we need exclusion around that lazy registration in
any case?  sysctl is not the only problem there...

> - Give up and simply don't register with sysctl for ppdev.
> 
> I did a quick google search and I could not find any hits (except for
> this bug report on devices/ppdev) so I am inclined just to special
> case ppdev and not even bother registering with sysctl.  I did not
> see any other fields that would have problems with a duplicate name.
> 
> The only other backwards compatible and viable approach appears
> to be registering ppdev parport devices when they are claimed.
> 
> The only reason we would be able to change the name without breakage
> is if no one uses the /proc interface in which case I don't see a
> point in continuing to provide it for ppdev.

Not quite.  /proc/sys/.../timeslice is a generically documented way to
tune the damn thing when we have several things on the same port.  Note
that while one of those might be in userland, the rest might be in kernel
and very different.  In this case the parameter is both relevant *and*
currently usable.

Frankly, I'd go for IDR and rename in cases when we have additional openers.
_And_ add a mutex around delayed allocation - that's a separate problem.
