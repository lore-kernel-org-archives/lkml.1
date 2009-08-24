Return-Path: <linux-kernel-owner+w=401wt.eu-S1751672AbZHXGdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbZHXGdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 02:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbZHXGdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 02:33:38 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:62231 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbZHXGdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 02:33:38 -0400
Message-ID: <4A923403.6010201@ct.jp.nec.com>
Date: Mon, 24 Aug 2009 15:32:35 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix race copy_process() vs de_thread()
References: <4A9210A4.4010108@ct.jp.nec.com> <20090824061420.341A9414DF@magilla.sf.frob.com>
In-Reply-To: <20090824061420.341A9414DF@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> I'm not sure I follow the problem scenario you are citing.
> 
> The thread in copy_process() will return -ERESTARTNOINTR
> after calling cleanup_signal(), which does properly decrement
> sig->count to return it to the state before the copy_process() call.
> Then this thread will get to signal handling, dequeue its SIGKILL from
> zap_other_threads(), and die itself.  When it's finally reaped, by itself
> in exit_notify(), or by de_thread() in the case of a replaced group_leader,
> the normal __exit_signal() will do that group_exit_task logic.
> 
> What part of this sequence fails to occur in your tests?

The point is that de_thread() waits until other thread calls wake_up_process().
In __exit_signal() when sig->count == 2, the thread calls wake_up_process(),
and then de_thread() will continue. However if another thread is during
copy_process(), the sig->count is incremented at copy_signal(). That makes
no wake_up_process().

The scenario flow is like this;

thread A          thread B    thread C      sig->count
   |                 |           |              3
  clone()          exec()        |              |
  copy_process()   de_thread()   |              |
  copy_signal()      |           |              4
   |                zap          |              4
  KILL               |          KILL            4
   |                 |          __exit_signal() 3 no wake up
  clean_signal()     |                          2 no wake up
   |                 |                             during copy_process()
  exit               |
                never wake up

thanks,
Hiroshi
