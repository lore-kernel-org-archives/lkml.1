Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbZFZRga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbZFZRga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 13:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbZFZRgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 13:36:20 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:49749 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbZFZRgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 13:36:19 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 26 Jun 2009 10:32:17 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
       netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fbl@redhat.com, nhorman@redhat.com, davem@redhat.com,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] net: fix race in the receive/select
In-Reply-To: <20090626135742.GB3845@redhat.com>
Message-ID: <alpine.DEB.1.10.0906261018580.16400@makko.or.mcafeemobile.com>
References: <20090625122545.GA3625@jolsa.lab.eng.brq.redhat.com> <20090625122416.GA23613@redhat.com> <alpine.DEB.1.10.0906251827510.9517@makko.or.mcafeemobile.com> <4A442B65.8040701@gmail.com> <alpine.DEB.1.10.0906251858520.9517@makko.or.mcafeemobile.com>
 <4A443033.8060401@gmail.com> <alpine.DEB.1.10.0906251947530.9517@makko.or.mcafeemobile.com> <20090626135742.GB3845@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009, Oleg Nesterov wrote:

> And if we remove waitqueue_active() in xxx_update(), then lock/unlock is
> not needed too.
>
> If xxx_poll() takes q->lock first, it can safely miss the changes in ->status
> and schedule(): xxx_update() will take q->lock, notice the sleeper and wake
> it up (ok, it will set ->triggered but this doesn't matter).
> 
> If xxx_update() takes q->lock first, xxx_poll() must see the changes in
> status after poll_wait()->unlock(&q->lock) (in fact, after lock, not unlock).

Sure. The snippet above was just to show what typically the code does, not 
a suggestion on how to solve the socket case.
But yeah, the problem in this case is the waitqueue_active() call. Without 
that, the wait queue lock/unlock in poll_wait() and the one in wake_up() 
guarantees the necessary barriers.
Some might argue the costs of the lock/unlock of q->lock, and wonder if 
MBs are a more efficient solution. This is something I'm not going into.
To me, it just looked not right having cross-matching MB in different 
subsystems.



- Davide


