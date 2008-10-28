Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbYJ1IYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbYJ1IYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 04:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYJ1IYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 04:24:34 -0400
Received: from main.gmane.org ([80.91.229.2]:52566 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbYJ1IYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 04:24:33 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Halesh S <halesh.s@india.com>
Subject: Re: parent process behaviour to signal after vfork()
Date: Tue, 28 Oct 2008 08:24:21 +0000 (UTC)
Message-ID: <loom.20081028T081449-734@post.gmane.org>
References: <loom.20081028T062822-852@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 59.96.48.15 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.3) Gecko/2008092417 Firefox/3.0.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Check this test


#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
int x = 0;
typedef void (*sighandler_t)(int);
void fun()
{
  printf("SIGNAL CAUGHT\n");
}

int main()
{
  int pid;
  char *s = "HELLO";

  signal(SIGINT, (sighandler_t)fun);
  signal(SIGSEGV, (sighandler_t)fun);
  pid = vfork();

  if ( pid == 0 ) {
    printf(" I am child - %d \n", getpid());
    x++;
    //kill(getpid(), SIGINT);
    raise(SIGINT);
    printf("x = %d\n", x);
    exit(0);
  }
  else {
    sleep(2);
    printf(" I am parent - %d\n", getpid());
    raise(SIGSEGV);
    //kill(getpid(), SIGSEGV);
    printf("x = %d\n", x);
  }
}


Just little analysis

If I use kill() to send the signal,it works fine, but not with raise().

O/p with raise()
 I am child - 15014
SIGNAL CAUGHT
x = 1
 I am parent - 15014         (** Child pid o/p in parent getpid)
x = 1


O/p with kill()
 I am child - 15016
SIGNAL CAUGHT
x = 1
 I am parent - 15015
SIGNAL CAUGHT
x = 1


checked that getpid() function is not working fine when used after raise().
It is still getting its child's pid in parent.

Is it a expected behaviour...Please let me know.

Thanks,
Halesh

