Return-Path: <linux-kernel-owner+w=401wt.eu-S1758479AbYG2Nl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbYG2Nl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 09:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbYG2NlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 09:41:21 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:53559 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870AbYG2NlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 09:41:20 -0400
Date: Tue, 29 Jul 2008 17:44:57 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch, minor] workqueue: consistently use 'err' in __create_workqueue_key()
Message-ID: <20080729134456.GA355@tv-sign.ru>
References: <1217277694.20627.9.camel@earth> <20080729110250.GA177@tv-sign.ru> <b647ffbd0807290458n23dbe79et45cb27273e4fc2ae@mail.gmail.com> <20080729125201.GC177@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729125201.GC177@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29, Oleg Nesterov wrote:
>
> On 07/29, Dmitry Adamushko wrote:
> >
> > And I'd say this behavior (of having a partially-created object
> > visible to the outside world) is not that robust. e.g. the
> > aforementioned race would be eliminated if we place a wq on the global
> > list only when it's been successfully initialized.
>
> Yes, we can change __create_workqueue_key() to check err == 0 before
> list_add(),

Well no, we can't do even this.

Then we have another race with cpu-hotplug. Suppose we have CPUs 0, 1, 2.
create_workqueue() fails to create cwq->thread for CPU 2 and calls
destroy_workqueue(). Before it takes the cpu_add_remove_lock, _cpu_down()
removes CPU 1 from cpu_populated_map, but since we didn't add this wq
on the global list, cwq[1]->thread remains alive.

destroy_workqueue() takes cpu_add_remove_lock, and calls
cleanup_workqueue_thread() for CPUs 0 and 2. cwq[1]->thread is lost.


Damn. I had this in mind when I wrote the code, but forgot. We need
comments, I'll send the patch.

Oleg.

