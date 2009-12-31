Return-Path: <linux-kernel-owner+w=401wt.eu-S1752957AbZLaBwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbZLaBwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 20:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbZLaBwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 20:52:31 -0500
Received: from mx.treblig.org ([80.68.94.177]:48804 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbZLaBwa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 20:52:30 -0500
Date: Thu, 31 Dec 2009 01:47:14 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: linux-kernel@vger.kernel.org
Subject: perf: confused by cc1
Message-ID: <20091231014714.GA8313@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.31.5-kvm-i386-2009-10-30 (i686)
X-Uptime: 01:35:22 up 45 days,  8:45,  1 user,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  I'm running 2.6.33rc2 and thought I'd have a play with perf; its
symbol resolution code seems to be getting itself a bit confused however:

I recorded a trace of a kernel build like so:

 sudo /discs/more/git/linux-2.6/tools/perf/perf record -a -e cycles -i -g -v -s -d make -j 8 bzImage

Then I did:
/discs/more/git/linux-2.6/tools/perf/perf report -g

and the top entry is:

    69.89%              cc1  cc1                                                      [.] 0x000000000337cd
                        |          
                        |--0.99%-- 0x9f5da8
                        |          
                        |--0.74%-- 0x9eec95
                         --98.27%-- [...]

but it's refusing to do symbol look up for cc1 even if I install
the (ubuntu) debug packages (most other files it is doing
symbol resolution on where they have it). I dug a bit further and
it looks like it's not trying to look up the debug packages for cc1
because it think that mapping is a kernel map.  Also for some reason it
thinks the cc1 is an overlapping mapping with the gcc4 binary it's been
executed from:

DAG: thread__find_addr_location : /usr/bin/gcc-4.4 addr 0x402f98
DAG: map__find_symbol for /usr/bin/gcc-4.4

(anything starting DAG is something I've added)
{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}
0x68270 [0x20]: event: 7
.
. ... raw event: size 32 bytes
.  0000:  07 00 00 00 00 00 20 00 f7 54 00 00 f3 54 00 00  ...... ..T...T.
.  0010:  f7 54 00 00 f3 54 00 00 bc 75 1c 9c 52 0c 00 00  .T...T...u..R..
.
0x68270 [0x20]: PERF_RECORD_FORK(21751:21751):(21747:21747)

0x68290 [0x18]: event: 3
.
. ... raw event: size 24 bytes
.  0000:  03 00 00 00 00 00 18 00 f7 54 00 00 f7 54 00 00  .........T...T.
.  0010:  63 63 31 00 00 00 00 00                          .T...T.
.
0x68290 [0x18]: PERF_RECORD_COMM: cc1:21751

0x682a8 [0x50]: event: 1
.
. ... raw event: size 80 bytes
.  0000:  01 00 00 00 00 00 50 00 f7 54 00 00 f7 54 00 00  ......P..T...T.
.  0010:  00 00 40 00 00 00 00 00 00 90 83 00 00 00 00 00  ..@............
.  0020:  00 00 00 00 00 00 00 00 2f 75 73 72 2f 6c 69 62  ......../usr/li
.  0030:  2f 67 63 63 2f 78 38 36 5f 36 34 2d 6c 69 6e 75  /gcc/x86_64-lin
.  0040:  78 2d 67 6e 75 2f 34 2e 34 2f 63 63 31 00 00 00  x-gnu/4.4/cc1..
.
0x682a8 [0x50]: PERF_RECORD_MMAPDAG: map__new for /usr/lib/gcc/x86_64-linux-gnu/4.4/cc1
 21751/21751: [0x400000(0x839000) @ (nil)]: /usr/lib/gcc/x86_64-linux-gnu/4.4/cc1
DAG: thread__insert_map: 400000-c39000 0 /usr/lib/gcc/x86_64-linux-gnu/4.4/cc1
overlapping maps:
 400000-c39000 0 /usr/lib/gcc/x86_64-linux-gnu/4.4/cc1
 400000-43c000 0 /usr/bin/gcc-4.4

0x682f8 [0x40]: event: 1

{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}

.....and then when it gets an event in cc1:

{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}
0x684f8 [0x40]: event: 9
.
. ... raw event: size 64 bytes
.  0000:  09 00 00 00 02 00 40 00 23 dc 64 00 00 00 00 00  ......@.#.d....
.  0010:  f7 54 00 00 f7 54 00 00 00 00 00 00 00 00 00 00  .T...T.........
.  0020:  6c 23 2a 00 00 00 00 00 02 00 00 00 00 00 00 00  l#*............
.  0030:  00 fe ff ff ff ff ff ff 23 dc 64 00 00 00 00 00  ........#.d....
.
0x684f8 [0x40]: PERF_RECORD_SAMPLE(IP, 2): 21751/21751: 0x64dc23 period: 2761580
... chain: nr:2
.....  0: fffffffffffffe00
.....  1: 000000000064dc23
 ... thread: cc1:21751
DAG: thread__find_addr_location : /usr/lib/gcc/x86_64-linux-gnu/4.4/cc1 addr 0x64dc23
DAG: map__find_symbol for /usr/lib/gcc/x86_64-linux-gnu/4.4/cc1
DAG: map__load: for /usr/lib/gcc/x86_64-linux-gnu/4.4/cc1 kernel=1
DAG: dso__load: Called for /usr/lib/gcc/x86_64-linux-gnu/4.4/cc1 self->kernel=1
Looking at the vmlinux_path (5 entries long)
symbol__new: bad_address 0xffffffff8100019a-0xffffffff8100019a
{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}

I haven't yet found why kernel=1 is set for cc1, but I assume it's fallout
from whatever reason that it's failed to understand the exec of cc1
and deal with the overlap.

(On Ubuntu Lucid alpha on an Intel i7)

Dave

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
