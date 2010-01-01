Return-Path: <linux-kernel-owner+w=401wt.eu-S1752154Ab0AAQcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab0AAQcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 11:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997Ab0AAQco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 11:32:44 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:35413 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab0AAQcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 11:32:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nuWJchGgdIUjEu/kpLUYOWJPcL0Vu6ocitdvnP+vHGqIUSxbWN7+f6iUKemRm4tya6
         pK9Lloq/4JF3Yco42y7hS4w4z5aOuM+bfvsP3uZvW8yASqBZrsX5sVfU4A7nGxtcigPO
         fMQnmFgAj4FEi4gFNYwsNADIUsDy5qeYTIpXI=
MIME-Version: 1.0
In-Reply-To: <1262340730.19773.47.camel@localhost>
References: <1262250960.1819.68.camel@localhost>
	 <4e5e476b0912310234mf9ccaadm771c637a3d107d18@mail.gmail.com>
	 <1262340730.19773.47.camel@localhost>
Date: Fri, 1 Jan 2010 17:32:41 +0100
Message-ID: <4e5e476b1001010832o24f6a0efudbfc36598bfc7c5e@mail.gmail.com>
Subject: Re: fio mmap randread 64k more than 40% regression with 2.6.33-rc1
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Shaohua Li <shaohua.li@intel.com>,
       "jmoyer@redhat.com" <jmoyer@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001636c9255fa4fec0047c1cebcd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636c9255fa4fec0047c1cebcd
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Yanmin,
On Fri, Jan 1, 2010 at 11:12 AM, Zhang, Yanmin
<yanmin_zhang@linux.intel.com> wrote:
> On Thu, 2009-12-31 at 11:34 +0100, Corrado Zoccolo wrote:
>> Hi Yanmin,
>> On Thu, Dec 31, 2009 at 10:16 AM, Zhang, Yanmin
>> <yanmin_zhang@linux.intel.com> wrote:
>> > Comparing with kernel 2.6.32, fio mmap randread 64k has more than 40% =
regression with
>> > 2.6.33-rc1.
>>
> Thanks for your timely reply. Some comments inlined below.
>
>> Can you compare the performance also with 2.6.31?
> We did. We run Linux kernel Performance Tracking project and run many ben=
chmarks when a RC kernel
> is released.
>
> The result of 2.6.31 is quite similar to the one of 2.6.32. But the one o=
f 2.6.30 is about
> 8% better than the one of 2.6.31.
>
>> I think I understand what causes your problem.
>> 2.6.32, with default settings, handled even random readers as
>> sequential ones to provide fairness. This has benefits on single disks
>> and JBODs, but causes harm on raids.
> I didn't test RAID as that machine with hardware RAID HBA is crashed now.=
 But if we turn on
> hardware RAID in HBA, mostly we use noop io scheduler.
I think you should start testing cfq with them, too. From 2.6.33, we
have some big improvements in this area.
>
>> For 2.6.33, we changed the way in which this is handled, restoring the
>> enable_idle =3D 0 for seeky queues as it was in 2.6.31:
>> @@ -2218,13 +2352,10 @@ cfq_update_idle_window(struct cfq_data *cfqd,
>> struct cfq_queue *cfqq,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0enable_idle =3D old_idle =3D cfq_cfqq_idle_wi=
ndow(cfqq);
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!atomic_read(&cic->ioc->nr_tasks) || !cfq=
d->cfq_slice_idle ||
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (!cfqd->cfq_latency && cfqd->hw_tag=
 && CFQQ_SEEKY(cfqq)))
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (sample_valid(cfqq->seek_samples) &=
& CFQQ_SEEKY(cfqq)))
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0enable_idle =3D 0=
;
>> (compare with 2.6.31:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!atomic_read(&cic->ioc->nr_tasks) || !cf=
qd->cfq_slice_idle ||
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (cfqd->hw_tag && CIC_SEEKY(cic=
)))
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 enable_idle =3D =
0;
>> excluding the sample_valid check, it should be equivalent for you (I
>> assume you have NCQ disks))
>> and we provide fairness for them by servicing all seeky queues
>> together, and then idling before switching to other ones.
> As for function cfq_update_idle_window, you is right. But since
> 2.6.32, CFQ merges many patches and the patches have impact on each other=
.
>
>>
>> The mmap 64k randreader will have a large seek_mean, resulting in
>> being marked seeky, but will send 16 * 4k sequential requests one
>> after the other, so alternating between those seeky queues will cause
>> harm.
>>
>> I'm working on a new way to compute seekiness of queues, that should
>> fix your issue, correctly identifying those queues as non-seeky (for
>> me, a queue should be considered seeky only if it submits more than 1
>> seeky requests for 8 sequential ones).
>>
>> >
>> > The test scenario: 1 JBOD has 12 disks and every disk has 2 partitions=
. Create
>> > 8 1-GB files per partition and start 8 processes to do rand read on th=
e 8 files
>> > per partitions. There are 8*24 processes totally. randread block size =
is 64K.
>> >
>> > We found the regression on 2 machines. One machine has 8GB memory and =
the other has
>> > 6GB.
>> >
>> > Bisect is very unstable. The related patches are many instead of just =
one.
>> >
>> >
>> > 1) commit 8e550632cccae34e265cb066691945515eaa7fb5
>> > Author: Corrado Zoccolo <czoccolo@gmail.com>
>> > Date: =C2=A0 Thu Nov 26 10:02:58 2009 +0100
>> >
>> > =C2=A0 =C2=A0cfq-iosched: fix corner cases in idling logic
>> >
>> >
>> > This patch introduces about less than 20% regression. I just reverted =
below section
>> > and this part regression disappear. It shows this regression is stable=
 and not impacted
>> > by other patches.
>> >
>> > @@ -1253,9 +1254,9 @@ static void cfq_arm_slice_timer(struct cfq_data =
*cfqd)
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
>> >
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
>> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0* still requests with the driver, don't i=
dle
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* still active requests from this queue, =
don't idle
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
>> > - =C2=A0 =C2=A0 =C2=A0 if (rq_in_driver(cfqd))
>> > + =C2=A0 =C2=A0 =C2=A0 if (cfqq->dispatched)
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
> Although 5 patches are related to the regression, above line is quite
> independent. Reverting above line could always improve the result for abo=
ut
> 20%.
I've looked at your fio script, and it is quite complex, with lot of
things going on.
Let's keep this for last.
I've created a smaller test, that already shows some regression:
[global]
direct=3D0
ioengine=3Dmmap
size=3D8G
bs=3D64k
numjobs=3D1
loops=3D5
runtime=3D60
#group_reporting
invalidate=3D0
directory=3D/media/hd/cfq-tests

[job0]
startdelay=3D0
rw=3Drandread
filename=3Dtestfile1

[job1]
startdelay=3D0
rw=3Drandread
filename=3Dtestfile2

[job2]
startdelay=3D0
rw=3Drandread
filename=3Dtestfile3

[job3]
startdelay=3D0
rw=3Drandread
filename=3Dtestfile4

The attached patches, in particular 0005 (that apply on top of
for-linus branch of Jen's tree
git://git.kernel.dk/linux-2.6-block.git) fix the regression on this
simplified workload.

>
>> >
>> This shouldn't affect you if all queues are marked as idle.
> Do you mean to use command ionice to mark it as idle class? I didn't try =
it.
No. I meant forcing enable_idle =3D 1, as you were almost doing with
your patch, when cfq_latency was set.
With my above patch, this should not be needed any more, since the
queues should be seen as sequential.

>
>> =C2=A0Does just
>> your patch:
>> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (!cfq_cfqq_deep(cfqq) && sample_v=
alid(cfqq->seek_samples)
>> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&& CFQQ_SEEKY(cfqq)))
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (!cfqd->cfq_latency && !cfq_cfqq_=
deep(cfqq) &&
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sample_valid(cfqq->=
seek_samples) && CFQQ_SEEKY(cfqq)))
>> fix most of the regression without touching arm_slice_timer?
> No. If to fix the regression completely, I need apply above patch plus
> a debug patch. The debug patch is to just work around the 3 patches repor=
t by
> Shaohua's tiobench regression report. Without the debug patch, the regres=
sion
> isn't resolved.

Jens already merged one of Shaohua's patches, that may fix the problem
with queue combining.

> Below is the debug patch.
> diff -Nraup linux-2.6.33_rc1/block/cfq-iosched.c linux-2.6.33_rc1_randrea=
d64k/block/cfq-iosched.c
> --- linux-2.6.33_rc1/block/cfq-iosched.c =C2=A0 =C2=A0 =C2=A0 =C2=A02009-=
12-23 14:12:03.000000000 +0800
> +++ linux-2.6.33_rc1_randread64k/block/cfq-iosched.c =C2=A0 =C2=A02009-12=
-30 17:12:28.000000000 +0800
> @@ -592,6 +592,9 @@ cfq_set_prio_slice(struct cfq_data *cfqd
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfqq->slice_start =3D jiffies;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfqq->slice_end =3D jiffies + slice;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfqq->allocated_slice =3D slice;
> +/*YMZHANG*/
> + =C2=A0 =C2=A0 =C2=A0 cfqq->slice_end =3D cfq_prio_to_slice(cfqd, cfqq) =
+ jiffies;
> +
This is disabled, on a vanilla 2.6.33 kernel, by setting low_latency =3D 0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfq_log_cfqq(cfqd, cfqq, "set_slice=3D%lu", cf=
qq->slice_end - jiffies);
> =C2=A0}
>
> @@ -1836,7 +1839,8 @@ static void cfq_arm_slice_timer(struct c
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * still active requests from this queue, don'=
t idle
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> - =C2=A0 =C2=A0 =C2=A0 if (cfqq->dispatched)
> + =C2=A0 =C2=A0 =C2=A0 //if (cfqq->dispatched)
> + =C2=A0 =C2=A0 =C2=A0 if (rq_in_driver(cfqd))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> @@ -1941,6 +1945,9 @@ static void cfq_setup_merge(struct cfq_q
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0new_cfqq =3D __cfq=
q;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> + =C2=A0 =C2=A0 =C2=A0 /* YMZHANG debug */
> + =C2=A0 =C2=A0 =C2=A0 return;
> +
This should be partially addressed by Shaohua's patch merged in Jens' tree.
But note that your 8 processes, can randomly start doing I/O on the
same file, so merging those queues is sometimes reasonable.
The patch to split them quickly was still not merged, though, so you
will still see some regression due to this. In my simplified job file,
I removed the randomness to make sure this cannot happen.

> =C2=A0 =C2=A0 =C2=A0 =C2=A0process_refs =3D cfqq_process_refs(cfqq);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * If the process for the cfqq has gone away, =
there is no
>
>
>>
>> I guess
>> > 5db5d64277bf390056b1a87d0bb288c8b8553f96.
>> will still introduce a 10% regression, but this is needed to improve
>> latency, and you can just disable low_latency to avoid it.
> You are right. I did a quick testing. If my patch + revert 2 patches and =
keep
> 5db5d64, the regression is about 20%.
>
> But low_latency=3D0 doesn't work like what we imagined. If patch + revert=
 2 patches
> and keep 5db5d64 while set low_latency=3D0, the regression is still there=
. One
> reason is my patch doesn't work when low_latency=3D0.
Right. You can try with my patch, instead, that doesn't depend on
low_latency, and set it to 0 to remove this performance degradation.
My results:
2.6.32.2:
   READ: io=3D146688KB, aggrb=3D2442KB/s, minb=3D602KB/s, maxb=3D639KB/s,
mint=3D60019msec, maxt=3D60067msec

2.6.33 - jens:
   READ: io=3D128512KB, aggrb=3D2140KB/s, minb=3D526KB/s, maxb=3D569KB/s,
mint=3D60004msec, maxt=3D60032msec

2.6.33 - jens + my patches :
   READ: io=3D143232KB, aggrb=3D2384KB/s, minb=3D595KB/s, maxb=3D624KB/s,
mint=3D60003msec, maxt=3D60072msec

2.6.33 - jens + my patches + low_lat =3D 0:
   READ: io=3D145216KB, aggrb=3D2416KB/s, minb=3D596KB/s, maxb=3D632KB/s,
mint=3D60027msec, maxt=3D60087msec


>>
>> Thanks,
>> Corrado
> I attach the fio job file for your reference.
>
> I got a cold and will continue to work on it next week.
>
> Yanmin
>

Thanks,
Corrado

--001636c9255fa4fec0047c1cebcd
Content-Type: application/octet-stream; 
	name="0003-cfq-iosched-non-rot-devices-do-not-need-read-queue-m.patch"
Content-Disposition: attachment; 
	filename="0003-cfq-iosched-non-rot-devices-do-not-need-read-queue-m.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g3x4wseg1

RnJvbSBmN2JmNGRiNzY4MThkNmEwY2U4M2MxNzljYjZhZTJhMzA1YWYzMDgyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBDb3JyYWRvIFpvY2NvbG8gPGN6b2Njb2xvQGdtYWlsLmNvbT4K
RGF0ZTogV2VkLCAzMCBEZWMgMjAwOSAxMTo1ODozNCArMDEwMApTdWJqZWN0OiBbUEFUQ0ggMy81
XSBjZnEtaW9zY2hlZDogbm9uLXJvdCBkZXZpY2VzIGRvIG5vdCBuZWVkIHJlYWQgcXVldWUgbWVy
Z2luZwoKTm9uIHJvdGF0aW9uYWwgZGV2aWNlcycgcGVyZm9ybWFuY2VzIGFyZSBub3QgYWZmZWN0
ZWQgYnkKZGlzdGFuY2Ugb2YgcmVhZCByZXF1ZXN0cywgc28gdGhlcmUgaXMgbm8gcG9pbnQgaW4g
aGF2aW5nCm92ZXJoZWFkIHRvIG1lcmdlIHN1Y2ggcXVldWVzLgpUaGlzIGRvZXNuJ3QgYXBwbHkg
dG8gd3JpdGVzLCBzbyB0aGlzIHBhdGNoIGNoYW5nZXMgdGhlCnF1ZXVlZFtdIGZpZWxkLCB0byBi
ZSBpbmRleGVkIGJ5IFJFQUQvV1JJVEUgaW5zdGVhZCBvZgpTWU5DL0FTWU5DLCBhbmQgb25seSBj
b21wdXRlIHByb3hpbWl0eSBmb3IgcXVldWVzIHdpdGgKV1JJVEUgcmVxdWVzdHMuCgpTaWduZWQt
b2ZmLWJ5OiBDb3JyYWRvIFpvY2NvbG8gPGN6b2Njb2xvQGdtYWlsLmNvbT4KLS0tCiBibG9jay9j
ZnEtaW9zY2hlZC5jIHwgICAyMCArKysrKysrKysrKy0tLS0tLS0tLQogMSBmaWxlcyBjaGFuZ2Vk
LCAxMSBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Jsb2NrL2Nm
cS1pb3NjaGVkLmMgYi9ibG9jay9jZnEtaW9zY2hlZC5jCmluZGV4IDkxOGM3ZmQuLjdkYTkzOTEg
MTAwNjQ0Ci0tLSBhL2Jsb2NrL2NmcS1pb3NjaGVkLmMKKysrIGIvYmxvY2svY2ZxLWlvc2NoZWQu
YwpAQCAtMTA4LDkgKzEwOCw5IEBAIHN0cnVjdCBjZnFfcXVldWUgewogCXN0cnVjdCByYl9yb290
IHNvcnRfbGlzdDsKIAkvKiBpZiBmaWZvIGlzbid0IGV4cGlyZWQsIG5leHQgcmVxdWVzdCB0byBz
ZXJ2ZSAqLwogCXN0cnVjdCByZXF1ZXN0ICpuZXh0X3JxOwotCS8qIHJlcXVlc3RzIHF1ZXVlZCBp
biBzb3J0X2xpc3QgKi8KKwkvKiByZXF1ZXN0cyBxdWV1ZWQgaW4gc29ydF9saXN0LCBpbmRleGVk
IGJ5IFJFQUQvV1JJVEUgKi8KIAlpbnQgcXVldWVkWzJdOwotCS8qIGN1cnJlbnRseSBhbGxvY2F0
ZWQgcmVxdWVzdHMgKi8KKwkvKiBjdXJyZW50bHkgYWxsb2NhdGVkIHJlcXVlc3RzLCBpbmRleGVk
IGJ5IFJFQUQvV1JJVEUgKi8KIAlpbnQgYWxsb2NhdGVkWzJdOwogCS8qIGZpZm8gbGlzdCBvZiBy
ZXF1ZXN0cyBpbiBzb3J0X2xpc3QgKi8KIAlzdHJ1Y3QgbGlzdF9oZWFkIGZpZm87CkBAIC0xMjY4
LDcgKzEyNjgsOCBAQCBzdGF0aWMgdm9pZCBjZnFfcHJpb190cmVlX2FkZChzdHJ1Y3QgY2ZxX2Rh
dGEgKmNmcWQsIHN0cnVjdCBjZnFfcXVldWUgKmNmcXEpCiAJCXJldHVybjsKIAlpZiAoIWNmcXEt
Pm5leHRfcnEpCiAJCXJldHVybjsKLQorCWlmIChibGtfcXVldWVfbm9ucm90KGNmcWQtPnF1ZXVl
KSAmJiAhY2ZxcS0+cXVldWVkW1dSSVRFXSkKKwkJcmV0dXJuOwogCWNmcXEtPnBfcm9vdCA9ICZj
ZnFkLT5wcmlvX3RyZWVzW2NmcXEtPm9yZ19pb3ByaW9dOwogCV9fY2ZxcSA9IGNmcV9wcmlvX3Ry
ZWVfbG9va3VwKGNmcWQsIGNmcXEtPnBfcm9vdCwKIAkJCQkgICAgICBibGtfcnFfcG9zKGNmcXEt
Pm5leHRfcnEpLCAmcGFyZW50LCAmcCk7CkBAIC0xMzM3LDEwICsxMzM4LDEwIEBAIHN0YXRpYyB2
b2lkIGNmcV9kZWxfY2ZxcV9ycihzdHJ1Y3QgY2ZxX2RhdGEgKmNmcWQsIHN0cnVjdCBjZnFfcXVl
dWUgKmNmcXEpCiBzdGF0aWMgdm9pZCBjZnFfZGVsX3JxX3JiKHN0cnVjdCByZXF1ZXN0ICpycSkK
IHsKIAlzdHJ1Y3QgY2ZxX3F1ZXVlICpjZnFxID0gUlFfQ0ZRUShycSk7Ci0JY29uc3QgaW50IHN5
bmMgPSBycV9pc19zeW5jKHJxKTsKKwljb25zdCBpbnQgcncgPSBycV9kYXRhX2RpcihycSk7CiAK
LQlCVUdfT04oIWNmcXEtPnF1ZXVlZFtzeW5jXSk7Ci0JY2ZxcS0+cXVldWVkW3N5bmNdLS07CisJ
QlVHX09OKCFjZnFxLT5xdWV1ZWRbcnddKTsKKwljZnFxLT5xdWV1ZWRbcnddLS07CiAKIAllbHZf
cmJfZGVsKCZjZnFxLT5zb3J0X2xpc3QsIHJxKTsKIApAQCAtMTM2Myw3ICsxMzY0LDcgQEAgc3Rh
dGljIHZvaWQgY2ZxX2FkZF9ycV9yYihzdHJ1Y3QgcmVxdWVzdCAqcnEpCiAJc3RydWN0IGNmcV9k
YXRhICpjZnFkID0gY2ZxcS0+Y2ZxZDsKIAlzdHJ1Y3QgcmVxdWVzdCAqX19hbGlhcywgKnByZXY7
CiAKLQljZnFxLT5xdWV1ZWRbcnFfaXNfc3luYyhycSldKys7CisJY2ZxcS0+cXVldWVkW3JxX2Rh
dGFfZGlyKHJxKV0rKzsKIAogCS8qCiAJICogbG9va3MgYSBsaXR0bGUgb2RkLCBidXQgdGhlIGZp
cnN0IGluc2VydCBtaWdodCByZXR1cm4gYW4gYWxpYXMuCkBAIC0xMzkzLDcgKzEzOTQsNyBAQCBz
dGF0aWMgdm9pZCBjZnFfYWRkX3JxX3JiKHN0cnVjdCByZXF1ZXN0ICpycSkKIHN0YXRpYyB2b2lk
IGNmcV9yZXBvc2l0aW9uX3JxX3JiKHN0cnVjdCBjZnFfcXVldWUgKmNmcXEsIHN0cnVjdCByZXF1
ZXN0ICpycSkKIHsKIAllbHZfcmJfZGVsKCZjZnFxLT5zb3J0X2xpc3QsIHJxKTsKLQljZnFxLT5x
dWV1ZWRbcnFfaXNfc3luYyhycSldLS07CisJY2ZxcS0+cXVldWVkW3JxX2RhdGFfZGlyKHJxKV0t
LTsKIAljZnFfYWRkX3JxX3JiKHJxKTsKIH0KIApAQCAtMTY4OSw3ICsxNjkwLDggQEAgc3RhdGlj
IHN0cnVjdCBjZnFfcXVldWUgKmNmcXFfY2xvc2Uoc3RydWN0IGNmcV9kYXRhICpjZnFkLAogCXN0
cnVjdCBjZnFfcXVldWUgKl9fY2ZxcTsKIAlzZWN0b3JfdCBzZWN0b3IgPSBjZnFkLT5sYXN0X3Bv
c2l0aW9uOwogCi0JaWYgKFJCX0VNUFRZX1JPT1Qocm9vdCkpCisJaWYgKFJCX0VNUFRZX1JPT1Qo
cm9vdCkgfHwKKwkgICAgKGJsa19xdWV1ZV9ub25yb3QoY2ZxZC0+cXVldWUpICYmICFjdXJfY2Zx
cS0+cXVldWVkW1dSSVRFXSkpCiAJCXJldHVybiBOVUxMOwogCiAJLyoKLS0gCjEuNi40LjQKCg==
--001636c9255fa4fec0047c1cebcd
Content-Type: application/octet-stream; 
	name="0004-cfq-iosched-requests-in-flight-vs-in-driver-clarific.patch"
Content-Disposition: attachment; 
	filename="0004-cfq-iosched-requests-in-flight-vs-in-driver-clarific.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g3x4x77n2

RnJvbSBiZDQ3NDU0YTQzODFmNTg0ZTc5YjliYjU3ZWIwMzI5ZTRiMzg1ZWU1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBDb3JyYWRvIFpvY2NvbG8gPGN6b2Njb2xvQGdtYWlsLmNvbT4K
RGF0ZTogV2VkLCAzMCBEZWMgMjAwOSAyMjo0OTo0MiArMDEwMApTdWJqZWN0OiBbUEFUQ0ggNC81
XSBjZnEtaW9zY2hlZDogcmVxdWVzdHMgImluIGZsaWdodCIgdnMgImluIGRyaXZlciIgY2xhcmlm
aWNhdGlvbgoKQ291bnRlcnMgZm9yIHJlcXVlc3RzICJpbiBmbGlnaHQiIGFuZCAiaW4gZHJpdmVy
IiBhcmUgdXNlZCBhc3ltbWV0cmljYWxseQppbiBjZnFfbWF5X2Rpc3BhdGNoLCBhbmQgaGF2ZSBz
bGlnaHRseSBkaWZmZXJlbnQgbWVhbmluZy4KV2Ugc3BsaXQgdGhlIHJxX2luX2ZsaWdodCBjb3Vu
dGVyICh3YXMgc3luY19mbGlnaHQpIHRvIGNvdW50IGJvdGggc3luYwphbmQgYXN5bmMgcmVxdWVz
dHMsIGluIG9yZGVyIHRvIHVzZSB0aGlzIG9uZSwgd2hpY2ggaXMgbW9yZSBhY2N1cmF0ZSBpbgpz
b21lIGNvcm5lciBjYXNlcy4KVGhlIHJxX2luX2RyaXZlciBjb3VudGVyIGlzIGNvYWxlc2NlZCwg
c2luY2UgaW5kaXZpZHVhbCBzeW5jL2FzeW5jIGNvdW50cwphcmUgbm90IHVzZWQgYW55IG1vcmUu
CgpTaWduZWQtb2ZmLWJ5OiBDb3JyYWRvIFpvY2NvbG8gPGN6b2Njb2xvQGdtYWlsLmNvbT4KLS0t
CiBibG9jay9jZnEtaW9zY2hlZC5jIHwgICA0NCArKysrKysrKysrKysrKysrKystLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspLCAyNiBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9ibG9jay9jZnEtaW9zY2hlZC5jIGIvYmxvY2svY2Zx
LWlvc2NoZWQuYwppbmRleCA3ZGE5MzkxLi5jNmQ1Njc4IDEwMDY0NAotLS0gYS9ibG9jay9jZnEt
aW9zY2hlZC5jCisrKyBiL2Jsb2NrL2NmcS1pb3NjaGVkLmMKQEAgLTIyNyw4ICsyMjcsOCBAQCBz
dHJ1Y3QgY2ZxX2RhdGEgewogCiAJdW5zaWduZWQgaW50IGJ1c3lfcXVldWVzOwogCi0JaW50IHJx
X2luX2RyaXZlclsyXTsKLQlpbnQgc3luY19mbGlnaHQ7CisJaW50IHJxX2luX2RyaXZlcjsKKwlp
bnQgcnFfaW5fZmxpZ2h0WzJdOwogCiAJLyoKIAkgKiBxdWV1ZS1kZXB0aCBkZXRlY3Rpb24KQEAg
LTQxOSwxMSArNDE5LDYgQEAgc3RhdGljIHN0cnVjdCBjZnFfcXVldWUgKmNmcV9nZXRfcXVldWUo
c3RydWN0IGNmcV9kYXRhICosIGJvb2wsCiBzdGF0aWMgc3RydWN0IGNmcV9pb19jb250ZXh0ICpj
ZnFfY2ljX2xvb2t1cChzdHJ1Y3QgY2ZxX2RhdGEgKiwKIAkJCQkJCXN0cnVjdCBpb19jb250ZXh0
ICopOwogCi1zdGF0aWMgaW5saW5lIGludCBycV9pbl9kcml2ZXIoc3RydWN0IGNmcV9kYXRhICpj
ZnFkKQotewotCXJldHVybiBjZnFkLT5ycV9pbl9kcml2ZXJbMF0gKyBjZnFkLT5ycV9pbl9kcml2
ZXJbMV07Ci19Ci0KIHN0YXRpYyBpbmxpbmUgc3RydWN0IGNmcV9xdWV1ZSAqY2ljX3RvX2NmcXEo
c3RydWN0IGNmcV9pb19jb250ZXh0ICpjaWMsCiAJCQkJCSAgICBib29sIGlzX3N5bmMpCiB7CkBA
IC0xNDIzLDkgKzE0MTgsOSBAQCBzdGF0aWMgdm9pZCBjZnFfYWN0aXZhdGVfcmVxdWVzdChzdHJ1
Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0IHJlcXVlc3QgKnJxKQogewogCXN0cnVjdCBjZnFf
ZGF0YSAqY2ZxZCA9IHEtPmVsZXZhdG9yLT5lbGV2YXRvcl9kYXRhOwogCi0JY2ZxZC0+cnFfaW5f
ZHJpdmVyW3JxX2lzX3N5bmMocnEpXSsrOworCWNmcWQtPnJxX2luX2RyaXZlcisrOwogCWNmcV9s
b2dfY2ZxcShjZnFkLCBSUV9DRlFRKHJxKSwgImFjdGl2YXRlIHJxLCBkcnY9JWQiLAotCQkJCQkJ
cnFfaW5fZHJpdmVyKGNmcWQpKTsKKwkJCQkJCWNmcWQtPnJxX2luX2RyaXZlcik7CiAKIAljZnFk
LT5sYXN0X3Bvc2l0aW9uID0gYmxrX3JxX3BvcyhycSkgKyBibGtfcnFfc2VjdG9ycyhycSk7CiB9
CkBAIC0xNDMzLDEyICsxNDI4LDExIEBAIHN0YXRpYyB2b2lkIGNmcV9hY3RpdmF0ZV9yZXF1ZXN0
KHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBzdHJ1Y3QgcmVxdWVzdCAqcnEpCiBzdGF0aWMgdm9p
ZCBjZnFfZGVhY3RpdmF0ZV9yZXF1ZXN0KHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBzdHJ1Y3Qg
cmVxdWVzdCAqcnEpCiB7CiAJc3RydWN0IGNmcV9kYXRhICpjZnFkID0gcS0+ZWxldmF0b3ItPmVs
ZXZhdG9yX2RhdGE7Ci0JY29uc3QgaW50IHN5bmMgPSBycV9pc19zeW5jKHJxKTsKIAotCVdBUk5f
T04oIWNmcWQtPnJxX2luX2RyaXZlcltzeW5jXSk7Ci0JY2ZxZC0+cnFfaW5fZHJpdmVyW3N5bmNd
LS07CisJV0FSTl9PTighY2ZxZC0+cnFfaW5fZHJpdmVyKTsKKwljZnFkLT5ycV9pbl9kcml2ZXIt
LTsKIAljZnFfbG9nX2NmcXEoY2ZxZCwgUlFfQ0ZRUShycSksICJkZWFjdGl2YXRlIHJxLCBkcnY9
JWQiLAotCQkJCQkJcnFfaW5fZHJpdmVyKGNmcWQpKTsKKwkJCQkJCWNmcWQtPnJxX2luX2RyaXZl
cik7CiB9CiAKIHN0YXRpYyB2b2lkIGNmcV9yZW1vdmVfcmVxdWVzdChzdHJ1Y3QgcmVxdWVzdCAq
cnEpCkBAIC0xODc2LDggKzE4NzAsNyBAQCBzdGF0aWMgdm9pZCBjZnFfZGlzcGF0Y2hfaW5zZXJ0
KHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBzdHJ1Y3QgcmVxdWVzdCAqcnEpCiAJY2ZxcS0+ZGlz
cGF0Y2hlZCsrOwogCWVsdl9kaXNwYXRjaF9zb3J0KHEsIHJxKTsKIAotCWlmIChjZnFfY2ZxcV9z
eW5jKGNmcXEpKQotCQljZnFkLT5zeW5jX2ZsaWdodCsrOworCWNmcWQtPnJxX2luX2ZsaWdodFtj
ZnFfY2ZxcV9zeW5jKGNmcXEpXSsrOwogCWNmcXEtPm5yX3NlY3RvcnMgKz0gYmxrX3JxX3NlY3Rv
cnMocnEpOwogfQogCkBAIC0yMjI0LDEzICsyMjE3LDEzIEBAIHN0YXRpYyBib29sIGNmcV9tYXlf
ZGlzcGF0Y2goc3RydWN0IGNmcV9kYXRhICpjZnFkLCBzdHJ1Y3QgY2ZxX3F1ZXVlICpjZnFxKQog
CS8qCiAJICogRHJhaW4gYXN5bmMgcmVxdWVzdHMgYmVmb3JlIHdlIHN0YXJ0IHN5bmMgSU8KIAkg
Ki8KLQlpZiAoY2ZxX3Nob3VsZF9pZGxlKGNmcWQsIGNmcXEpICYmIGNmcWQtPnJxX2luX2RyaXZl
cltCTEtfUldfQVNZTkNdKQorCWlmIChjZnFfc2hvdWxkX2lkbGUoY2ZxZCwgY2ZxcSkgJiYgY2Zx
ZC0+cnFfaW5fZmxpZ2h0W0JMS19SV19BU1lOQ10pCiAJCXJldHVybiBmYWxzZTsKIAogCS8qCiAJ
ICogSWYgdGhpcyBpcyBhbiBhc3luYyBxdWV1ZSBhbmQgd2UgaGF2ZSBzeW5jIElPIGluIGZsaWdo
dCwgbGV0IGl0IHdhaXQKIAkgKi8KLQlpZiAoY2ZxZC0+c3luY19mbGlnaHQgJiYgIWNmcV9jZnFx
X3N5bmMoY2ZxcSkpCisJaWYgKGNmcWQtPnJxX2luX2ZsaWdodFtCTEtfUldfU1lOQ10gJiYgIWNm
cV9jZnFxX3N5bmMoY2ZxcSkpCiAJCXJldHVybiBmYWxzZTsKIAogCW1heF9kaXNwYXRjaCA9IGNm
cWQtPmNmcV9xdWFudHVtOwpAQCAtMzIyMCwxNCArMzIxMywxNCBAQCBzdGF0aWMgdm9pZCBjZnFf
dXBkYXRlX2h3X3RhZyhzdHJ1Y3QgY2ZxX2RhdGEgKmNmcWQpCiB7CiAJc3RydWN0IGNmcV9xdWV1
ZSAqY2ZxcSA9IGNmcWQtPmFjdGl2ZV9xdWV1ZTsKIAotCWlmIChycV9pbl9kcml2ZXIoY2ZxZCkg
PiBjZnFkLT5od190YWdfZXN0X2RlcHRoKQotCQljZnFkLT5od190YWdfZXN0X2RlcHRoID0gcnFf
aW5fZHJpdmVyKGNmcWQpOworCWlmIChjZnFkLT5ycV9pbl9kcml2ZXIgPiBjZnFkLT5od190YWdf
ZXN0X2RlcHRoKQorCQljZnFkLT5od190YWdfZXN0X2RlcHRoID0gY2ZxZC0+cnFfaW5fZHJpdmVy
OwogCiAJaWYgKGNmcWQtPmh3X3RhZyA9PSAxKQogCQlyZXR1cm47CiAKIAlpZiAoY2ZxZC0+cnFf
cXVldWVkIDw9IENGUV9IV19RVUVVRV9NSU4gJiYKLQkgICAgcnFfaW5fZHJpdmVyKGNmcWQpIDw9
IENGUV9IV19RVUVVRV9NSU4pCisJICAgIGNmcWQtPnJxX2luX2RyaXZlciA8PSBDRlFfSFdfUVVF
VUVfTUlOKQogCQlyZXR1cm47CiAKIAkvKgpAQCAtMzIzNyw3ICszMjMwLDcgQEAgc3RhdGljIHZv
aWQgY2ZxX3VwZGF0ZV9od190YWcoc3RydWN0IGNmcV9kYXRhICpjZnFkKQogCSAqLwogCWlmIChj
ZnFxICYmIGNmcV9jZnFxX2lkbGVfd2luZG93KGNmcXEpICYmCiAJICAgIGNmcXEtPmRpc3BhdGNo
ZWQgKyBjZnFxLT5xdWV1ZWRbMF0gKyBjZnFxLT5xdWV1ZWRbMV0gPAotCSAgICBDRlFfSFdfUVVF
VUVfTUlOICYmIHJxX2luX2RyaXZlcihjZnFkKSA8IENGUV9IV19RVUVVRV9NSU4pCisJICAgIENG
UV9IV19RVUVVRV9NSU4gJiYgY2ZxZC0+cnFfaW5fZHJpdmVyIDwgQ0ZRX0hXX1FVRVVFX01JTikK
IAkJcmV0dXJuOwogCiAJaWYgKGNmcWQtPmh3X3RhZ19zYW1wbGVzKysgPCA1MCkKQEAgLTMyOTAs
MTMgKzMyODMsMTIgQEAgc3RhdGljIHZvaWQgY2ZxX2NvbXBsZXRlZF9yZXF1ZXN0KHN0cnVjdCBy
ZXF1ZXN0X3F1ZXVlICpxLCBzdHJ1Y3QgcmVxdWVzdCAqcnEpCiAKIAljZnFfdXBkYXRlX2h3X3Rh
ZyhjZnFkKTsKIAotCVdBUk5fT04oIWNmcWQtPnJxX2luX2RyaXZlcltzeW5jXSk7CisJV0FSTl9P
TighY2ZxZC0+cnFfaW5fZHJpdmVyKTsKIAlXQVJOX09OKCFjZnFxLT5kaXNwYXRjaGVkKTsKLQlj
ZnFkLT5ycV9pbl9kcml2ZXJbc3luY10tLTsKKwljZnFkLT5ycV9pbl9kcml2ZXItLTsKIAljZnFx
LT5kaXNwYXRjaGVkLS07CiAKLQlpZiAoY2ZxX2NmcXFfc3luYyhjZnFxKSkKLQkJY2ZxZC0+c3lu
Y19mbGlnaHQtLTsKKwljZnFkLT5ycV9pbl9mbGlnaHRbY2ZxX2NmcXFfc3luYyhjZnFxKV0tLTsK
IAogCWlmIChzeW5jKSB7CiAJCVJRX0NJQyhycSktPmxhc3RfZW5kX3JlcXVlc3QgPSBub3c7CkBA
IC0zMzUwLDcgKzMzNDIsNyBAQCBzdGF0aWMgdm9pZCBjZnFfY29tcGxldGVkX3JlcXVlc3Qoc3Ry
dWN0IHJlcXVlc3RfcXVldWUgKnEsIHN0cnVjdCByZXF1ZXN0ICpycSkKIAkJfQogCX0KIAotCWlm
ICghcnFfaW5fZHJpdmVyKGNmcWQpKQorCWlmICghY2ZxZC0+cnFfaW5fZHJpdmVyKQogCQljZnFf
c2NoZWR1bGVfZGlzcGF0Y2goY2ZxZCk7CiB9CiAKLS0gCjEuNi40LjQKCg==
--001636c9255fa4fec0047c1cebcd
Content-Type: application/octet-stream; 
	name="0005-cfq-iosched-rework-seeky-detection.patch"
Content-Disposition: attachment; 
	filename="0005-cfq-iosched-rework-seeky-detection.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g3x4xeo83

RnJvbSBjNmViMTM2MjA1YzBiNmViZTJlOTczMmRlMjQ5ZGRlZmJhMjZkNDFkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBDb3JyYWRvIFpvY2NvbG8gPGN6b2Njb2xvQGdtYWlsLmNvbT4K
RGF0ZTogVGh1LCAzMSBEZWMgMjAwOSAxMzo0MTo1OSArMDEwMApTdWJqZWN0OiBbUEFUQ0ggNS81
XSBjZnEtaW9zY2hlZDogcmV3b3JrIHNlZWt5IGRldGVjdGlvbgoKLS0tCiBibG9jay9jZnEtaW9z
Y2hlZC5jIHwgICA1NCArKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCA0MCBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9ibG9jay9jZnEtaW9zY2hlZC5jIGIvYmxvY2svY2ZxLWlvc2NoZWQu
YwppbmRleCBjNmQ1Njc4Li40ZTIwM2M0IDEwMDY0NAotLS0gYS9ibG9jay9jZnEtaW9zY2hlZC5j
CisrKyBiL2Jsb2NrL2NmcS1pb3NjaGVkLmMKQEAgLTEzMyw5ICsxMzMsNyBAQCBzdHJ1Y3QgY2Zx
X3F1ZXVlIHsKIAl1bnNpZ25lZCBzaG9ydCBpb3ByaW8sIG9yZ19pb3ByaW87CiAJdW5zaWduZWQg
c2hvcnQgaW9wcmlvX2NsYXNzLCBvcmdfaW9wcmlvX2NsYXNzOwogCi0JdW5zaWduZWQgaW50IHNl
ZWtfc2FtcGxlczsKLQl1NjQgc2Vla190b3RhbDsKLQlzZWN0b3JfdCBzZWVrX21lYW47CisJdTMy
IHNlZWtfaGlzdG9yeTsKIAlzZWN0b3JfdCBsYXN0X3JlcXVlc3RfcG9zOwogCXVuc2lnbmVkIGxv
bmcgc2Vla3lfc3RhcnQ7CiAKQEAgLTE2NTgsMjIgKzE2NTYsMTMgQEAgc3RhdGljIGlubGluZSBz
ZWN0b3JfdCBjZnFfZGlzdF9mcm9tX2xhc3Qoc3RydWN0IGNmcV9kYXRhICpjZnFkLAogCQlyZXR1
cm4gY2ZxZC0+bGFzdF9wb3NpdGlvbiAtIGJsa19ycV9wb3MocnEpOwogfQogCi0jZGVmaW5lIENG
UVFfU0VFS19USFIJCTggKiAxMDI0Ci0jZGVmaW5lIENGUVFfU0VFS1koY2ZxcSkJKChjZnFxKS0+
c2Vla19tZWFuID4gQ0ZRUV9TRUVLX1RIUikKKyNkZWZpbmUgQ0ZRUV9TRUVLX1RIUgkJKHNlY3Rv
cl90KSg4ICogMTAwKQorI2RlZmluZSBDRlFRX1NFRUtZKGNmcXEpCShod2VpZ2h0MzIoY2ZxcS0+
c2Vla19oaXN0b3J5KSA+IDMyLzgpCiAKIHN0YXRpYyBpbmxpbmUgaW50IGNmcV9ycV9jbG9zZShz
dHJ1Y3QgY2ZxX2RhdGEgKmNmcWQsIHN0cnVjdCBjZnFfcXVldWUgKmNmcXEsCiAJCQkgICAgICAg
c3RydWN0IHJlcXVlc3QgKnJxLCBib29sIGZvcl9wcmVlbXB0KQogewotCXNlY3Rvcl90IHNkaXN0
ID0gY2ZxcS0+c2Vla19tZWFuOwotCi0JaWYgKCFzYW1wbGVfdmFsaWQoY2ZxcS0+c2Vla19zYW1w
bGVzKSkKLQkJc2Rpc3QgPSBDRlFRX1NFRUtfVEhSOwotCi0JLyogaWYgc2Vla19tZWFuIGlzIGJp
ZywgdXNpbmcgaXQgYXMgY2xvc2UgY3JpdGVyaWEgaXMgbWVhbmluZ2xlc3MgKi8KLQlpZiAoc2Rp
c3QgPiBDRlFRX1NFRUtfVEhSICYmICFmb3JfcHJlZW1wdCkKLQkJc2Rpc3QgPSBDRlFRX1NFRUtf
VEhSOwotCi0JcmV0dXJuIGNmcV9kaXN0X2Zyb21fbGFzdChjZnFkLCBycSkgPD0gc2Rpc3Q7CisJ
cmV0dXJuIGNmcV9kaXN0X2Zyb21fbGFzdChjZnFkLCBycSkgPD0gQ0ZRUV9TRUVLX1RIUjsKIH0K
IAogc3RhdGljIHN0cnVjdCBjZnFfcXVldWUgKmNmcXFfY2xvc2Uoc3RydWN0IGNmcV9kYXRhICpj
ZnFkLApAQCAtMjk3MSwzMCArMjk2MCwxNiBAQCBzdGF0aWMgdm9pZAogY2ZxX3VwZGF0ZV9pb19z
ZWVrdGltZShzdHJ1Y3QgY2ZxX2RhdGEgKmNmcWQsIHN0cnVjdCBjZnFfcXVldWUgKmNmcXEsCiAJ
CSAgICAgICBzdHJ1Y3QgcmVxdWVzdCAqcnEpCiB7Ci0Jc2VjdG9yX3Qgc2Rpc3Q7Ci0JdTY0IHRv
dGFsOwotCi0JaWYgKCFjZnFxLT5sYXN0X3JlcXVlc3RfcG9zKQotCQlzZGlzdCA9IDA7Ci0JZWxz
ZSBpZiAoY2ZxcS0+bGFzdF9yZXF1ZXN0X3BvcyA8IGJsa19ycV9wb3MocnEpKQotCQlzZGlzdCA9
IGJsa19ycV9wb3MocnEpIC0gY2ZxcS0+bGFzdF9yZXF1ZXN0X3BvczsKLQllbHNlCi0JCXNkaXN0
ID0gY2ZxcS0+bGFzdF9yZXF1ZXN0X3BvcyAtIGJsa19ycV9wb3MocnEpOwotCi0JLyoKLQkgKiBE
b24ndCBhbGxvdyB0aGUgc2VlayBkaXN0YW5jZSB0byBnZXQgdG9vIGxhcmdlIGZyb20gdGhlCi0J
ICogb2RkIGZyYWdtZW50LCBwYWdlaW4sIGV0YwotCSAqLwotCWlmIChjZnFxLT5zZWVrX3NhbXBs
ZXMgPD0gNjApIC8qIHNlY29uZCZ0aGlyZCBzZWVrICovCi0JCXNkaXN0ID0gbWluKHNkaXN0LCAo
Y2ZxcS0+c2Vla19tZWFuICogNCkgKyAyKjEwMjQqMTAyNCk7Ci0JZWxzZQotCQlzZGlzdCA9IG1p
bihzZGlzdCwgKGNmcXEtPnNlZWtfbWVhbiAqIDQpICsgMioxMDI0KjY0KTsKKwlzZWN0b3JfdCBz
ZGlzdCA9IDA7CisJaWYgKGNmcXEtPmxhc3RfcmVxdWVzdF9wb3MpIHsKKwkJaWYgKGNmcXEtPmxh
c3RfcmVxdWVzdF9wb3MgPCBibGtfcnFfcG9zKHJxKSkKKwkJCXNkaXN0ID0gYmxrX3JxX3Bvcyhy
cSkgLSBjZnFxLT5sYXN0X3JlcXVlc3RfcG9zOworCQllbHNlCisJCQlzZGlzdCA9IGNmcXEtPmxh
c3RfcmVxdWVzdF9wb3MgLSBibGtfcnFfcG9zKHJxKTsKKwl9CiAKLQljZnFxLT5zZWVrX3NhbXBs
ZXMgPSAoNypjZnFxLT5zZWVrX3NhbXBsZXMgKyAyNTYpIC8gODsKLQljZnFxLT5zZWVrX3RvdGFs
ID0gKDcqY2ZxcS0+c2Vla190b3RhbCArICh1NjQpMjU2KnNkaXN0KSAvIDg7Ci0JdG90YWwgPSBj
ZnFxLT5zZWVrX3RvdGFsICsgKGNmcXEtPnNlZWtfc2FtcGxlcy8yKTsKLQlkb19kaXYodG90YWws
IGNmcXEtPnNlZWtfc2FtcGxlcyk7Ci0JY2ZxcS0+c2Vla19tZWFuID0gKHNlY3Rvcl90KXRvdGFs
OworCWNmcXEtPnNlZWtfaGlzdG9yeSA8PD0gMTsKKwljZnFxLT5zZWVrX2hpc3RvcnkgfD0gKHNk
aXN0ID4gQ0ZRUV9TRUVLX1RIUik7CiAKIAkvKgogCSAqIElmIHRoaXMgY2ZxcSBpcyBzaGFyZWQg
YmV0d2VlbiBtdWx0aXBsZSBwcm9jZXNzZXMsIGNoZWNrIHRvCkBAIC0zMDMyLDggKzMwMDcsNyBA
QCBjZnFfdXBkYXRlX2lkbGVfd2luZG93KHN0cnVjdCBjZnFfZGF0YSAqY2ZxZCwgc3RydWN0IGNm
cV9xdWV1ZSAqY2ZxcSwKIAkJY2ZxX21hcmtfY2ZxcV9kZWVwKGNmcXEpOwogCiAJaWYgKCFhdG9t
aWNfcmVhZCgmY2ljLT5pb2MtPm5yX3Rhc2tzKSB8fCAhY2ZxZC0+Y2ZxX3NsaWNlX2lkbGUgfHwK
LQkgICAgKCFjZnFfY2ZxcV9kZWVwKGNmcXEpICYmIHNhbXBsZV92YWxpZChjZnFxLT5zZWVrX3Nh
bXBsZXMpCi0JICAgICAmJiBDRlFRX1NFRUtZKGNmcXEpKSkKKwkgICAgKCFjZnFfY2ZxcV9kZWVw
KGNmcXEpICYmIENGUVFfU0VFS1koY2ZxcSkpKQogCQllbmFibGVfaWRsZSA9IDA7CiAJZWxzZSBp
ZiAoc2FtcGxlX3ZhbGlkKGNpYy0+dHRpbWVfc2FtcGxlcykpIHsKIAkJaWYgKGNpYy0+dHRpbWVf
bWVhbiA+IGNmcWQtPmNmcV9zbGljZV9pZGxlKQotLSAKMS42LjQuNAoK
--001636c9255fa4fec0047c1cebcd--
