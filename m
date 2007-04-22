Return-Path: <linux-kernel-owner+w=401wt.eu-S1030624AbXDVMcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030624AbXDVMcO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 08:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030608AbXDVMcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 08:32:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46942 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030576AbXDVMcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 08:32:13 -0400
Date: Sun, 22 Apr 2007 13:31:55 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       linux-s390@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] powerpc pseries eeh: Convert to kthread API
Message-ID: <20070422123155.GF20763@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
	Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
	Paul Mackerras <paulus@samba.org>, linux-s390@vger.kernel.org,
	linuxppc-dev@ozlabs.org
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <11769695763104-git-send-email-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11769695763104-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 01:58:45AM -0600, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> This patch modifies the startup of eehd to use kthread_run
> not a combination of kernel_thread and daemonize.  Making
> the code slightly simpler and more maintainable.

This one has the same scheme as the various s390 drivers where a thread
is spawned using a workqueue on demand.  I think we should not blindly
convert it but think a litte more about it.

The first question is obviously, is this really something we want?
spawning kernel thread on demand without reaping them properly seems
quite dangerous.

The second question is whether this is the right implementation.
kthread_create already works by using a workqueue to create the thread
and then waits for it.  If we really want to support creating threads
asynchronously on demand we should have a proper API in kthread.c for
this instead of spreading workqueues.

