Return-Path: <linux-kernel-owner+w=401wt.eu-S934144AbXEQFGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934144AbXEQFGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 01:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760034AbXEQFGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 01:06:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48666
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760030AbXEQFGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 01:06:32 -0400
Date: Wed, 16 May 2007 22:06:31 -0700 (PDT)
Message-Id: <20070516.220631.07641650.davem@davemloft.net>
To: skb300@hotmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: user pointers and race conditions
From: David Miller <davem@davemloft.net>
In-Reply-To: <BAY115-W33D3EC723171255D88FBF86330@phx.gbl>
References: <BAY115-W33D3EC723171255D88FBF86330@phx.gbl>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: sk b <skb300@hotmail.com>
Date: Wed, 16 May 2007 22:56:22 -0600

> 3:        if (!access_ok(VERIFY_READ,stp,sizeof(struct st)))
> 4:                return;
> 5:        if (!access_ok(VERIFY_WRITE,stp->u,sizeof(int)))
> 6:                return;

This code would not exist in the kernel, the kernel cannot dereference
stp->u.  The stp->u dereference would silently work on x86 and x86_64
but it would generate an exception on sparc64 and other platforms.

User space accesses must go through the proper copy_from_user(),
copy_to_user, get_user(), and put_user() interfaces.

It must first copy stp into a local kernel space copy, then it may
inspect the value of stp->u.

And yes sparse would catch this problem in your code, because the
"__user" annotations would catch the illegal "stp->u" dereference.
