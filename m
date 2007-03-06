Return-Path: <linux-kernel-owner+w=401wt.eu-S965839AbXCFK5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965839AbXCFK5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 05:57:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965837AbXCFK5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 05:57:12 -0500
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:2489 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965839AbXCFK5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 05:57:11 -0500
Date: Tue, 6 Mar 2007 11:56:24 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       "J.A. Magallon" <jamagallon@ono.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i2c vs nVidia [Re: 2.6.21-rc2-mm1]
Message-Id: <20070306115624.523d99dc.khali@linux-fr.org>
In-Reply-To: <20070306094543.abb6e290.khali@linux-fr.org>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	<20070306011621.5a844c41@werewolf-wl>
	<20070305163320.2b21ab7e.akpm@linux-foundation.org>
	<20070306004444.GC12566@kroah.com>
	<20070306094543.abb6e290.khali@linux-fr.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

On Tue, 6 Mar 2007 09:45:43 +0100, Jean Delvare wrote:
> > > I guess we need to wait and see if someone hits the same problems
> > > with an in-kernel driver.
> 
> I just did, with i2c-nforce2. The key to trigger it seems to be to load
> an i2c bus driver _after_ loading i2c-isa and a suitable i2c-isa-based
> hardware monitoring driver (w83791d, w83627hf, w83627ehf, it87, lm78,
> pc87360, sis5595, smsc47m1, smsc47b397, via686a or vt8231.) I have no
> idea why, though. Given that I was able to trigger the problem with
> only my own patches on top of Linus' tree, it means that the bug was
> clearly introduced by one of my patches. I'll bisect my stack now to
> find out which one. There aren't that many patches so it should be
> relatively quick.

Faulty patch is i2c-06-remove-duplicate-i2c-drivers-list.patch. The
oops is the result of the combination of two factors:

1* I'm too optimistic trying to remove the duplicate i2c drivers list
now. i2c-isa drivers are listed in the list managed by the driver
model, but not in the list managed by i2c-core. This difference between
both lists caused new errors to be returned, triggering the second
problem.

2* We do not want i2c_add_adapter to fail just because one
attach_adapter callback returned an error. The patch improperly caused
this to happen, while i2c_add_adapter is not designed to handle these
errors.

The bottom line is that I really need to kill i2c-isa before I can
apply this patch. So I'll drop it out for now, sorry for the noise.

-- 
Jean Delvare
