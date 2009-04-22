Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbZDVVHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbZDVVHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 17:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbZDVVHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 17:07:35 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:37448 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbZDVVHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 17:07:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=o7f04/r5Ufp/IZQpbgVUZHWzoW/KsK2qJqVeVt4pfr2uVw2pwN1OUSzv1yg9SYKVpr
         c9FYFzaNIWro0eiTT2LA05EzkoJNj9BP6E2Db7yPQM5qvLN8B61b+87rR07cds5X+voM
         zJCk81fZkjwYV63u7pRpCLuOmDvKVk0hLTy9c=
MIME-Version: 1.0
Date: Wed, 22 Apr 2009 23:07:32 +0200
Message-ID: <4e5e476b0904221407v7f43c058l8fc61198a2e4bb6e@mail.gmail.com>
Subject: Reduce latencies for syncronous writes and high I/O priority requests 
	in deadline IO scheduler
From: Corrado Zoccolo <czoccolo@gmail.com>
To: jens.axboe@oracle.com, Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016364d260fe3308704682b267d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016364d260fe3308704682b267d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,
deadline I/O scheduler currently classifies all I/O requests in only 2
classes, reads (always considered high priority) and writes (always
lower).
The attached patch, intended to reduce latencies for syncronous writes
and high I/O priority requests, introduces more levels of priorities:
* real time reads: highest priority and shortest deadline, can starve
other levels
* syncronous operations (either best effort reads or RT/BE writes),
mid priority, starvation for lower level is prevented as usual
* asyncronous operations (async writes and all IDLE class requests),
lowest priority and longest deadline

The patch also introduces some new heuristics:
* for non-rotational devices, reads (within a given priority level)
are issued in FIFO order, to improve the latency perceived by readers
* minimum batch timespan (time quantum): partners with fifo_batch to
improve throughput, by sending more consecutive requests together. A
given number of requests will not always take the same time (due to
amount of seek needed), therefore fifo_batch must be tuned for worst
cases, while in best cases, having longer batches would give a
throughput boost.
* batch start request is chosen fifo_batch/3 requests before the
expired one, to improve fairness for requests with lower start sector,
that otherwise have higher probability to miss a deadline than
mid-sector requests.

I did few performance comparisons:
* HDD, ext3 partition with data=writeback, tiotest with 32 threads,
each writing 80MB of data

** deadline-original
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

** cfq (2.6.30-rc2)
Tiotest results for 32 concurrent io threads:
,----------------------------------------------------------------------.
| Item                  | Time     | Rate         | Usr CPU  | Sys CPU |
+-----------------------+----------+--------------+----------+---------+
| Write        2560 MBs |  132.4 s |  19.342 MB/s |   8.5 %  | 400.4 % |
| Random Write  125 MBs |  107.8 s |   1.159 MB/s |  -1.6 %  |  16.8 % |
| Read         2560 MBs |  107.6 s |  23.788 MB/s |   5.4 %  |  95.7 % |
| Random Read   125 MBs |  158.4 s |   0.789 MB/s |   0.9 %  |   7.7 % |
`----------------------------------------------------------------------'
Tiotest latency results:
,-------------------------------------------------------------------------.
| Item         | Average latency | Maximum latency | % >2 sec | % >10 sec |
+--------------+-----------------+-----------------+----------+-----------+
| Write        |        5.362 ms |    21081.012 ms |  0.09811 |   0.00244 |
| Random Write |       23.310 ms |    31865.095 ms |  0.13437 |   0.06250 |
| Read         |        5.048 ms |     3694.001 ms |  0.15167 |   0.00000 |
| Random Read  |      146.523 ms |     2880.409 ms |  0.52187 |   0.00000 |
|--------------+-----------------+-----------------+----------+-----------|
| Total        |        8.916 ms |    31865.095 ms |  0.13435 |   0.00262 |
`--------------+-----------------+-----------------+----------+-----------'

** deadline-patched
Tiotest results for 32 concurrent io threads:
,----------------------------------------------------------------------.
| Item                  | Time     | Rate         | Usr CPU  | Sys CPU |
+-----------------------+----------+--------------+----------+---------+
| Write        2560 MBs |  105.3 s |  24.301 MB/s |  10.5 %  | 514.8 % |
| Random Write  125 MBs |   95.9 s |   1.304 MB/s |  -1.8 %  |  17.3 % |
| Read         2560 MBs |  165.1 s |  15.507 MB/s |   2.7 %  |  61.9 % |
| Random Read   125 MBs |  110.6 s |   1.130 MB/s |   0.8 %  |  12.2 % |
`----------------------------------------------------------------------'
Tiotest latency results:
,-------------------------------------------------------------------------.
| Item         | Average latency | Maximum latency | % >2 sec | % >10 sec |
+--------------+-----------------+-----------------+----------+-----------+
| Write        |        4.131 ms |    17456.831 ms |  0.08041 |   0.00275 |
| Random Write |        2.780 ms |     5073.180 ms |  0.07500 |   0.00000 |
| Read         |        7.748 ms |      936.499 ms |  0.00000 |   0.00000 |
| Random Read  |      104.849 ms |      695.192 ms |  0.00000 |   0.00000 |
|--------------+-----------------+-----------------+----------+-----------|
| Total        |        8.168 ms |    17456.831 ms |  0.04008 |   0.00131 |
`--------------+-----------------+-----------------+----------+-----------'

* SD card, nilfs2 partition, tiotest with 16 threads, each writing 80MB of data
** cfq(2.6.30-rc2)
Tiotest results for 16 concurrent io threads:
,----------------------------------------------------------------------.
| Item                  | Time     | Rate         | Usr CPU  | Sys CPU |
+-----------------------+----------+--------------+----------+---------+
| Write        1280 MBs |  217.8 s |   5.878 MB/s |   3.7 %  |  92.2 % |
| Random Write   62 MBs |   18.2 s |   3.432 MB/s |  -2.3 %  |  28.7 % |
| Read         1280 MBs |  114.7 s |  11.156 MB/s |   7.3 %  |  76.6 % |
| Random Read    62 MBs |    3.4 s |  18.615 MB/s |  -5.4 %  | 274.2 % |
`----------------------------------------------------------------------'
Tiotest latency results:
,-------------------------------------------------------------------------.
| Item         | Average latency | Maximum latency | % >2 sec | % >10 sec |
+--------------+-----------------+-----------------+----------+-----------+
| Write        |        9.943 ms |    10223.581 ms |  0.14252 |   0.00488 |
| Random Write |       12.287 ms |     5097.196 ms |  0.25625 |   0.00000 |
| Read         |        5.352 ms |     1550.162 ms |  0.00000 |   0.00000 |
| Random Read  |        3.051 ms |     1507.837 ms |  0.00000 |   0.00000 |
|--------------+-----------------+-----------------+----------+-----------|
| Total        |        7.649 ms |    10223.581 ms |  0.07391 |   0.00233 |
`--------------+-----------------+-----------------+----------+-----------'

** deadline-patched:
Tiotest results for 16 concurrent io threads:
,----------------------------------------------------------------------.
| Item                  | Time     | Rate         | Usr CPU  | Sys CPU |
+-----------------------+----------+--------------+----------+---------+
| Write        1280 MBs |  220.9 s |   5.794 MB/s |   4.0 %  |  93.9 % |
| Random Write   62 MBs |   20.5 s |   3.044 MB/s |  -2.2 %  |  24.9 % |
| Read         1280 MBs |  113.2 s |  11.304 MB/s |   6.8 %  |  72.8 % |
| Random Read    62 MBs |    2.9 s |  21.896 MB/s |   5.1 %  | 293.8 % |
`----------------------------------------------------------------------'
Tiotest latency results:
,-------------------------------------------------------------------------.
| Item         | Average latency | Maximum latency | % >2 sec | % >10 sec |
+--------------+-----------------+-----------------+----------+-----------+
| Write        |       10.078 ms |    13303.036 ms |  0.14160 |   0.00031 |
| Random Write |       14.350 ms |     5265.088 ms |  0.40000 |   0.00000 |
| Read         |        5.455 ms |      434.495 ms |  0.00000 |   0.00000 |
| Random Read  |        2.685 ms |       12.652 ms |  0.00000 |   0.00000 |
|--------------+-----------------+-----------------+----------+-----------|
| Total        |        7.801 ms |    13303.036 ms |  0.07682 |   0.00015 |
`--------------+-----------------+-----------------+----------+-----------'

* fsync-tester results, on HDD, empty ext3 partition, mounted with
data=writeback
** deadline-original:
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
** cfq 2.6.30-rc2
fsync time: 0.0288
fsync time: 0.0528
fsync time: 0.0299
fsync time: 0.0397
fsync time: 0.5720
fsync time: 0.0409
fsync time: 0.0876
fsync time: 0.0294
fsync time: 0.0485
** deadline-patched
fsync time: 0.0772
fsync time: 0.0381
fsync time: 0.0604
fsync time: 0.2923
fsync time: 0.2488
fsync time: 0.0924
fsync time: 0.0144
fsync time: 1.4824
fsync time: 0.0789
fsync time: 0.0565
fsync time: 0.0550
fsync time: 0.0421
** deadline-patched, ionice -c1:
fsync time: 0.2569
fsync time: 0.0500
fsync time: 0.0681
fsync time: 0.2863
fsync time: 0.0140
fsync time: 0.0171
fsync time: 0.1198
fsync time: 0.0530
fsync time: 0.0503
fsync time: 0.0462
fsync time: 0.0484
fsync time: 0.0328
fsync time: 0.0562
fsync time: 0.0451
fsync time: 0.0576
fsync time: 0.0444
fsync time: 0.0469
fsync time: 0.0368
fsync time: 0.2865

Corrado

-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------

--0016364d260fe3308704682b267d
Content-Type: application/octet-stream; name="deadline-iosched.c.patch"
Content-Disposition: attachment; filename="deadline-iosched.c.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ftuhn1a11

ZGlmZiAtLWdpdCBhL2Jsb2NrL2RlYWRsaW5lLWlvc2NoZWQuYyBiL2Jsb2NrL2RlYWRsaW5lLWlv
c2NoZWQuYwppbmRleCBjNGQ5OTFkLi41MjIyYjYxIDEwMDY0NAotLS0gYS9ibG9jay9kZWFkbGlu
ZS1pb3NjaGVkLmMKKysrIGIvYmxvY2svZGVhZGxpbmUtaW9zY2hlZC5jCkBAIC0xNywxMSArMTcs
MTIgQEAKIC8qCiAgKiBTZWUgRG9jdW1lbnRhdGlvbi9ibG9jay9kZWFkbGluZS1pb3NjaGVkLnR4
dAogICovCi1zdGF0aWMgY29uc3QgaW50IHJlYWRfZXhwaXJlID0gSFogLyAyOyAgLyogbWF4IHRp
bWUgYmVmb3JlIGEgcmVhZCBpcyBzdWJtaXR0ZWQuICovCi1zdGF0aWMgY29uc3QgaW50IHdyaXRl
X2V4cGlyZSA9IDUgKiBIWjsgLyogZGl0dG8gZm9yIHdyaXRlcywgdGhlc2UgbGltaXRzIGFyZSBT
T0ZUISAqLwotc3RhdGljIGNvbnN0IGludCB3cml0ZXNfc3RhcnZlZCA9IDI7ICAgIC8qIG1heCB0
aW1lcyByZWFkcyBjYW4gc3RhcnZlIGEgd3JpdGUgKi8KLXN0YXRpYyBjb25zdCBpbnQgZmlmb19i
YXRjaCA9IDE2OyAgICAgICAvKiAjIG9mIHNlcXVlbnRpYWwgcmVxdWVzdHMgdHJlYXRlZCBhcyBv
bmUKLQkJCQkgICAgIGJ5IHRoZSBhYm92ZSBwYXJhbWV0ZXJzLiBGb3IgdGhyb3VnaHB1dC4gKi8K
K3N0YXRpYyBjb25zdCBpbnQgcnRfc3luY19leHBpcmUgPSBIWiAvIDg7ICAvKiBtYXggdGltZSBi
ZWZvcmUgYSByZWFsLXRpbWUgc3luYyBvcGVyYXRpb24gKGUuZy4gcmVhZCBmb3IgUlQgY2xhc3Mg
cHJvY2VzcykgaXMgc3VibWl0dGVkLiAqLworc3RhdGljIGNvbnN0IGludCBzeW5jX2V4cGlyZSA9
IEhaIC8gMjsgICAgIC8qIG1heCB0aW1lIGJlZm9yZSBhIHN5bmMgb3BlcmF0aW9uIChlLmcuIHJl
YWQpIGlzIHN1Ym1pdHRlZC4gKi8KK3N0YXRpYyBjb25zdCBpbnQgYXN5bmNfZXhwaXJlID0gNSAq
IEhaOyAgICAvKiBkaXR0byBmb3IgYXN5bmMgb3BlcmF0aW9ucyAoZS5nLiB3cml0ZXMpLCB0aGVz
ZSBsaW1pdHMgYXJlIFNPRlQhICovCitzdGF0aWMgY29uc3QgaW50IGFzeW5jX3N0YXJ2ZWQgPSAy
OyAgICAgICAgLyogbWF4IHRpbWVzIFNZTkMgY2FuIHN0YXJ2ZSBBU1lOQyByZXF1ZXN0cyAqLwor
c3RhdGljIGNvbnN0IGludCBmaWZvX2JhdGNoID0gMTY7ICAgICAgICAgIC8qIG1pbiAjIG9mIHNl
cXVlbnRpYWwgcmVxdWVzdHMgdHJlYXRlZCBhcyBvbmUgYnkgdGhlIGFib3ZlIHBhcmFtZXRlcnMu
IEZvciB0aHJvdWdocHV0LiAqLworc3RhdGljIGNvbnN0IGludCB0aW1lX3F1YW50dW0gID0gSFog
LyAxMDsgIC8qIG1pbiBkdXJhdGlvbiBmb3IgYSBiYXRjaCAqLwogCiBzdHJ1Y3QgZGVhZGxpbmVf
ZGF0YSB7CiAJLyoKQEAgLTMxLDI3ICszMiwzMyBAQCBzdHJ1Y3QgZGVhZGxpbmVfZGF0YSB7CiAJ
LyoKIAkgKiByZXF1ZXN0cyAoZGVhZGxpbmVfcnEgcykgYXJlIHByZXNlbnQgb24gYm90aCBzb3J0
X2xpc3QgYW5kIGZpZm9fbGlzdAogCSAqLwotCXN0cnVjdCByYl9yb290IHNvcnRfbGlzdFsyXTsJ
Ci0Jc3RydWN0IGxpc3RfaGVhZCBmaWZvX2xpc3RbMl07CisJc3RydWN0IHJiX3Jvb3Qgc29ydF9s
aXN0WzJdOyAvKiBSRUFELCBXUklURSAqLworCXN0cnVjdCBsaXN0X2hlYWQgZmlmb19saXN0WzNd
OyAvKiAwPUFTWU5DIChvciBJRExFKSwgMT1TWU5DIChvciBSVCBBU1lOQyksIDI9UlQgU1lOQyAq
LwogCiAJLyoKLQkgKiBuZXh0IGluIHNvcnQgb3JkZXIuIHJlYWQsIHdyaXRlIG9yIGJvdGggYXJl
IE5VTEwKKwkgKiBuZXh0IGluIHNvcnQgb3JkZXIuCiAJICovCi0Jc3RydWN0IHJlcXVlc3QgKm5l
eHRfcnFbMl07CisJc3RydWN0IHJlcXVlc3QgKm5leHRfcnE7CiAJdW5zaWduZWQgaW50IGJhdGNo
aW5nOwkJLyogbnVtYmVyIG9mIHNlcXVlbnRpYWwgcmVxdWVzdHMgbWFkZSAqLwotCXNlY3Rvcl90
IGxhc3Rfc2VjdG9yOwkJLyogaGVhZCBwb3NpdGlvbiAqLwogCXVuc2lnbmVkIGludCBzdGFydmVk
OwkJLyogdGltZXMgcmVhZHMgaGF2ZSBzdGFydmVkIHdyaXRlcyAqLwogCiAJLyoKIAkgKiBzZXR0
aW5ncyB0aGF0IGNoYW5nZSBob3cgdGhlIGkvbyBzY2hlZHVsZXIgYmVoYXZlcwogCSAqLwotCWlu
dCBmaWZvX2V4cGlyZVsyXTsKKwlpbnQgZmlmb19leHBpcmVbM107CisJaW50IHRpbWVfcXVhbnR1
bTsKIAlpbnQgZmlmb19iYXRjaDsKLQlpbnQgd3JpdGVzX3N0YXJ2ZWQ7CisJaW50IGFzeW5jX3N0
YXJ2ZWQ7CiAJaW50IGZyb250X21lcmdlczsKKworCS8qCisJICBjdXJyZW50IGJhdGNoIGRhdGEg
JiBzdGF0cworCSAqLworCWludCBjdXJfYmF0Y2hfcHJpbzsKKwl1bnNpZ25lZCBsb25nIGN1cl9i
YXRjaF9zdGFydDsKIH07CiAKLXN0YXRpYyB2b2lkIGRlYWRsaW5lX21vdmVfcmVxdWVzdChzdHJ1
Y3QgZGVhZGxpbmVfZGF0YSAqLCBzdHJ1Y3QgcmVxdWVzdCAqKTsKK3N0YXRpYyB2b2lkIGRlYWRs
aW5lX21vdmVfcmVxdWVzdChzdHJ1Y3QgZGVhZGxpbmVfZGF0YSAqLCBzdHJ1Y3QgcmVxdWVzdCAq
LCBpbnQgbm9ucm90KTsKIAogc3RhdGljIGlubGluZSBzdHJ1Y3QgcmJfcm9vdCAqCiBkZWFkbGlu
ZV9yYl9yb290KHN0cnVjdCBkZWFkbGluZV9kYXRhICpkZCwgc3RydWN0IHJlcXVlc3QgKnJxKQpA
QCAtNjMsNyArNzAsNyBAQCBkZWFkbGluZV9yYl9yb290KHN0cnVjdCBkZWFkbGluZV9kYXRhICpk
ZCwgc3RydWN0IHJlcXVlc3QgKnJxKQogICogZ2V0IHRoZSByZXF1ZXN0IGFmdGVyIGBycScgaW4g
c2VjdG9yLXNvcnRlZCBvcmRlcgogICovCiBzdGF0aWMgaW5saW5lIHN0cnVjdCByZXF1ZXN0ICoK
LWRlYWRsaW5lX2xhdHRlcl9yZXF1ZXN0KHN0cnVjdCByZXF1ZXN0ICpycSkKK2RlYWRsaW5lX25l
eHRfcmVxdWVzdChzdHJ1Y3QgcmVxdWVzdCAqcnEpCiB7CiAJc3RydWN0IHJiX25vZGUgKm5vZGUg
PSByYl9uZXh0KCZycS0+cmJfbm9kZSk7CiAKQEAgLTczLDI3ICs4MCwxMTggQEAgZGVhZGxpbmVf
bGF0dGVyX3JlcXVlc3Qoc3RydWN0IHJlcXVlc3QgKnJxKQogCXJldHVybiBOVUxMOwogfQogCisv
KgorICogZ2V0IHRoZSByZXF1ZXN0IGJlZm9yZSBgcnEnIGluIHNlY3Rvci1zb3J0ZWQgb3JkZXIK
KyAqLworc3RhdGljIGlubGluZSBzdHJ1Y3QgcmVxdWVzdCAqCitkZWFkbGluZV9wcmV2X3JlcXVl
c3Qoc3RydWN0IHJlcXVlc3QgKnJxKQoreworCXN0cnVjdCByYl9ub2RlICpub2RlID0gcmJfcHJl
digmcnEtPnJiX25vZGUpOworCisJaWYgKG5vZGUpCisJCXJldHVybiByYl9lbnRyeV9ycShub2Rl
KTsKKworCXJldHVybiBOVUxMOworfQorCiBzdGF0aWMgdm9pZAotZGVhZGxpbmVfYWRkX3JxX3Ji
KHN0cnVjdCBkZWFkbGluZV9kYXRhICpkZCwgc3RydWN0IHJlcXVlc3QgKnJxKQorZGVhZGxpbmVf
YWRkX3JxX3JiKHN0cnVjdCBkZWFkbGluZV9kYXRhICpkZCwgc3RydWN0IHJlcXVlc3QgKnJxLCBp
bnQgbm9ucm90KQogewogCXN0cnVjdCByYl9yb290ICpyb290ID0gZGVhZGxpbmVfcmJfcm9vdChk
ZCwgcnEpOwogCXN0cnVjdCByZXF1ZXN0ICpfX2FsaWFzOwogCiAJd2hpbGUgKHVubGlrZWx5KF9f
YWxpYXMgPSBlbHZfcmJfYWRkKHJvb3QsIHJxKSkpCi0JCWRlYWRsaW5lX21vdmVfcmVxdWVzdChk
ZCwgX19hbGlhcyk7CisJCWRlYWRsaW5lX21vdmVfcmVxdWVzdChkZCwgX19hbGlhcywgbm9ucm90
KTsKIH0KIAogc3RhdGljIGlubGluZSB2b2lkCiBkZWFkbGluZV9kZWxfcnFfcmIoc3RydWN0IGRl
YWRsaW5lX2RhdGEgKmRkLCBzdHJ1Y3QgcmVxdWVzdCAqcnEpCiB7Ci0JY29uc3QgaW50IGRhdGFf
ZGlyID0gcnFfZGF0YV9kaXIocnEpOwotCi0JaWYgKGRkLT5uZXh0X3JxW2RhdGFfZGlyXSA9PSBy
cSkKLQkJZGQtPm5leHRfcnFbZGF0YV9kaXJdID0gZGVhZGxpbmVfbGF0dGVyX3JlcXVlc3QocnEp
OworCWlmIChkZC0+bmV4dF9ycSA9PSBycSkKKwkJZGQtPm5leHRfcnEgPSBkZWFkbGluZV9uZXh0
X3JlcXVlc3QocnEpOwogCiAJZWx2X3JiX2RlbChkZWFkbGluZV9yYl9yb290KGRkLCBycSksIHJx
KTsKIH0KIAorc3RhdGljIHZvaWQKK2xpc3RfYWRkX3RpbWVzb3J0ZWQoc3RydWN0IGxpc3RfaGVh
ZCAqcSwgc3RydWN0IHJlcXVlc3QgKnJxKQoreworCXN0cnVjdCBsaXN0X2hlYWQgKmVudHJ5Owor
CWludCBzdG9wX2ZsYWdzID0gUkVRX1NPRlRCQVJSSUVSIHwgUkVRX0hBUkRCQVJSSUVSIHwgUkVR
X1NUQVJURUQ7CisJbGlzdF9mb3JfZWFjaF9wcmV2KGVudHJ5LCBxKSB7CisJCXN0cnVjdCByZXF1
ZXN0ICpwb3MgPSBsaXN0X2VudHJ5X3JxKGVudHJ5KTsKKwkJaWYgKHBvcy0+Y21kX2ZsYWdzICYg
c3RvcF9mbGFncykKKwkJCWJyZWFrOworCQlpZiAocnFfZmlmb190aW1lKHJxKSA+IHJxX2ZpZm9f
dGltZShwb3MpKQorCQkJYnJlYWs7CisJCWlmIChycV9maWZvX3RpbWUocnEpID09IHJxX2ZpZm9f
dGltZShwb3MpICYmCisJCSAgICBycS0+c2VjdG9yID49IHBvcy0+c2VjdG9yKQorCQkJYnJlYWs7
CisJfQorCWxpc3RfYWRkKCZycS0+cXVldWVsaXN0LCBlbnRyeSk7Cit9CisKK3N0YXRpYyBpbnQg
aW9wcmlvX2x1Yih1bnNpZ25lZCBzaG9ydCBhcHJpbywgdW5zaWduZWQgc2hvcnQgYnByaW8pCit7
CisJdW5zaWduZWQgc2hvcnQgYWNsYXNzID0gSU9QUklPX1BSSU9fQ0xBU1MoYXByaW8pOworCXVu
c2lnbmVkIHNob3J0IGJjbGFzcyA9IElPUFJJT19QUklPX0NMQVNTKGJwcmlvKTsKKworCWlmIChh
Y2xhc3MgPT0gSU9QUklPX0NMQVNTX05PTkUpCisJCXJldHVybiBicHJpbzsKKwlpZiAoYmNsYXNz
ID09IElPUFJJT19DTEFTU19OT05FKQorCQlyZXR1cm4gYXByaW87CisKKwlpZiAoYWNsYXNzID09
IGJjbGFzcykKKwkJcmV0dXJuIG1pbihhcHJpbywgYnByaW8pOworCWlmIChhY2xhc3MgPiBiY2xh
c3MpCisJCXJldHVybiBicHJpbzsKKwllbHNlCisJCXJldHVybiBhcHJpbzsKK30KKworc3RhdGlj
IHZvaWQKK2RlYWRsaW5lX21lcmdlX3ByaW9fZGF0YShzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwg
c3RydWN0IHJlcXVlc3QgKnJxKQoreworCXN0cnVjdCB0YXNrX3N0cnVjdCAqdHNrID0gY3VycmVu
dDsKKwlzdHJ1Y3QgaW9fY29udGV4dCAqaW9jID0gZ2V0X2lvX2NvbnRleHQoR0ZQX0FUT01JQyxx
LT5ub2RlKTsKKwlpbnQgaW9wcmlvX2NsYXNzID0gSU9QUklPX0NMQVNTX05PTkU7CisJaW50IGlv
cHJpbyA9IElPUFJJT19OT1JNOworCisJaWYoaW9jKSB7CisJCWlvcHJpb19jbGFzcyA9IHRhc2tf
aW9wcmlvX2NsYXNzKGlvYyk7CisJfQorCisJc3dpdGNoIChpb3ByaW9fY2xhc3MpIHsKKwlkZWZh
dWx0OgorCQlwcmludGsoS0VSTl9FUlIgImRlYWRsaW5lOiBiYWQgcHJpbyAleFxuIiwgaW9wcmlv
X2NsYXNzKTsKKwljYXNlIElPUFJJT19DTEFTU19OT05FOgorCQkvKgorCQkgKiBubyBwcmlvIHNl
dCwgaW5oZXJpdCBDUFUgc2NoZWR1bGluZyBzZXR0aW5ncworCQkgKi8KKwkJaW9wcmlvID0gdGFz
a19uaWNlX2lvcHJpbyh0c2spOworCQlpb3ByaW9fY2xhc3MgPSB0YXNrX25pY2VfaW9jbGFzcyh0
c2spOworCQlicmVhazsKKwljYXNlIElPUFJJT19DTEFTU19SVDoKKwljYXNlIElPUFJJT19DTEFT
U19CRToKKwkJaW9wcmlvID0gdGFza19pb3ByaW8oaW9jKTsKKwkJYnJlYWs7CisJY2FzZSBJT1BS
SU9fQ0xBU1NfSURMRToKKwkJaW9wcmlvID0gNzsKKwkJYnJlYWs7CisJfQorCisJaW9wcmlvPUlP
UFJJT19QUklPX1ZBTFVFKGlvcHJpb19jbGFzcyxpb3ByaW8pOworCXJxLT5pb3ByaW89aW9wcmlv
X2x1YihycS0+aW9wcmlvLGlvcHJpbyk7Cit9CisKK3N0YXRpYyBpbnQKK2RlYWRsaW5lX2NvbXB1
dGVfcmVxdWVzdF9wcmlvcml0eShzdHJ1Y3QgcmVxdWVzdCAqcmVxKQoreworCXVuc2lnbmVkIHNo
b3J0IGlvcHJpb19jbGFzcz1JT1BSSU9fUFJJT19DTEFTUyhyZXFfZ2V0X2lvcHJpbyhyZXEpKTsK
KwlyZXR1cm4gKGlvcHJpb19jbGFzcyE9SU9QUklPX0NMQVNTX0lETEUpKgorCQkoISFycV9pc19z
eW5jKHJlcSkgKyAocnFfZGF0YV9kaXIocmVxKT09UkVBRCkqKGlvcHJpb19jbGFzcz09SU9QUklP
X0NMQVNTX1JUKSk7Cit9CisKIC8qCiAgKiBhZGQgcnEgdG8gcmJ0cmVlIGFuZCBmaWZvCiAgKi8K
QEAgLTEwMSwxNSArMTk5LDE3IEBAIHN0YXRpYyB2b2lkCiBkZWFkbGluZV9hZGRfcmVxdWVzdChz
dHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0IHJlcXVlc3QgKnJxKQogewogCXN0cnVjdCBk
ZWFkbGluZV9kYXRhICpkZCA9IHEtPmVsZXZhdG9yLT5lbGV2YXRvcl9kYXRhOwotCWNvbnN0IGlu
dCBkYXRhX2RpciA9IHJxX2RhdGFfZGlyKHJxKTsKIAotCWRlYWRsaW5lX2FkZF9ycV9yYihkZCwg
cnEpOworCWRlYWRsaW5lX21lcmdlX3ByaW9fZGF0YShxLHJxKTsKKwlkZWFkbGluZV9hZGRfcnFf
cmIoZGQsIHJxLCBibGtfcXVldWVfbm9ucm90KHEpKTsKIAogCS8qCi0JICogc2V0IGV4cGlyZSB0
aW1lIGFuZCBhZGQgdG8gZmlmbyBsaXN0CisJICogc2V0IHJlcXVlc3QgY3JlYXRpb24gdGltZSBh
bmQgYWRkIHRvIGZpZm8gbGlzdAogCSAqLwotCXJxX3NldF9maWZvX3RpbWUocnEsIGppZmZpZXMg
KyBkZC0+Zmlmb19leHBpcmVbZGF0YV9kaXJdKTsKLQlsaXN0X2FkZF90YWlsKCZycS0+cXVldWVs
aXN0LCAmZGQtPmZpZm9fbGlzdFtkYXRhX2Rpcl0pOworCisJcnFfc2V0X2ZpZm9fdGltZShycSwg
amlmZmllcyk7CisJCisJbGlzdF9hZGRfdGltZXNvcnRlZCgmZGQtPmZpZm9fbGlzdFtkZWFkbGlu
ZV9jb21wdXRlX3JlcXVlc3RfcHJpb3JpdHkocnEpXSxycSk7CiB9CiAKIC8qCkBAIC0xNTcsMTQg
KzI1NywxNiBAQCBzdGF0aWMgdm9pZCBkZWFkbGluZV9tZXJnZWRfcmVxdWVzdChzdHJ1Y3QgcmVx
dWVzdF9xdWV1ZSAqcSwKIAkJCQkgICAgc3RydWN0IHJlcXVlc3QgKnJlcSwgaW50IHR5cGUpCiB7
CiAJc3RydWN0IGRlYWRsaW5lX2RhdGEgKmRkID0gcS0+ZWxldmF0b3ItPmVsZXZhdG9yX2RhdGE7
Ci0KIAkvKgogCSAqIGlmIHRoZSBtZXJnZSB3YXMgYSBmcm9udCBtZXJnZSwgd2UgbmVlZCB0byBy
ZXBvc2l0aW9uIHJlcXVlc3QKIAkgKi8KIAlpZiAodHlwZSA9PSBFTEVWQVRPUl9GUk9OVF9NRVJH
RSkgewogCQllbHZfcmJfZGVsKGRlYWRsaW5lX3JiX3Jvb3QoZGQsIHJlcSksIHJlcSk7Ci0JCWRl
YWRsaW5lX2FkZF9ycV9yYihkZCwgcmVxKTsKKwkJZGVhZGxpbmVfYWRkX3JxX3JiKGRkLCByZXEs
IGJsa19xdWV1ZV9ub25yb3QocSkpOwogCX0KKworCWRlYWRsaW5lX21lcmdlX3ByaW9fZGF0YShx
LHJlcSk7CisKIH0KIAogc3RhdGljIHZvaWQKQEAgLTE3Miw3ICsyNzQsNyBAQCBkZWFkbGluZV9t
ZXJnZWRfcmVxdWVzdHMoc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsIHN0cnVjdCByZXF1ZXN0ICpy
ZXEsCiAJCQkgc3RydWN0IHJlcXVlc3QgKm5leHQpCiB7CiAJLyoKLQkgKiBpZiBuZXh0IGV4cGly
ZXMgYmVmb3JlIHJxLCBhc3NpZ24gaXRzIGV4cGlyZSB0aW1lIHRvIHJxCisJICogcmVxdWVzdCB0
aGF0IGNhbm5vdCBpZGxlLiBpZiBuZXh0IGV4cGlyZXMgYmVmb3JlIHJxLCBhc3NpZ24gaXRzIGV4
cGlyZSB0aW1lIHRvIHJxCiAJICogYW5kIG1vdmUgaW50byBuZXh0IHBvc2l0aW9uIChuZXh0IHdp
bGwgYmUgZGVsZXRlZCkgaW4gZmlmbwogCSAqLwogCWlmICghbGlzdF9lbXB0eSgmcmVxLT5xdWV1
ZWxpc3QpICYmICFsaXN0X2VtcHR5KCZuZXh0LT5xdWV1ZWxpc3QpKSB7CkBAIC0yMDQsMTUgKzMw
NiwzMyBAQCBkZWFkbGluZV9tb3ZlX3RvX2Rpc3BhdGNoKHN0cnVjdCBkZWFkbGluZV9kYXRhICpk
ZCwgc3RydWN0IHJlcXVlc3QgKnJxKQogICogbW92ZSBhbiBlbnRyeSB0byBkaXNwYXRjaCBxdWV1
ZQogICovCiBzdGF0aWMgdm9pZAotZGVhZGxpbmVfbW92ZV9yZXF1ZXN0KHN0cnVjdCBkZWFkbGlu
ZV9kYXRhICpkZCwgc3RydWN0IHJlcXVlc3QgKnJxKQorZGVhZGxpbmVfbW92ZV9yZXF1ZXN0KHN0
cnVjdCBkZWFkbGluZV9kYXRhICpkZCwgc3RydWN0IHJlcXVlc3QgKnJxLCBpbnQgbm9ucm90KQog
ewogCWNvbnN0IGludCBkYXRhX2RpciA9IHJxX2RhdGFfZGlyKHJxKTsKKwlkZC0+bmV4dF9ycSA9
IE5VTEw7CisKKwlpZihkYXRhX2RpciAhPSBSRUFEIHx8ICFub25yb3QpIHsKKwkJaW50IG1heF9z
ZWFyY2ggPSBkZC0+Zmlmb19iYXRjaDsKKwkJLyogZm9yIHJvdCBkZXZpY2VzLCBvciB3cml0ZXMg
b24gbm9uLXJvdCwgcmVxdWVzdHMgYXJlIGRpc3BhdGNoZWQgaW4gZGlzayBvcmRlciAqLworCQlk
ZC0+bmV4dF9ycSA9IHJxOworCQkvKiB0cnkgdG8gZ2V0IHJlcXVlc3RzIG9mIGF0IGxlYXN0IHRo
ZSBzYW1lIHByaW9yaXR5IGFzIGN1cnJlbnQgb25lICovCisJCXdoaWxlKG1heF9zZWFyY2gtLSAm
JiAoZGQtPm5leHRfcnEgPSBkZWFkbGluZV9uZXh0X3JlcXVlc3QoZGQtPm5leHRfcnEpKSAmJiBk
ZC0+Y3VyX2JhdGNoX3ByaW8+ZGVhZGxpbmVfY29tcHV0ZV9yZXF1ZXN0X3ByaW9yaXR5KGRkLT5u
ZXh0X3JxKSk7CisJCWlmKCFtYXhfc2VhcmNoIHx8ICFkZC0+bmV4dF9ycSkgeyAvLyBkaWQgbm90
IGdldCBhIG5leHQgb2YgdGhlIHNhbWUgcHJpb3JpdHksIGRlbW90ZSBiYXRjaCB0byBsb3dlciwg
YW5kIGNvbnRpbnVlIGluIGRpc2sgb3JkZXIKKwkJCWRkLT5uZXh0X3JxID0gZGVhZGxpbmVfbmV4
dF9yZXF1ZXN0KHJxKTsKKwkJCWlmKGRkLT5uZXh0X3JxKSBkZC0+Y3VyX2JhdGNoX3ByaW8gPSBk
ZWFkbGluZV9jb21wdXRlX3JlcXVlc3RfcHJpb3JpdHkoZGQtPm5leHRfcnEpOworCQl9CiAKLQlk
ZC0+bmV4dF9ycVtSRUFEXSA9IE5VTEw7Ci0JZGQtPm5leHRfcnFbV1JJVEVdID0gTlVMTDsKLQlk
ZC0+bmV4dF9ycVtkYXRhX2Rpcl0gPSBkZWFkbGluZV9sYXR0ZXJfcmVxdWVzdChycSk7Ci0KLQlk
ZC0+bGFzdF9zZWN0b3IgPSBycV9lbmRfc2VjdG9yKHJxKTsKKwl9IGVsc2UgeyAvKiBub25yb3Qg
JiYgZGF0YV9kaXI9PVJFQUQgOiByZXF1ZXN0cyBhcmUgZGlzcGF0Y2hlZCBpbiBkZWFkbGluZSBv
cmRlciAqLworCQlzdHJ1Y3QgbGlzdF9oZWFkICplbnRyeTsKKwkJbGlzdF9mb3JfZWFjaChlbnRy
eSwgJmRkLT5maWZvX2xpc3RbZGQtPmN1cl9iYXRjaF9wcmlvXSkgeworCQkJc3RydWN0IHJlcXVl
c3QgKnBvcyA9IGxpc3RfZW50cnlfcnEoZW50cnkpOworCQkJaWYocG9zPT1ycSkgY29udGludWU7
CisJCQlpZihycV9kYXRhX2Rpcihwb3MpPT1kYXRhX2RpcikgeyAvKiBmaW5kIHNhbWUgZGlyZWN0
aW9uIChhbHdheXMgUkVBRCkgKi8KKwkJCQlkZC0+bmV4dF9ycSA9IHBvczsKKwkJCQlicmVhazsK
KwkJCX0KKwkJfQorCX0KIAogCS8qCiAJICogdGFrZSBpdCBvZmYgdGhlIHNvcnQgYW5kIGZpZm8g
bGlzdCwgbW92ZQpAQCAtMjIyLDIwICszNDIsMTYgQEAgZGVhZGxpbmVfbW92ZV9yZXF1ZXN0KHN0
cnVjdCBkZWFkbGluZV9kYXRhICpkZCwgc3RydWN0IHJlcXVlc3QgKnJxKQogfQogCiAvKgotICog
ZGVhZGxpbmVfY2hlY2tfZmlmbyByZXR1cm5zIDAgaWYgdGhlcmUgYXJlIG5vIGV4cGlyZWQgcmVx
dWVzdHMgb24gdGhlIGZpZm8sCi0gKiAxIG90aGVyd2lzZS4gUmVxdWlyZXMgIWxpc3RfZW1wdHko
JmRkLT5maWZvX2xpc3RbZGF0YV9kaXJdKQorICogZGVhZGxpbmVfY2hlY2tfZmlmbyByZXR1cm5z
IDAgaWYgdGhlcmUgYXJlIG5vIGV4cGlyZWQgcmVxdWVzdHMgb24gdGhlIGZpZm8gZm9yIGdpdmVu
IHByaW9yaXR5LAorICogMSBvdGhlcndpc2UuIFJlcXVpcmVzICFsaXN0X2VtcHR5KCZkZC0+Zmlm
b19saXN0W3ByaW9dKQogICovCi1zdGF0aWMgaW5saW5lIGludCBkZWFkbGluZV9jaGVja19maWZv
KHN0cnVjdCBkZWFkbGluZV9kYXRhICpkZCwgaW50IGRkaXIpCitzdGF0aWMgaW5saW5lIGludCBk
ZWFkbGluZV9jaGVja19yZXF1ZXN0KHN0cnVjdCBkZWFkbGluZV9kYXRhICpkZCwgdW5zaWduZWQg
cHJpbykgCiB7Ci0Jc3RydWN0IHJlcXVlc3QgKnJxID0gcnFfZW50cnlfZmlmbyhkZC0+Zmlmb19s
aXN0W2RkaXJdLm5leHQpOwotCisJQlVHX09OKGxpc3RfZW1wdHkoJmRkLT5maWZvX2xpc3RbcHJp
b10pKTsKIAkvKgotCSAqIHJxIGlzIGV4cGlyZWQhCisJICogZGVhZGxpbmUgaXMgZXhwaXJlZCEK
IAkgKi8KLQlpZiAodGltZV9hZnRlcihqaWZmaWVzLCBycV9maWZvX3RpbWUocnEpKSkKLQkJcmV0
dXJuIDE7Ci0KLQlyZXR1cm4gMDsKKwlyZXR1cm4gdGltZV9hZnRlcihqaWZmaWVzLCBkZC0+Zmlm
b19leHBpcmVbcHJpb10gKyBycV9maWZvX3RpbWUocnFfZW50cnlfZmlmbyhkZC0+Zmlmb19saXN0
W3ByaW9dLm5leHQpKSk7CiB9CiAKIC8qCkBAIC0yNDUsMzYgKzM2MSwzMSBAQCBzdGF0aWMgaW5s
aW5lIGludCBkZWFkbGluZV9jaGVja19maWZvKHN0cnVjdCBkZWFkbGluZV9kYXRhICpkZCwgaW50
IGRkaXIpCiBzdGF0aWMgaW50IGRlYWRsaW5lX2Rpc3BhdGNoX3JlcXVlc3RzKHN0cnVjdCByZXF1
ZXN0X3F1ZXVlICpxLCBpbnQgZm9yY2UpCiB7CiAJc3RydWN0IGRlYWRsaW5lX2RhdGEgKmRkID0g
cS0+ZWxldmF0b3ItPmVsZXZhdG9yX2RhdGE7Ci0JY29uc3QgaW50IHJlYWRzID0gIWxpc3RfZW1w
dHkoJmRkLT5maWZvX2xpc3RbUkVBRF0pOwotCWNvbnN0IGludCB3cml0ZXMgPSAhbGlzdF9lbXB0
eSgmZGQtPmZpZm9fbGlzdFtXUklURV0pOwotCXN0cnVjdCByZXF1ZXN0ICpycTsKLQlpbnQgZGF0
YV9kaXI7CisJaW50IHJ0XyA9ICFsaXN0X2VtcHR5KCZkZC0+Zmlmb19saXN0WzJdKTsKKwlpbnQg
c3luY18gPSAhbGlzdF9lbXB0eSgmZGQtPmZpZm9fbGlzdFsxXSk7CisJaW50IGFzeW5jXyA9ICFs
aXN0X2VtcHR5KCZkZC0+Zmlmb19saXN0WzBdKTsKKwlzdHJ1Y3QgcmVxdWVzdCAqcnEgPSBkZC0+
bmV4dF9ycTsKKwlpbnQgcmVxdWVzdF9wcmlvID0gZGQtPmN1cl9iYXRjaF9wcmlvOwogCi0JLyoK
LQkgKiBiYXRjaGVzIGFyZSBjdXJyZW50bHkgcmVhZHMgWE9SIHdyaXRlcwotCSAqLwotCWlmIChk
ZC0+bmV4dF9ycVtXUklURV0pCi0JCXJxID0gZGQtPm5leHRfcnFbV1JJVEVdOwotCWVsc2UKLQkJ
cnEgPSBkZC0+bmV4dF9ycVtSRUFEXTsKLQotCWlmIChycSAmJiBkZC0+YmF0Y2hpbmcgPCBkZC0+
Zmlmb19iYXRjaCkKKwlpZiAocnEgJiYgKGRkLT5iYXRjaGluZyA8IGRkLT5maWZvX2JhdGNoIHx8
IGppZmZpZXMtZGQtPmN1cl9iYXRjaF9zdGFydCA8IGRkLT50aW1lX3F1YW50dW0pKSB7CiAJCS8q
IHdlIGhhdmUgYSBuZXh0IHJlcXVlc3QgYXJlIHN0aWxsIGVudGl0bGVkIHRvIGJhdGNoICovCiAJ
CWdvdG8gZGlzcGF0Y2hfcmVxdWVzdDsKKwl9CiAKIAkvKgogCSAqIGF0IHRoaXMgcG9pbnQgd2Ug
YXJlIG5vdCBydW5uaW5nIGEgYmF0Y2guIHNlbGVjdCB0aGUgYXBwcm9wcmlhdGUKIAkgKiBkYXRh
IGRpcmVjdGlvbiAocmVhZCAvIHdyaXRlKQogCSAqLwogCi0JaWYgKHJlYWRzKSB7Ci0JCUJVR19P
TihSQl9FTVBUWV9ST09UKCZkZC0+c29ydF9saXN0W1JFQURdKSk7Ci0KLQkJaWYgKHdyaXRlcyAm
JiAoZGQtPnN0YXJ2ZWQrKyA+PSBkZC0+d3JpdGVzX3N0YXJ2ZWQpKQotCQkJZ290byBkaXNwYXRj
aF93cml0ZXM7Ci0KLQkJZGF0YV9kaXIgPSBSRUFEOworCWlmIChydF8pIHsKKwkJcmVxdWVzdF9w
cmlvID0gMjsKKwkJZ290byBkaXNwYXRjaF9maW5kX3JlcXVlc3Q7CisJfQogCisJaWYgKHN5bmNf
KSB7CisJCWlmIChhc3luY18gJiYgKGRkLT5zdGFydmVkKysgPj0gZGQtPmFzeW5jX3N0YXJ2ZWQp
KQorCQkJZ290byBkaXNwYXRjaF9hc3luYzsKKwkJcmVxdWVzdF9wcmlvID0gMTsKIAkJZ290byBk
aXNwYXRjaF9maW5kX3JlcXVlc3Q7CiAJfQogCkBAIC0yODIsMzcgKzM5Myw0NCBAQCBzdGF0aWMg
aW50IGRlYWRsaW5lX2Rpc3BhdGNoX3JlcXVlc3RzKHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBp
bnQgZm9yY2UpCiAJICogdGhlcmUgYXJlIGVpdGhlciBubyByZWFkcyBvciB3cml0ZXMgaGF2ZSBi
ZWVuIHN0YXJ2ZWQKIAkgKi8KIAotCWlmICh3cml0ZXMpIHsKLWRpc3BhdGNoX3dyaXRlczoKLQkJ
QlVHX09OKFJCX0VNUFRZX1JPT1QoJmRkLT5zb3J0X2xpc3RbV1JJVEVdKSk7Ci0KKwlpZiAoYXN5
bmNfKSB7CitkaXNwYXRjaF9hc3luYzoKIAkJZGQtPnN0YXJ2ZWQgPSAwOwotCi0JCWRhdGFfZGly
ID0gV1JJVEU7Ci0KKwkJcmVxdWVzdF9wcmlvID0gMDsKIAkJZ290byBkaXNwYXRjaF9maW5kX3Jl
cXVlc3Q7CiAJfQogCisJZGQtPmN1cl9iYXRjaF9zdGFydD1qaWZmaWVzOworCWRkLT5iYXRjaGlu
ZyA9IDA7CiAJcmV0dXJuIDA7CiAKIGRpc3BhdGNoX2ZpbmRfcmVxdWVzdDoKKwogCS8qCi0JICog
d2UgYXJlIG5vdCBydW5uaW5nIGEgYmF0Y2gsIGZpbmQgYmVzdCByZXF1ZXN0IGZvciBzZWxlY3Rl
ZCBkYXRhX2RpcgorCSAqIHdlIGFyZSBub3QgcnVubmluZyBhIGJhdGNoLCBmaW5kIGJlc3QgcmVx
dWVzdCBmb3Igc2VsZWN0ZWQgcmVxdWVzdF9wcmlvCiAJICovCi0JaWYgKGRlYWRsaW5lX2NoZWNr
X2ZpZm8oZGQsIGRhdGFfZGlyKSB8fCAhZGQtPm5leHRfcnFbZGF0YV9kaXJdKSB7CisJaWYgKCFk
ZC0+bmV4dF9ycSB8fAorCSAgICBkZC0+Y3VyX2JhdGNoX3ByaW8gPCByZXF1ZXN0X3ByaW8gfHwK
KwkgICAgZGVhZGxpbmVfY2hlY2tfcmVxdWVzdChkZCwgcmVxdWVzdF9wcmlvKSkgewogCQkvKgot
CQkgKiBBIGRlYWRsaW5lIGhhcyBleHBpcmVkLCB0aGUgbGFzdCByZXF1ZXN0IHdhcyBpbiB0aGUg
b3RoZXIKLQkJICogZGlyZWN0aW9uLCBvciB3ZSBoYXZlIHJ1biBvdXQgb2YgaGlnaGVyLXNlY3Rv
cmVkIHJlcXVlc3RzLgotCQkgKiBTdGFydCBhZ2FpbiBmcm9tIHRoZSByZXF1ZXN0IHdpdGggdGhl
IGVhcmxpZXN0IGV4cGlyeSB0aW1lLgorCQkgKiBBIGRlYWRsaW5lIGhhcyBleHBpcmVkLCB0aGUg
cHJldmlvdXMgYmF0Y2ggaGFkIGEgbG93ZXIgcHJpb3JpdHksCisJCSAqIG9yIHdlIGhhdmUgcnVu
IG91dCBvZiBoaWdoZXItc2VjdG9yZWQgcmVxdWVzdHMuCisJCSAqIFN0YXJ0IGFnYWluIChhIGJp
dCBiZWZvcmUpIHRoZSByZXF1ZXN0IHdpdGggdGhlIGVhcmxpZXN0IGV4cGlyeSB0aW1lLgogCQkg
Ki8KLQkJcnEgPSBycV9lbnRyeV9maWZvKGRkLT5maWZvX2xpc3RbZGF0YV9kaXJdLm5leHQpOwor
CQlzdHJ1Y3QgcmVxdWVzdCAqIG5ycSA9IHJxX2VudHJ5X2ZpZm8oZGQtPmZpZm9fbGlzdFtyZXF1
ZXN0X3ByaW9dLm5leHQpOworCQlpbnQgYmF0Y2ggPSBkZC0+Zmlmb19iYXRjaC8zOworCQlycT1u
cnE7CisJCXdoaWxlKGJhdGNoLS0gJiYgKG5ycSA9IGRlYWRsaW5lX3ByZXZfcmVxdWVzdChucnEp
KSkKKwkJCWlmKHJlcXVlc3RfcHJpbzw9ZGVhZGxpbmVfY29tcHV0ZV9yZXF1ZXN0X3ByaW9yaXR5
KG5ycSkpIHJxID0gbnJxOwogCX0gZWxzZSB7CiAJCS8qCi0JCSAqIFRoZSBsYXN0IHJlcSB3YXMg
dGhlIHNhbWUgZGlyIGFuZCB3ZSBoYXZlIGEgbmV4dCByZXF1ZXN0IGluCisJCSAqIFRoZSBsYXN0
IGJhdGNoIHdhcyBzYW1lIG9yIGhpZ2hlciBwcmlvcml0eSBhbmQgd2UgaGF2ZSBhIG5leHQgcmVx
dWVzdCBpbgogCQkgKiBzb3J0IG9yZGVyLiBObyBleHBpcmVkIHJlcXVlc3RzIHNvIGNvbnRpbnVl
IG9uIGZyb20gaGVyZS4KIAkJICovCi0JCXJxID0gZGQtPm5leHRfcnFbZGF0YV9kaXJdOworCQly
cSA9IGRkLT5uZXh0X3JxOwogCX0KKwlkZC0+Y3VyX2JhdGNoX3ByaW8gPSByZXF1ZXN0X3ByaW87
CisJZGQtPmN1cl9iYXRjaF9zdGFydCA9IGppZmZpZXM7CiAKIAlkZC0+YmF0Y2hpbmcgPSAwOwog
CkBAIC0zMjAsMjYgKzQzOCwyOSBAQCBkaXNwYXRjaF9yZXF1ZXN0OgogCS8qCiAJICogcnEgaXMg
dGhlIHNlbGVjdGVkIGFwcHJvcHJpYXRlIHJlcXVlc3QuCiAJICovCi0JZGQtPmJhdGNoaW5nKys7
Ci0JZGVhZGxpbmVfbW92ZV9yZXF1ZXN0KGRkLCBycSk7CiAKKwlkZC0+YmF0Y2hpbmcrKzsKKwlk
ZWFkbGluZV9tb3ZlX3JlcXVlc3QoZGQsIHJxLCBibGtfcXVldWVfbm9ucm90KHEpKTsKIAlyZXR1
cm4gMTsKIH0KIAogc3RhdGljIGludCBkZWFkbGluZV9xdWV1ZV9lbXB0eShzdHJ1Y3QgcmVxdWVz
dF9xdWV1ZSAqcSkKIHsKIAlzdHJ1Y3QgZGVhZGxpbmVfZGF0YSAqZGQgPSBxLT5lbGV2YXRvci0+
ZWxldmF0b3JfZGF0YTsKLQotCXJldHVybiBsaXN0X2VtcHR5KCZkZC0+Zmlmb19saXN0W1dSSVRF
XSkKLQkJJiYgbGlzdF9lbXB0eSgmZGQtPmZpZm9fbGlzdFtSRUFEXSk7CisJcmV0dXJuIGxpc3Rf
ZW1wdHkoJmRkLT5maWZvX2xpc3RbMF0pCisJCSYmIGxpc3RfZW1wdHkoJmRkLT5maWZvX2xpc3Rb
MV0pCisJCSYmIGxpc3RfZW1wdHkoJmRkLT5maWZvX2xpc3RbMl0pOwogfQogCisKKwogc3RhdGlj
IHZvaWQgZGVhZGxpbmVfZXhpdF9xdWV1ZShzdHJ1Y3QgZWxldmF0b3JfcXVldWUgKmUpCiB7CiAJ
c3RydWN0IGRlYWRsaW5lX2RhdGEgKmRkID0gZS0+ZWxldmF0b3JfZGF0YTsKIAotCUJVR19PTigh
bGlzdF9lbXB0eSgmZGQtPmZpZm9fbGlzdFtSRUFEXSkpOwotCUJVR19PTighbGlzdF9lbXB0eSgm
ZGQtPmZpZm9fbGlzdFtXUklURV0pKTsKKwlCVUdfT04oIWxpc3RfZW1wdHkoJmRkLT5maWZvX2xp
c3RbMF0pKTsKKwlCVUdfT04oIWxpc3RfZW1wdHkoJmRkLT5maWZvX2xpc3RbMV0pKTsKKwlCVUdf
T04oIWxpc3RfZW1wdHkoJmRkLT5maWZvX2xpc3RbMl0pKTsKIAogCWtmcmVlKGRkKTsKIH0KQEAg
LTM1NSwxMyArNDc2LDE2IEBAIHN0YXRpYyB2b2lkICpkZWFkbGluZV9pbml0X3F1ZXVlKHN0cnVj
dCByZXF1ZXN0X3F1ZXVlICpxKQogCWlmICghZGQpCiAJCXJldHVybiBOVUxMOwogCi0JSU5JVF9M
SVNUX0hFQUQoJmRkLT5maWZvX2xpc3RbUkVBRF0pOwotCUlOSVRfTElTVF9IRUFEKCZkZC0+Zmlm
b19saXN0W1dSSVRFXSk7CisJSU5JVF9MSVNUX0hFQUQoJmRkLT5maWZvX2xpc3RbMF0pOworCUlO
SVRfTElTVF9IRUFEKCZkZC0+Zmlmb19saXN0WzFdKTsKKwlJTklUX0xJU1RfSEVBRCgmZGQtPmZp
Zm9fbGlzdFsyXSk7CiAJZGQtPnNvcnRfbGlzdFtSRUFEXSA9IFJCX1JPT1Q7CiAJZGQtPnNvcnRf
bGlzdFtXUklURV0gPSBSQl9ST09UOwotCWRkLT5maWZvX2V4cGlyZVtSRUFEXSA9IHJlYWRfZXhw
aXJlOwotCWRkLT5maWZvX2V4cGlyZVtXUklURV0gPSB3cml0ZV9leHBpcmU7Ci0JZGQtPndyaXRl
c19zdGFydmVkID0gd3JpdGVzX3N0YXJ2ZWQ7CisJZGQtPmZpZm9fZXhwaXJlWzBdID0gYXN5bmNf
ZXhwaXJlOworCWRkLT5maWZvX2V4cGlyZVsxXSA9IHN5bmNfZXhwaXJlOworCWRkLT5maWZvX2V4
cGlyZVsyXSA9IHJ0X3N5bmNfZXhwaXJlOworCWRkLT50aW1lX3F1YW50dW0gPSB0aW1lX3F1YW50
dW07CisJZGQtPmFzeW5jX3N0YXJ2ZWQgPSBhc3luY19zdGFydmVkOwogCWRkLT5mcm9udF9tZXJn
ZXMgPSAxOwogCWRkLT5maWZvX2JhdGNoID0gZmlmb19iYXRjaDsKIAlyZXR1cm4gZGQ7CkBAIC0z
OTUsOSArNTE5LDEyIEBAIHN0YXRpYyBzc2l6ZV90IF9fRlVOQyhzdHJ1Y3QgZWxldmF0b3JfcXVl
dWUgKmUsIGNoYXIgKnBhZ2UpCQlcCiAJCV9fZGF0YSA9IGppZmZpZXNfdG9fbXNlY3MoX19kYXRh
KTsJCQlcCiAJcmV0dXJuIGRlYWRsaW5lX3Zhcl9zaG93KF9fZGF0YSwgKHBhZ2UpKTsJCQlcCiB9
Ci1TSE9XX0ZVTkNUSU9OKGRlYWRsaW5lX3JlYWRfZXhwaXJlX3Nob3csIGRkLT5maWZvX2V4cGly
ZVtSRUFEXSwgMSk7Ci1TSE9XX0ZVTkNUSU9OKGRlYWRsaW5lX3dyaXRlX2V4cGlyZV9zaG93LCBk
ZC0+Zmlmb19leHBpcmVbV1JJVEVdLCAxKTsKLVNIT1dfRlVOQ1RJT04oZGVhZGxpbmVfd3JpdGVz
X3N0YXJ2ZWRfc2hvdywgZGQtPndyaXRlc19zdGFydmVkLCAwKTsKK1NIT1dfRlVOQ1RJT04oZGVh
ZGxpbmVfYXN5bmNfZXhwaXJlX3Nob3csIGRkLT5maWZvX2V4cGlyZVswXSwgMSk7CitTSE9XX0ZV
TkNUSU9OKGRlYWRsaW5lX3N5bmNfZXhwaXJlX3Nob3csIGRkLT5maWZvX2V4cGlyZVsxXSwgMSk7
CitTSE9XX0ZVTkNUSU9OKGRlYWRsaW5lX3J0X3N5bmNfZXhwaXJlX3Nob3csIGRkLT5maWZvX2V4
cGlyZVsyXSwgMSk7CitTSE9XX0ZVTkNUSU9OKGRlYWRsaW5lX3RpbWVfcXVhbnR1bV9zaG93LCBk
ZC0+dGltZV9xdWFudHVtLCAxKTsKKworU0hPV19GVU5DVElPTihkZWFkbGluZV9hc3luY19zdGFy
dmVkX3Nob3csIGRkLT5hc3luY19zdGFydmVkLCAwKTsKIFNIT1dfRlVOQ1RJT04oZGVhZGxpbmVf
ZnJvbnRfbWVyZ2VzX3Nob3csIGRkLT5mcm9udF9tZXJnZXMsIDApOwogU0hPV19GVU5DVElPTihk
ZWFkbGluZV9maWZvX2JhdGNoX3Nob3csIGRkLT5maWZvX2JhdGNoLCAwKTsKICN1bmRlZiBTSE9X
X0ZVTkNUSU9OCkBAIC00MTgsOSArNTQ1LDEyIEBAIHN0YXRpYyBzc2l6ZV90IF9fRlVOQyhzdHJ1
Y3QgZWxldmF0b3JfcXVldWUgKmUsIGNvbnN0IGNoYXIgKnBhZ2UsIHNpemVfdCBjb3VudCkKIAkJ
KihfX1BUUikgPSBfX2RhdGE7CQkJCQlcCiAJcmV0dXJuIHJldDsJCQkJCQkJXAogfQotU1RPUkVf
RlVOQ1RJT04oZGVhZGxpbmVfcmVhZF9leHBpcmVfc3RvcmUsICZkZC0+Zmlmb19leHBpcmVbUkVB
RF0sIDAsIElOVF9NQVgsIDEpOwotU1RPUkVfRlVOQ1RJT04oZGVhZGxpbmVfd3JpdGVfZXhwaXJl
X3N0b3JlLCAmZGQtPmZpZm9fZXhwaXJlW1dSSVRFXSwgMCwgSU5UX01BWCwgMSk7Ci1TVE9SRV9G
VU5DVElPTihkZWFkbGluZV93cml0ZXNfc3RhcnZlZF9zdG9yZSwgJmRkLT53cml0ZXNfc3RhcnZl
ZCwgSU5UX01JTiwgSU5UX01BWCwgMCk7CitTVE9SRV9GVU5DVElPTihkZWFkbGluZV9hc3luY19l
eHBpcmVfc3RvcmUsICZkZC0+Zmlmb19leHBpcmVbMF0sIDAsIElOVF9NQVgsIDEpOworU1RPUkVf
RlVOQ1RJT04oZGVhZGxpbmVfc3luY19leHBpcmVfc3RvcmUsICZkZC0+Zmlmb19leHBpcmVbMV0s
IDAsIElOVF9NQVgsIDEpOworU1RPUkVfRlVOQ1RJT04oZGVhZGxpbmVfcnRfc3luY19leHBpcmVf
c3RvcmUsICZkZC0+Zmlmb19leHBpcmVbMl0sIDAsIElOVF9NQVgsIDEpOworU1RPUkVfRlVOQ1RJ
T04oZGVhZGxpbmVfdGltZV9xdWFudHVtX3N0b3JlLCAmZGQtPnRpbWVfcXVhbnR1bSwgMCwgSU5U
X01BWCwgMSk7CisKK1NUT1JFX0ZVTkNUSU9OKGRlYWRsaW5lX2FzeW5jX3N0YXJ2ZWRfc3RvcmUs
ICZkZC0+YXN5bmNfc3RhcnZlZCwgSU5UX01JTiwgSU5UX01BWCwgMCk7CiBTVE9SRV9GVU5DVElP
TihkZWFkbGluZV9mcm9udF9tZXJnZXNfc3RvcmUsICZkZC0+ZnJvbnRfbWVyZ2VzLCAwLCAxLCAw
KTsKIFNUT1JFX0ZVTkNUSU9OKGRlYWRsaW5lX2ZpZm9fYmF0Y2hfc3RvcmUsICZkZC0+Zmlmb19i
YXRjaCwgMCwgSU5UX01BWCwgMCk7CiAjdW5kZWYgU1RPUkVfRlVOQ1RJT04KQEAgLTQzMCw5ICs1
NjAsMTEgQEAgU1RPUkVfRlVOQ1RJT04oZGVhZGxpbmVfZmlmb19iYXRjaF9zdG9yZSwgJmRkLT5m
aWZvX2JhdGNoLCAwLCBJTlRfTUFYLCAwKTsKIAkJCQkgICAgICBkZWFkbGluZV8jI25hbWUjI19z
dG9yZSkKIAogc3RhdGljIHN0cnVjdCBlbHZfZnNfZW50cnkgZGVhZGxpbmVfYXR0cnNbXSA9IHsK
LQlERF9BVFRSKHJlYWRfZXhwaXJlKSwKLQlERF9BVFRSKHdyaXRlX2V4cGlyZSksCi0JRERfQVRU
Uih3cml0ZXNfc3RhcnZlZCksCisJRERfQVRUUihhc3luY19leHBpcmUpLAorCUREX0FUVFIoc3lu
Y19leHBpcmUpLAorCUREX0FUVFIocnRfc3luY19leHBpcmUpLAorCUREX0FUVFIodGltZV9xdWFu
dHVtKSwKKwlERF9BVFRSKGFzeW5jX3N0YXJ2ZWQpLAogCUREX0FUVFIoZnJvbnRfbWVyZ2VzKSwK
IAlERF9BVFRSKGZpZm9fYmF0Y2gpLAogCV9fQVRUUl9OVUxMCg==
--0016364d260fe3308704682b267d--
