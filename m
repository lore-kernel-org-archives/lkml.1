Return-Path: <linux-kernel-owner+w=401wt.eu-S1758104AbZDXVh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbZDXVh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 17:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbZDXVhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 17:37:10 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:4518 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZDXVhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 17:37:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ibykdgRMErbbmxGDpXHLzVdIqJzg85igkxeYeZMUHjyAFxebabw2CWzdEU9U1MzGCF
         t/asQAp0QMFFrQXfUD72fDuHJzDd7UGR4VJrwXUe+vrZbbLQREnBczrjPZ5TvjZ3Uu+F
         DTo87dnWW46aODWXhFCYJX2ycF+xfjG98dSRQ=
MIME-Version: 1.0
In-Reply-To: <4e5e476b0904240907h61efc0ej93d04488003ec104@mail.gmail.com>
References: <4e5e476b0904221407v7f43c058l8fc61198a2e4bb6e@mail.gmail.com>
	 <49F05699.2070006@cse.unsw.edu.au>
	 <4e5e476b0904230910r685e8300oa2323e8985c97a00@mail.gmail.com>
	 <20090424063944.GA4593@kernel.dk>
	 <4e5e476b0904240907h61efc0ej93d04488003ec104@mail.gmail.com>
Date: Fri, 24 Apr 2009 23:37:06 +0200
Message-ID: <4e5e476b0904241437h2da4371fmf6e24ac543a257d3@mail.gmail.com>
Subject: Re: Reduce latencies for syncronous writes and high I/O priority 
	requests in deadline IO scheduler
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Aaron Carroll <aaronc@cse.unsw.edu.au>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001485f423184eceb3046853ccfc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001485f423184eceb3046853ccfc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On Fri, Apr 24, 2009 at 6:07 PM, Corrado Zoccolo <czoccolo@gmail.com> wrote:
> Ok, this is the first patch of the series, and contains code cleanup
> needed before changing read/write to sync/async. No behavioral change
> is introduced by this patch.
>

And this one is the second patch, that changes read/write to sync vs. async.
fsync-tester results,with
     while : ; do time sh -c "dd if=/dev/zero of=bigfile bs=8M
count=256 ; sync; rm bigfile"; done:
running in the background
./fsync-tester
fsync time: 0.6383
fsync time: 0.1835
fsync time: 0.1744
fsync time: 0.1103
fsync time: 0.1535
fsync time: 0.1545
fsync time: 0.1491
fsync time: 0.1524
fsync time: 0.1609
fsync time: 0.1168
fsync time: 0.1458
fsync time: 0.1328
fsync time: 0.1655
fsync time: 0.1731
fsync time: 0.1356
fsync time: 0.1746
fsync time: 0.1166
fsync time: 0.1609
fsync time: 0.1370
fsync time: 0.1379
fsync time: 0.2096
fsync time: 0.1438
fsync time: 0.1652
fsync time: 0.1612
fsync time: 0.1438

compared with original deadline:
fsync time: 0.7963
fsync time: 4.5914
fsync time: 4.2347
fsync time: 1.1670
fsync time: 0.8164
fsync time: 1.9783
fsync time: 4.9726
fsync time: 2.4929
fsync time: 2.5448
fsync time: 3.9627

Usual tio-test, 32 threads 80Mb each:
Tiotest results for 32 concurrent io threads:
,----------------------------------------------------------------------.
| Item                  | Time     | Rate         | Usr CPU  | Sys CPU |
+-----------------------+----------+--------------+----------+---------+
| Write        2560 MBs |  103.6 s |  24.705 MB/s |   9.7 %  | 495.6 % |
| Random Write  125 MBs |   95.9 s |   1.304 MB/s |  -1.9 %  |  23.8 % |
| Read         2560 MBs |  164.3 s |  15.580 MB/s |   3.5 %  |  70.1 % |
| Random Read   125 MBs |  129.7 s |   0.964 MB/s |  -0.0 %  |  16.2 % |
`----------------------------------------------------------------------'
Tiotest latency results:
,-------------------------------------------------------------------------.
| Item         | Average latency | Maximum latency | % >2 sec | % >10 sec |
+--------------+-----------------+-----------------+----------+-----------+
| Write        |        4.040 ms |     8949.999 ms |  0.07614 |   0.00000 |
| Random Write |        1.252 ms |     5439.023 ms |  0.03125 |   0.00000 |
| Read         |        7.920 ms |      792.899 ms |  0.00000 |   0.00000 |
| Random Read  |      123.807 ms |      910.263 ms |  0.00000 |   0.00000 |
|--------------+-----------------+-----------------+----------+-----------|
| Total        |        8.613 ms |     8949.999 ms |  0.03703 |   0.00000 |
`--------------+-----------------+-----------------+----------+-----------'

compared with original deadline:
Tiotest results for 32 concurrent io threads:
,----------------------------------------------------------------------.
| Item                  | Time     | Rate         | Usr CPU  | Sys CPU |
+-----------------------+----------+--------------+----------+---------+
| Write        2560 MBs |  103.0 s |  24.848 MB/s |  10.6 %  | 522.2 % |
| Random Write  125 MBs |   98.8 s |   1.265 MB/s |  -1.6 %  |  16.1 % |
| Read         2560 MBs |  166.2 s |  15.400 MB/s |   4.2 %  |  82.7 % |
| Random Read   125 MBs |  193.3 s |   0.647 MB/s |  -0.8 %  |  14.5 % |
`----------------------------------------------------------------------'
Tiotest latency results:
,-------------------------------------------------------------------------.
| Item         | Average latency | Maximum latency | % >2 sec | % >10 sec |
+--------------+-----------------+-----------------+----------+-----------+
| Write        |        4.122 ms |    17922.920 ms |  0.07980 |   0.00061 |
| Random Write |        0.599 ms |     1245.200 ms |  0.00000 |   0.00000 |
| Read         |        8.032 ms |     1125.759 ms |  0.00000 |   0.00000 |
| Random Read  |      181.968 ms |      972.657 ms |  0.00000 |   0.00000 |
|--------------+-----------------+-----------------+----------+-----------|
| Total        |       10.044 ms |    17922.920 ms |  0.03804 |   0.00029 |
`--------------+-----------------+-----------------+----------+-----------'

We see the improvement on random read (not as pronounced as with full
set of heuristics, but still noticeable) and smaller increase on
random write latency, but this will not harm, since now we have
distinction between sync vs async reads.
I can test which of the other heuristics will provide the other few %
of improvements on random read if you are interested.
Otherwise, I'm more inclined on submitting an other patch to add
io-priorities to this series.

-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------

--001485f423184eceb3046853ccfc
Content-Type: application/octet-stream; name=deadline-patch-sync-async
Content-Disposition: attachment; filename=deadline-patch-sync-async
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ftxei7b31

RGVhZGxpbmUgSU9zY2hlZHVsZXIgc3luYy9hc3luYyBwYXRjaAoKVGhpcyBpcyB0aGUgc2Vjb25k
IHBhdGNoIG9mIHRoZSBzZXJpZXMsIGFuZCBjb250YWlucyB0aGUgY2hhbmdlcwp0byBjbGFzc2lm
eSByZXF1ZXN0cyBpbiBzeW5jL2FzeW5jIGluc3RlYWQgb2YgcmVhZC93cml0ZSBmb3IgZGVhZGxp
bmUKYXNzaWdubWVudC4gCk1vc3QgY2hhbmdlcyBhcmUgc3RyYWlnaHRmb3J3YXJkLgpGZXcgdGhp
bmdzIHRvIG5vdGU6CiogdXNlciBzcGFjZSB0dW5hYmxlcyBjaGFuZ2UgdGhlaXIgbmFtZSBhY2Nv
cmRpbmdseS4KKiBkZWFkbGluZV9kaXNwYXRjaF9yZXF1ZXN0cyBub3cgc2VsZWN0cyByZXF1ZXN0
cyB0byBkaXNwYXRjaCBiYXNlZAogIG9uIHRoZWlyIGJlbG9uZ2luZyB0byBzeW5jIHZzIGFzeW5j
IGNsYXNzLiBCYXRjaCBleHRlbnNpb24gcnVsZXMKICBhcmUgY2hhbmdlZCB0byBhbGxvdyBhIHN5
bmMgYmF0Y2ggdG8gYmUgZXh0ZW5kZWQsIGV2ZW4gaWYgYXN5bmMKICB3YXMgc2VsZWN0ZWQgZHVl
IHRvIGFzeW5jX3N0YXJ2ZWQgKHVubGVzcyB0aGUgZGVhZGxpbmUgaXMgZXhwaXJlZCkuCiogZGVh
ZGxpbmVfbW92ZV9yZXF1ZXN0IGJlY29tZXMgbW9yZSBjb21wbGV4LCBzaW5jZSBub3cgdGhlIG5l
eHQgCiAgcmVxdWVzdCBpbiBkaXNrIG9yZGVyIG1heSBub3QgYmUgc3VpdGFibGUgaWYgb2YgbG93
ZXIgcHJpb3JpdHkKICB0aGFuIHRoZSBjdXJyZW50IGJhdGNoLiBJbiBvcmRlciB0byBrZWVwIGl0
IGNvbnN0YW50IHRpbWUKICBjb21wbGV4aXR5LCB3ZSBwdXQgYSBsaW1pdCBpbiB0aGUgbnVtYmVy
IG9mIHJlcXVlc3RzIHRoYXQgY2FuIGJlCiAgc2tpcHBlZCBsb29raW5nIGZvciBvbmUgd2l0aCB0
aGUgY29ycmVjdCBwcmlvcml0eSwgYW5kIHdlIGFsbG93IGZvcgogIGJhdGNoIHByaW9yaXR5IGRl
bW90aW9uIGluIGNhc2UgdGhlIHN1aXRhYmxlIHJlcXVlc3QgaXMgbm90IGZvdW5kLgoKClNpZ25l
ZC1vZmYtYnk6IENvcnJhZG8gWm9jY29sbyA8Y3pvY2NvbG9AZ21haWwuY29tPgoKZGlmZiAtLWdp
dCBhL2Jsb2NrL2RlYWRsaW5lLWlvc2NoZWQuYyBiL2Jsb2NrL2RlYWRsaW5lLWlvc2NoZWQuYwpp
bmRleCA1NzEzNTk1Li5mOGNhMWEzIDEwMDY0NAotLS0gYS9ibG9jay9kZWFkbGluZS1pb3NjaGVk
LmMKKysrIGIvYmxvY2svZGVhZGxpbmUtaW9zY2hlZC5jCkBAIC0xNyw5ICsxNyw5IEBACiAvKgog
ICogU2VlIERvY3VtZW50YXRpb24vYmxvY2svZGVhZGxpbmUtaW9zY2hlZC50eHQKICAqLwotc3Rh
dGljIGNvbnN0IGludCByZWFkX2V4cGlyZSA9IEhaIC8gMjsgIC8qIG1heCB0aW1lIGJlZm9yZSBh
IHJlYWQgaXMgc3VibWl0dGVkLiAqLwotc3RhdGljIGNvbnN0IGludCB3cml0ZV9leHBpcmUgPSA1
ICogSFo7IC8qIGRpdHRvIGZvciB3cml0ZXMsIHRoZXNlIGxpbWl0cyBhcmUgU09GVCEgKi8KLXN0
YXRpYyBjb25zdCBpbnQgd3JpdGVzX3N0YXJ2ZWQgPSAyOyAgICAvKiBtYXggdGltZXMgcmVhZHMg
Y2FuIHN0YXJ2ZSBhIHdyaXRlICovCitzdGF0aWMgY29uc3QgaW50IHN5bmNfZXhwaXJlID0gSFog
LyAyOyAgICAgLyogbWF4IHRpbWUgYmVmb3JlIGEgc3luYyBvcGVyYXRpb24gaXMgc3VibWl0dGVk
LiAqLworc3RhdGljIGNvbnN0IGludCBhc3luY19leHBpcmUgPSA1ICogSFo7ICAgIC8qIGRpdHRv
IGZvciBhc3luYyBvcGVyYXRpb25zLCB0aGVzZSBsaW1pdHMgYXJlIFNPRlQhICovCitzdGF0aWMg
Y29uc3QgaW50IGFzeW5jX3N0YXJ2ZWQgPSAyOyAgICAgICAgLyogbWF4IHRpbWVzIFNZTkMgY2Fu
IHN0YXJ2ZSBBU1lOQyByZXF1ZXN0cyAqLwogc3RhdGljIGNvbnN0IGludCBmaWZvX2JhdGNoID0g
MTY7ICAgICAgIC8qICMgb2Ygc2VxdWVudGlhbCByZXF1ZXN0cyB0cmVhdGVkIGFzIG9uZQogCQkJ
CSAgICAgYnkgdGhlIGFib3ZlIHBhcmFtZXRlcnMuIEZvciB0aHJvdWdocHV0LiAqLwogCkBAIC0z
MSw4ICszMSw4IEBAIHN0cnVjdCBkZWFkbGluZV9kYXRhIHsKIAkvKgogCSAqIHJlcXVlc3RzIChk
ZWFkbGluZV9ycSBzKSBhcmUgcHJlc2VudCBvbiBib3RoIHNvcnRfbGlzdCBhbmQgZmlmb19saXN0
CiAJICovCi0Jc3RydWN0IHJiX3Jvb3Qgc29ydF9saXN0WzJdOwkKLQlzdHJ1Y3QgbGlzdF9oZWFk
IGZpZm9fbGlzdFsyXTsKKwlzdHJ1Y3QgcmJfcm9vdCBzb3J0X2xpc3RbMl07IC8qIFJFQUQsIFdS
SVRFICovCisJc3RydWN0IGxpc3RfaGVhZCBmaWZvX2xpc3RbMl07IC8qIDA9QVNZTkMsIDE9U1lO
QyAqLwogCiAJLyoKIAkgKiBuZXh0IGluIHNvcnQgb3JkZXIuCkBAIC00Niw4ICs0NiwxMyBAQCBz
dHJ1Y3QgZGVhZGxpbmVfZGF0YSB7CiAJICovCiAJaW50IGZpZm9fZXhwaXJlWzJdOwogCWludCBm
aWZvX2JhdGNoOwotCWludCB3cml0ZXNfc3RhcnZlZDsKKwlpbnQgYXN5bmNfc3RhcnZlZDsKIAlp
bnQgZnJvbnRfbWVyZ2VzOworCisJLyoKKwkgIGN1cnJlbnQgYmF0Y2ggZGF0YSAmIHN0YXRzCisJ
ICovCisJaW50IGN1cl9iYXRjaF9wcmlvOwogfTsKIAogc3RhdGljIHZvaWQgZGVhZGxpbmVfbW92
ZV9yZXF1ZXN0KHN0cnVjdCBkZWFkbGluZV9kYXRhICosIHN0cnVjdCByZXF1ZXN0ICopOwpAQCAt
OTEsNiArOTYsMTIgQEAgZGVhZGxpbmVfZGVsX3JxX3JiKHN0cnVjdCBkZWFkbGluZV9kYXRhICpk
ZCwgc3RydWN0IHJlcXVlc3QgKnJxKQogCWVsdl9yYl9kZWwoZGVhZGxpbmVfcmJfcm9vdChkZCwg
cnEpLCBycSk7CiB9CiAKK3N0YXRpYyBpbnQKK2RlYWRsaW5lX2NvbXB1dGVfcmVxX3ByaW9yaXR5
KHN0cnVjdCByZXF1ZXN0ICpyZXEpCit7CisJcmV0dXJuICEhcnFfaXNfc3luYyhyZXEpOworfQor
CiAvKgogICogYWRkIHJxIHRvIHJidHJlZSBhbmQgZmlmbwogICovCkBAIC0xMDUsNyArMTE2LDgg
QEAgZGVhZGxpbmVfYWRkX3JlcXVlc3Qoc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsIHN0cnVjdCBy
ZXF1ZXN0ICpycSkKIAkgKiBzZXQgcmVxdWVzdCBjcmVhdGlvbiB0aW1lIGFuZCBhZGQgdG8gZmlm
byBsaXN0CiAJICovCiAJcnFfc2V0X2ZpZm9fdGltZShycSwgamlmZmllcyk7Ci0JbGlzdF9hZGRf
dGFpbCgmcnEtPnF1ZXVlbGlzdCwgJmRkLT5maWZvX2xpc3RbcnFfZGF0YV9kaXIocnEpXSk7CisJ
bGlzdF9hZGRfdGFpbCgmcnEtPnF1ZXVlbGlzdCwKKwkJICAgICAgJmRkLT5maWZvX2xpc3RbZGVh
ZGxpbmVfY29tcHV0ZV9yZXFfcHJpb3JpdHkocnEpXSk7CiB9CiAKIC8qCkBAIC0yMDIsNyArMjE0
LDI0IEBAIGRlYWRsaW5lX21vdmVfdG9fZGlzcGF0Y2goc3RydWN0IGRlYWRsaW5lX2RhdGEgKmRk
LCBzdHJ1Y3QgcmVxdWVzdCAqcnEpCiBzdGF0aWMgdm9pZAogZGVhZGxpbmVfbW92ZV9yZXF1ZXN0
KHN0cnVjdCBkZWFkbGluZV9kYXRhICpkZCwgc3RydWN0IHJlcXVlc3QgKnJxKQogewotCWRkLT5u
ZXh0X3JxID0gZGVhZGxpbmVfbmV4dF9yZXF1ZXN0KHJxKTsKKwlpbnQgbWF4X3NlYXJjaCA9IGRk
LT5maWZvX2JhdGNoOworCisJZGQtPm5leHRfcnEgPSBycTsKKwkvKiB0cnkgdG8gZ2V0IHJlcXVl
c3RzIG9mIGF0IGxlYXN0IHRoZSBzYW1lIHByaW9yaXR5IChvciBhYm92ZSkKKwkgICBhbmQgc2Ft
ZSBkaXJlY3Rpb24gYXMgY3VycmVudCBvbmUgKi8KKwl3aGlsZSAobWF4X3NlYXJjaC0tICYmCisJ
ICAgICAgIChkZC0+bmV4dF9ycSA9IGRlYWRsaW5lX25leHRfcmVxdWVzdChkZC0+bmV4dF9ycSkp
ICYmCisJICAgICAgIGRkLT5jdXJfYmF0Y2hfcHJpbyA+IGRlYWRsaW5lX2NvbXB1dGVfcmVxX3By
aW9yaXR5KGRkLT5uZXh0X3JxKSkKKwkJOworCisJaWYgKCFtYXhfc2VhcmNoIHx8ICFkZC0+bmV4
dF9ycSkgeworCQkvKiBkaWQgbm90IGdldCBhIG5leHQgb2Ygc3VpdGFibGUgcHJpb3JpdHksIGRl
bW90ZSBiYXRjaCB0bworCQkgICBsb3dlciwgYW5kIGNvbnRpbnVlIGluIGRpc2sgb3JkZXIgKi8K
KwkJZGQtPm5leHRfcnEgPSBkZWFkbGluZV9uZXh0X3JlcXVlc3QocnEpOworCQlpZiAoZGQtPm5l
eHRfcnEpCisJCQlkZC0+Y3VyX2JhdGNoX3ByaW8gPQorCQkJCWRlYWRsaW5lX2NvbXB1dGVfcmVx
X3ByaW9yaXR5KGRkLT5uZXh0X3JxKTsKKwl9CiAKIAkvKgogCSAqIHRha2UgaXQgb2ZmIHRoZSBz
b3J0IGFuZCBmaWZvIGxpc3QsIG1vdmUKQEAgLTIxMiwxNyArMjQxLDE3IEBAIGRlYWRsaW5lX21v
dmVfcmVxdWVzdChzdHJ1Y3QgZGVhZGxpbmVfZGF0YSAqZGQsIHN0cnVjdCByZXF1ZXN0ICpycSkK
IH0KIAogLyoKLSAqIGRlYWRsaW5lX2NoZWNrX2ZpZm8gcmV0dXJucyAwIGlmIHRoZXJlIGFyZSBu
byBleHBpcmVkIHJlcXVlc3RzIG9uIHRoZSBmaWZvLAotICogMSBvdGhlcndpc2UuIFJlcXVpcmVz
ICFsaXN0X2VtcHR5KCZkZC0+Zmlmb19saXN0W2RhdGFfZGlyXSkKKyAqIGRlYWRsaW5lX2NoZWNr
X2ZpZm8gcmV0dXJucyAwIGlmIHRoZXJlIGFyZSBubyBleHBpcmVkIHJlcXVlc3RzIG9uIHRoZSBm
aWZvCisgKiBmb3IgZ2l2ZW4gcHJpb3JpdHksIDEgb3RoZXJ3aXNlLiBSZXF1aXJlcyAhbGlzdF9l
bXB0eSgmZGQtPmZpZm9fbGlzdFtwcmlvXSkKICAqLwotc3RhdGljIGlubGluZSBpbnQgZGVhZGxp
bmVfY2hlY2tfZmlmbyhzdHJ1Y3QgZGVhZGxpbmVfZGF0YSAqZGQsIGludCBkZGlyKQorc3RhdGlj
IGlubGluZSBpbnQgZGVhZGxpbmVfY2hlY2tfZmlmbyhzdHJ1Y3QgZGVhZGxpbmVfZGF0YSAqZGQs
IHVuc2lnbmVkIHByaW8pCiB7Ci0JQlVHX09OKGxpc3RfZW1wdHkoJmRkLT5maWZvX2xpc3RbZGRp
cl0pKTsKKwlCVUdfT04obGlzdF9lbXB0eSgmZGQtPmZpZm9fbGlzdFtwcmlvXSkpOwogCS8qCiAJ
ICogZGVhZGxpbmUgaXMgZXhwaXJlZCEKIAkgKi8KLQlyZXR1cm4gdGltZV9hZnRlcihqaWZmaWVz
LCBkZC0+Zmlmb19leHBpcmVbZGRpcl0gKwotCQkJICBycV9maWZvX3RpbWUocnFfZW50cnlfZmlm
byhkZC0+Zmlmb19saXN0W2RkaXJdLm5leHQpKQorCXJldHVybiB0aW1lX2FmdGVyKGppZmZpZXMs
IGRkLT5maWZvX2V4cGlyZVtwcmlvXSArCisJCQkgIHJxX2ZpZm9fdGltZShycV9lbnRyeV9maWZv
KGRkLT5maWZvX2xpc3RbcHJpb10ubmV4dCkpCiAJCQkgICk7CiB9CiAKQEAgLTIzMywxMCArMjYy
LDEwIEBAIHN0YXRpYyBpbmxpbmUgaW50IGRlYWRsaW5lX2NoZWNrX2ZpZm8oc3RydWN0IGRlYWRs
aW5lX2RhdGEgKmRkLCBpbnQgZGRpcikKIHN0YXRpYyBpbnQgZGVhZGxpbmVfZGlzcGF0Y2hfcmVx
dWVzdHMoc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsIGludCBmb3JjZSkKIHsKIAlzdHJ1Y3QgZGVh
ZGxpbmVfZGF0YSAqZGQgPSBxLT5lbGV2YXRvci0+ZWxldmF0b3JfZGF0YTsKLQljb25zdCBpbnQg
cmVhZHMgPSAhbGlzdF9lbXB0eSgmZGQtPmZpZm9fbGlzdFtSRUFEXSk7Ci0JY29uc3QgaW50IHdy
aXRlcyA9ICFsaXN0X2VtcHR5KCZkZC0+Zmlmb19saXN0W1dSSVRFXSk7CisJY29uc3QgaW50IHN5
bmNfcmVxcyA9ICFsaXN0X2VtcHR5KCZkZC0+Zmlmb19saXN0WzFdKTsKKwljb25zdCBpbnQgYXN5
bmNfcmVxcyA9ICFsaXN0X2VtcHR5KCZkZC0+Zmlmb19saXN0WzBdKTsKIAlzdHJ1Y3QgcmVxdWVz
dCAqcnEgPSBkZC0+bmV4dF9ycTsKLQlpbnQgZGF0YV9kaXI7CisJaW50IHJlcXVlc3RfcHJpbyA9
IGRkLT5jdXJfYmF0Y2hfcHJpbzsKIAogCWlmIChycSAmJiBkZC0+YmF0Y2hpbmcgPCBkZC0+Zmlm
b19iYXRjaCkgewogCQkvKiB3ZSBoYXZlIGEgbmV4dCByZXF1ZXN0IGFyZSBzdGlsbCBlbnRpdGxl
ZCB0byBiYXRjaCAqLwpAQCAtMjQ4LDE0ICsyNzcsMTAgQEAgc3RhdGljIGludCBkZWFkbGluZV9k
aXNwYXRjaF9yZXF1ZXN0cyhzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgaW50IGZvcmNlKQogCSAq
IGRhdGEgZGlyZWN0aW9uIChyZWFkIC8gd3JpdGUpCiAJICovCiAKLQlpZiAocmVhZHMpIHsKLQkJ
QlVHX09OKFJCX0VNUFRZX1JPT1QoJmRkLT5zb3J0X2xpc3RbUkVBRF0pKTsKLQotCQlpZiAod3Jp
dGVzICYmIChkZC0+c3RhcnZlZCsrID49IGRkLT53cml0ZXNfc3RhcnZlZCkpCi0JCQlnb3RvIGRp
c3BhdGNoX3dyaXRlczsKLQotCQlkYXRhX2RpciA9IFJFQUQ7Ci0KKwlpZiAoc3luY19yZXFzKSB7
CisJCWlmIChhc3luY19yZXFzICYmIChkZC0+c3RhcnZlZCsrID49IGRkLT5hc3luY19zdGFydmVk
KSkKKwkJCWdvdG8gZGlzcGF0Y2hfYXN5bmM7CisJCXJlcXVlc3RfcHJpbyA9IDE7CiAJCWdvdG8g
ZGlzcGF0Y2hfZmluZF9yZXF1ZXN0OwogCX0KIApAQCAtMjYzLDE0ICsyODgsMTAgQEAgc3RhdGlj
IGludCBkZWFkbGluZV9kaXNwYXRjaF9yZXF1ZXN0cyhzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwg
aW50IGZvcmNlKQogCSAqIHRoZXJlIGFyZSBlaXRoZXIgbm8gcmVhZHMgb3Igd3JpdGVzIGhhdmUg
YmVlbiBzdGFydmVkCiAJICovCiAKLQlpZiAod3JpdGVzKSB7Ci1kaXNwYXRjaF93cml0ZXM6Ci0J
CUJVR19PTihSQl9FTVBUWV9ST09UKCZkZC0+c29ydF9saXN0W1dSSVRFXSkpOwotCisJaWYgKGFz
eW5jX3JlcXMpIHsKK2Rpc3BhdGNoX2FzeW5jOgogCQlkZC0+c3RhcnZlZCA9IDA7Ci0KLQkJZGF0
YV9kaXIgPSBXUklURTsKLQorCQlyZXF1ZXN0X3ByaW8gPSAwOwogCQlnb3RvIGRpc3BhdGNoX2Zp
bmRfcmVxdWVzdDsKIAl9CiAKQEAgLTI3OCwyNSArMjk5LDI4IEBAIGRpc3BhdGNoX3dyaXRlczoK
IAogZGlzcGF0Y2hfZmluZF9yZXF1ZXN0OgogCS8qCi0JICogd2UgYXJlIG5vdCBydW5uaW5nIGEg
YmF0Y2gsIGZpbmQgYmVzdCByZXF1ZXN0IGZvciBzZWxlY3RlZCBkYXRhX2RpcgorCSAqIHdlIGFy
ZSBub3QgcnVubmluZyBhIGJhdGNoOgorCSAqIGZpbmQgYmVzdCByZXF1ZXN0IGZvciBzZWxlY3Rl
ZCByZXF1ZXN0X3ByaW8KIAkgKi8KIAlpZiAoIWRkLT5uZXh0X3JxCi0JICAgIHx8IHJxX2RhdGFf
ZGlyKGRkLT5uZXh0X3JxKSAhPSBkYXRhX2RpcgotCSAgICB8fCBkZWFkbGluZV9jaGVja19maWZv
KGRkLCBkYXRhX2RpcikpIHsKKwkgICAgfHwgZGQtPmN1cl9iYXRjaF9wcmlvIDwgcmVxdWVzdF9w
cmlvCisJICAgIHx8IGRlYWRsaW5lX2NoZWNrX2ZpZm8oZGQsIHJlcXVlc3RfcHJpbykpIHsKIAkJ
LyoKLQkJICogQSBkZWFkbGluZSBoYXMgZXhwaXJlZCwgdGhlIGxhc3QgcmVxdWVzdCB3YXMgaW4g
dGhlIG90aGVyCi0JCSAqIGRpcmVjdGlvbiwgb3Igd2UgaGF2ZSBydW4gb3V0IG9mIGhpZ2hlci1z
ZWN0b3JlZCByZXF1ZXN0cy4KKwkJICogQSBkZWFkbGluZSBleHBpcmVkLCB0aGUgcHJldmlvdXMg
YmF0Y2ggaGFkIGEgbG93ZXIgcHJpb3JpdHksCisJCSAqIG9yIHdlIGhhdmUgcnVuIG91dCBvZiBo
aWdoZXItc2VjdG9yZWQgcmVxdWVzdHMuCiAJCSAqIFN0YXJ0IGFnYWluIGZyb20gdGhlIHJlcXVl
c3Qgd2l0aCB0aGUgZWFybGllc3QgZXhwaXJ5IHRpbWUuCiAJCSAqLwotCQlycSA9IHJxX2VudHJ5
X2ZpZm8oZGQtPmZpZm9fbGlzdFtkYXRhX2Rpcl0ubmV4dCk7CisJCXJxID0gcnFfZW50cnlfZmlm
byhkZC0+Zmlmb19saXN0W3JlcXVlc3RfcHJpb10ubmV4dCk7CiAJfSBlbHNlIHsKIAkJLyoKLQkJ
ICogVGhlIGxhc3QgcmVxIHdhcyB0aGUgc2FtZSBkaXIgYW5kIHdlIGhhdmUgYSBuZXh0IHJlcXVl
c3QgaW4KLQkJICogc29ydCBvcmRlci4gTm8gZXhwaXJlZCByZXF1ZXN0cyBzbyBjb250aW51ZSBv
biBmcm9tIGhlcmUuCisJCSAqIFRoZSBsYXN0IGJhdGNoIHdhcyBzYW1lIG9yIGhpZ2hlciBwcmlv
cml0eSBhbmQgd2UgaGF2ZSBhCisJCSAqIG5leHQgcmVxdWVzdCBpbiBzb3J0IG9yZGVyLiBObyBl
eHBpcmVkIHJlcXVlc3RzIHNvIGNvbnRpbnVlCisJCSAqIG9uIGZyb20gaGVyZS4KIAkJICovCiAJ
CXJxID0gZGQtPm5leHRfcnE7CiAJfQogCisJZGQtPmN1cl9iYXRjaF9wcmlvID0gcmVxdWVzdF9w
cmlvOwogCWRkLT5iYXRjaGluZyA9IDA7CiAKIGRpc3BhdGNoX3JlcXVlc3Q6CkBAIC0zMTMsMTYg
KzMzNywxNiBAQCBzdGF0aWMgaW50IGRlYWRsaW5lX3F1ZXVlX2VtcHR5KHN0cnVjdCByZXF1ZXN0
X3F1ZXVlICpxKQogewogCXN0cnVjdCBkZWFkbGluZV9kYXRhICpkZCA9IHEtPmVsZXZhdG9yLT5l
bGV2YXRvcl9kYXRhOwogCi0JcmV0dXJuIGxpc3RfZW1wdHkoJmRkLT5maWZvX2xpc3RbV1JJVEVd
KQotCQkmJiBsaXN0X2VtcHR5KCZkZC0+Zmlmb19saXN0W1JFQURdKTsKKwlyZXR1cm4gbGlzdF9l
bXB0eSgmZGQtPmZpZm9fbGlzdFswXSkKKwkJJiYgbGlzdF9lbXB0eSgmZGQtPmZpZm9fbGlzdFsx
XSk7CiB9CiAKIHN0YXRpYyB2b2lkIGRlYWRsaW5lX2V4aXRfcXVldWUoc3RydWN0IGVsZXZhdG9y
X3F1ZXVlICplKQogewogCXN0cnVjdCBkZWFkbGluZV9kYXRhICpkZCA9IGUtPmVsZXZhdG9yX2Rh
dGE7CiAKLQlCVUdfT04oIWxpc3RfZW1wdHkoJmRkLT5maWZvX2xpc3RbUkVBRF0pKTsKLQlCVUdf
T04oIWxpc3RfZW1wdHkoJmRkLT5maWZvX2xpc3RbV1JJVEVdKSk7CisJQlVHX09OKCFsaXN0X2Vt
cHR5KCZkZC0+Zmlmb19saXN0WzBdKSk7CisJQlVHX09OKCFsaXN0X2VtcHR5KCZkZC0+Zmlmb19s
aXN0WzFdKSk7CiAKIAlrZnJlZShkZCk7CiB9CkBAIC0zMzgsMTMgKzM2MiwxMyBAQCBzdGF0aWMg
dm9pZCAqZGVhZGxpbmVfaW5pdF9xdWV1ZShzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSkKIAlpZiAo
IWRkKQogCQlyZXR1cm4gTlVMTDsKIAotCUlOSVRfTElTVF9IRUFEKCZkZC0+Zmlmb19saXN0W1JF
QURdKTsKLQlJTklUX0xJU1RfSEVBRCgmZGQtPmZpZm9fbGlzdFtXUklURV0pOworCUlOSVRfTElT
VF9IRUFEKCZkZC0+Zmlmb19saXN0WzBdKTsKKwlJTklUX0xJU1RfSEVBRCgmZGQtPmZpZm9fbGlz
dFsxXSk7CiAJZGQtPnNvcnRfbGlzdFtSRUFEXSA9IFJCX1JPT1Q7CiAJZGQtPnNvcnRfbGlzdFtX
UklURV0gPSBSQl9ST09UOwotCWRkLT5maWZvX2V4cGlyZVtSRUFEXSA9IHJlYWRfZXhwaXJlOwot
CWRkLT5maWZvX2V4cGlyZVtXUklURV0gPSB3cml0ZV9leHBpcmU7Ci0JZGQtPndyaXRlc19zdGFy
dmVkID0gd3JpdGVzX3N0YXJ2ZWQ7CisJZGQtPmZpZm9fZXhwaXJlWzBdID0gYXN5bmNfZXhwaXJl
OworCWRkLT5maWZvX2V4cGlyZVsxXSA9IHN5bmNfZXhwaXJlOworCWRkLT5hc3luY19zdGFydmVk
ID0gYXN5bmNfc3RhcnZlZDsKIAlkZC0+ZnJvbnRfbWVyZ2VzID0gMTsKIAlkZC0+Zmlmb19iYXRj
aCA9IGZpZm9fYmF0Y2g7CiAJcmV0dXJuIGRkOwpAQCAtMzc4LDkgKzQwMiw5IEBAIHN0YXRpYyBz
c2l6ZV90IF9fRlVOQyhzdHJ1Y3QgZWxldmF0b3JfcXVldWUgKmUsIGNoYXIgKnBhZ2UpCQlcCiAJ
CV9fZGF0YSA9IGppZmZpZXNfdG9fbXNlY3MoX19kYXRhKTsJCQlcCiAJcmV0dXJuIGRlYWRsaW5l
X3Zhcl9zaG93KF9fZGF0YSwgKHBhZ2UpKTsJCQlcCiB9Ci1TSE9XX0ZVTkNUSU9OKGRlYWRsaW5l
X3JlYWRfZXhwaXJlX3Nob3csIGRkLT5maWZvX2V4cGlyZVtSRUFEXSwgMSk7Ci1TSE9XX0ZVTkNU
SU9OKGRlYWRsaW5lX3dyaXRlX2V4cGlyZV9zaG93LCBkZC0+Zmlmb19leHBpcmVbV1JJVEVdLCAx
KTsKLVNIT1dfRlVOQ1RJT04oZGVhZGxpbmVfd3JpdGVzX3N0YXJ2ZWRfc2hvdywgZGQtPndyaXRl
c19zdGFydmVkLCAwKTsKK1NIT1dfRlVOQ1RJT04oZGVhZGxpbmVfYXN5bmNfZXhwaXJlX3Nob3cs
IGRkLT5maWZvX2V4cGlyZVswXSwgMSk7CitTSE9XX0ZVTkNUSU9OKGRlYWRsaW5lX3N5bmNfZXhw
aXJlX3Nob3csIGRkLT5maWZvX2V4cGlyZVsxXSwgMSk7CitTSE9XX0ZVTkNUSU9OKGRlYWRsaW5l
X2FzeW5jX3N0YXJ2ZWRfc2hvdywgZGQtPmFzeW5jX3N0YXJ2ZWQsIDApOwogU0hPV19GVU5DVElP
TihkZWFkbGluZV9mcm9udF9tZXJnZXNfc2hvdywgZGQtPmZyb250X21lcmdlcywgMCk7CiBTSE9X
X0ZVTkNUSU9OKGRlYWRsaW5lX2ZpZm9fYmF0Y2hfc2hvdywgZGQtPmZpZm9fYmF0Y2gsIDApOwog
I3VuZGVmIFNIT1dfRlVOQ1RJT04KQEAgLTQwMSw5ICs0MjUsOSBAQCBzdGF0aWMgc3NpemVfdCBf
X0ZVTkMoc3RydWN0IGVsZXZhdG9yX3F1ZXVlICplLCBjb25zdCBjaGFyICpwYWdlLCBzaXplX3Qg
Y291bnQpCiAJCSooX19QVFIpID0gX19kYXRhOwkJCQkJXAogCXJldHVybiByZXQ7CQkJCQkJCVwK
IH0KLVNUT1JFX0ZVTkNUSU9OKGRlYWRsaW5lX3JlYWRfZXhwaXJlX3N0b3JlLCAmZGQtPmZpZm9f
ZXhwaXJlW1JFQURdLCAwLCBJTlRfTUFYLCAxKTsKLVNUT1JFX0ZVTkNUSU9OKGRlYWRsaW5lX3dy
aXRlX2V4cGlyZV9zdG9yZSwgJmRkLT5maWZvX2V4cGlyZVtXUklURV0sIDAsIElOVF9NQVgsIDEp
OwotU1RPUkVfRlVOQ1RJT04oZGVhZGxpbmVfd3JpdGVzX3N0YXJ2ZWRfc3RvcmUsICZkZC0+d3Jp
dGVzX3N0YXJ2ZWQsIElOVF9NSU4sIElOVF9NQVgsIDApOworU1RPUkVfRlVOQ1RJT04oZGVhZGxp
bmVfYXN5bmNfZXhwaXJlX3N0b3JlLCAmZGQtPmZpZm9fZXhwaXJlWzBdLCAwLCBJTlRfTUFYLCAx
KTsKK1NUT1JFX0ZVTkNUSU9OKGRlYWRsaW5lX3N5bmNfZXhwaXJlX3N0b3JlLCAmZGQtPmZpZm9f
ZXhwaXJlWzFdLCAwLCBJTlRfTUFYLCAxKTsKK1NUT1JFX0ZVTkNUSU9OKGRlYWRsaW5lX2FzeW5j
X3N0YXJ2ZWRfc3RvcmUsICZkZC0+YXN5bmNfc3RhcnZlZCwgSU5UX01JTiwgSU5UX01BWCwgMCk7
CiBTVE9SRV9GVU5DVElPTihkZWFkbGluZV9mcm9udF9tZXJnZXNfc3RvcmUsICZkZC0+ZnJvbnRf
bWVyZ2VzLCAwLCAxLCAwKTsKIFNUT1JFX0ZVTkNUSU9OKGRlYWRsaW5lX2ZpZm9fYmF0Y2hfc3Rv
cmUsICZkZC0+Zmlmb19iYXRjaCwgMCwgSU5UX01BWCwgMCk7CiAjdW5kZWYgU1RPUkVfRlVOQ1RJ
T04KQEAgLTQxMyw5ICs0MzcsOSBAQCBTVE9SRV9GVU5DVElPTihkZWFkbGluZV9maWZvX2JhdGNo
X3N0b3JlLCAmZGQtPmZpZm9fYmF0Y2gsIDAsIElOVF9NQVgsIDApOwogCQkJCSAgICAgIGRlYWRs
aW5lXyMjbmFtZSMjX3N0b3JlKQogCiBzdGF0aWMgc3RydWN0IGVsdl9mc19lbnRyeSBkZWFkbGlu
ZV9hdHRyc1tdID0gewotCUREX0FUVFIocmVhZF9leHBpcmUpLAotCUREX0FUVFIod3JpdGVfZXhw
aXJlKSwKLQlERF9BVFRSKHdyaXRlc19zdGFydmVkKSwKKwlERF9BVFRSKGFzeW5jX2V4cGlyZSks
CisJRERfQVRUUihzeW5jX2V4cGlyZSksCisJRERfQVRUUihhc3luY19zdGFydmVkKSwKIAlERF9B
VFRSKGZyb250X21lcmdlcyksCiAJRERfQVRUUihmaWZvX2JhdGNoKSwKIAlfX0FUVFJfTlVMTAo=
--001485f423184eceb3046853ccfc--
