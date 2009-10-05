Return-Path: <linux-kernel-owner+w=401wt.eu-S1758356AbZJECYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356AbZJECYs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 22:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758310AbZJECYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 22:24:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42656 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758229AbZJECYq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 22:24:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Bryan Donlan <bdonlan@gmail.com>
Subject: Re: [PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
Cc: kosaki.motohiro@jp.fujitsu.com,
       KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Timo Sirainen <tss@iki.fi>,
       linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
In-Reply-To: <3e8340490910041921p315f3726me0143f2516022f66@mail.gmail.com>
References: <20091005105617.5F86.A69D9226@jp.fujitsu.com> <3e8340490910041921p315f3726me0143f2516022f66@mail.gmail.com>
Message-Id: <20091005112314.5F89.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  5 Oct 2009 11:24:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Oct 4, 2009 at 9:59 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> On Sun, Oct 4, 2009 at 9:38 PM, KOSAKI Motohiro
> >> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> >> The improvement idea is here.
> >> >>
> >> >> Changelog
> >> >>   - Added task_lock() to prctl(PR_SET_PROCTITLE_AREA)
> >> >>  -  Added small input sanity check to prctl(PR_SET_PROCTITLE_AREA)
> >> >
> >> > Doh, task_lock() is obviously wrong. please forget this.
> >>
> >> As another note, in general I think we'd need to hold a lock over the
> >> entire operation. After all, if userspace changes its PROCTITLE_AREA,
> >> and then reuses the memory for something else, we have an information
> >> leak.
> >
> > if reusing occur, it's obviously userland fault. I don't think we need to care this.
> > because current kernel also can be information leak by strcpy(argv[0], mypassword).
> >
> > I think they are userland bug both.
> 
> No, the scenario is:
> 
> Process B: Enter proc_pid_cmdline(), read arg_start and arg_end into
> CPU registers
> Process A: prctl(PR_SET_PROCTITLE_AREA)....
> Process A: free(old_arg_area);
> Process A: char *foo = malloc(...);
> Process A: strcpy(foo, super_secret_password);
> Process B: access_process_vm - using an area overlapping foo
> 
> Process B now has process A's secrets. This cannot be avoided by
> process A, as it cannot control when process B will complete
> proc_pid_cmdline(), and so the kernel must protect against this
> scenario.  The only way a userspace process could prevent this is by
> only using PR_SET_PROCTITLE_AREA once, and never reusing that memory,
> ever. This does not seem like an appropriate restriction to pass down
> to userspace for me...
> 
> Anyway, I'm working on a patch that uses the generation-counter approach now :)

Ok, you are right.
Plus, I've finished to made generation-counter approach patch :)



