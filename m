Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbXHJDmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbXHJDmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 23:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbXHJDlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 23:41:51 -0400
Received: from mx.inf.ufpr.br ([200.17.202.3]:34509 "EHLO urquell.c3sl.ufpr.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbXHJDlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 23:41:50 -0400
Message-ID: <46BBDE7B.7060908@c3sl.ufpr.br>
Date: Fri, 10 Aug 2007 00:41:47 -0300
From: Tiago Vignatti <vignatti@c3sl.ufpr.br>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: mlock() is working?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I'm trying to lock some piece of the code in memory using mlock(). I did 
a simple program to test it and to certify I using my own simple page 
fault notifier [0]. The program is below.

-- cut --

#include <stdio.h>
#include <sys/mman.h>

#define SIZE 10000

int mlock_all = 0;

int
f(void)
{
     int c[SIZE];
     int i;

     if (mlock_all) {
         if (!mlockall(MCL_CURRENT))
             fprintf(stderr, "mlockall'ed succefully\n");
         else
             perror("mlockall");
     }
     else {
         if (!mlock(&c[0], SIZE))
             fprintf(stderr, "mlock'ed succefully\n");
         else
             perror("mlock");
     }

     fprintf(stderr, "start: 0x%x, end: 0x%x\n", &c[0], &c[SIZE]);

     for (i = 0; i < SIZE; i++)
         c[i] = i;

}
int
main(int argc, char **argv)
{
     if (argv[1])
         mlock_all = 1;

     while(1) {
         f();
         sleep (15);
     }

     return 0;
}

-- cut --


So, if I use mlockall() I always obtained the desired result, i.e., I 
lock the 'c[SIZE]'. But when I switch to mlock() it never works and my 
page fault notifier prints all pages concerning 'c[SIZE]'. Am I missing 
something? Is it possible to lock the automatic variables?

My Linux is 2.6.22.2.

my regards

[0] http://lkml.org/lkml/2007/7/27/11
     http://lkml.org/lkml/2007/7/27/8

-- 
Tiago Vignatti
C3SL - Centro de Computação Científica e Software Livre
www.c3sl.ufpr.br
