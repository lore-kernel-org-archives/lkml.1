Return-Path: <linux-kernel-owner+w=401wt.eu-S1752934AbZGYNbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbZGYNbS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 09:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbZGYNbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 09:31:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38599 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752841AbZGYNbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 09:31:17 -0400
Date: Sat, 25 Jul 2009 14:31:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Regression] kdesu broken
Message-ID: <20090725143135.5e964f7a@lxorguk.ukuu.org.uk>
In-Reply-To: <87ws5xjo2x.fsf@devron.myhome.or.jp>
References: <200907240145.31935.rjw@sisk.pl>
	<2c0942db0907231721q124dc8f9mdbe64ed33c69ffbf@mail.gmail.com>
	<200907241721.45943.rjw@sisk.pl>
	<20090724164058.21a054e6@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907240930120.3960@localhost.localdomain>
	<87ws5xjo2x.fsf@devron.myhome.or.jp>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Jul 2009 15:04:06 +0900
> I also was seeing this. I hope the attached test code shows the problem.

It does for me: I've been using the test attached below from the Emacs 21
for Mac OS X web site where MacOS developed the same behaviour

>                                                 input_available_p()
>                                                 # buffer was not received yet
>                                                     test_bit(TTY_OTHER_CLOSED)
>                                                         return -EIO
> 
>                                             flush_to_ldisc()
>                                                 ->receive_buf()
> 
> master is having the input data in tty->buf, but ->receive_buf() is not
> called yet. So, it seems to return -EIO before handling input data in
> tty->buf.

Would make sense. Just investigating that now.

-----------

#include <stdio.h>
#include <unistd.h>

int main(int argc, char **argv) {
      pid_t   pid;
      int     master;
      char    buf[101];
      int     n;

      pid = forkpty(&master, NULL, NULL, NULL);
      if(pid < 0) {
          perror("fork error");
          exit(-1);
      } else if(pid == 0) {
          printf("### This is the child process ###\n");  // To be read by parent
          fflush(stdout);     // Doesn't help.
       sleep(1);       // Shouldn't be needed, but it makes things work.
          return(0);
      } else {
          while(n = read(master, buf, 100)) {
              if(n < 0) {
                  perror("read error");
                  exit(-1);
              }
              buf[n] = 0;     // Make a string out of our data.
              printf("Read %d bytes: %s", n, buf);
          }
      }
      exit(0);
}
