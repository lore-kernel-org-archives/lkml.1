Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbZKKAnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbZKKAnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 19:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbZKKAnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 19:43:50 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47155 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbZKKAnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 19:43:50 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Timo Sirainen <tss@iki.fi>
Subject: Re: + prctl-add-pr_set_proctitle_area-option.patch added to -mm tree
Cc: kosaki.motohiro@jp.fujitsu.com, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bryan Donlan <bdonlan@gmail.com>, Ulrich Drepper <drepper@redhat.com>,
       WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1257876016.3022.277.camel@timo-desktop>
References: <2f11576a0911100948o79970e44t197cd2978428de1a@mail.gmail.com> <1257876016.3022.277.camel@timo-desktop>
Message-Id: <20091111090704.FD2D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 11 Nov 2009 09:43:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2009-11-11 at 02:48 +0900, KOSAKI Motohiro wrote:
> > There is unwritten reason. I hope to add /proc/[pid]/cmdline cache. It
> > help to avoid
> > ps getting stuck by mmap_sem.
> 
> Can you explain this further? When would it cache the value and when
> would it be returned? I was at least hoping to avoid calling prctl()
> every time when I want process title changed.

Hmm...
I'm not intent it.

The setter's prctl() performance is not critical. Plus, current code
isn't so slow.

I mean ps -elf (or ps aux) read the /proc/pid/cmdline of all task.
It mean grabbing mmap_sem and read another task's mem for all task.
Then, A stress workload can kill ps performance easily.

Essentially, reading another process's memory is costly operation. but
it can be cached.

Some *BSD has similar mechanism.


Caution: This feature break SPT_ARGV style process title changing.
then, it should be optional feature and sould be able to enable by
admin's explicit operation.
2years after, probably this issue will disappear automatically. because
all setproctitle() using software try to use libc's setproctitle().
IOW, if libc has setproctitle(), nobody try to change own stack argv
string brutally.


> I think Solaris saves the first 80 chars of the initial cmdline to
> kernel memory and gives that to ps. I guess doing something similar and
> returning it only when userspace memory can't be accessed would be ok.

Linux does it too. but 16 chars.


