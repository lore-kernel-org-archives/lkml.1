Return-Path: <linux-kernel-owner+w=401wt.eu-S932581AbZJEKdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbZJEKdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 06:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932519AbZJEKdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 06:33:54 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:45582 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932515AbZJEKdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 06:33:53 -0400
X-SourceIP: 213.93.53.227
Subject: Re: futex question
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Anirban Sinha <ani@anirban.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       Kaz Kylheku <kaz@zeugmasystems.com>,
       Anirban Sinha <asinha@zeugmasystems.com>
In-Reply-To: <alpine.LFD.2.00.0910041853180.2646@localhost.localdomain>
References: <DDFD17CC94A9BD49A82147DDF7D545C501FD7F97@exchange.ZeugmaSystems.local>
	 <20091001092218.GH15345@elte.hu>
	 <DDFD17CC94A9BD49A82147DDF7D545C501FD8409@exchange.ZeugmaSystems.local>
	 <4AC68F13.8050601@us.ibm.com>
	 <alpine.LFD.2.00.0910041031330.2646@localhost.localdomain>
	 <DDFD17CC94A9BD49A82147DDF7D545C501F457C5@exchange.ZeugmaSystems.local>
	 <4AC8CF32.8060108@anirban.org>
	 <alpine.LFD.2.00.0910041853180.2646@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 05 Oct 2009 12:36:14 +0200
Message-Id: <1254738974.26976.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-04 at 18:59 +0200, Thomas Gleixner wrote:

> > do. It does not feel right. Currently, with or without my change,
> > such a thing would indefinitely block other waiters on the same
> > futex.
> 
> Right. Which completely defeats the purpose of the robust list. Will
> have a look tomorrow.

Right, so mm_release() which is meant to destroy the old mm context
actually does exit_robust_list(), but the problem is that it does so on
the new mm, not the old one that got passed down to mm_release().

The other detail is that exit_robust_list() doesn't clear
current->robust_list.

The problem with the patch send my Ani is that it clears the robust
lists before the point of no return, so on a failing execve() we'd have
messed up the state.

Making exit_robust_list() deal with an mm that is not the current mm is
interesting indeed.

