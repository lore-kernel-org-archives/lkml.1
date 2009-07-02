Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbZGBQhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbZGBQhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 12:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750726AbZGBQhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 12:37:32 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:55797 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbZGBQhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 12:37:32 -0400
Date: Thu, 2 Jul 2009 11:37:31 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH][BUGFIX] cgroups: fix pid namespace bug
Message-ID: <20090702163731.GA14267@us.ibm.com>
References: <4A4C0C60.4050106@cn.fujitsu.com> <6599ad830907020926t6305bec9t44a50cc165f6fc28@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6599ad830907020926t6305bec9t44a50cc165f6fc28@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Menage (menage@google.com):
> On Wed, Jul 1, 2009 at 6:24 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
> > +       cp = kzalloc(sizeof(*cp), GFP_KERNEL);
> > +       if (!cp) {
> > +               up_write(&cgrp->pids_mutex);
> > +               kfree(pidarray);
> > +               return -ENOMEM;
> > +       }
> > +       cp->cgrp = cgrp;
> > +       cp->pid_ns = pid_ns;
> 
> You're storing an uncounted reference to the pid ns here - there's no
> guarantee that the pid_ns will outlive the open file.

Yeah I was thinking about that, but

	1. the only way it won't outlive the open file is if the 
		task opens the file, hands the open fd over a
		unix socket, then exits as the last task of its
		pidns
	2. We don't dereference the pid_ns, so there is no actual
		safety issue.  So it would become a problem only
		if a new pidns gets created at that same address
		*and* a task in the new pidns opens the same
		tasks file.

Still, it wouldn't hurt to do get_pid_ns/put_pid_ns at the open
and release :)

-serge
