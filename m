Return-Path: <linux-kernel-owner+w=401wt.eu-S1760016AbYFJWdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016AbYFJWdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbYFJWc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:32:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49682
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753272AbYFJWc4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:32:56 -0400
Date: Tue, 10 Jun 2008 15:32:52 -0700 (PDT)
Message-Id: <20080610.153252.252676827.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: mingo@elte.hu, mcmanus@ducksong.com, peterz@infradead.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, rjw@sisk.pl,
       akpm@linux-foundation.org, johnpol@2ka.mipt.ru
Subject: Re: [fixed] [patch] Re: [bug] stuck localhost TCP connections,
 v2.6.26-rc3+
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0806040208350.7315@wrl-59.cs.helsinki.fi>
References: <Pine.LNX.4.64.0806040052270.3474@wrl-59.cs.helsinki.fi>
	<20080603.150344.145518113.davem@davemloft.net>
	<Pine.LNX.4.64.0806040208350.7315@wrl-59.cs.helsinki.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo_Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Wed, 4 Jun 2008 02:22:16 +0300 (EEST)

> [PATCH] tcp DEFER_ACCEPT: fix racy access to listen_sk
> 
> It seems that replacement of DA code also moved parts outside
> of appropriate locking. The Ingo's problem seems to come from
> the fact that two flows could now race in
> (inet_csk_)reqsk_queue_add corrupting the queue. ...This can
> leave dangling socks around which won't resolve themselves
> without stimuli from outside (e.g., external RST would help
> I think).
> 
> Then some details I'm not too sure of:
> I guess we want to put listen_sk->sk_state checking under the
> lock as well. I've not evaluated if ->sk_data_ready too
> requires locking but assumed it does.
> 
> I'm by no means familiar with all locking variants, requirements,
> etc.
> 
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

I took a close look at this, it seems this patch adds
an ABBA deadlock.  But I might be wrong.

Normally the locking order is:

	listen_sk --> some_child_sk

And this can be seen by the code paths that flow down
to tcp_child_process() in net/ipv4/tcp_minisocks.c (via
tcp_v4_do_rcv() for example).

However here in this patch we will lock in the:

	child_sk --> listen_sk

order.

Unless... these defer accepted sockets live outside of the
normal socket collection found by tcp_v{4,6}_hnd_req().  If
that is the case, that ought to make this locking order OK
but I fear that lockdep will likely complain because it has
no way to see this distinction.

If we cannot find a simple and easy way to deal with this locking
problem, I am reverting the defer-accept changes entirely.  It's not
the end of the world if this feature has to be deferred to 2.6.27
and this bug has been known for several weeks already.

