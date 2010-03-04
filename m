Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0CDMlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 07:41:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453Ab0CDMlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 07:41:12 -0500
Subject: Re: [PATCH 1/4] dlm: fix ordering of bast and cast
From: Steven Whitehouse <swhiteho@redhat.com>
To: David Teigland <teigland@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1267211864-5474-2-git-send-email-teigland@redhat.com>
References: <1267211864-5474-2-git-send-email-teigland@redhat.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Thu, 04 Mar 2010 12:41:10 +0000
Message-Id: <1267706470.14393.422.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2010-02-26 at 13:17 -0600, David Teigland wrote:
> When both blocking and completion callbacks are queued for lock,
> the dlm would always deliver the completion callback (cast) first.
> In some cases the blocking callback (bast) is queued before the
> cast, though, and should be delivered first.  This patch keeps
> track of the order in which they were queued and delivers them
> in that order.
> 
> This patch also keeps track of the granted mode in the last cast
> and eliminates the following bast if the bast mode is compatible
> with the preceding cast mode.  This happens when a remotely mastered
> lock is demoted, e.g. EX->NL, in which case the local node queues
> a cast immediately after sending the demote message.  In this way
> a cast can be queued for a mode, e.g. NL, that makes an in-transit
> bast extraneous.
> 
Some questions on this one... shouldn't the filtering of the basts go at
the start of dlm_add_ast() so that it catches both the basts heading to
userspace and the ones going via the kernel interface?

Also, when the short-cut of generating casts locally on certain remotly
mastered demote requests is used, does that somehow suppress the
generation of casts on the lock master? If not, where do the duplicate
cast messages get filtered out?

I notice that the variable lkb->lkb_bastmode_done has been added, but is
only ever assigned to and never read. Was that supposed to have been
made accessible via debugfs for example?

Steve.


