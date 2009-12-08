Return-Path: <linux-kernel-owner+w=401wt.eu-S932310AbZLHF4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbZLHF4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 00:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbZLHF4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 00:56:37 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43030 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbZLHF4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 00:56:36 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v6] Added PR_SET_PROCTITLE_AREA option for prctl()
Cc: kosaki.motohiro@jp.fujitsu.com, Bryan Donlan <bdonlan@gmail.com>,
       Ulrich Drepper <drepper@redhat.com>, Timo Sirainen <tss@iki.fi>,
       WANG Cong <xiyou.wangcong@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091208053851.GA12383@elte.hu>
References: <20091208135010.B5A8.A69D9226@jp.fujitsu.com> <20091208053851.GA12383@elte.hu>
Message-Id: <20091208144004.B5AB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Dec 2009 14:56:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > The feature looks useful, but the choice of a prctl as an API is strange 
> > > - it limits us to the current task only - while the ability to set 
> > > arguments for another task looks a more generic (and potentially more 
> > > useful) solution.
> > 
> > No. It's impossible.
> > /proc/{pid}/cmdline read user process's memory. iow, this prctl() don't
> > receive string, it receive virtual address itself. [...]
> 
> it's not 'impossible' at all, you yourself mention ptrace:

Ah yes, 'impossible' was wrong word. but it doesn't works intentionally.

1. setproctitle() unaware application continue to see argv[0] directly.
  it makes some inconsistent behavior. 
2. proc title (i.e. string) injection need to map new page as process title area.
   implicit mapping increasing makes new trouble
   - mihgt cause to exceed max_map_count awhile after.
   - might cause leak proc title area (who know when it should be freed?)

I think reasonable way is 1. send signal (or use another inter process
communication way) to target process 2. target process change own proc title
themself.

Plus, I haven't seen the use-case of changin another task. iow I doubt
it's worth to change lots code.


> > [...] I don't want any task allow to change another task's memory 
> > except ptrace.
> 
> And i did not mean to allow 'any' task to be allowed to do this - 
> security checks apply, obviously.

Agreed. My 'any' didn't intent bypass security check ;-)



