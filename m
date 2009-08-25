Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbZHYAU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbZHYAU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 20:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbZHYAUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 20:20:54 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:33180 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbZHYAUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 20:20:53 -0400
Message-ID: <4A932BF6.1090405@ct.jp.nec.com>
Date: Tue, 25 Aug 2009 09:10:30 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, stable@kernel.org
Subject: Re: [PATCH v3] fix race copy_process() vs de_thread()
References: <4A9210A4.4010108@ct.jp.nec.com> <20090824061420.341A9414DF@magilla.sf.frob.com> <4A923403.6010201@ct.jp.nec.com> <20090824083826.GA475@redhat.com> <20090824162730.GA14367@redhat.com>
In-Reply-To: <20090824162730.GA14367@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> Spotted by Hiroshi Shimamoto who also provided the test-case below.
> 
> copy_process() pathes use signal->count as a reference counter, but
> it is not. This test case
> 
> 	#include <sys/types.h>
> 	#include <sys/wait.h>
> 	#include <unistd.h>
> 	#include <stdio.h>
> 	#include <errno.h>
> 	#include <pthread.h>
> 
> 	void *null_thread(void *p)
> 	{
> 		for (;;)
> 			sleep(1);
> 
> 		return NULL;
> 	}
> 
> 	void *exec_thread(void *p)
> 	{
> 		execl("/bin/true", "/bin/true", NULL);
> 
> 		return null_thread(p);
> 	}
> 
> 	int main(int argc, char **argv)
> 	{
> 		for (;;) {
> 			pid_t pid;
> 			int ret, status;
> 
> 			pid = fork();
> 			if (pid < 0)
> 				break;
> 
> 			if (!pid) {
> 				pthread_t tid;
> 
> 				pthread_create(&tid, NULL, exec_thread, NULL);
> 				for (;;)
> 					pthread_create(&tid, NULL, null_thread, NULL);
> 			}
> 
> 			do {
> 				ret = waitpid(pid, &status, 0);
> 			} while (ret == -1 && errno == EINTR);
> 		}
> 
> 		return 0;
> 	}
> 
> quickly creates the unkillable task.
> 
> If copy_process(CLONE_THREAD) races with de_thread()
> copy_signal()->atomic(signal->count) breaks the signal->notify_count
> logic, and the execing thread can hang forever in kernel space.
> 
> Change copy_process() to increment count/live only when we know for
> sure we can't fail. In this case the forked thread will take care
> of its reference to signal correctly.
> 
> If copy_process() fails, check CLONE_THREAD flag. If it it set - do
> nothing, the counters were not changed and current belongs to the same
> thread group. If it is not set, ->signal must be released in any case
> (and ->count must be == 1), the forked child is the only thread in the
> thread group.
> 
> We need more cleanups here, in particular signal->count should not be
> used by de_thread/__exit_signal at all. This patch only fixes the bug.
> 
> Reported-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Nice fix!
Tested-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Thanks,
Hiroshi
