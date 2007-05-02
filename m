Return-Path: <linux-kernel-owner+w=401wt.eu-S2992663AbXEBD0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992663AbXEBD0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 23:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992678AbXEBD0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 23:26:18 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:62460 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992663AbXEBD0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 23:26:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=OCmXvr0MsVRM+BmuLUeCuVKC1OLKKZotx0jBghwnmuZwpIIsRR+IQKIpuZerJJRToSk/6ugBLpX8IWg8RlVc5KmONZM5807PeqnlNznBO7XOQuUwt+gDF50Xczksvt+a7ZB86dxrrWgPpH2xJZpKys6lMSaRLonR3wIiYTe9uPk=
Message-ID: <a8f16e2b0705012026u6078f90dsbe55f854d8638795@mail.gmail.com>
Date: Wed, 2 May 2007 07:26:13 +0400
From: "Dan Kruchinin" <dubalom@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC BUG?] dereference PAGE_OFFSET address (rc7-mm2)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I don't know why, but when I'm dereferencing PAGE_OFFSET(0xC0000000 on
x86) address from user space on rc7-mm2 I don't receive SIGSEGV signal
and there is no any core dump.
btw: on poor rc-7 all is ok.

test_code:
---
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <sys/types.h>

#define PAGE_OFFSET 0xC0000000

static void _error(const char *msg)
{
  int errcode = errno;

  fprintf(stderr, "ERROR:\n--> %s [%s]\n", msg, strerror(errcode));
  exit(EXIT_FAILURE);
}

int main(void)
{
  int pid;
  struct rlimit rl;
  int status;

  printf("Trying to cause ELF core dump...\n");

  rl.rlim_cur = rl.rlim_max = 0x10000000;

  if(setrlimit(RLIMIT_CORE, &rl) < 0)
	_error("setrlim error!");
  if((pid = fork()) < 0)
	_error("fork error!");
  else if(pid == 0) {
	*((long*) PAGE_OFFSET ) = 0; /* trying to dereference kernel start address */
	_exit(EXIT_SUCCESS);
  }

  if(waitpid(pid, &status, 0) < 0)
	_error("waitpid error!");
  if(WCOREDUMP(status))
	printf("All is ok. We receive SIGSEGV and core dump has occured.\n");
  else
	printf("All is bad. We don't receive SIGSEGV and core dump hasn't
occured. (WHY?!)\n"); /* here I just get SIGCHLD, this means that
child process have made it's work success... */

  exit(EXIT_SUCCESS);
}
---

[asgard@midgard]$ uname -a
Linux midgard 2.6.21-rc7-mm2 #5 SMP Wed May 2 04:15:09 MSD 2007 i686 GNU/Linux

[asgard@midgard]$ ./a.out
Trying to cause ELF core dump...
All is bad. We don't receive SIGSEGV and core dump hasn't occured. (WHY?!)

---

[asgard@midgard]$ uname -a
Linux midgard 2.6.21-rc7 #5 SMP Wed May 2 02:11:50 MSD 2007 i686 GNU/Linux

[asgard@midgard]$ ./a.out
Trying to cause ELF core dump...
All is ok. We receive SIGSEGV and core dump has occured.

With best regards.
Dan Kruchinin.
