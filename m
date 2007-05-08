Return-Path: <linux-kernel-owner+w=401wt.eu-S968237AbXEHOe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968237AbXEHOe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 10:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968067AbXEHOe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 10:34:26 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:47662 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968233AbXEHOeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 10:34:24 -0400
Date: Tue, 8 May 2007 18:42:37 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Christoph Hellwig <hch@lst.de>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH -utrace] Move utrace into task_struct
Message-ID: <20070508144237.GB6130@localhost.sw.ru>
References: <20070502113252.GA8017@localhost.sw.ru> <20070502220203.D73D21801A3@magilla.sf.frob.com> <20070503103449.GB6147@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503103449.GB6147@lst.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Regardless of future of "struct utrace utrace;" patch looks like there
is another race: engine's flags and ops settings in utrace_detach() and
acting on them in report_quiescent():

utrace_detach()				report_quiescent()
---------------				------------------
[utrace lock held]			[utrace lock is not held]

engine->flags = UTRACE_EVENT(QUIESCE) |
		UTRACE_ACTION_QUIESCE;
					if (engine->flags & UTRACE_EVENT(QUIESCE))
						REPORT(report_quiesce);

rcu_assign_pointer(engine->ops, &dead_engine_ops);


At the moment of REPORT call engine's ops are still "live" ptrace ops
which do not have ->report_quiesce callback. So, there will oops while
calling function at NULL address. "Dead" ptrace engine ops do have dummy
callback but it wasn't yet glued.

I hit this once with "struct utrace utrace;" patch applied, but this
bug is also present in stock utrace, I'm sure.

