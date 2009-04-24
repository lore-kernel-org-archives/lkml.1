Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbZDXQIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbZDXQIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZDXQH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:07:56 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:62103 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbZDXQHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:07:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AgWzB5eppSUu4GK5r/9k16XxYYVfIaNUGOsHwCGVCe3NLY4fRvmkuwOHU2lD6lf5cL
         m9zh7eZX/TJCun1k4CY6/zIq19Z/S17a7lQqqGclecZkglEF6g7aH9WJ8SI9eIPqR2W8
         sf1fLv+2jk786A3ndCPAmxIGOtDq4GNwR9jtk=
MIME-Version: 1.0
In-Reply-To: <20090424063944.GA4593@kernel.dk>
References: <4e5e476b0904221407v7f43c058l8fc61198a2e4bb6e@mail.gmail.com>
	 <49F05699.2070006@cse.unsw.edu.au>
	 <4e5e476b0904230910r685e8300oa2323e8985c97a00@mail.gmail.com>
	 <20090424063944.GA4593@kernel.dk>
Date: Fri, 24 Apr 2009 18:07:53 +0200
Message-ID: <4e5e476b0904240907h61efc0ej93d04488003ec104@mail.gmail.com>
Subject: Re: Reduce latencies for syncronous writes and high I/O priority 
	requests in deadline IO scheduler
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Aaron Carroll <aaronc@cse.unsw.edu.au>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016e6de04d5f5bff204684f3227
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6de04d5f5bff204684f3227
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On Fri, Apr 24, 2009 at 8:39 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> I find your solution quite confusing - the statement is that it CFQ
> isn't optimal on SSD, so you modify deadline? ;-)

Well, I find CFQ too confusing to start with, so I chose a simpler one.
If I can prove something with deadline, maybe you will decide to
implement it also on CFQ ;)

>
> Most of the "CFQ doesn't work well on SSD" statements are mostly wrong.
> Now, you seem to have done some testing, so when you say that you
> probably have actually done some testing that tells you that this is the
> case. But lets attempt to fix that issue, then!
>
> One thing you pointed out is that CFQ doesn't treat the device as a
> "real" SSD unless it does queueing. This is very much on purpose, for
> two reasons:
>
> 1) I have never seen a non-queueing SSD that actually performs well for
>   reads-vs-write situations, so CFQ still does idling for those.

Does CFQ idle only when switching between reads and writes, or even
when switching between reads from one process, and reads from an
other?
I think I'll have to instrument CFQ a bit to understand how it works.
Is there a better way instead of scattering printks all around?

> 2) It's a problem that is going away. SSD that are coming out today and
>   in the future WILL definitely do queuing. We can attribute most of
>   the crap behaviour to the lacking jmicron flash controller, which
>   also has a crappy SATA interface.

I think SD cards will still be around a lot, and I don't expect them
to have queuing, so some support for them might still be needed.

> What I am worried about in the future is even faster SSD devices. CFQ is
> already down a percent or two when we are doing 100k iops and such, this
> problem will only get worse. So I'm very much interested in speeding up
> CFQ for such devices, which I think will mainly be slimming down the IO
> path and bypassing much of the (unneeded) complexity for them. The last
> thing I want is to have to tell people to use deadline or noop on SSD
> devices.
>

Totally agree. Having the main IOscheduler perform good on most
scenarios is surely needed.
But this could be achieved in various ways.
What if the main IO scheduler had in his toolbox various strategies,
and could switch between them based on the workload or type of
hardware?
FIFO scheduling for reads could be one such strategy, used only when
the conditions are good for it.
An other possibility is to use auto-tuning strategies, but those are
more difficult to devise and test.

>> In the meantime, I wanted to overcome also deadline limitations, i.e.
>> the high latencies on fsync/fdatasync.
>
> This is very much something you could pull out of the patchset and we
> could include without much questioning.
>

Ok, this is the first patch of the series, and contains code cleanup
needed before changing read/write to sync/async. No behavioral change
is introduced by this patch.

I found where the random read performance is gained, but I didn't
include in this patch, because it require sync/async separation to not
negatively impact sync write latencies.

If the following new code, that replicates existing behaviour:
       if (!dd->next_rq
           || rq_data_dir(dd->next_rq) != data_dir
           || deadline_check_fifo(dd, data_dir)) {
                /*
                 * A deadline has expired, the last request was in the other
                 * direction, or we have run out of higher-sectored requests.
is changed to:
       if (!dd->next_rq
           || rq_data_dir(dd->next_rq) > data_dir
           || deadline_check_fifo(dd, data_dir)) {
                /*
                 * A deadline has expired, the last request was less
important (where WRITE is less important than READ),
                 * or we have run out of higher-sectored requests.

you get both higher random read throughput and higher write latencies.

Corrado

> --
> Jens Axboe
>
>

-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------

--0016e6de04d5f5bff204684f3227
Content-Type: application/octet-stream; name=deadline-patch-cleanup
Content-Disposition: attachment; filename=deadline-patch-cleanup
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ftwveoh11

RGVhZGxpbmUgSU9zY2hlZHVsZXIgY29kZSBjbGVhbnVwLCBwcmVwYXJhdGlvbiBmb3Igc3luYy9h
c3luYyBwYXRjaAoKVGhpcyBpcyB0aGUgZmlyc3QgcGF0Y2ggb2YgdGhlIHNlcmllcywgYW5kIGNv
bnRhaW5zIGNvZGUgY2xlYW51cApuZWVkZWQgYmVmb3JlIGNoYW5naW5nIHJlYWQvd3JpdGUgdG8g
c3luYy9hc3luYy4KTm8gYmVoYXZpb3JhbCBjaGFuZ2UgaXMgaW50cm9kdWNlZCBieSB0aGlzIHBh
dGNoLgoKQ29kZSBjbGVhbnVwczoKKiBBIHNpbmdsZSBuZXh0X3JxIGlzIHN1ZmZpY2llbnQuCiog
d2Ugc3RvcmUgZmlmbyBpbnNlcnRpb24gdGltZSBvbiByZXF1ZXN0LCBhbmQgY29tcHV0ZSBkZWFk
bGluZSBvbiB0aGUKICBmbHksIHRvIGhhbmRsZSBmaWZvX2V4cGlyZSBjaGFuZ2VzIGJldHRlciAo
Zmlmb3MgcmVtYWluIHNvcnRlZCkKKiByZW1vdmUgdW51c2VkIGZpZWxkCiogZGVhZGxpbmVfbGF0
dGVyX3JlcXVlc3QgYmVjb21lcyBkZWFkbGluZV9uZXh0X3JlcXVlc3QuCgpTaWduZWQtb2ZmLWJ5
OiBDb3JyYWRvIFpvY2NvbG8gPGN6b2Njb2xvQGdtYWlsLmNvbT4KCmRpZmYgLS1naXQgYS9ibG9j
ay9kZWFkbGluZS1pb3NjaGVkLmMgYi9ibG9jay9kZWFkbGluZS1pb3NjaGVkLmMKaW5kZXggYzRk
OTkxZC4uNTcxMzU5NSAxMDA2NDQKLS0tIGEvYmxvY2svZGVhZGxpbmUtaW9zY2hlZC5jCisrKyBi
L2Jsb2NrL2RlYWRsaW5lLWlvc2NoZWQuYwpAQCAtMzUsMTEgKzM1LDEwIEBAIHN0cnVjdCBkZWFk
bGluZV9kYXRhIHsKIAlzdHJ1Y3QgbGlzdF9oZWFkIGZpZm9fbGlzdFsyXTsKIAogCS8qCi0JICog
bmV4dCBpbiBzb3J0IG9yZGVyLiByZWFkLCB3cml0ZSBvciBib3RoIGFyZSBOVUxMCisJICogbmV4
dCBpbiBzb3J0IG9yZGVyLgogCSAqLwotCXN0cnVjdCByZXF1ZXN0ICpuZXh0X3JxWzJdOworCXN0
cnVjdCByZXF1ZXN0ICpuZXh0X3JxOwogCXVuc2lnbmVkIGludCBiYXRjaGluZzsJCS8qIG51bWJl
ciBvZiBzZXF1ZW50aWFsIHJlcXVlc3RzIG1hZGUgKi8KLQlzZWN0b3JfdCBsYXN0X3NlY3RvcjsJ
CS8qIGhlYWQgcG9zaXRpb24gKi8KIAl1bnNpZ25lZCBpbnQgc3RhcnZlZDsJCS8qIHRpbWVzIHJl
YWRzIGhhdmUgc3RhcnZlZCB3cml0ZXMgKi8KIAogCS8qCkBAIC02Myw3ICs2Miw3IEBAIGRlYWRs
aW5lX3JiX3Jvb3Qoc3RydWN0IGRlYWRsaW5lX2RhdGEgKmRkLCBzdHJ1Y3QgcmVxdWVzdCAqcnEp
CiAgKiBnZXQgdGhlIHJlcXVlc3QgYWZ0ZXIgYHJxJyBpbiBzZWN0b3Itc29ydGVkIG9yZGVyCiAg
Ki8KIHN0YXRpYyBpbmxpbmUgc3RydWN0IHJlcXVlc3QgKgotZGVhZGxpbmVfbGF0dGVyX3JlcXVl
c3Qoc3RydWN0IHJlcXVlc3QgKnJxKQorZGVhZGxpbmVfbmV4dF9yZXF1ZXN0KHN0cnVjdCByZXF1
ZXN0ICpycSkKIHsKIAlzdHJ1Y3QgcmJfbm9kZSAqbm9kZSA9IHJiX25leHQoJnJxLT5yYl9ub2Rl
KTsKIApAQCAtODYsMTAgKzg1LDggQEAgZGVhZGxpbmVfYWRkX3JxX3JiKHN0cnVjdCBkZWFkbGlu
ZV9kYXRhICpkZCwgc3RydWN0IHJlcXVlc3QgKnJxKQogc3RhdGljIGlubGluZSB2b2lkCiBkZWFk
bGluZV9kZWxfcnFfcmIoc3RydWN0IGRlYWRsaW5lX2RhdGEgKmRkLCBzdHJ1Y3QgcmVxdWVzdCAq
cnEpCiB7Ci0JY29uc3QgaW50IGRhdGFfZGlyID0gcnFfZGF0YV9kaXIocnEpOwotCi0JaWYgKGRk
LT5uZXh0X3JxW2RhdGFfZGlyXSA9PSBycSkKLQkJZGQtPm5leHRfcnFbZGF0YV9kaXJdID0gZGVh
ZGxpbmVfbGF0dGVyX3JlcXVlc3QocnEpOworCWlmIChkZC0+bmV4dF9ycSA9PSBycSkKKwkJZGQt
Pm5leHRfcnEgPSBkZWFkbGluZV9uZXh0X3JlcXVlc3QocnEpOwogCiAJZWx2X3JiX2RlbChkZWFk
bGluZV9yYl9yb290KGRkLCBycSksIHJxKTsKIH0KQEAgLTEwMSwxNSArOTgsMTQgQEAgc3RhdGlj
IHZvaWQKIGRlYWRsaW5lX2FkZF9yZXF1ZXN0KHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBzdHJ1
Y3QgcmVxdWVzdCAqcnEpCiB7CiAJc3RydWN0IGRlYWRsaW5lX2RhdGEgKmRkID0gcS0+ZWxldmF0
b3ItPmVsZXZhdG9yX2RhdGE7Ci0JY29uc3QgaW50IGRhdGFfZGlyID0gcnFfZGF0YV9kaXIocnEp
OwogCiAJZGVhZGxpbmVfYWRkX3JxX3JiKGRkLCBycSk7CiAKIAkvKgotCSAqIHNldCBleHBpcmUg
dGltZSBhbmQgYWRkIHRvIGZpZm8gbGlzdAorCSAqIHNldCByZXF1ZXN0IGNyZWF0aW9uIHRpbWUg
YW5kIGFkZCB0byBmaWZvIGxpc3QKIAkgKi8KLQlycV9zZXRfZmlmb190aW1lKHJxLCBqaWZmaWVz
ICsgZGQtPmZpZm9fZXhwaXJlW2RhdGFfZGlyXSk7Ci0JbGlzdF9hZGRfdGFpbCgmcnEtPnF1ZXVl
bGlzdCwgJmRkLT5maWZvX2xpc3RbZGF0YV9kaXJdKTsKKwlycV9zZXRfZmlmb190aW1lKHJxLCBq
aWZmaWVzKTsKKwlsaXN0X2FkZF90YWlsKCZycS0+cXVldWVsaXN0LCAmZGQtPmZpZm9fbGlzdFty
cV9kYXRhX2RpcihycSldKTsKIH0KIAogLyoKQEAgLTIwNiwxMyArMjAyLDcgQEAgZGVhZGxpbmVf
bW92ZV90b19kaXNwYXRjaChzdHJ1Y3QgZGVhZGxpbmVfZGF0YSAqZGQsIHN0cnVjdCByZXF1ZXN0
ICpycSkKIHN0YXRpYyB2b2lkCiBkZWFkbGluZV9tb3ZlX3JlcXVlc3Qoc3RydWN0IGRlYWRsaW5l
X2RhdGEgKmRkLCBzdHJ1Y3QgcmVxdWVzdCAqcnEpCiB7Ci0JY29uc3QgaW50IGRhdGFfZGlyID0g
cnFfZGF0YV9kaXIocnEpOwotCi0JZGQtPm5leHRfcnFbUkVBRF0gPSBOVUxMOwotCWRkLT5uZXh0
X3JxW1dSSVRFXSA9IE5VTEw7Ci0JZGQtPm5leHRfcnFbZGF0YV9kaXJdID0gZGVhZGxpbmVfbGF0
dGVyX3JlcXVlc3QocnEpOwotCi0JZGQtPmxhc3Rfc2VjdG9yID0gcnFfZW5kX3NlY3RvcihycSk7
CisJZGQtPm5leHRfcnEgPSBkZWFkbGluZV9uZXh0X3JlcXVlc3QocnEpOwogCiAJLyoKIAkgKiB0
YWtlIGl0IG9mZiB0aGUgc29ydCBhbmQgZmlmbyBsaXN0LCBtb3ZlCkBAIC0yMjcsMTUgKzIxNywx
MyBAQCBkZWFkbGluZV9tb3ZlX3JlcXVlc3Qoc3RydWN0IGRlYWRsaW5lX2RhdGEgKmRkLCBzdHJ1
Y3QgcmVxdWVzdCAqcnEpCiAgKi8KIHN0YXRpYyBpbmxpbmUgaW50IGRlYWRsaW5lX2NoZWNrX2Zp
Zm8oc3RydWN0IGRlYWRsaW5lX2RhdGEgKmRkLCBpbnQgZGRpcikKIHsKLQlzdHJ1Y3QgcmVxdWVz
dCAqcnEgPSBycV9lbnRyeV9maWZvKGRkLT5maWZvX2xpc3RbZGRpcl0ubmV4dCk7Ci0KKwlCVUdf
T04obGlzdF9lbXB0eSgmZGQtPmZpZm9fbGlzdFtkZGlyXSkpOwogCS8qCi0JICogcnEgaXMgZXhw
aXJlZCEKKwkgKiBkZWFkbGluZSBpcyBleHBpcmVkIQogCSAqLwotCWlmICh0aW1lX2FmdGVyKGpp
ZmZpZXMsIHJxX2ZpZm9fdGltZShycSkpKQotCQlyZXR1cm4gMTsKLQotCXJldHVybiAwOworCXJl
dHVybiB0aW1lX2FmdGVyKGppZmZpZXMsIGRkLT5maWZvX2V4cGlyZVtkZGlyXSArCisJCQkgIHJx
X2ZpZm9fdGltZShycV9lbnRyeV9maWZvKGRkLT5maWZvX2xpc3RbZGRpcl0ubmV4dCkpCisJCQkg
ICk7CiB9CiAKIC8qCkBAIC0yNDcsMjAgKzIzNSwxMyBAQCBzdGF0aWMgaW50IGRlYWRsaW5lX2Rp
c3BhdGNoX3JlcXVlc3RzKHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBpbnQgZm9yY2UpCiAJc3Ry
dWN0IGRlYWRsaW5lX2RhdGEgKmRkID0gcS0+ZWxldmF0b3ItPmVsZXZhdG9yX2RhdGE7CiAJY29u
c3QgaW50IHJlYWRzID0gIWxpc3RfZW1wdHkoJmRkLT5maWZvX2xpc3RbUkVBRF0pOwogCWNvbnN0
IGludCB3cml0ZXMgPSAhbGlzdF9lbXB0eSgmZGQtPmZpZm9fbGlzdFtXUklURV0pOwotCXN0cnVj
dCByZXF1ZXN0ICpycTsKKwlzdHJ1Y3QgcmVxdWVzdCAqcnEgPSBkZC0+bmV4dF9ycTsKIAlpbnQg
ZGF0YV9kaXI7CiAKLQkvKgotCSAqIGJhdGNoZXMgYXJlIGN1cnJlbnRseSByZWFkcyBYT1Igd3Jp
dGVzCi0JICovCi0JaWYgKGRkLT5uZXh0X3JxW1dSSVRFXSkKLQkJcnEgPSBkZC0+bmV4dF9ycVtX
UklURV07Ci0JZWxzZQotCQlycSA9IGRkLT5uZXh0X3JxW1JFQURdOwotCi0JaWYgKHJxICYmIGRk
LT5iYXRjaGluZyA8IGRkLT5maWZvX2JhdGNoKQorCWlmIChycSAmJiBkZC0+YmF0Y2hpbmcgPCBk
ZC0+Zmlmb19iYXRjaCkgewogCQkvKiB3ZSBoYXZlIGEgbmV4dCByZXF1ZXN0IGFyZSBzdGlsbCBl
bnRpdGxlZCB0byBiYXRjaCAqLwogCQlnb3RvIGRpc3BhdGNoX3JlcXVlc3Q7CisJfQogCiAJLyoK
IAkgKiBhdCB0aGlzIHBvaW50IHdlIGFyZSBub3QgcnVubmluZyBhIGJhdGNoLiBzZWxlY3QgdGhl
IGFwcHJvcHJpYXRlCkBAIC0yOTksNyArMjgwLDkgQEAgZGlzcGF0Y2hfZmluZF9yZXF1ZXN0Ogog
CS8qCiAJICogd2UgYXJlIG5vdCBydW5uaW5nIGEgYmF0Y2gsIGZpbmQgYmVzdCByZXF1ZXN0IGZv
ciBzZWxlY3RlZCBkYXRhX2RpcgogCSAqLwotCWlmIChkZWFkbGluZV9jaGVja19maWZvKGRkLCBk
YXRhX2RpcikgfHwgIWRkLT5uZXh0X3JxW2RhdGFfZGlyXSkgeworCWlmICghZGQtPm5leHRfcnEK
KwkgICAgfHwgcnFfZGF0YV9kaXIoZGQtPm5leHRfcnEpICE9IGRhdGFfZGlyCisJICAgIHx8IGRl
YWRsaW5lX2NoZWNrX2ZpZm8oZGQsIGRhdGFfZGlyKSkgewogCQkvKgogCQkgKiBBIGRlYWRsaW5l
IGhhcyBleHBpcmVkLCB0aGUgbGFzdCByZXF1ZXN0IHdhcyBpbiB0aGUgb3RoZXIKIAkJICogZGly
ZWN0aW9uLCBvciB3ZSBoYXZlIHJ1biBvdXQgb2YgaGlnaGVyLXNlY3RvcmVkIHJlcXVlc3RzLgpA
QCAtMzExLDcgKzI5NCw3IEBAIGRpc3BhdGNoX2ZpbmRfcmVxdWVzdDoKIAkJICogVGhlIGxhc3Qg
cmVxIHdhcyB0aGUgc2FtZSBkaXIgYW5kIHdlIGhhdmUgYSBuZXh0IHJlcXVlc3QgaW4KIAkJICog
c29ydCBvcmRlci4gTm8gZXhwaXJlZCByZXF1ZXN0cyBzbyBjb250aW51ZSBvbiBmcm9tIGhlcmUu
CiAJCSAqLwotCQlycSA9IGRkLT5uZXh0X3JxW2RhdGFfZGlyXTsKKwkJcnEgPSBkZC0+bmV4dF9y
cTsKIAl9CiAKIAlkZC0+YmF0Y2hpbmcgPSAwOwo=
--0016e6de04d5f5bff204684f3227--
