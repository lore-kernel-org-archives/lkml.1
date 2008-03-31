Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbYCaKI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbYCaKI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 06:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753721AbYCaKIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 06:08:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37664
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751713AbYCaKIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 06:08:48 -0400
Date: Mon, 31 Mar 2008 03:08:48 -0700 (PDT)
Message-Id: <20080331.030848.175668431.davem@davemloft.net>
To: mingo@elte.hu
Cc: dada1@cosmosbay.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl
Subject: Re: [RFC,PATCH] loopback: calls netif_receive_skb() instead of
 netif_rx()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080331094823.GA11651@elte.hu>
References: <20080323.032949.194309002.davem@davemloft.net>
	<47E6A5FD.6060407@cosmosbay.com>
	<20080331094823.GA11651@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 31 Mar 2008 11:48:23 +0200

> 
> * Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
> > I noticed some paths in kernel are very stack aggressive, and on i386 
> > with CONFIG_4KSTACKS we were really in a dangerous land, even without 
> > my patch.
> >
> > What we call 4K stacks is in fact 4K - sizeof(struct task_struct), so 
> > a litle bit more than 2K. [...]
> 
> that's just wrong - 4K stacks on x86 are 4K-sizeof(thread_info) - the 
> task struct is allocated elsewhere. The patch below runs just fine on 
> 4K-stack x86.

I don't think it's safe.

Every packet you receive can result in a sent packet, which
in turn can result in a full packet receive path being
taken, and yet again another sent packet.

And so on and so forth.

Some cases like this would be stack bugs, but wouldn't
you like that bug to be a very busy cpu instead of a
crash from overrunning the current stack?
