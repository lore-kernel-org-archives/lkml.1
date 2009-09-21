Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbZIUNkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbZIUNkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZIUNke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:40:34 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:34857 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751384AbZIUNkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:40:33 -0400
Date: Mon, 21 Sep 2009 15:40:46 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: Linux Test Project <Ltp-list@lists.sourceforge.net>
Subject: [LTP] mmapstress03 weirdness? (fwd)
Message-ID: <alpine.LRH.2.00.0909211539520.16077@vixen.sonytel.be>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
Date: Wed, 16 Sep 2009 18:37:12 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linux Test Project <Ltp-list@lists.sourceforge.net>
Subject: [LTP] mmapstress03 weirdness?

On ppc64, with 32-bit userland, I get:

| Running tests.......
| <<<test_start>>>
| tag=mmapstress03 stime=1253117251
| cmdline="mmapstress03"
| contacts=""
| analysis=exit
| <<<test_output>>>
| incrementing stop
| : errno = 0: really large mmap didn't fail
| mmapstress03    1  TFAIL  :  Test failed
                     ^^^^^^^^^^^^^^^^^^^^^
| <<<execution_status>>>
| initiation_status="ok"
| duration=0 termination_type=exited termination_id=0 corefile=no
| cutime=0 cstime=0
| <<<test_end>>>
| INFO: ltp-pan reported all tests PASS
                                   ^^^^

The core part of this test is:

        /* Ask for a ridiculously large mmap region at a high address */
        if (mmap((caddr_t)(1UL << (POINTER_SIZE  - 1)) - pagesize,
                (size_t)((1UL << (POINTER_SIZE - 1)) - pagesize),
                PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_FIXED|MAP_SHARED, 0, 0)
                != (caddr_t)-1)
        {
                ERROR("really large mmap didn't fail");
                anyfail();
        }
        if (errno != ENOMEM && errno != EINVAL) {
                ERROR("really large mmap didn't set errno = ENOMEM nor EINVAL");
                anyfail();
        }

With 32-bit userland, this boils down to:

| mmap addr 0x7fff0000 size 0x7fff0000
| mmap returned 0x7fff0000

i.e. mmap() succeeds, but (1) the test expects it to fail, so the test returns
TFAIL, but (2) ltp-pan still reports that the tests passed?

In addition, sometimes mmapstress03 fails due to SEGV. I created a small test
program that just does the above mmap(), and depending on the distro and what
else I print later it crashes with a SEGV, too. Probably this happens because
the mmap() did succeed, and corrupted some existing mappings, cfr. the notes
for MAP_FIXED:

       MAP_FIXED
              Don’t  interpret  addr  as  a hint: place the mapping at exactly
              that address.  addr must be a multiple of the page size.  If the
              memory  region  specified  by addr and len overlaps pages of any
              existing mapping(s), then the overlapped part  of  the  existing
              mapping(s)  will  be discarded.  If the specified address cannot
              be used, mmap() will fail.  Because requiring  a  fixed  address
              for  a  mapping is less portable, the use of this option is dis‐
              couraged.


JFYI, with 64-bit userland, this boils down to:

| mmap addr 0x7fffffffffff0000 size 0x7fffffffffff0000
| mmap returned 0xffffffffffffffff

i.e. mmap() fails as expected, and the test succeeds.

Does all of this sound OK?
Thanks for your comments!

With kind regards,

Geert Uytterhoeven
Software Architect
Techsoft Centre

Technology and Software Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
