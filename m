Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbZGOSnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbZGOSnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 14:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbZGOSnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 14:43:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53310 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654AbZGOSnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 14:43:11 -0400
Date: Wed, 15 Jul 2009 20:39:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Anirban Sinha <ASinha@zeugmasystems.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: FW: avoiding run_workqueue() recursion
Message-ID: <20090715183941.GA13341@redhat.com>
References: <DDFD17CC94A9BD49A82147DDF7D545C501CFAE3D@exchange.ZeugmaSystems.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C501CFAE3D@exchange.ZeugmaSystems.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anirban,

On 07/14, Anirban Sinha wrote:
>
> >I had a question about one of your previous commits:
> >
> >: commit 2355b70fd59cb5be7de2052a9edeee7afb7ff099
> >: Author: Lai Jiangshan <laijs@cn.fujitsu.com>
> >: Date:   Thu Apr 2 16:58:24 2009 -0700
> >:
> >:    workqueue: avoid recursion in run_workqueue()
> >
> >http://git.kernel.org/linus/2355b70fd59cb5be7de2052a9edeee7afb7ff099
> >
> >
> >I saw a few discussions on the mailing list around this. I also did see
> >your "I still don't know why I merged ..." comment on this. I have the
> >following observations. I am new in the kernel hacking world, so please
> >bear with me.
> >
> >(a) I do agree that flushing the work queues from within
> run_workqueue()
> >is buggy in itself.
> >
> >(b) I do also agree that recursive call to run_workqueue() is bad due
> to
> >the reasons cited in the commit log (even though I had a good laugh
> when
> >I saw the "morton gets to eat his hat" stuff :)).
> >
> >(c) I am a little puzzled by the change the patch made. If we let the
> >call sleep on completion when keventd is itself running the
> >flush_workqueue(), are we not introducing a deadlock? If the thread
> that
> >is itself is responsible for walking the workqueue and dispatching the
> >work functions goes to sleep, who will wake it up?

Yes, this will deadlock. Note the WARN_ON().

> >In my honest opinion, I think we should simply return when (cwq->thread
> >== current) is true. I think in that condition,  it should be just a
> >nop.

If we just return silently, we do not flush but hide the problem ?
And in this can lead to other problems which are very hard to
trigger/debug.

Oleg.

