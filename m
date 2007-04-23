Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbXDWQ60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbXDWQ60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 12:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbXDWQ60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 12:58:26 -0400
Received: from mail.screens.ru ([213.234.233.54]:33107 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090AbXDWQ6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 12:58:25 -0400
Date: Mon, 23 Apr 2007 20:58:10 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
       rusty@rustcorp.com.au
Subject: Re: [PATCH] kthread: Spontaneous exit support
Message-ID: <20070423165810.GA188@tv-sign.ru>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <1176969596686-git-send-email-ebiederm@xmission.com> <20070419162459.af7a182c.akpm@linux-foundation.org> <20070422194455.GA18561@infradead.org> <m1fy6rzsug.fsf_-_@ebiederm.dsl.xmission.com> <20070423112537.GA21941@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423112537.GA21941@infradead.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23, Christoph Hellwig wrote:
>
> On Sun, Apr 22, 2007 at 09:12:55PM -0600, Eric W. Biederman wrote:
> > 
> > This patch implements the kthread helper functions kthread_start
> > and kthread_end which make it simple to support a kernel thread
> > that may decided to exit on it's own before we request it to.
> > It is still assumed that eventually we will get around to requesting
> > that the kernel thread stop.
> 
> I don't think having to parallel APIs is a good idea, people will
> get utterly confused which one to use.  Better always grab a reference
> in kthread_create and drop it in kthread_stop.  For normal thread
> no change in behaviour and only slightly more code in the slowpath.
> 
> Of course it will need an audit for half-assed kthread conversion
> first to avoid task_struct reference count leaks.

In that case it is better to grab a reference in kthread(). This also
close the race when a new thread is woken (freezer) and exits before
kthread_create() does get_task_struct().

> In addition to that kthrad_end implementation look wrong. When
> the kthread has exited prematurely no one will call complete
> on kthread_stop_info.done before it's been setup.

This is not true anymore, see another patch from Eric

	kthread-enhance-kthread_stop-to-abort-interruptible-sleeps.patch

Oleg.

