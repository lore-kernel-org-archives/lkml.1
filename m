Return-Path: <linux-kernel-owner+w=401wt.eu-S1762818AbYGBGe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762818AbYGBGe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 02:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759585AbYGBGeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 02:34:21 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37200 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755795AbYGBGeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 02:34:20 -0400
X-Sasl-enc: 8H+MVZlCODyyvMjJhjn3rVOebpDuGDhhjIwHVogJGfiW 1214980459
Message-ID: <3f2201c8dc0d$d1012d60$0b01a8c0@robmhp>
From: "Rob Mueller" <robm@fastmail.fm>
To: "Michael Kerrisk" <mtk.manpages@googlemail.com>,
       "Bron Gondwana" <brong@fastmail.fm>
Cc: "Philippe De Muyter" <phdm@macqel.be>, <linux-kernel@vger.kernel.org>
References: <20080701132149.GA32510@frolo.macqel> <517f3f820807011116g6ce1b3e1qf166070f7a4c523f@mail.gmail.com> <20080701214423.GA29875@brong.net> <cfd18e0f0807012214o78353faal84a5fa764d3210bf@mail.gmail.com>
Subject: Re: mmap'ed memory in core files ?
Date: Wed, 2 Jul 2008 16:35:22 +1000
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This is particularly interesting on a 64 bit kernel where a bug in
>> your code causes you to try to read something about 2Gb into your
>> alleged mmaped file (actual size ~500 bytes) and the segfault causes
>> a coredump.
>
> Do you have a ssimple example program for this?

Trying to reproduce the problem, I think it's actually related to sparse 
files.

$ cat a.c
#include <stdlib.h>
int main() {
  unsigned int i;
  char * a = malloc(3000000000u);
  *(int *)0 = 0;
}
$ gcc a.c
$ ulimit -c 10240 && ./a.out
$ ls -l
-rw------- 1 root root 3000082432 Jul  2 02:23 core.7761
$

It's clearly sparse, but slightly unintuitive that the ulimit doesn't 
actually limit the filesize, just the size of the data written to the file.

If I change the code to include this line after the malloc():

  for (i = 0; i < 3000000000u; i++) a[i] = i % 256;

I get:

-rw------- 1 root root   10485760 Jul  2 02:25 core.8992

More what you'd expect.

One interesting side effect of running a 64-bit kernel + 32-bit userland is 
that previously bugs that might have previously caused malloc() to fail (eg 
underflowing integer to a huge value), now succeed and allocate a huge chunk 
of memory rather than failing and causing the program to bailout/crash on 
dereference.

Rob

