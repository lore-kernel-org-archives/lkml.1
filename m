Return-Path: <linux-kernel-owner+w=401wt.eu-S1161217AbXDWSJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161217AbXDWSJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 14:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161218AbXDWSJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 14:09:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35401 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161217AbXDWSJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 14:09:32 -0400
Date: Mon, 23 Apr 2007 19:09:18 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
       rusty@rustcorp.com.au
Subject: Re: [PATCH] kthread: Spontaneous exit support
Message-ID: <20070423180918.GA19439@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Oleg Nesterov <oleg@tv-sign.ru>,
	Andrew Morton <akpm@linux-foundation.org>,
	containers@lists.osdl.org, linux-kernel@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>, rusty@rustcorp.com.au
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <1176969596686-git-send-email-ebiederm@xmission.com> <20070419162459.af7a182c.akpm@linux-foundation.org> <20070422194455.GA18561@infradead.org> <m1fy6rzsug.fsf_-_@ebiederm.dsl.xmission.com> <20070423112537.GA21941@infradead.org> <20070423165810.GA188@tv-sign.ru> <m1mz0zvvao.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1mz0zvvao.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 11:45:51AM -0600, Eric W. Biederman wrote:
> Ok.  Thinking about it I agree with Christoph that parallel API's can
> be a problem.
> 
> However we do still need to support kernel threads where kthread_stop will
> never be called.  There appear to be a few legitimate cases where
> someone wants to fire off a thread and have it do some work but don't
> care at all for stopping it before it is done.

There's two cases where it's valid that kthread_stop is not called:

 a) the user is always builtin and the thread runs until the kernel halts.
    examples: voyager, arm ecard
 b) the thread is normally started/stopped, e.g. at module_init/module_exit
    but there is some reason why it could terminate earlier.
    examples:  the various bluetooth threads, nfs-related threads that
    can be killed using signals
 c) we have some kind of asynchronous helper thread.
    examples: various s390 drivers, usbatm, therm_pm72
 d) a driver has threadpools were we need to start/stop threads on demand.
    examples: nfsd, xpc


case a)
	is trivial, we can just ignore the refcounting issue.

case b)
	is what refcounting the task struct and proper handling in
	kthread_stop will deal with.

case c)
	should get a new kthread_create_async api which starts a thread
	without blocking, so we can get rid of the workqueues in the
	s390 drivers.  it should probably also be safe to be called from
	irq context.  What makes this a bit complicated is the need to
	make sure no more thread is running in case the caller terminates
	(shutdown of the structure it's associated with or module removal)

case d)
	should be deal with with a kthread_pool api

