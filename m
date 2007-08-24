Return-Path: <linux-kernel-owner+w=401wt.eu-S1759476AbXHXPp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbXHXPp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 11:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbXHXPpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 11:45:51 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:34772 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753564AbXHXPpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 11:45:51 -0400
Date: Fri, 24 Aug 2007 11:45:48 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] Sort module list by pointer address to get coherent sleepable seq_file iterators
Message-ID: <20070824154548.GB21226@Krystal>
References: <20070820202600.116795129@polymtl.ca> <20070820202646.555561265@polymtl.ca> <1187654910.19435.147.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1187654910.19435.147.camel@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:46:53 up 24 days, 16:05,  4 users,  load average: 0.10, 0.13, 0.22
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Mon, 2007-08-20 at 16:26 -0400, Mathieu Desnoyers wrote:
> > plain text document attachment (module.c-sort-module-list.patch)
> > A race that appears both in /proc/modules and in kallsyms: if, between the
> > seq file reads, the process is put to sleep and at this moment a module is
> > or removed from the module list, the listing will skip an amount of
> > modules/symbols corresponding to the amount of elements present in the unloaded
> > module, but at the current position in the list if the iteration is located
> > after the removed module.
> > 
> > The cleanest way I found to deal with this problem is to sort the module list.
> > We can then keep the old struct module * as the old iterator, knowing the it may
> > be removed between the seq file reads, but we only use it as "get next". If it
> > is not present in the module list, the next pointer will be used.
> > 
> > By doing this, removing a given module will now only fuzz the output related to
> > this specific module, not any random module anymore. Since modprobe uses
> > /proc/modules, it might be important to make sure multiple concurrent running
> > modprobes won't interfere with each other.
> 
> You've reduced, but not eliminated, the problem.  A new module inserted
> is quite likely to reuse the same address.
> 

Hi Rusty,

Please tell me if I'm wrong, but I think it would not be a problem:

- seq_read() makes sure that a buffer large enough is available so that
  m_show() can fully extract and print the information relative to 1
  module.
- m_start() and m_stop() takes the module_mutex, therefore within one
  seq_read(), once m_start has returned, the struct module * that we
  have is valid and will be consistent during the whole seq_read
  operation.
- If a module is removed, and then a different one is inserted at the
  same address, while we are between two seq_reads for this given struct
  module address, the seq_reads will copy to user-space the information
  that is still in the buffer for the _first_ struct module encountered,
  not the new one.
- After that, iteration will continue to the new struct module address,
  effectively skipping the newly inserted module.


> I don't have a real problem with this patch, but I'm wondering if the
> problem is theoretical or demonstrated.
> 

Small test module for this:

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#define BUFSIZE 1024

int main()
{
	int fd = open("/proc/modules", O_RDONLY);
	char buf[BUFSIZE];
	ssize_t size;

	do {
		size = read(fd, buf, 1);
		printf("%c", buf[0]);
		usleep(100000);
	} while(size > 0);

	close(fd);
	return 0;
}

(compiled as ./module)

Actual test (kernel 2.6.23-rc3):

dijkstra:~# lsmod
Module                  Size  Used by
pl2303                 18564  0 
usbserial              29032  1 pl2303
ppdev                   7844  0 
sky2                   37476  0 
skge                   36368  0 
rtc                    10104  0 
snd_hda_intel         265628  0 

  (here, while we are printing the 2nd line, I rmmod pl2303)
compudj@dijkstra:~/test$ ./module
pl2303 18564 0 - Live 0xf886e000
usbserial 29032 1 pl2303, Live 0xf8865000
sky2 37476 0 - Live 0xf884f000
skge 36368 0 - Live 0xf8838000
rtc 10104 0 - Live 0xf8825000

We see the the 2nd line is garbage.

Now, with my patch applied:
  (here, while we are printing the rtc module, I rmmod rtc)
nd_hda_intel 268708 0 - Live 0xf8820000
ltt_control 2372 0 - Live 0xf8866000
rtc 10392 0 - Live 0xf886d000
skge 36768 0 - Live 0xf8871000
ltt_statedump 8516 0 - Live 0xf887b000

We see that since the rtc line was already in the buffer, it has been
printed completely.


  (here, while we are printing the skge module, I rmmod rtc)
snd_hda_intel 268708 0 - Live 0xf8820000
ltt_control 2372 0 - Live 0xf8866000
rtc 10392 0 - Live 0xf886d000
skge 36768 0 - Live 0xf8871000
ltt_statedump 8516 0 - Live 0xf887b000
sky2 38420 0 - Live 0xf88cd000

We see that the iteration continued at the same position even though the
rtc module, located in earlier addresses, was removed.

Note that this test is done with the 
"Sort modules list - use ppos instead of m->private"
patch applied.

Thanks for the review,

Mathieu

> Rusty.
> 
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
