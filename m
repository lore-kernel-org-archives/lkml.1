Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbZCVFgX (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sun, 22 Mar 2009 01:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZCVFgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 01:36:06 -0400
Received: from mx44.mail.ru ([94.100.176.58]:60779 "EHLO mx44.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbZCVFgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 01:36:05 -0400
From: Peter Lojkin <ia6432@inbox.ru>
To: linux-kernel@vger.kernel.org
Subject: =?koi8-r?Q?Re=3A_[Bug_#12911]_Limiting_cpu_time_doesn't_work?=
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: unknown via proxy [83.167.111.116]
Date: Sun, 22 Mar 2009 08:34:49 +0300
X-Mru-Data: 2342:1:1:70:70:0
Reply-To: Peter Lojkin <ia6432@inbox.ru>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1LlGKf-000OqX-00.ia6432-inbox-ru@f221.mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

additional info on subject.
problem first apeared in 2.6.27-git9 and RLIMIT_CPU actually works on process that sets limit but not on its children. examples:

test1.c
#include <sys/time.h>
#include <sys/resource.h>

int main() {
  struct rlimit a;
  a.rlim_cur=3;
  a.rlim_max=5;
  setrlimit(RLIMIT_CPU, &a);
  while(1);
  return 0;
}

test1 dies with "CPU time limit exceeded" after 3sec as expected, but

test2.c
#include <sys/time.h>
#include <sys/resource.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int main() {
  struct rlimit a;
  int status;

  a.rlim_cur=3;
  a.rlim_max=5;
  setrlimit(RLIMIT_CPU, &a);
  if (0==fork())
    while(1);
  else
    wait(&status);
  return 0;
}

test2 not get killed. checking limits on child process show that limits set correctly.

two equivalent examples for shell:
sh -c "ulimit -t 3; while true; do true; done"
sh -c "ulimit -t 3; sh -c 'while true; do true; done'"

