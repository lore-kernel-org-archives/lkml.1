Return-Path: <linux-kernel-owner+w=401wt.eu-S1759337AbXHADlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbXHADlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 23:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbXHADlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 23:41:04 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1609 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbXHADlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 23:41:01 -0400
Date: Wed, 1 Aug 2007 05:41:10 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Mike Galbraith <efault@gmx.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: CFS review
In-Reply-To: <1184389456.6632.13.camel@Homer.simpson.net>
Message-ID: <Pine.LNX.4.64.0708010439050.1817@scrub.home>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> 
 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> 
 <20070711211638.GE18767@one.firstfloor.org>  <20070711214649.GK14435@v2.random>
  <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0707130415520.1818@scrub.home>  <1184302024.6709.11.camel@Homer.simpson.net>
  <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811837-1827576381-1185939670=:1817"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811837-1827576381-1185939670=:1817
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi,

On Sat, 14 Jul 2007, Mike Galbraith wrote:

> > On Fri, 13 Jul 2007, Mike Galbraith wrote:
> > 
> > > > The new scheduler does _a_lot_ of heavy 64 bit calculations without any 
> > > > attempt to scale that down a little...
> > > 
> > > See prio_to_weight[], prio_to_wmult[] and sysctl_sched_stat_granularity.
> > > Perhaps more can be done, but "without any attempt..." isn't accurate.
> > 
> > Calculating these values at runtime would have been completely insane, the 
> > alternative would be a crummy approximation, so using a lookup table is 
> > actually a good thing. That's not the problem.
> 
> I meant see usage.

I more meant serious attempts. At this point I'm not that much interested 
in a few localized optimizations, what I'm interested in is how can this 
optimized at the design level (e.g. how can arch information be used to 
simplify things). So I spent quite a bit of time looking through cfs and 
experimenting with some ideas. I want to put the main focus on the 
performance aspect, but there are a few other issues as well.


But first something else (especially for Ingo): I tried to be very careful 
with any claims made in this mail, but this of course doesn't exclude the 
possibility of errors, in which case I'd appreciate any corrections. Any 
explanations done in this mail don't imply that anyone needs any such 
explanations, they're done to keep things in context, so that interested 
readers have a chance to follow even if they don't have the complete 
background information. Any suggestions made don't imply that they have to 
be implemented like this, there are more an incentive for further 
discussion and I'm always interested in better solutions.


A first indication that something may not be quite right is the increase
in code size:

2.6.22:
   text    data     bss     dec     hex filename
  10150      24    3344   13518    34ce kernel/sched.o

recent git:
   text    data     bss     dec     hex filename
  14724     228    2020   16972    424c kernel/sched.o

That's i386 without stats/debug. A lot of the new code is in regularly
executed regions and it's often not exactly trivial code as cfs added
lots of heavy 64bit calculations. With the increased text comes
increased runtime memory usage, e.g. task_struct increased so that only
5 of them instead 6 fit now into 8KB.

Since sched-design-CFS.txt doesn't really go into any serious detail, so
the EEVDF paper was more helpful and after playing with the ideas a
little I noticed that the whole idea of fair scheduling can be explained
somewhat simpler and I'm a little surprised not finding it mentioned
anywhere.
So a different view on this is that the runtime of a task is simply
normalized and the virtual time (or fair_clock) is the weighted average of
these normalized runtimes. The advantage of normalization is that it
makes things comparable, once the normalized time values are equal each
task got its fair share. It's more obvious in the EEVDF paper, cfs makes
it a bit more complicated, as it uses the virtual time to calculate the
eligible runtime, but it doesn't maintain a per process virtual time
(fair_key is not quite the same).

Here we get to the first problem, cfs is not overly accurate at
maintaining a precise balance. First there a lot of rounding errors due
to constant conversion between normalized and non-normalized values and
the higher the update frequency the bigger the error. The effect of
this can be seen by running:

	while (1)
		sched_yield();

and watching the sched_debug output and watch the underrun counter go 
crazy. cfs thus needs the limiting to keep this misbehaviour under
control. The problem here is that it's not that difficult to hit one of
the many limits, which may change the behaviour and makes cfs hard to
predict how it will behave under different situations.

The next issue is scheduler granularity, here I don't quite understand
why the actual running time has no influence at all, which makes it
difficult to predict how much cpu time a process will get at a time
(even the comments only refer to the vmstat output). What is basically
used instead is the normalized time since it was enqueued and
practically it's a bit more complicated, as fair_key is not entirely a
normalized time value. If the wait_runtime value is positive, higher
prioritized tasks are given even more priority than they already get
from their larger wait_runtime value. The problem here is that this
triggers underruns and lower priority tasks get even less time.

Another issue is the sleep bonus given to sleeping tasks. A problem here
is that this can be exploited, if a job is spread over a few threads,
they can get more time relativ to other tasks, e.g. in this example
there are three tasks that run only for about 1ms every 3ms, but they
get far more time than should have gotten fairly:

 4544 roman     20   0  1796  520  432 S 32.1  0.4   0:21.08 lt
 4545 roman     20   0  1796  344  256 R 32.1  0.3   0:21.07 lt
 4546 roman     20   0  1796  344  256 R 31.7  0.3   0:21.07 lt
 4547 roman     20   0  1532  272  216 R  3.3  0.2   0:01.94 l

The debug output for this is also interesting:

            task   PID        tree-key         delta       waiting  switches  prio        sum-exec        sum-wait       sum-sleep    wait-overrun   wait-underrun
------------------------------------------------------------------------------------------------------------------------------------------------------------------
              lt  4544  42958653977764      -2800118       2797765     11753   120     11449444657       201615584     23750292211            9600               0
              lt  4545  42958653767067      -3010815       2759284     11747   120     11442604925       202910051     23746575676            9613               0
               l  4547  42958653330276      -3447606       1332892     32333   120      1035284848       -47628857               0               0           14247

Practically this means a few interactive tasks can steal quite a lot of
time from other tasks, which might try to get some work done. This may
be fine in Desktop environments, but I'm not sure it can be that easily
generalized. This can make cfs quite unfair, if waiting outside the
runqueue has more advantages than waiting in the runqueue.

Finally there is still the issue with the nice levels, where I still
think the massive increase overcompensates for adequate scheduling
classes, e.g. to give audio apps a fixed amount of time instead of a
relative portion.

Overall while cfs has a number of good ideas, I don't think it was
quite ready for a stable release. Maybe it's possible to fix this until
the release, but I certainly would have prefered less time pressure.
It's not just the small inaccuracies, it's also the significantly
increased complexity. In this regard I find the claim that cfs "has no
heuristics whatsoever" interesting, for that to be true I would expect a
little more accuracy, but that wouldn't be a big problem, if cfs were a
really fast and compact scheduler and here it's quite hard to argue that
cfs has been improvement in this particular area. Anyway, before Ingo
starts accussing me now of "negativism", let's look at some
possibilities how this could be improved.


To reduce the inaccuracies it's better to avoid conversion between 
normalized and real time values, so the first example program pretty much 
shows just that and demonstrate the very core of a scheduler. It maintains 
per task normalized times and uses only that to make the scheduling 
decision (it doesn't even need an explicit wait_runtime value). The nice 
thing about this how consistently it gives out time shares - unless there 
is a higher priority task, that task will get the maximum share, which 
makes the scheduling behaviour quite a bit more predictable.

The second example program is more complete (e.g. it demonstrates
adding/removing tasks) but it's based on the same basic idea. First the
floating point values are converted to fixed point values. To maintain
accuracy one has to take overflows into account, cfs currently avoids
overflows by throwing away (possibly important) information, but that
adds checks all over the place instead of dealing with them within the
design, so I consider this overflow avoidance a failed strategy - it
doesn't make anything simpler and creates problems elsewhere. Of course
the example program has its own limits, but in this case I can define
them, so that within them the scheduler will work correctly. The most
important limits are:

max normalized task time delta = max inverse weight * max cpu share
max normalized average time delta = max active tasks * max inverse weight * cpu share base

The first limit is used for comparing individual task and the second one
is used for maintaining the average.  With these limits it's possible to
choose the appropriate data types that can hold these maximum values and
then I don't really have to worry about overflows and I know the
scheduler is accurate without the need for a lot of extra checks.

The second example also adds a normalized average, but contrary to
current cfs it's not central to the design. An average is not needed to
give every task its fair share, but it can be used to make better
scheduling decisions to control _when_ a task gets its share. In this
example I provided two possibilities where it's used to schedule new
tasks, the first divides time into slices and sets a new task to the
start of that slice, the second gives the task a full time share
relative to the current average, but approximating the average (by
looking just at the min/max time) should work as well.
The average here is not a weighted average, a weighted average is a
little more complex to maintain accurately and has issues regarding
overflows, so I'm using a simple average, which is sufficient especially
since it's not a primary part of the scheduler anymore.

BTW above unfairness of sleeping tasks can be easily avoided in this
model by simply making sure that normalized time never goes backward.

The accuracy of this model makes it possible to further optimize the
code (it's really a key element, that's why I'm stressing it so much,
OTOH it's rather difficult to further optimize current cfs without
risking to make it worse).
For example the regular updates aren't really necessary, they can also
be done when necessary (i.e. when scheduling, where an update is
necessary anyway for precise accounting), the next schedule time can be
easily precalculated instead. OTOH the regular updates allow for very
cheap incremental updates, especially if one already knows that
scheduler clock has only limited resolution (because it's based on
jiffies), it becomes possible to use mostly 32bit values.

I hope the code example helps to further improve scheduler, I'm quite
aware that it doesn't implement everything, but this just means some of
the cfs design decisions need more explanation. I'm not really that
much interested in scheduler, I only want a small and fast scheduler and
that's some areas where cfs is no real improvement right now. cfs
practically obliterated my efforts I put into the ntp code to keep the
regular updates both cheap and highly precise...

bye, Roman

---1463811837-1827576381-1185939670=:1817
Content-Type: TEXT/x-csrc; charset=US-ASCII; name=fs.c
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0708010541100.1817@scrub.home>
Content-Description: 
Content-Disposition: attachment; filename=fs.c

I2luY2x1ZGUgPHN0ZGlvLmg+DQoNCmludCB3ZWlnaHRbMTBdID0gew0KCTIw
LCAyMCwgMjAsIDUwLCAyMCwgMjAsIDIwDQp9Ow0KZG91YmxlIHRpbWVbMTBd
Ow0KZG91YmxlIG50aW1lWzEwXTsNCg0KI2RlZmluZSBNSU5fUwkJMQ0KI2Rl
ZmluZSBNQVhfUwkJMTANCg0KI2RlZmluZSBTTElDRSh4KQkoTUFYX1MgLyAo
ZG91YmxlKXdlaWdodFt4XSkNCiNkZWZpbmUgTUlOU0xJQ0UoeCkJKE1JTl9T
IC8gKGRvdWJsZSl3ZWlnaHRbeF0pDQoNCmludCBtYWluKHZvaWQpDQp7DQoJ
aW50IGksIGosIGwsIHc7DQoJZG91YmxlIHMsIHQsIG1pbiwgbWF4Ow0KDQoJ
Zm9yIChpID0gMDsgaSA8IDEwOyBpKyspDQoJCW50aW1lW2ldID0gdGltZVtp
XSA9IDA7DQoNCglqID0gMDsNCglsID0gMDsNCglzID0gMDsNCgl3aGlsZSAo
MSkgew0KCQlqID0gbCA/IDAgOiAxOw0KCQlmb3IgKGkgPSAwOyBpIDwgMTA7
IGkrKykgew0KCQkJaWYgKCF3ZWlnaHRbaV0gfHwgaSA9PSBsKQ0KCQkJCWNv
bnRpbnVlOw0KCQkJaWYgKG50aW1lW2ldICsgTUlOU0xJQ0UoaSkgPCBudGlt
ZVtqXSArIE1JTlNMSUNFKGopKQ0KCQkJCWogPSBpOw0KCQl9DQoJCWlmIChu
dGltZVtsXSA+PSBudGltZVtqXSArIFNMSUNFKGopIHx8DQoJCSAgICAobnRp
bWVbbF0gPj0gbnRpbWVbal0gJiYNCgkJICAgICBudGltZVtsXSA+PSBzICsg
U0xJQ0UobCkpKSB7DQoJCQlsID0gajsNCgkJCXMgPSBudGltZVtsXTsNCgkJ
fQ0KCQl0aW1lW2xdICs9IE1JTl9TOw0KCQludGltZVtsXSArPSBNSU5fUyAv
IChkb3VibGUpd2VpZ2h0W2xdOw0KDQoJCXByaW50ZigiJXUiLCBsKTsNCgkJ
Zm9yIChpID0gMCwgdyA9IDAsIHQgPSAwOyBpIDwgMTA7IGkrKykgew0KCQkJ
aWYgKCF3ZWlnaHRbaV0pDQoJCQkJY29udGludWU7DQoJCQl3ICs9IHdlaWdo
dFtpXTsNCgkJCXQgKz0gbnRpbWVbaV0gKiB3ZWlnaHRbaV07DQoJCQlwcmlu
dGYoIlx0JTN1LyV1OiU1Zy8lLTdnIiwgaSwgd2VpZ2h0W2ldLCB0aW1lW2ld
LCBudGltZVtpXSk7DQoJCX0NCgkJdCAvPSB3Ow0KCQltaW4gPSBtYXggPSB0
Ow0KCQlmb3IgKGkgPSAwOyBpIDwgMTA7IGkrKykgew0KCQkJaWYgKCF3ZWln
aHRbaV0pDQoJCQkJY29udGludWU7DQoJCQlpZiAobnRpbWVbaV0gPCBtaW4p
DQoJCQkJbWluID0gbnRpbWVbaV07DQoJCQlpZiAobnRpbWVbaV0gPiBtYXgp
DQoJCQkJbWF4ID0gbnRpbWVbaV07DQoJCX0NCgkJcHJpbnRmKCJcdHwgJWcg
KCVnKVxuIiwgdCwgbWF4IC0gbWluKTsNCgl9DQp9DQo=

---1463811837-1827576381-1185939670=:1817
Content-Type: TEXT/x-csrc; charset=US-ASCII; name=fs2.c
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0708010541101.1817@scrub.home>
Content-Description: 
Content-Disposition: attachment; filename=fs2.c

I2luY2x1ZGUgPHN0ZGlvLmg+DQojaW5jbHVkZSA8c3RkbGliLmg+DQoNCnN0
cnVjdCB0YXNrIHsNCgl1bnNpZ25lZCBpbnQgd2VpZ2h0LCB3ZWlnaHRfaW52
Ow0KCWludCBhY3RpdmU7DQoNCgl1bnNpZ25lZCBpbnQgdGltZSwgdGltZV9h
dmc7DQoJaW50IHRpbWVfbm9ybSwgYXZnX2ZyYWN0Ow0KfSB0YXNrWzEwXSAg
PSB7DQoJeyAud2VpZ2h0ID0gMTAgfSwNCgl7IC53ZWlnaHQgPSA0MCB9LA0K
CXsgLndlaWdodCA9IDgwIH0sDQp9Ow0KDQojZGVmaW5lIE1JTl9TCQkxMDAN
CiNkZWZpbmUgTUFYX1MJCTEwMDANCg0KI2RlZmluZSBTTElDRSh4KQkoTUFY
X1MgKiB0YXNrW3hdLndlaWdodF9pbnYpDQojZGVmaW5lIE1JTlNMSUNFKHgp
CShNSU5fUyAqIHRhc2tbeF0ud2VpZ2h0X2ludikNCg0KI2RlZmluZSBXRUlH
VEgwCQk0MA0KI2RlZmluZSBXRUlHVEgwX0lOVgkoKDEgPDwgMTYpIC8gV0VJ
R1RIMCkNCg0KdW5zaWduZWQgaW50IHRpbWVfYXZnLCB0aW1lX25vcm1fc3Vt
Ow0KaW50IGF2Z19mcmFjdCwgd2VpZ2h0X3N1bV9pbnY7DQoNCnN0YXRpYyB2
b2lkIG5vcm1hbGl6ZV9hdmcoaW50IGkpDQp7DQoJaWYgKCF3ZWlnaHRfc3Vt
X2ludikNCgkJcmV0dXJuOw0KCS8qIGFzc3VtZSB0aGUgY29tbW9uIGNhc2Ug
b2YgMC8xIGZpcnN0LCB0aGVuIGZhbGxiYWNrICovDQoJaWYgKHRhc2tbaV0u
YXZnX2ZyYWN0IDwgMCB8fCB0YXNrW2ldLmF2Z19mcmFjdCA+PSBXRUlHVEgw
X0lOViAqIE1BWF9TKSB7DQoJCXRhc2tbaV0udGltZV9hdmcrKzsNCgkJdGFz
a1tpXS5hdmdfZnJhY3QgLT0gV0VJR1RIMF9JTlYgKiBNQVhfUzsNCgkJaWYg
KHRhc2tbaV0uYXZnX2ZyYWN0IDwgMCB8fCB0YXNrW2ldLmF2Z19mcmFjdCA+
PSBXRUlHVEgwX0lOViAqIE1BWF9TKSB7DQoJCQl0YXNrW2ldLnRpbWVfYXZn
ICs9IHRhc2tbaV0uYXZnX2ZyYWN0IC8gKFdFSUdUSDBfSU5WICogTUFYX1Mp
Ow0KCQkJdGFza1tpXS5hdmdfZnJhY3QgJT0gV0VJR1RIMF9JTlYgKiBNQVhf
UzsNCgkJfQ0KCX0NCglpZiAoYXZnX2ZyYWN0IDwgMCB8fCBhdmdfZnJhY3Qg
Pj0gd2VpZ2h0X3N1bV9pbnYpIHsNCgkJdGltZV9hdmcrKzsNCgkJYXZnX2Zy
YWN0IC09IHdlaWdodF9zdW1faW52Ow0KCQlpZiAoYXZnX2ZyYWN0IDwgMCB8
fCBhdmdfZnJhY3QgPj0gd2VpZ2h0X3N1bV9pbnYpIHsNCgkJCXRpbWVfYXZn
ICs9IGF2Z19mcmFjdCAvIHdlaWdodF9zdW1faW52Ow0KCQkJYXZnX2ZyYWN0
ICU9IHdlaWdodF9zdW1faW52Ow0KCQl9DQoJfQ0KfQ0KDQppbnQgbWFpbih2
b2lkKQ0Kew0KCWludCBpLCBqLCBsLCB0YXNrX2NudDsNCgl1bnNpZ25lZCBp
bnQgczsNCgl1bnNpZ25lZCBpbnQgdGltZV9zdW0sIHRpbWVfc3VtMjsNCg0K
CXRhc2tfY250ID0gdGltZV9hdmcgPSAwOw0KCWZvciAoaSA9IDA7IGkgPCAx
MDsgaSsrKSB7DQoJCWlmICghdGFza1tpXS53ZWlnaHQpDQoJCQljb250aW51
ZTsNCgkJdGFza1tpXS5hY3RpdmUgPSAxOw0KCQl0YXNrX2NudCsrOw0KCQl0
YXNrW2ldLndlaWdodF9pbnYgPSAoMSA8PCAxNikgLyB0YXNrW2ldLndlaWdo
dDsNCgl9DQoJd2VpZ2h0X3N1bV9pbnYgPSB0YXNrX2NudCAqIFdFSUdUSDBf
SU5WICogTUFYX1M7DQoJcHJpbnRmKCJ3OiAldSwldVxuIiwgV0VJR1RIMF9J
TlYgKiBNQVhfUywgd2VpZ2h0X3N1bV9pbnYpOw0KDQoJdGltZV9ub3JtX3N1
bSA9IGF2Z19mcmFjdCA9IDA7DQoJbCA9IDA7DQoJcyA9IDA7DQoJd2hpbGUg
KDEpIHsNCgkJaiA9IC0xOw0KCQlmb3IgKGkgPSAwOyBpIDwgMTA7IGkrKykg
ew0KCQkJaWYgKGkgPT0gbCkNCgkJCQljb250aW51ZTsNCgkJCWlmICghdGFz
a1tpXS5hY3RpdmUgJiYgdGFza1tpXS53ZWlnaHQpIHsNCgkJCQlpZiAoIShy
YW5kKCkgJSAzMCkpIHsNCgkJCQkJbm9ybWFsaXplX2F2ZyhpKTsNCgkJCQkJ
dGFza1tpXS5hY3RpdmUgPSAxOw0KCQkJCQlpZiAoIXRhc2tfY250KQ0KCQkJ
CQkJZ290byBkb25lOw0KI2lmIDENCgkJCQkJaWYgKChpbnQpKHRhc2tbaV0u
dGltZV9hdmcgLSB0aW1lX2F2ZykgPCAwKSB7DQoJCQkJCQl0YXNrW2ldLnRp
bWVfbm9ybSAtPSAoaW50KSh0YXNrW2ldLnRpbWVfYXZnIC0gdGltZV9hdmcp
ICogV0VJR1RIMF9JTlYgKiBNQVhfUyArIHRhc2tbaV0uYXZnX2ZyYWN0Ow0K
CQkJCQkJdGFza1tpXS50aW1lX2F2ZyA9IHRpbWVfYXZnOw0KCQkJCQkJdGFz
a1tpXS5hdmdfZnJhY3QgPSAwOw0KCQkJCQl9DQojZWxzZQ0KCQkJCQl1bnNp
Z25lZCBpbnQgbmV3X3RpbWVfYXZnID0gdGltZV9hdmc7DQoJCQkJCWludCBu
ZXdfYXZnX2ZyYWN0ID0gYXZnX2ZyYWN0IC8gdGFza19jbnQgLSB0YXNrW2ld
LndlaWdodF9pbnYgKiBNQVhfUzsNCgkJCQkJd2hpbGUgKG5ld19hdmdfZnJh
Y3QgPCAwKSB7DQoJCQkJCQluZXdfdGltZV9hdmctLTsNCgkJCQkJCW5ld19h
dmdfZnJhY3QgKz0gV0VJR1RIMF9JTlYgKiBNQVhfUzsNCgkJCQkJfQ0KCQkJ
CQlpZiAoKGludCkodGFza1tpXS50aW1lX2F2ZyAtIG5ld190aW1lX2F2Zykg
PCAwIHx8DQoJCQkJCSAgICAoKGludCkodGFza1tpXS50aW1lX2F2ZyAtIG5l
d190aW1lX2F2ZykgPT0gMCAmJg0KCQkJCQkgICAgIHRhc2tbaV0uYXZnX2Zy
YWN0IDwgbmV3X2F2Z19mcmFjdCkpIHsNCgkJCQkJCXRhc2tbaV0udGltZV9u
b3JtICs9IChpbnQpKG5ld190aW1lX2F2ZyAtIHRhc2tbaV0udGltZV9hdmcp
ICogV0VJR1RIMF9JTlYgKiBNQVhfUyArDQoJCQkJCQkJbmV3X2F2Z19mcmFj
dCAtIHRhc2tbaV0uYXZnX2ZyYWN0Ow0KCQkJCQkJdGFza1tpXS50aW1lX2F2
ZyA9IG5ld190aW1lX2F2ZzsNCgkJCQkJCXRhc2tbaV0uYXZnX2ZyYWN0ID0g
bmV3X2F2Z19mcmFjdDsNCgkJCQkJfQ0KI2VuZGlmDQoJCQkJZG9uZToNCgkJ
CQkJdGFza19jbnQrKzsNCgkJCQkJd2VpZ2h0X3N1bV9pbnYgKz0gV0VJR1RI
MF9JTlYgKiBNQVhfUzsNCgkJCQkJYXZnX2ZyYWN0ICs9IChpbnQpKHRhc2tb
aV0udGltZV9hdmcgLSB0aW1lX2F2ZykgKiBXRUlHVEgwX0lOViAqIE1BWF9T
ICsgdGFza1tpXS5hdmdfZnJhY3Q7DQoJCQkJCXRpbWVfbm9ybV9zdW0gKz0g
dGFza1tpXS50aW1lX25vcm07DQoJCQkJfQ0KCQkJfQ0KCQkJaWYgKCF0YXNr
W2ldLmFjdGl2ZSkNCgkJCQljb250aW51ZTsNCgkJCWlmIChqIDwgMCB8fA0K
CQkJICAgIChpbnQpKHRhc2tbaV0udGltZV9ub3JtICsgTUlOU0xJQ0UoaSkg
LSAodGFza1tqXS50aW1lX25vcm0gKyBNSU5TTElDRShqKSkpIDwgMCkNCgkJ
CQlqID0gaTsNCgkJfQ0KDQoJCWlmICghdGFza1tsXS5hY3RpdmUpIHsNCgkJ
CWlmIChqIDwgMCkNCgkJCQljb250aW51ZTsNCgkJCWdvdG8gZG9fc3dpdGNo
Ow0KCQl9DQoNCgkJaWYgKCEocmFuZCgpICUgMTAwKSkgew0KCQkJdGFza1ts
XS5hY3RpdmUgPSAwOw0KCQkJdGFza19jbnQtLTsNCgkJCXdlaWdodF9zdW1f
aW52IC09IFdFSUdUSDBfSU5WICogTUFYX1M7DQoJCQlhdmdfZnJhY3QgLT0g
KGludCkodGFza1tsXS50aW1lX2F2ZyAtIHRpbWVfYXZnKSAqIFdFSUdUSDBf
SU5WICogTUFYX1MgKyB0YXNrW2xdLmF2Z19mcmFjdDsNCgkJCXRpbWVfbm9y
bV9zdW0gLT0gdGFza1tsXS50aW1lX25vcm07DQoJCQlpZiAoaiA8IDApDQoJ
CQkJY29udGludWU7DQoJCQlnb3RvIGRvX3N3aXRjaDsNCgkJfQ0KDQoJCWlm
IChqID49IDAgJiYNCgkJICAgICgoaW50KSh0YXNrW2xdLnRpbWVfbm9ybSAt
ICh0YXNrW2pdLnRpbWVfbm9ybSArIFNMSUNFKGopKSkgPj0gMCB8fA0KCQkg
ICAgICgoaW50KSh0YXNrW2xdLnRpbWVfbm9ybSAtIHRhc2tbal0udGltZV9u
b3JtKSA+PSAwICYmDQoJCSAgICAgIChpbnQpKHRhc2tbbF0udGltZV9ub3Jt
IC0gKHMgKyBTTElDRShsKSkpID49IDApKSkgew0KCQkJaW50IHByZXZfdGlt
ZV9hdmc7DQoJCWRvX3N3aXRjaDoNCgkJCXByZXZfdGltZV9hdmcgPSB0aW1l
X2F2ZzsNCgkJCW5vcm1hbGl6ZV9hdmcobCk7DQoJCQlpZiAocHJldl90aW1l
X2F2ZyA8IHRpbWVfYXZnKQ0KCQkJCXByaW50ZigiLVxuIik7DQoJCQlsID0g
ajsNCgkJCXMgPSB0YXNrW2xdLnRpbWVfbm9ybTsNCgkJfQ0KCQl0YXNrW2xd
LnRpbWUgKz0gTUlOX1M7DQoJCXRhc2tbbF0udGltZV9ub3JtICs9IE1JTlNM
SUNFKGwpOw0KCQl0YXNrW2xdLmF2Z19mcmFjdCArPSBNSU5TTElDRShsKTsN
CgkJdGltZV9ub3JtX3N1bSArPSBNSU5TTElDRShsKTsNCgkJYXZnX2ZyYWN0
ICs9IE1JTlNMSUNFKGwpOw0KDQoJCXByaW50ZigiJXUiLCBsKTsNCgkJdGlt
ZV9zdW0gPSB0aW1lX3N1bTIgPSAwOw0KCQlmb3IgKGkgPSAwOyBpIDwgMTA7
IGkrKykgew0KCQkJaWYgKCF0YXNrW2ldLmFjdGl2ZSkgew0KCQkJCWlmICh0
YXNrW2ldLndlaWdodCkNCgkJCQkJcHJpbnRmKCJcdCUzdS8ldTogLVx0Iiwg
aSwgdGFza1tpXS53ZWlnaHQpOw0KCQkJCWNvbnRpbnVlOw0KCQkJfQ0KCQkJ
dGltZV9zdW0gKz0gdGFza1tpXS50aW1lX25vcm07DQoJCQl0aW1lX3N1bTIg
Kz0gdGFza1tpXS50aW1lX2F2ZyAqIFdFSUdUSDBfSU5WICogTUFYX1MgKyB0
YXNrW2ldLmF2Z19mcmFjdDsNCgkJCXByaW50ZigiXHQlM3UvJXU6JTV1LyUt
N2cvJS03ZyIsIGksIHRhc2tbaV0ud2VpZ2h0LCB0YXNrW2ldLnRpbWUsDQoJ
CQkJKGRvdWJsZSl0YXNrW2ldLnRpbWVfbm9ybSAvICgxIDw8IDE2KSwNCgkJ
CQl0YXNrW2ldLnRpbWVfYXZnICsgKGRvdWJsZSl0YXNrW2ldLmF2Z19mcmFj
dCAvIChXRUlHVEgwX0lOViAqIE1BWF9TKSk7DQoJCX0NCgkJaWYgKHRpbWVf
c3VtICE9IHRpbWVfbm9ybV9zdW0pDQoJCQlhYm9ydCgpOw0KCQlpZiAodGlt
ZV9zdW0yICE9IHRpbWVfYXZnICogd2VpZ2h0X3N1bV9pbnYgKyBhdmdfZnJh
Y3QpDQoJCQlhYm9ydCgpOw0KCQlpZiAodGltZV9zdW0gIT0gdGltZV9zdW0y
KQ0KCQkJYWJvcnQoKTsNCgkJcHJpbnRmKCJcdHwgJWcvJWdcbiIsIChkb3Vi
bGUpdGltZV9ub3JtX3N1bSAvIHRhc2tfY250IC8gKDEgPDwgMTYpLA0KCQkJ
dGltZV9hdmcgKyAoZG91YmxlKShpbnQpYXZnX2ZyYWN0IC8gd2VpZ2h0X3N1
bV9pbnYpOw0KCX0NCn0NCg==

---1463811837-1827576381-1185939670=:1817--
