Return-Path: <linux-kernel-owner+w=401wt.eu-S1752324AbXCUE7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbXCUE7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 00:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbXCUE7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 00:59:19 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:33255 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbXCUE7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 00:59:18 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 20 Mar 2007 21:58:49 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: AIO, FIO and Threads ...
Message-ID: <Pine.LNX.4.64.0703202146570.28960@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1795850513-1155867408-1174453129=:28960"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1795850513-1155867408-1174453129=:28960
Content-Type: TEXT/PLAIN; charset=US-ASCII


I was looking at Jens FIO stuff, and I decided to cook a quick patch for 
FIO to support GUASI (Generic Userspace Asyncronous Syscall Interface):

http://www.xmailserver.org/guasi-lib.html

I then ran a few tests on my Dual Opteron 252 with SATA drives (sata_nv) 
and 8GB of RAM.
Mind that I'm not FIO expert, like at all, but I got some interesting 
results when comparing GUASI with libaio at 8/1000/10000 depths.
If I read those result correctly (Jens may help), GUASI output is more 
then double the libaio one.
Lots of context switches, yes. But the throughput looks like 2+ times.
Can someone try to repeat the measures and/or spot the error?
Or tell me which other tests to run?
This is kinda a suprise for me ...



PS: FIO patch to support GUASI is attached. You also need to fetch GUASI 
    and (configure && make install)



- Davide



>> fio --name=global --rw=randread --size=64m --ioengine=guasi --name=job1 --iodepth=8 --thread

job1: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=guasi, iodepth=8
Starting 1 thread
Jobs: 1: [r] [100.0% done] [  3135/     0 kb/s] [eta 00m:00s]
job1: (groupid=0, jobs=1): err= 0: pid=29298
  read : io=65,536KiB, bw=1,576KiB/s, iops=384, runt= 42557msec
    slat (msec): min=    0, max=    0, avg= 0.00, stdev= 0.00
    clat (msec): min=    0, max=  212, avg=20.26, stdev=18.83
    bw (KiB/s) : min= 1166, max= 3376, per=98.51%, avg=1552.50, stdev=317.42
  cpu          : usr=7.69%, sys=92.99%, ctx=97648
  IO depths    : 1=0.0%, 2=0.0%, 4=0.1%, 8=99.9%, 16=0.0%, 32=0.0%, >=64=0.0%
     lat (msec): 2=1.4%, 4=3.6%, 10=25.3%, 20=34.0%, 50=28.1%, 100=6.8%
     lat (msec): 250=0.8%, 500=0.0%, 750=0.0%, 1000=0.0%, >=2000=0.0%

Run status group 0 (all jobs):
   READ: io=65,536KiB, aggrb=1,576KiB/s, minb=1,576KiB/s, maxb=1,576KiB/s, mint=42557msec, maxt=42557msec

Disk stats (read/write):
  sda: ios=16376/98, merge=8/135, ticks=339481/2810, in_queue=342290, util=99.17%


>> fio --name=global --rw=randread --size=64m --ioengine=libaio --name=job1 --iodepth=8 --thread

job1: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=8
Starting 1 thread
Jobs: 1: [r] [95.9% done] [  2423/     0 kb/s] [eta 00m:03s]
job1: (groupid=0, jobs=1): err= 0: pid=29332
  read : io=65,536KiB, bw=929KiB/s, iops=226, runt= 72181msec
    slat (msec): min=    0, max=   98, avg=31.30, stdev=15.53
    clat (msec): min=    0, max=    0, avg= 0.00, stdev= 0.00
    bw (KiB/s) : min=  592, max= 2835, per=98.56%, avg=915.58, stdev=325.29
  cpu          : usr=0.02%, sys=0.34%, ctx=23023
  IO depths    : 1=22.2%, 2=22.2%, 4=44.4%, 8=11.1%, 16=0.0%, 32=0.0%, >=64=0.0%
     lat (msec): 2=100.0%, 4=0.0%, 10=0.0%, 20=0.0%, 50=0.0%, 100=0.0%
     lat (msec): 250=0.0%, 500=0.0%, 750=0.0%, 1000=0.0%, >=2000=0.0%

Run status group 0 (all jobs):
   READ: io=65,536KiB, aggrb=929KiB/s, minb=929KiB/s, maxb=929KiB/s, mint=72181msec, maxt=72181msec

Disk stats (read/write):
  sda: ios=16384/43, merge=0/42, ticks=71889/20573, in_queue=92461, util=99.57%


>> fio --name=global --rw=randread --size=64m --ioengine=guasi --name=job1 --iodepth=1000 --thread

job1: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=guasi, iodepth=1000
Starting 1 thread
Jobs: 1: [r] [93.9% done] [   815/     0 kb/s] [eta 00m:02s]
job1: (groupid=0, jobs=1): err= 0: pid=29343
  read : io=65,536KiB, bw=2,130KiB/s, iops=520, runt= 31500msec
    slat (msec): min=    0, max=   26, avg= 1.02, stdev= 4.19
    clat (msec): min=   12, max=28024, avg=1920.73, stdev=764.20
    bw (KiB/s) : min= 1139, max= 3376, per=95.21%, avg=2027.87, stdev=354.38
  cpu          : usr=7.35%, sys=93.77%, ctx=104637
  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.1%, 32=0.2%, >=64=99.6%
     lat (msec): 2=0.0%, 4=0.0%, 10=0.0%, 20=0.0%, 50=0.1%, 100=0.4%
     lat (msec): 250=1.2%, 500=1.0%, 750=0.8%, 1000=0.7%, >=2000=45.5%

Run status group 0 (all jobs):
   READ: io=65,536KiB, aggrb=2,130KiB/s, minb=2,130KiB/s, maxb=2,130KiB/s, mint=31500msec, maxt=31500msec

Disk stats (read/write):
  sda: ios=16267/31, merge=115/28, ticks=4019824/313471, in_queue=4333625, util=98.84%


>> fio --name=global --rw=randread --size=64m --ioengine=libaio --name=job1 --iodepth=1000 --thread

job1: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=1000
Starting 1 thread
Jobs: 1: [r] [98.6% done] [  4083/     0 kb/s] [eta 00m:01s]]
job1: (groupid=0, jobs=1): err= 0: pid=30346
  read : io=65,536KiB, bw=920KiB/s, iops=224, runt= 72925msec
    slat (msec): min=    0, max= 5539, avg=4431.27, stdev=1268.03
    clat (msec): min=    0, max=    0, avg= 0.00, stdev= 0.00
    bw (KiB/s) : min=    0, max= 2361, per=103.56%, avg=952.75, stdev=499.54
  cpu          : usr=0.02%, sys=0.39%, ctx=23089
  IO depths    : 1=0.2%, 2=0.2%, 4=0.4%, 8=0.8%, 16=1.7%, 32=3.3%, >=64=93.4%
     lat (msec): 2=100.0%, 4=0.0%, 10=0.0%, 20=0.0%, 50=0.0%, 100=0.0%
     lat (msec): 250=0.0%, 500=0.0%, 750=0.0%, 1000=0.0%, >=2000=0.0%

Run status group 0 (all jobs):
   READ: io=65,536KiB, aggrb=920KiB/s, minb=920KiB/s, maxb=920KiB/s, mint=72925msec, maxt=72925msec

Disk stats (read/write):
  sda: ios=16384/70, merge=0/54, ticks=72644/31038, in_queue=103682, util=99.61%


>> fio --name=global --rw=randread --size=64m --ioengine=guasi --name=job1 --iodepth=10000 --thread

job1: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=guasi, iodepth=10000
Starting 1 thread
Jobs: 1: [r] [100.0% done] [ 40752/     0 kb/s] [eta 00m:00s]
job1: (groupid=0, jobs=1): err= 0: pid=32203
  read : io=65,536KiB, bw=1,965KiB/s, iops=479, runt= 34148msec
    slat (msec): min=    0, max=  323, avg=124.06, stdev=112.39
    clat (msec): min=    0, max=33982, avg=20686.86, stdev=13689.22
    bw (KiB/s) : min=    1, max= 2187, per=94.75%, avg=1861.75, stdev=392.89
  cpu          : usr=0.35%, sys=2.42%, ctx=166667
  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.1%, 32=0.2%, >=64=99.6%
     lat (msec): 2=0.0%, 4=0.0%, 10=0.0%, 20=0.1%, 50=0.5%, 100=1.5%
     lat (msec): 250=5.0%, 500=5.6%, 750=1.8%, 1000=0.8%, >=2000=2.3%

Run status group 0 (all jobs):
   READ: io=65,536KiB, aggrb=1,965KiB/s, minb=1,965KiB/s, maxb=1,965KiB/s, mint=34148msec, maxt=34148msec

Disk stats (read/write):
  sda: ios=16064/122, merge=319/73, ticks=4350268/172548, in_queue=4521657, util=98.95%



>> fio --name=global --rw=randread --size=64m --ioengine=libaio --name=job1 --iodepth=10000 --thread

job1: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=10000
Starting 1 thread
Jobs: 1: [r] [61.3% done] [     0/     0 kb/s] [eta 00m:46s]]
job1: (groupid=0, jobs=1): err= 0: pid=9791
  read : io=65,536KiB, bw=917KiB/s, iops=224, runt= 73118msec
    slat (msec): min=    1, max=52656, avg=40082.23, stdev=15703.83
    clat (msec): min=    0, max=    3, avg= 2.61, stdev= 0.49
    bw (KiB/s) : min=    0, max= 2002, per=109.16%, avg=1001.00, stdev=1415.63
  cpu          : usr=0.02%, sys=0.40%, ctx=23095
  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.1%, 16=0.2%, 32=0.4%, >=64=99.2%
     lat (msec): 2=0.0%, 4=100.0%, 10=0.0%, 20=0.0%, 50=0.0%, 100=0.0%
     lat (msec): 250=0.0%, 500=0.0%, 750=0.0%, 1000=0.0%, >=2000=0.0%

Run status group 0 (all jobs):
   READ: io=65,536KiB, aggrb=917KiB/s, minb=917KiB/s, maxb=917KiB/s, mint=73118msec, maxt=73118msec

Disk stats (read/write):
  sda: ios=16384/82, merge=0/86, ticks=72720/36477, in_queue=109197, util=99.44%


--1795850513-1155867408-1174453129=:28960
Content-Type: TEXT/x-diff; charset=US-ASCII; name=fio-guasi-0.2.diff
Content-Transfer-Encoding: BASE64
Content-Description: 
Content-Disposition: attachment; filename=fio-guasi-0.2.diff

ZGlmZiAtTnJ1IGZpby0xLjE0L2VuZ2luZXMvZ3Vhc2kuYyBmaW8tMS4xNC5n
dWFzaS9lbmdpbmVzL2d1YXNpLmMNCi0tLSBmaW8tMS4xNC9lbmdpbmVzL2d1
YXNpLmMJMTk2OS0xMi0zMSAxNjowMDowMC4wMDAwMDAwMDAgLTA4MDANCisr
KyBmaW8tMS4xNC5ndWFzaS9lbmdpbmVzL2d1YXNpLmMJMjAwNy0wMy0yMCAy
MToyNjo1OC4wMDAwMDAwMDAgLTA3MDANCkBAIC0wLDAgKzEsMjU2IEBADQor
LyoNCisgKiBndWFzaSBlbmdpbmUNCisgKg0KKyAqIElPIGVuZ2luZSB1c2lu
ZyB0aGUgR1VBU0kgbGlicmFyeS4NCisgKg0KKyAqLw0KKyNpbmNsdWRlIDxz
dGRpby5oPg0KKyNpbmNsdWRlIDxzdGRsaWIuaD4NCisjaW5jbHVkZSA8dW5p
c3RkLmg+DQorI2luY2x1ZGUgPGVycm5vLmg+DQorI2luY2x1ZGUgPGFzc2Vy
dC5oPg0KKw0KKyNpbmNsdWRlICIuLi9maW8uaCINCisjaW5jbHVkZSAiLi4v
b3MuaCINCisNCisjaWZkZWYgRklPX0hBVkVfR1VBU0kNCisNCisjZGVmaW5l
IEdGSU9fTUlOX1RIUkVBRFMgMzINCisNCisjaW5jbHVkZSA8Z3Vhc2kuaD4N
CisjaW5jbHVkZSA8Z3Vhc2lfc3lzY2FsbHMuaD4NCisNCisjaWZkZWYgR0ZJ
T19ERUJVRw0KKyNkZWZpbmUgR0RCR19QUklOVChhKSBwcmludGYgYQ0KKyNl
bHNlDQorI2RlZmluZSBHREJHX1BSSU5UKGEpICh2b2lkKSAwDQorI2VuZGlm
DQorDQorI2RlZmluZSBTVEZVX0dDQyhhKSBhID0gYQ0KKw0KKw0KK3N0cnVj
dCBndWFzaV9kYXRhIHsNCisJZ3Vhc2lfdCBoY3R4Ow0KKwlpbnQgbWF4X3Jl
cXM7DQorCWd1YXNpX3JlcV90ICpyZXFzOw0KKwlzdHJ1Y3QgaW9fdSAqKmlv
X3VzOw0KKwlpbnQgcmVxc19ucjsNCit9Ow0KKw0KK3N0YXRpYyBpbnQgZmlv
X2d1YXNpX3ByZXAoc3RydWN0IHRocmVhZF9kYXRhIGZpb191bnVzZWQgKnRk
LCBzdHJ1Y3QgaW9fdSAqaW9fdSkNCit7DQorCVNURlVfR0NDKGlvX3UpOw0K
Kw0KKwlHREJHX1BSSU5UKCgiZmlvX2d1YXNpX3ByZXAoJXApXG4iLCBpb191
KSk7DQorDQorCXJldHVybiAwOw0KK30NCisNCitzdGF0aWMgc3RydWN0IGlv
X3UgKmZpb19ndWFzaV9ldmVudChzdHJ1Y3QgdGhyZWFkX2RhdGEgKnRkLCBp
bnQgZXZlbnQpDQorew0KKwlzdHJ1Y3QgZ3Vhc2lfZGF0YSAqbGQgPSB0ZC0+
aW9fb3BzLT5kYXRhOw0KKwlzdHJ1Y3QgaW9fdSAqaW9fdTsNCisJc3RydWN0
IGd1YXNpX3JlcWluZm8gcmluZjsNCisNCisJR0RCR19QUklOVCgoImZpb19n
dWFzaV9ldmVudCglZClcbiIsIGV2ZW50KSk7DQorCWlmIChndWFzaV9yZXFf
aW5mbyhsZC0+cmVxc1tldmVudF0sICZyaW5mKSA8IDApIHsNCisJCWZwcmlu
dGYoc3RkZXJyLCAiZ3Vhc2lfcmVxX2luZm8oJWQpIEZBSUxFRCFcbiIsIGV2
ZW50KTsNCisJCXJldHVybiBOVUxMOw0KKwl9DQorCWlvX3UgPSByaW5mLmFz
aWQ7DQorCUdEQkdfUFJJTlQoKCJmaW9fZ3Vhc2lfZXZlbnQoJWQpIC0+ICVw
XG4iLCBldmVudCwgaW9fdSkpOw0KKw0KKwlpZiAoaW9fdS0+ZGRpciA9PSBE
RElSX1JFQUQgfHwNCisJICAgIGlvX3UtPmRkaXIgPT0gRERJUl9XUklURSkg
ew0KKwkJaWYgKHJpbmYucmVzdWx0ICE9IChsb25nKSBpb191LT54ZmVyX2J1
Zmxlbikgew0KKwkJCWlmIChyaW5mLnJlc3VsdCA8IDApDQorCQkJCWlvX3Ut
PmVycm9yID0gcmluZi5lcnJvcjsNCisJCQllbHNlDQorCQkJCWlvX3UtPnJl
c2lkID0gaW9fdS0+eGZlcl9idWZsZW4gLSByaW5mLnJlc3VsdDsNCisJCX0g
ZWxzZQ0KKwkJCWlvX3UtPmVycm9yID0gMDsNCisJfSBlbHNlDQorCQlpb191
LT5lcnJvciA9IHJpbmYucmVzdWx0Ow0KKw0KKwlyZXR1cm4gaW9fdTsNCit9
DQorDQorc3RhdGljIGludCBmaW9fZ3Vhc2lfZ2V0ZXZlbnRzKHN0cnVjdCB0
aHJlYWRfZGF0YSAqdGQsIGludCBtaW4sIGludCBtYXgsDQorCQkJICAgICAg
IHN0cnVjdCB0aW1lc3BlYyAqdCkNCit7DQorCXN0cnVjdCBndWFzaV9kYXRh
ICpsZCA9IHRkLT5pb19vcHMtPmRhdGE7DQorCWludCBuID0gMCwgcjsNCisJ
bG9uZyB0aW1lbyA9IC0xOw0KKw0KKwlHREJHX1BSSU5UKCgiZmlvX2d1YXNp
X2dldGV2ZW50cyglZCwgJWQpXG4iLCBtaW4sIG1heCkpOw0KKwlpZiAobWlu
ID4gbGQtPm1heF9yZXFzKQ0KKwkJbWluID0gbGQtPm1heF9yZXFzOw0KKwlp
ZiAobWF4ID4gbGQtPm1heF9yZXFzKQ0KKwkJbWF4ID0gbGQtPm1heF9yZXFz
Ow0KKwlpZiAodCkNCisJCXRpbWVvID0gdC0+dHZfc2VjICogMTAwMEwgKyB0
LT50dl9uc2VjIC8gMTAwMDAwMEw7DQorCWRvIHsNCisJCXIgPSBndWFzaV9m
ZXRjaChsZC0+aGN0eCwgbGQtPnJlcXMgKyBuLCBtYXggLSBuLCB0aW1lbyk7
DQorCQlpZiAociA8IDApDQorCQkJYnJlYWs7DQorCQluICs9IHI7DQorCQlp
ZiAobiA+PSBtaW4pDQorCQkJYnJlYWs7DQorCX0gd2hpbGUgKDEpOw0KKwlH
REJHX1BSSU5UKCgiZmlvX2d1YXNpX2dldGV2ZW50cygpIC0+ICVkXG4iLCBu
KSk7DQorDQorCXJldHVybiBuOw0KK30NCisNCitzdGF0aWMgaW50IGZpb19n
dWFzaV9xdWV1ZShzdHJ1Y3QgdGhyZWFkX2RhdGEgKnRkLCBzdHJ1Y3QgaW9f
dSAqaW9fdSkNCit7DQorCXN0cnVjdCBndWFzaV9kYXRhICpsZCA9IHRkLT5p
b19vcHMtPmRhdGE7DQorDQorCUdEQkdfUFJJTlQoKCJmaW9fZ3Vhc2lfcXVl
dWUoJXApXG4iLCBpb191KSk7DQorCWlmIChsZC0+cmVxc19uciA9PSAoaW50
KSB0ZC0+aW9kZXB0aCkNCisJCXJldHVybiBGSU9fUV9CVVNZOw0KKw0KKwls
ZC0+aW9fdXNbbGQtPnJlcXNfbnJdID0gaW9fdTsNCisJbGQtPnJlcXNfbnIr
KzsNCisJcmV0dXJuIEZJT19RX1FVRVVFRDsNCit9DQorDQorc3RhdGljIHZv
aWQgZmlvX2d1YXNpX3F1ZXVlZChzdHJ1Y3QgdGhyZWFkX2RhdGEgKnRkLCBz
dHJ1Y3QgaW9fdSAqKmlvX3VzLA0KKwkJCSAgICAgdW5zaWduZWQgaW50IG5y
KQ0KK3sNCisJc3RydWN0IHRpbWV2YWwgbm93Ow0KKwlzdHJ1Y3QgaW9fdSAq
aW9fdSA9IGlvX3VzW25yXTsNCisNCisJZmlvX2dldHRpbWUoJm5vdywgTlVM
TCk7DQorCW1lbWNweSgmaW9fdS0+aXNzdWVfdGltZSwgJm5vdywgc2l6ZW9m
KG5vdykpOw0KKwlpb191X3F1ZXVlZCh0ZCwgaW9fdSk7DQorfQ0KKw0KK3N0
YXRpYyBpbnQgZmlvX2d1YXNpX2NvbW1pdChzdHJ1Y3QgdGhyZWFkX2RhdGEg
KnRkKQ0KK3sNCisJc3RydWN0IGd1YXNpX2RhdGEgKmxkID0gdGQtPmlvX29w
cy0+ZGF0YTsNCisJaW50IGk7DQorCXN0cnVjdCBpb191ICppb191Ow0KKwlz
dHJ1Y3QgZmlvX2ZpbGUgKmY7DQorDQorCUdEQkdfUFJJTlQoKCJmaW9fZ3Vh
c2lfY29tbWl0KClcbiIpKTsNCisJZm9yIChpID0gMDsgaSA8IGxkLT5yZXFz
X25yOyBpKyspIHsNCisJCWlvX3UgPSBsZC0+aW9fdXNbaV07DQorCQlmID0g
aW9fdS0+ZmlsZTsNCisJCWlvX3UtPmdyZXEgPSBOVUxMOw0KKwkJaWYgKGlv
X3UtPmRkaXIgPT0gRERJUl9SRUFEKQ0KKwkJCWlvX3UtPmdyZXEgPSBndWFz
aV9fcHJlYWQobGQtPmhjdHgsIGxkLCBpb191LCAwLA0KKwkJCQkJCSAgZi0+
ZmQsIGlvX3UtPnhmZXJfYnVmLCBpb191LT54ZmVyX2J1ZmxlbiwNCisJCQkJ
CQkgIGlvX3UtPm9mZnNldCk7DQorCQllbHNlIGlmIChpb191LT5kZGlyID09
IERESVJfV1JJVEUpDQorCQkJaW9fdS0+Z3JlcSA9IGd1YXNpX19wd3JpdGUo
bGQtPmhjdHgsIGxkLCBpb191LCAwLA0KKwkJCQkJCSAgIGYtPmZkLCBpb191
LT54ZmVyX2J1ZiwgaW9fdS0+eGZlcl9idWZsZW4sDQorCQkJCQkJICAgaW9f
dS0+b2Zmc2V0KTsNCisJCWVsc2UgaWYgKGlvX3UtPmRkaXIgPT0gRERJUl9T
WU5DKQ0KKwkJCWlvX3UtPmdyZXEgPSBndWFzaV9fZnN5bmMobGQtPmhjdHgs
IGxkLCBpb191LCAwLCBmLT5mZCk7DQorCQllbHNlIHsNCisJCQlmcHJpbnRm
KHN0ZGVyciwgImZpb19ndWFzaV9jb21taXQoKSBGQUlMRUQ6ICVkXG4iLCBp
b191LT5kZGlyKTsNCisJCX0NCisJCWlmIChpb191LT5ncmVxICE9IE5VTEwp
DQorCQkJZmlvX2d1YXNpX3F1ZXVlZCh0ZCwgbGQtPmlvX3VzLCBpKTsNCisJ
fQ0KKwlsZC0+cmVxc19uciA9IDA7DQorCUdEQkdfUFJJTlQoKCJmaW9fZ3Vh
c2lfY29tbWl0KCkgLT4gJWRcbiIsIGkpKTsNCisNCisJcmV0dXJuIDA7DQor
fQ0KKw0KK3N0YXRpYyBpbnQgZmlvX2d1YXNpX2NhbmNlbChzdHJ1Y3QgdGhy
ZWFkX2RhdGEgKnRkLCBzdHJ1Y3QgaW9fdSAqaW9fdSkNCit7DQorCXN0cnVj
dCBndWFzaV9kYXRhICpsZCA9IHRkLT5pb19vcHMtPmRhdGE7DQorDQorCVNU
RlVfR0NDKGxkKTsNCisJR0RCR19QUklOVCgoImZpb19ndWFzaV9jYW5jZWwo
JXApXG4iLCBpb191KSk7DQorDQorCXJldHVybiBndWFzaV9yZXFfY2FuY2Vs
KGlvX3UtPmdyZXEpOw0KK30NCisNCitzdGF0aWMgdm9pZCBmaW9fZ3Vhc2lf
Y2xlYW51cChzdHJ1Y3QgdGhyZWFkX2RhdGEgKnRkKQ0KK3sNCisJc3RydWN0
IGd1YXNpX2RhdGEgKmxkID0gdGQtPmlvX29wcy0+ZGF0YTsNCisNCisJaWYg
KGxkKSB7DQorCQlndWFzaV9mcmVlKGxkLT5oY3R4KTsNCisJCWZyZWUobGQt
PnJlcXMpOw0KKwkJZnJlZShsZC0+aW9fdXMpOw0KKwkJZnJlZShsZCk7DQor
CQl0ZC0+aW9fb3BzLT5kYXRhID0gTlVMTDsNCisJfQ0KK30NCisNCitzdGF0
aWMgaW50IGZpb19ndWFzaV9pbml0KHN0cnVjdCB0aHJlYWRfZGF0YSAqdGQp
DQorew0KKwlpbnQgbWF4dGhyOw0KKwlzdHJ1Y3QgZ3Vhc2lfZGF0YSAqbGQg
PSBtYWxsb2Moc2l6ZW9mKCpsZCkpOw0KKw0KKwlHREJHX1BSSU5UKCgiZmlv
X2d1YXNpX2luaXQoKTogZGVwdGg9JWRcbiIsIHRkLT5pb2RlcHRoKSk7DQor
CW1lbXNldChsZCwgMCwgc2l6ZW9mKCpsZCkpOw0KKwltYXh0aHIgPSB0ZC0+
aW9kZXB0aCA+IEdGSU9fTUlOX1RIUkVBRFMgPyB0ZC0+aW9kZXB0aDogR0ZJ
T19NSU5fVEhSRUFEUzsNCisJaWYgKChsZC0+aGN0eCA9IGd1YXNpX2NyZWF0
ZShHRklPX01JTl9USFJFQURTLCBtYXh0aHIsIDEpKSA9PSBOVUxMKSB7DQor
CQl0ZF92ZXJyb3IodGQsIGVycm5vLCAiZ3Vhc2lfY3JlYXRlIik7DQorCQlm
cmVlKGxkKTsNCisJCXJldHVybiAxOw0KKwl9DQorCWxkLT5tYXhfcmVxcyA9
IHRkLT5pb2RlcHRoOw0KKwlsZC0+cmVxcyA9IG1hbGxvYyhsZC0+bWF4X3Jl
cXMgKiBzaXplb2YoZ3Vhc2lfcmVxX3QpKTsNCisJbGQtPmlvX3VzID0gbWFs
bG9jKGxkLT5tYXhfcmVxcyAqIHNpemVvZihzdHJ1Y3QgaW9fdSAqKSk7DQor
CW1lbXNldChsZC0+aW9fdXMsIDAsIGxkLT5tYXhfcmVxcyAqIHNpemVvZihz
dHJ1Y3QgaW9fdSAqKSk7DQorCWxkLT5yZXFzX25yID0gMDsNCisNCisJdGQt
PmlvX29wcy0+ZGF0YSA9IGxkOw0KKwlHREJHX1BSSU5UKCgiZmlvX2d1YXNp
X2luaXQoKTogZGVwdGg9JWQgLT4gJXBcbiIsIHRkLT5pb2RlcHRoLCBsZCkp
Ow0KKw0KKwlyZXR1cm4gMDsNCit9DQorDQorc3RhdGljIHN0cnVjdCBpb2Vu
Z2luZV9vcHMgaW9lbmdpbmUgPSB7DQorCS5uYW1lCQk9ICJndWFzaSIsDQor
CQkudmVyc2lvbgk9IEZJT19JT09QU19WRVJTSU9OLA0KKwkJLmluaXQJCT0g
ZmlvX2d1YXNpX2luaXQsDQorCQkucHJlcAkJPSBmaW9fZ3Vhc2lfcHJlcCwN
CisJCS5xdWV1ZQkJPSBmaW9fZ3Vhc2lfcXVldWUsDQorCQkuY29tbWl0CQk9
IGZpb19ndWFzaV9jb21taXQsDQorCQkuY2FuY2VsCQk9IGZpb19ndWFzaV9j
YW5jZWwsDQorCQkuZ2V0ZXZlbnRzCT0gZmlvX2d1YXNpX2dldGV2ZW50cywN
CisJCS5ldmVudAkJPSBmaW9fZ3Vhc2lfZXZlbnQsDQorCQkuY2xlYW51cAk9
IGZpb19ndWFzaV9jbGVhbnVwLA0KKwkJLm9wZW5fZmlsZQk9IGdlbmVyaWNf
b3Blbl9maWxlLA0KKwkJLmNsb3NlX2ZpbGUJPSBnZW5lcmljX2Nsb3NlX2Zp
bGUsDQorfTsNCisNCisjZWxzZSAvKiBGSU9fSEFWRV9HVUFTSSAqLw0KKw0K
Ky8qDQorICogV2hlbiB3ZSBoYXZlIGEgcHJvcGVyIGNvbmZpZ3VyZSBzeXN0
ZW0gaW4gcGxhY2UsIHdlIHNpbXBseSB3b250IGJ1aWxkDQorICogYW5kIGlu
c3RhbGwgdGhpcyBpbyBlbmdpbmUuIEZvciBub3cgaW5zdGFsbCBhIGNyaXBw
bGVkIHZlcnNpb24gdGhhdA0KKyAqIGp1c3QgY29tcGxhaW5zIGFuZCBmYWls
cyB0byBsb2FkLg0KKyAqLw0KK3N0YXRpYyBpbnQgZmlvX2d1YXNpX2luaXQo
c3RydWN0IHRocmVhZF9kYXRhIGZpb191bnVzZWQgKnRkKQ0KK3sNCisJZnBy
aW50ZihzdGRlcnIsICJmaW86IGd1YXNpIG5vdCBhdmFpbGFibGVcbiIpOw0K
KwlyZXR1cm4gMTsNCit9DQorDQorc3RhdGljIHN0cnVjdCBpb2VuZ2luZV9v
cHMgaW9lbmdpbmUgPSB7DQorCS5uYW1lCQk9ICJndWFzaSIsDQorCQkudmVy
c2lvbgk9IEZJT19JT09QU19WRVJTSU9OLA0KKwkJLmluaXQJCT0gZmlvX2d1
YXNpX2luaXQsDQorfTsNCisNCisjZW5kaWYNCisNCitzdGF0aWMgdm9pZCBm
aW9faW5pdCBmaW9fZ3Vhc2lfcmVnaXN0ZXIodm9pZCkNCit7DQorCXJlZ2lz
dGVyX2lvZW5naW5lKCZpb2VuZ2luZSk7DQorfQ0KKw0KK3N0YXRpYyB2b2lk
IGZpb19leGl0IGZpb19ndWFzaV91bnJlZ2lzdGVyKHZvaWQpDQorew0KKwl1
bnJlZ2lzdGVyX2lvZW5naW5lKCZpb2VuZ2luZSk7DQorfQ0KKw0KZGlmZiAt
TnJ1IGZpby0xLjE0L2Zpby5oIGZpby0xLjE0Lmd1YXNpL2Zpby5oDQotLS0g
ZmlvLTEuMTQvZmlvLmgJMjAwNy0wMy0xNCAwNjoyNDo0Mi4wMDAwMDAwMDAg
LTA3MDANCisrKyBmaW8tMS4xNC5ndWFzaS9maW8uaAkyMDA3LTAzLTIwIDIw
OjA2OjQ4LjAwMDAwMDAwMCAtMDcwMA0KQEAgLTIzLDYgKzIzLDEwIEBADQog
I2luY2x1ZGUgInN5c2xldC5oIg0KICNlbmRpZg0KIA0KKyNpZmRlZiBGSU9f
SEFWRV9HVUFTSQ0KKyNpbmNsdWRlIDxndWFzaS5oPg0KKyNlbmRpZg0KKw0K
IGVudW0gZmlvX2RkaXIgew0KIAlERElSX1JFQUQgPSAwLA0KIAlERElSX1dS
SVRFLA0KQEAgLTExMCw2ICsxMTQsOSBAQA0KICNpZmRlZiBGSU9fSEFWRV9T
WVNMRVQNCiAJCXN0cnVjdCBzeXNsZXRfcmVxIHJlcTsNCiAjZW5kaWYNCisj
aWZkZWYgRklPX0hBVkVfR1VBU0kNCisJCWd1YXNpX3JlcV90IGdyZXE7DQor
I2VuZGlmDQogCX07DQogCXN0cnVjdCB0aW1ldmFsIHN0YXJ0X3RpbWU7DQog
CXN0cnVjdCB0aW1ldmFsIGlzc3VlX3RpbWU7DQpCaW5hcnkgZmlsZXMgZmlv
LTEuMTQvam9iMS4xLjAgYW5kIGZpby0xLjE0Lmd1YXNpL2pvYjEuMS4wIGRp
ZmZlcg0KZGlmZiAtTnJ1IGZpby0xLjE0L01ha2VmaWxlIGZpby0xLjE0Lmd1
YXNpL01ha2VmaWxlDQotLS0gZmlvLTEuMTQvTWFrZWZpbGUJMjAwNy0wMy0x
NCAwNjoyNDo0Mi4wMDAwMDAwMDAgLTA3MDANCisrKyBmaW8tMS4xNC5ndWFz
aS9NYWtlZmlsZQkyMDA3LTAzLTIwIDIxOjEzOjQyLjAwMDAwMDAwMCAtMDcw
MA0KQEAgLTE4LDYgKzE4LDcgQEANCiBPQkpTICs9IGVuZ2luZXMvbnVsbC5v
DQogT0JKUyArPSBlbmdpbmVzL25ldC5vDQogT0JKUyArPSBlbmdpbmVzL3N5
c2xldC1ydy5vDQorT0JKUyArPSBlbmdpbmVzL2d1YXNpLm8NCiANCiBJTlNU
QUxMID0gaW5zdGFsbA0KIHByZWZpeCA9IC91c3IvbG9jYWwNCkBAIC0yNiw3
ICsyNyw3IEBADQogYWxsOiAkKFBST0dTKSAkKFNDUklQVFMpDQogDQogZmlv
OiAkKE9CSlMpDQotCSQoQ0MpICQoQ0ZMQUdTKSAtbyAkQCAkKGZpbHRlciAl
Lm8sJF4pIC1scHRocmVhZCAtbG0gLWxkbCAtbGFpbyAtbHJ0DQorCSQoQ0Mp
ICQoQ0ZMQUdTKSAtbyAkQCAkKGZpbHRlciAlLm8sJF4pIC1sZ3Vhc2kgLWxw
dGhyZWFkIC1sbSAtbGRsIC1sYWlvIC1scnQNCiANCiBjbGVhbjoNCiAJLXJt
IC1mICoubyAuZGVwZW5kIGNzY29wZS5vdXQgJChQUk9HUykgZW5naW5lcy8q
Lm8gY29yZS4qIGNvcmUNCmRpZmYgLU5ydSBmaW8tMS4xNC9vcy1saW51eC5o
IGZpby0xLjE0Lmd1YXNpL29zLWxpbnV4LmgNCi0tLSBmaW8tMS4xNC9vcy1s
aW51eC5oCTIwMDctMDMtMTQgMDY6MjQ6NDIuMDAwMDAwMDAwIC0wNzAwDQor
KysgZmlvLTEuMTQuZ3Vhc2kvb3MtbGludXguaAkyMDA3LTAzLTIwIDIxOjEz
OjU4LjAwMDAwMDAwMCAtMDcwMA0KQEAgLTEwLDYgKzEwLDcgQEANCiANCiAj
ZGVmaW5lIEZJT19IQVZFX0xJQkFJTw0KICNkZWZpbmUgRklPX0hBVkVfUE9T
SVhBSU8NCisjZGVmaW5lIEZJT19IQVZFX0dVQVNJDQogI2RlZmluZSBGSU9f
SEFWRV9GQURWSVNFDQogI2RlZmluZSBGSU9fSEFWRV9DUFVfQUZGSU5JVFkN
CiAjZGVmaW5lIEZJT19IQVZFX0RJU0tfVVRJTA0K

--1795850513-1155867408-1174453129=:28960--
