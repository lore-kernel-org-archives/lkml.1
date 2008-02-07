Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbYBGEF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbYBGEF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 23:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbYBGEFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 23:05:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36683
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751489AbYBGEFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 23:05:48 -0500
Date: Wed, 06 Feb 2008 20:06:18 -0800 (PST)
Message-Id: <20080206.200618.11213859.davem@davemloft.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: partition sysfs OOPS in current GIT
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080207000959.GA16601@suse.de>
References: <20080206235902.GA15719@suse.de>
	<20080206.160231.45881964.davem@davemloft.net>
	<20080207000959.GA16601@suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg, I'm pretty sure I know what's happening.

For whatever reason we're invoking dev_attr_show() on attribute_group
objects.

The reason it probably only crashes on sparc64 is because perhaps at
that dev_attr->show offset on x86 there are zero bytes there instead
of a pointer, so the NULL check here in dev_attr_show() masks the bug.

The problem with all of this "container_of() this", "container_of()
that" is that we lose real type checking.  So unless we add magic
cookies to verify or other hacks, functions never really know if the
container they are being passed really is a subset object of the type
they expect.

Can you read the code instead of asking more information from me to
try and figure out why the attribute showing paths might be
misconfigured for these block device objects after the changeset in
question?  I can do this, but you're more likely to find the problem
quickly than I am.

I redid the bisect to make sure it absolutely was that specific
changeset, and it is.

Thanks.
