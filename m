Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbYIWTJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbYIWTJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 15:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbYIWTJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 15:09:26 -0400
Received: from smtp-out.google.com ([216.239.33.17]:30127 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbYIWTJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 15:09:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:references:x-gmailtapped-by;
	b=wS91O/kU56pvVtaCKqfoEcDMgTZSNIldtuQ7X52+upTQaxrMWUPa3xkKkghXRMRIb
	oEK0bvF9r65B8rz4C5faw==
Message-ID: <af8810200809231209w7428347neb88094e543a048f@mail.gmail.com>
Date: Tue, 23 Sep 2008 12:09:14 -0700
From: Pardo <pardo@google.com>
To: linux-kernel@vger.kernel.org, mbligh@google.com
Subject: Faster getcpu() and sched_getcpu()
Cc: briangrant@google.com, odo@google.com, nil@google.com, jyasskin@google.com
In-Reply-To: <af8810200809111648n55e05ac9g286fcd498690432f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_78772_1915574.1222196954930"
References: <af8810200809111648n55e05ac9g286fcd498690432f@mail.gmail.com>
X-GMailtapped-By: 172.24.198.93
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_78772_1915574.1222196954930
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

getcpu() returns a caller's current core number.  On 2.6.26 running on
x86_64, there are two VDSO implementations: store it in TSCP's AUX
register; or, if the processor does not support TSCP, store it in
GDT's limit.  Dean Gaudet and Nathan Laredo also suggest using IDT's
limit.  Call these GDT, TSCP, and SIDT.

The cost of reading the CPU number can be reduced significantly across
a variety of platforms.  Suggestions: eliminate per-call architecture
check, use SIDT to hold the CPU and node number, cache the result,
split the VDSO in to red-zone and no-red-zone areas, streamline cache
checks in getcpu() code; provide a specialized sched_getcpu().
Result: on various x86_64 platforms, reading the CPU number drops from
about 30-100 cycles to 4-21 cycles.

I do not yet have a patch.  I would like folks to (a) comment; and (b)
try the attached microbenchmark on various machines to see if there
are any machines where something is faster than SIDT.

TESTS AND DATA

I ran timing tests that "fake" the user-space instruction sequence for
various VDSO-based getcpu() and sched_getcpu() implementations.  I ran
the tests on seven kinds of Intel and AMD platforms.  Each sequence
was measured individually (rather than averaging N runs).  Best and
median costs of 1000 runs were recorded.  An empty sequence was also
measured and that cost subtracted from each of the other runs, so a
reported "20 cycles" is "20 cycles more than the empty sequence."

A first test is the "raw" cost of just the machine instructions to
read the special register.  SIDT holds the value offset by 0x1000 and
the machine instruction saves it to memory.  The SIDT cost reported
here is conservative in that it includes a load and subtract which are
sometimes eliminated in getcpu()/sched_getcpu().  Note machine E is
based on a P4-microarchitecture processor, which is typically hard to
measure accurately, hence some reported costs for E are as low as 0
cycles.

    --- BEST ---    -- MEDIAN --
    GDT TSCP SIDT   GDT TSCP SIDT
A   60   77   15    61   78   16
B   45  N/A    9    54  N/A   18
C   54  N/A    9    54  N/A   18
D   49  N/A   14    56  N/A   14
E   32  N/A    0    42  N/A   11
F   74  N/A   17    74  N/A   18
G   16   23   16    21   24   17

On all machines, SIDT is always fastest, often by 3x or more.  TSCP is
always slowest.



Current implementations (2.6.26/arch/x86/kernel/vsyscall_64.c and
2.6.26/arch/x86/vdso/vgetcpu.c) choose dynamically whether to use GDT
or TSCP, something like

if (global)
  raw = GDT();
else
  raw = TSCP();

A second test compares the cost of dispatch to GDT, dispatch to TSCP,
or using GDT, TSCP, or SIDT unconditionally.  This test mimics the
glibc/VDSO strcuture, where the benchmark calls an out-of-line "fake
glibc" routine that performs an indirect call to a "fake vdso"
routine.

    ---------- BEST ---------    --------- MEDIAN -------
    *GDT *TSCP  GDT TSCP SIDT    *GDT *TSCP GDT TSCP SIDT
A    67    86   65   83   31      68    87  68   85   31
B    72   N/A   72  N/A   18      81   N/A  81  N/A   27
C    72   N/A   77  N/A   18      81   N/A  81  N/A   27
D    77   N/A   77  N/A   21      77   N/A  77  N/A   28
E    63   N/A   53  N/A    0      64   N/A  63  N/A   11
F    99   N/A   98  N/A   17      99   N/A  98  N/A   21
G    26    29   20   28   19      28    32  27   28   22

In these tests, TSCP is still significantly slower and SIDT is still
significantly faster, despite function call and conditional overheads.
 Also, dispatch overhead is small.




A third test compares the cost of caching.  There are 4 variations:
never use a cache (like 2.6.26/arch/x86/vdso/vgetcpu.c), do use a
cache (like 2.6.26/arch/x86/kernel/vsyscall_64.c) but pass in NULL;
use a cache and take a miss, and use a cache and take a hit.  The
following are all SIDT implementations and measure the cost to read
and set the CPU number but not the node number.

    ------ BEST ------    ----- MEDIAN -----
    NONE NULL MISS HIT    NONE NULL MISS HIT
A    31   32   29   10     31   32   30   10
B    18   27   27    9     27   27   27   27
C    18   18   27   18     27   27   27   27
D    21   21   18   14     28   28   28   28
E     0    0    0    0     11   11   11   11
F    17   19   23   12     21   21   25   15
G    19   22   24   12     22   23   26   13

In these tests, HIT is usually faster in the best case, and is
sometimes faster and never slower in the median case.  The savings
from skipping the cache test is usually small.  So even in cases where
NULL is always passed, the penalty is usually small.



A fourth test compares two "fake" sched_getcpu() implementations.  The
generic version (similar to
glibc-2.7/sysdeps/unix/sysv/linux/x86_64/sched_getcpu.S) calls the
general VDSO getcpu().  The specialized version tail-calls a
specialized VDSO sched_getcpu() similar to getcpu() but faster because
various checks are eliminated.  The following reports times for the
cache-hit case.

    ------- BEST ------   ------ MEDIAN -----
    GENERAL SPECIALIZED   GENERAL SPECIALIZED
A     12       4            13      6
B     18      18            18     18
C     18      18            18     18
D     14      14            21     21
E      0       0            11     11
F     18      11            19     11
G     16       9            17      9

The specialized version is only faster on 3 of 7 machines, but is
roughly 2x faster in those cases.



The original getcpu() code always tests twice for the cache, and
writes it whether or not it changed.  Tests here use a slight rewrite
that re-tests and writes only on a cache miss:

  if (cache && (cache->blob[0] == (j = _jiffies))) {
    p = cache->blob[1];
  } else {
    p = ...;
    if (cache) {
      cache->blob[0] = j;
      cache->blob[1] = p;
    }
  }

It turns out this "streamlining" is of no benefit because GCC makes
this optimization anyway (but see below).


Code to measure and report raw GDT/TSCP/SIDT timings is attached.  I
have other test data and test code if it is useful.



ANALYSIS AND SUGGESTIONS

Caching is currently disabled for 2.6.26/arch/x86/vdso/vgetcpu.c.
getcpu()/sched_getcpu() performance is most important when they are
used very frequently, in which case the jiffy-based cache is
effective.  Conversely, when calls are infrequent, cache miss overhead
is small.  Recommendation: caching should be enabled (probably for all
architectures, not just x86-64).

Switching to SIDT everywhere looks promising for all machines measured
so far.  The SIDT instruction performs a memory store, which means the
VDSO needs to be split in to red-zone/no-red-zone areas to avoid frame
overhead.  See, e.g., http://lkml.org/lkml/2007/1/14/27 for details
and http://arctic.org/~dean/patches/linux-2.6.20-vgetcpu-sidt.patch
for an old 2.6.20 patch.  Recommendation: measure relative costs on
more systems to see if SIDT is ever a worse choice.  Code to measure
and report GDT/TSCP/SIDT timings is attached.

If GDT or TSCP turns out to be faster on some machines, the binding
could be done via the indirect pointer set once on startup and used by
glibc to call the VDSO entry, rather than a conditional in
getcpu()/sched_getcpu() run on every call.  This would increase code
size and might cause cache fragmentation, but would improve
prefetching and reduce branch predictor pressure.  Recommendation:
nothing now; should GDT or TSCP turn out to be faster, this might
deserve more study.

A specialized version of the VDSO code for sched_getcpu() is
substantially faster than calling getcpu().  It can be implemented
almost trivially by inlining getcpu()'s code in a second function.  It
adds about 75 bytes of x86-64 instructions to the VDSO code page.
Recommendation: probably useful for all architectures.

It turns out GCC is able to rewrite the existing code in to the
"streamlined" form that only updates the cache when it changes.  So
while a rewrite won't change the performance it might make the code
more obviously fast.  Recommendation: to keep people from looking at
this repeatedly, recode so it is "obviously" fast or add a comment
indicating no further benefit from a rewrite.

Comments?  More GDT/TSCP/SIDT performance numbers?

------=_Part_78772_1915574.1222196954930
Content-Type: text/x-csrc; name=simple.c
Content-Transfer-Encoding: base64
X-Attachment-Id: f_flgvvvfx0
Content-Disposition: attachment; filename=simple.c

I2luY2x1ZGUgPGFzbS14ODZfNjQvbXNyLmg+CiNpbmNsdWRlIDxzdGRpby5oPgojaW5jbHVkZSA8
c3RkbGliLmg+CgojZGVmaW5lIG5vaW5saW5lIF9fYXR0cmlidXRlX18oKF9fbm9pbmxpbmVfXykp
CgpzdGF0aWMgaW5saW5lIGludCBlbXB0eSgpIHsKICByZXR1cm4gMTsKfQoKc3RhdGljIGlubGlu
ZSBpbnQgZ2R0X2xpbWl0KCkgewogIC8qICJzZWdtZW50IiB2YWx1ZSBpcyBmcm9tIExpbnV4IDIu
Ni4yNi9pbmNsdWRlL2FzbS14ODYvc2VnbWVudC5oICovCiAgY29uc3QgaW50IHNlZ21lbnQgPSAo
MTUgKiA4ICsgMyk7CiAgaW50IGxpbWl0OwogIGFzbSB2b2xhdGlsZSgibHNsICUxLCUwIiA6ICI9
ciIgKGxpbWl0KSA6ICJyIiAoc2VnbWVudCkpOwogIHJldHVybiBsaW1pdDsKfQoKc3RhdGljIGlu
bGluZSBpbnQgaWR0X2xpbWl0KCkgewogIHN0cnVjdCB7CiAgICBjaGFyIHBhZFs2XTsgICAgICAg
ICAgICAgICAgICAgICAgICAvKiBBbGlnbiBhY2Nlc3Nlcy4gKi8KICAgIHVuc2lnbmVkIGludCBs
aW1pdDsgICAgICAgICAgICAgICAgIC8qIDE2YiAqLwogICAgdW5zaWduZWQgbG9uZyBsb25nIGFk
ZHJlc3M7ICAgICAgICAgLyogNjRiICovCiAgfSBpZHQ7CiAgYXNtIHZvbGF0aWxlKCJzaWR0ICUw
IiA6ICI9bSIoaWR0KSk7CiAgcmV0dXJuIGlkdC5saW1pdDsKfQoKc3RhdGljIGlubGluZSBpbnQg
dHNjcF9hdXgoKSB7CiAgaW50IGVheCwgZWR4LCBhdXg7CiAgYXNtIHZvbGF0aWxlKCIuYnl0ZSAw
eDBmLDB4MDEsMHhmOSIgOiAiPWEiIChlYXgpLCAiPWQiIChlZHgpLCAiPWMiIChhdXgpKTsKICBy
ZXR1cm4gYXV4Owp9CgpzdGF0aWMgaW5saW5lIGludCBjcHVpZF9lZHhfdmFsKHVuc2lnbmVkIGlu
dCBvcCkgewogIGludCBlYXgsIGVkeDsKCiAgYXNtKCJjcHVpZCIgOiAiPWEiIChlYXgpLCAiPWQi
IChlZHgpIDogIjAiIChvcCkgOiAiYngiLCAiY3giKTsKICByZXR1cm4gZWR4Owp9CgppbmxpbmUg
aW50IC8qYm9vbCovIGhhdmVfdHNjcCgpIHsKICByZXR1cm4gKGNwdWlkX2VkeF92YWwoMHg4MDAw
MDAwMSkgJiAoMSA8PCAyNykpICE9IDA7Cn0KCgp0eXBlZGVmIGxvbmcgbG9uZyB0c2M7Cgpub2lu
bGluZSB0c2Mgbm93KCkgewogIHVuc2lnbmVkIGludCBlYXhfbG8sIGVkeF9oaTsKICB0c2Mgbm93
OwogIGFzbSB2b2xhdGlsZSgicmR0c2MiIDogIj1hIiAoZWF4X2xvKSwgIj1kIiAoZWR4X2hpKSk7
CiAgbm93ID0gKCh0c2MpZWF4X2xvKSB8ICgodHNjKShlZHhfaGkpIDw8IDMyKTsKICByZXR1cm4g
bm93Owp9CgppbnQgdHNjX3NvcnRfcHJlZChjb25zdCB2b2lkICp2YSwgY29uc3Qgdm9pZCAqdmIp
IHsKICBjb25zdCB0c2MgKmEgPSAoY29uc3QgdHNjICopKHZhKTsKICBjb25zdCB0c2MgKmIgPSAo
Y29uc3QgdHNjICopKHZiKTsKICByZXR1cm4gKmEgLSAqYjsKfQoKdHlwZWRlZiBlbnVtIHdoaWNo
IHsKICBFTVBUWSwgICAgICAgICAgICAgICAgICAgICAvKiBNdXN0IGJlIGZpcnN0ICgwJ3RoKSB0
byBzZXQgYmFzZV9jb3N0LiAqLwogIEdEVF9MSU1JVCwKICBJRFRfTElNSVQsCiAgVFNDUF9BVVgs
Cn0gd2hpY2g7Cgp2b2xhdGlsZSBpbnQgZ19zaW5rOwoKc3RhdGljIGlubGluZSBpbnQvKmJvb2wq
LyBydW5fdGVzdCh0c2MgKmRlbHRhLCBpbnQgbiwgd2hpY2ggdGVzdCkgewogIGludCBpOwoKICBp
ZiAoKHRlc3QgPT0gVFNDUF9BVVgpICYmICFoYXZlX3RzY3AoKSkKICAgIHJldHVybiAwOwoKICBm
b3IgKGkgPSAwOyBpIDwgbjsgKytpKSB7CiAgICBpbnQgdmFsOyAgICAgICAgICAgICAgICAgICAg
ICAgIC8qIFdyaXR0ZW4gYmVmb3JlIHJlYWQuICBSZWFsbHkhKi8KICAgIHRzYyBzdG9wOwogICAg
dHNjIHN0YXJ0ID0gbm93KCk7CiAgICBhc20gdm9sYXRpbGUoIm5vcCIgOjo6ICJtZW1vcnkiKTsK
ICAgIHN3aXRjaCAodGVzdCkgewogICAgICBjYXNlIEVNUFRZOiAgICAgIHZhbCA9IGVtcHR5KCk7
ICAgICAgYnJlYWs7CiAgICAgIGNhc2UgR0RUX0xJTUlUOiAgdmFsID0gZ2R0X2xpbWl0KCk7ICBi
cmVhazsKICAgICAgY2FzZSBJRFRfTElNSVQ6ICB2YWwgPSBpZHRfbGltaXQoKTsgIGJyZWFrOwog
ICAgICBjYXNlIFRTQ1BfQVVYOiAgIHZhbCA9IHRzY3BfYXV4KCk7ICAgYnJlYWs7CiAgICB9CiAg
ICBhc20gdm9sYXRpbGUoIm5vcCIgOjo6ICJtZW1vcnkiKTsKICAgIHN0b3AgPSBub3coKTsKICAg
IGdfc2luayA9IHZhbDsKICAgICpkZWx0YSsrID0gc3RvcCAtIHN0YXJ0OwogIH0KICByZXR1cm4g
MTsKfQoKbm9pbmxpbmUgaW50Lypib29sKi8gcnVuX3Rlc3RfZW1wdHkodHNjICpkZWx0YSwgaW50
IG4pIHsKICByZXR1cm4gcnVuX3Rlc3QodHNjLCBuLCBFTVBUWSk7Cn0KCm5vaW5saW5lIGludC8q
Ym9vbCovIHJ1bl90ZXN0X2dkdF9saW1pdCh0c2MgKmRlbHRhLCBpbnQgbikgewogIHJldHVybiBy
dW5fdGVzdCh0c2MsIG4sIEdEVF9MSU1JVCk7Cn0KCm5vaW5saW5lIGludC8qYm9vbCovIHJ1bl90
ZXN0X2lkdF9saW1pdCh0c2MgKmRlbHRhLCBpbnQgbikgewogIHJldHVybiBydW5fdGVzdCh0c2Ms
IG4sIElEVF9MSU1JVCk7Cn0KCm5vaW5saW5lIGludC8qYm9vbCovIHJ1bl90ZXN0X3RzY3BfYXV4
KHRzYyAqZGVsdGEsIGludCBuKSB7CiAgcmV0dXJuIHJ1bl90ZXN0KHRzYywgbiwgVFNDUF9BVVgp
Owp9Cgp0eXBlZGVmIGludC8qYm9vbCovICgqZnVuY3B0cikodHNjICpkZWx0YSwgaW50IG4pOwoK
LyogT2JmdXNjYXRlIHBvaW50ZXJzIHNvIHZhcmlvdXMgcnVuX3Rlc3QqKCkgY2FzZXMgZG8gbm90
IGdldCBpbmxpbmVkLiAqLwpmdW5jcHRyIGZ1bmNbXSA9IHsKICBydW5fdGVzdF9lbXB0eSwKICBy
dW5fdGVzdF9nZHRfbGltaXQsCiAgcnVuX3Rlc3RfaWR0X2xpbWl0LAogIHJ1bl90ZXN0X3RzY3Bf
YXV4Cn07Cgpjb25zdCBjaGFyICpuYW1lc1tdID0geyAiRU1QVFkiLCAiR0RUX0xJTUlUIiwgIklE
VF9MSU1JVCIsICJUU0NQX0FVWCIgfTsKCmludCBtYWluIChpbnQgYXJnYywgY2hhciAqKmFyZ3Yp
IHsKICBpbnQgdDsKICBjb25zdCBpbnQgTiA9IDEwMDA7CiAgdHNjIGRlbHRhW05dOwogIHRzYyBi
YXNlX2Nvc3QgPSAwOwoKICAvKiBJbiBwcmluY2lwbGUgY2FuIGNoYW5nZSAnZnVuYycgc28gY29t
cGlsZXIgY2Fubm90IGRpc3BhdGNoICovCiAgcHJpbnRmKCJTdGFydGluZyB0ZXN0cy4uLlxuIik7
CgogIGZvciAodD0wOyB0PD1UU0NQX0FVWDsgKyt0KSB7CiAgICBpbnQgcmFuID0gKCpmdW5jW3Rd
KShkZWx0YSwgTik7CiAgICBjb25zdCBjaGFyICpuYW1lID0gbmFtZXNbdF07CgogICAgaWYgKCFy
YW4pIHsKICAgICAgcHJpbnRmKCJOb3QtcnVuOiAlc1xuIiwgbmFtZSk7CiAgICAgIGNvbnRpbnVl
OwogICAgfQoKICAgIHsKICAgICAgc3RhdGljIGludCBiaW5bXSA9IHsgNSwgMTAsIDIwLCA1MCB9
OwogICAgICBpbnQgaTsKICAgICAgcXNvcnQoZGVsdGEsIE4sIHNpemVvZih0c2MpLCB0c2Nfc29y
dF9wcmVkKTsKICAgICAgcHJpbnRmKCJSdW46ICVzXHR0b3RhbC10ZXN0cz0gJWRcdGJlc3RzOiAi
LCBuYW1lLCBOKTsKICAgICAgZm9yIChpID0gMDsgaSA8IDUgOyArK2kpCiAgICAgICAgcHJpbnRm
KCIgJTJsbGQiLCBkZWx0YVtpXSAtIGJhc2VfY29zdCk7CiAgICAgIHByaW50ZigiXHRtZWRpYW5z
OiIpOwogICAgICBmb3IgKGkgPSAwOyBpIDwgc2l6ZW9mKGJpbikvc2l6ZW9mKGJpblswXSk7ICsr
aSkKICAgICAgICBwcmludGYoIiAlMmQlJTogJTJsbGQiLCBiaW5baV0sIGRlbHRhW04gKiBiaW5b
aV0gLyAxMDBdIC0gYmFzZV9jb3N0KTsKICAgICAgcHJpbnRmKCJcbiIpOwogICAgfQoKICAgIGlm
ICh0ID09IEVNUFRZKQogICAgICBiYXNlX2Nvc3QgPSBkZWx0YVswXTsKICB9CiAgcmV0dXJuIDA7
Cn0K
------=_Part_78772_1915574.1222196954930
Content-Type: application/octet-stream; name=Makefile
Content-Transfer-Encoding: base64
X-Attachment-Id: f_flgvw2fq1
Content-Disposition: attachment; filename=Makefile

Q0MgPSBnY2MKQ0ZMQUdTID0gLVdhbGwgLU8zCgphbGw6CXNpbXBsZSBzaW1wbGUuZGlzCgpzaW1w
bGU6CXNpbXBsZS5jIE1ha2VmaWxlCgkkKENDKSAkKENGTEFHUykgLW8gc2ltcGxlIHNpbXBsZS5j
CgpzaW1wbGUuZGlzOglzaW1wbGUKCW9iamR1bXAgLS1kaXNhc3NlbWJsZSBzaW1wbGUgPiBzaW1w
bGUuZGlzCg==
------=_Part_78772_1915574.1222196954930--
