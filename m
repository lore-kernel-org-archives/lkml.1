Return-Path: <linux-kernel-owner+w=401wt.eu-S1161359AbXBGPOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161359AbXBGPOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 10:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161360AbXBGPOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 10:14:32 -0500
Received: from mail.screens.ru ([213.234.233.54]:44621 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161359AbXBGPOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 10:14:32 -0500
Date: Wed, 7 Feb 2007 18:16:30 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Daniel Drake <dsd@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/6] workqueue: make cancel_rearming_delayed_workqueue() work on idle dwork
Message-ID: <20070207151630.GA138@tv-sign.ru>
References: <20070206233016.GA108@tv-sign.ru> <45C9E320.3070001@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C9E320.3070001@gentoo.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07, Daniel Drake wrote:
>
> Oleg Nesterov wrote:
> >cancel_rearming_delayed_workqueue(dwork) will hang forever if dwork was not
> >scheduled, because in that case cancel_delayed_work()->del_timer_sync() 
> >never
> >returns true.
> 
> Thanks! We hit this problem before with the zd1211rw driver and avoided 
> using cancel_rearming_delayed_workqueue() for this reason.

Great. But I am afraid my changelog was incomplete. This patch only fixes
the cancel_rearming_delayed_workqueue(freshly_initialized_dwork) lockup.

The following code

	schedule_delayed_work(dw);
	cancel_rearming_delayed_workqueue(dw);	// OK
	cancel_rearming_delayed_workqueue(dw);	// HANGS!

still doesn't work.

Is it worth fixing? The fix is very simple, and probably makes sense by
itself:

	cancel_delayed_work:

	-	work_release(&work->work);
	+	work->work.data = NULL;

Oleg.

