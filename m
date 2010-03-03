Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437Ab0CCTrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:47:41 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59164 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab0CCTrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:47:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=aWa0tqrQMREjplUyfvcH+/kCF4LNYgkZNdn7bTCJ0eoP7TDLif46kGqmtN6eRJdvn7
         /SIBTpeodk3Z11xOCNkCzahoWjYJL9yIuO4PQKsqbdlRe1TmSbOmxLI6Sfwg2Kbb4Cmd
         zukrOBn7I2oM11JNtcfTyAYu3ho3FyXrqMGz8=
MIME-Version: 1.0
In-Reply-To: <20100301142553.GB8878@redhat.com>
References: <1267296340-3820-1-git-send-email-czoccolo@gmail.com>
	 <1267296340-3820-2-git-send-email-czoccolo@gmail.com>
	 <1267296340-3820-3-git-send-email-czoccolo@gmail.com>
	 <20100301142553.GB8878@redhat.com>
Date: Wed, 3 Mar 2010 20:47:31 +0100
Message-ID: <4e5e476b1003031147n6a53b646k418483a93013d77c@mail.gmail.com>
Subject: Re: [PATCH 2/2] cfq-iosched: rethink seeky detection for SSDs
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Content-Type: multipart/mixed; boundary=0016e6469722d8eb890480eac025
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6469722d8eb890480eac025
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Vivek,
On Mon, Mar 1, 2010 at 3:25 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Sat, Feb 27, 2010 at 07:45:40PM +0100, Corrado Zoccolo wrote:
>> CFQ currently applies the same logic of detecting seeky queues and
>> grouping them together for rotational disks as well as SSDs.
>> For SSDs, the time to complete a request doesn't depend on the
>> request location, but only on the size.
>> This patch therefore changes the criterion to group queues by
>> request size in case of SSDs, in order to achieve better fairness.
>
> Hi Corrado,
>
> Can you give some numbers regarding how are you measuring fairness and
> how did you decide that we achieve better fairness?
>
Please, see the attached fio script. It benchmarks pairs of processes
performing direct random I/O.
One is always fixed at bs=3D4k , while I vary the other from 8K to 64K
test00: (g=3D0): rw=3Drandread, bs=3D8K-8K/8K-8K, ioengine=3Dsync, iodepth=
=3D1
test01: (g=3D0): rw=3Drandread, bs=3D4K-4K/4K-4K, ioengine=3Dsync, iodepth=
=3D1
test10: (g=3D1): rw=3Drandread, bs=3D16K-16K/16K-16K, ioengine=3Dsync, iode=
pth=3D1
test11: (g=3D1): rw=3Drandread, bs=3D4K-4K/4K-4K, ioengine=3Dsync, iodepth=
=3D1
test20: (g=3D2): rw=3Drandread, bs=3D32K-32K/32K-32K, ioengine=3Dsync, iode=
pth=3D1
test21: (g=3D2): rw=3Drandread, bs=3D4K-4K/4K-4K, ioengine=3Dsync, iodepth=
=3D1
test30: (g=3D3): rw=3Drandread, bs=3D64K-64K/64K-64K, ioengine=3Dsync, iode=
pth=3D1
test31: (g=3D3): rw=3Drandread, bs=3D4K-4K/4K-4K, ioengine=3Dsync, iodepth=
=3D1

With unpatched cfq (2.6.33), on a flash card (non-ncq), after running
a fio script with high number of parallel readers to make sure ncq
detection is stabilized, I get the following:
Run status group 0 (all jobs):
   READ: io=3D21528KiB, aggrb=3D4406KiB/s, minb=3D1485KiB/s, maxb=3D2922KiB=
/s,
mint=3D5001msec, maxt=3D5003msec

Run status group 1 (all jobs):
   READ: io=3D31524KiB, aggrb=3D6452KiB/s, minb=3D1327KiB/s, maxb=3D5126KiB=
/s,
mint=3D5002msec, maxt=3D5003msec

Run status group 2 (all jobs):
   READ: io=3D46544KiB, aggrb=3D9524KiB/s, minb=3D1031KiB/s, maxb=3D8493KiB=
/s,
mint=3D5001msec, maxt=3D5004msec

Run status group 3 (all jobs):
   READ: io=3D64712KiB, aggrb=3D13242KiB/s, minb=3D761KiB/s,
maxb=3D12486KiB/s, mint=3D5002msec, maxt=3D5004msec

As you can see from minb, the process with smallest I/O size is
penalized (the fact is that being both marked as noidle, they both end
up in the noidle tree, where they are serviced round robin, so they
get fairness in term of IOPS, but bandwidth varies a lot.

With my patches in place, I get:
Run status group 0 (all jobs):
   READ: io=3D21544KiB, aggrb=3D4409KiB/s, minb=3D1511KiB/s, maxb=3D2898KiB=
/s,
mint=3D5002msec, maxt=3D5003msec

Run status group 1 (all jobs):
   READ: io=3D32000KiB, aggrb=3D6549KiB/s, minb=3D1277KiB/s, maxb=3D5274KiB=
/s,
mint=3D5001msec, maxt=3D5003msec

Run status group 2 (all jobs):
   READ: io=3D39444KiB, aggrb=3D8073KiB/s, minb=3D1576KiB/s, maxb=3D6498KiB=
/s,
mint=3D5002msec, maxt=3D5003msec

Run status group 3 (all jobs):
   READ: io=3D49180KiB, aggrb=3D10059KiB/s, minb=3D1512KiB/s,
maxb=3D8548KiB/s, mint=3D5001msec, maxt=3D5006msec

The process doing smaller requests is now not penalized by the fact
that it is run concurrently with the other one, and the other still
benefits from larger requests because it uses better its time slice.

> In case of SSDs with NCQ, we will not idle on any of the queues (either
> sync or sync-noidle (seeky queues)). So w.r.t code, what behavior changes
> if we mark a queue as seeky/non-seeky on SSD?
>

I've not tested on NCQ SSD, but I think at worst it will not harm, and
at best, it will provide similar fairness improvements when the queue
of processes submitting requests grows above the available NCQ slots.

> IOW, looking at this patch, now any queue doing IO in smaller chunks than
> 32K on SSD will be marked as seeky. How does that change the behavior in
> terms of fairness for the queue?
>
Basically, we will have IOPS based fairness for small requests, and
time based fairness for larger requests.

Thanks,
Corrado

> Thanks
> Vivek
>
>>
>> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
>> ---
>> =C2=A0block/cfq-iosched.c | =C2=A0 =C2=A07 ++++++-
>> =C2=A01 files changed, 6 insertions(+), 1 deletions(-)
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index 806d30b..f27e535 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -47,6 +47,7 @@ static const int cfq_hist_divisor =3D 4;
>> =C2=A0#define CFQ_SERVICE_SHIFT =C2=A0 =C2=A0 =C2=A0 12
>>
>> =C2=A0#define CFQQ_SEEK_THR =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0(sector_t)(8 * 100)
>> +#define CFQQ_SECT_THR_NONROT (sector_t)(2 * 32)
>> =C2=A0#define CFQQ_SEEKY(cfqq) =C2=A0 =C2=A0 (hweight32(cfqq->seek_histo=
ry) > 32/8)
>>
>> =C2=A0#define RQ_CIC(rq) =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \
>> @@ -2958,6 +2959,7 @@ cfq_update_io_seektime(struct cfq_data *cfqd, stru=
ct cfq_queue *cfqq,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0struct request *rq)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 sector_t sdist =3D 0;
>> + =C2=A0 =C2=A0 sector_t n_sec =3D blk_rq_sectors(rq);
>> =C2=A0 =C2=A0 =C2=A0 if (cfqq->last_request_pos) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (cfqq->last_request_=
pos < blk_rq_pos(rq))
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 sdist =3D blk_rq_pos(rq) - cfqq->last_request_pos;
>> @@ -2966,7 +2968,10 @@ cfq_update_io_seektime(struct cfq_data *cfqd, str=
uct cfq_queue *cfqq,
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> =C2=A0 =C2=A0 =C2=A0 cfqq->seek_history <<=3D 1;
>> - =C2=A0 =C2=A0 cfqq->seek_history |=3D (sdist > CFQQ_SEEK_THR);
>> + =C2=A0 =C2=A0 if (blk_queue_nonrot(cfqd->queue))
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cfqq->seek_history |=3D (n_s=
ec < CFQQ_SECT_THR_NONROT);
>> + =C2=A0 =C2=A0 else
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cfqq->seek_history |=3D (sdi=
st > CFQQ_SEEK_THR);
>> =C2=A0}
>>
>> =C2=A0/*
>> --
>> 1.6.4.4
>

--0016e6469722d8eb890480eac025
Content-Type: application/octet-stream; name="fair.fio"
Content-Disposition: attachment; filename="fair.fio"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g6ciibhj0

W2dsb2JhbF0Kc2l6ZT0xRwppb2VuZ2luZT1zeW5jCmludmFsaWRhdGU9MQpydW50aW1lPTUKdGlt
ZV9iYXNlZApkaXJlY3Q9MQoKW3Rlc3QwMF0Kcnc9cmFuZHJlYWQKYnM9OGsKZmlsZW5hbWU9dGVz
dGZpbGUxCgpbdGVzdDAxXQpydz1yYW5kcmVhZApicz00awpmaWxlbmFtZT10ZXN0ZmlsZTIKClt0
ZXN0MTBdCnJ3PXJhbmRyZWFkCmJzPTE2awpmaWxlbmFtZT10ZXN0ZmlsZTEKc3RvbmV3YWxsCgpb
dGVzdDExXQpydz1yYW5kcmVhZApicz00awpmaWxlbmFtZT10ZXN0ZmlsZTIKClt0ZXN0MjBdCnJ3
PXJhbmRyZWFkCmJzPTMyawpmaWxlbmFtZT10ZXN0ZmlsZTEKc3RvbmV3YWxsCgpbdGVzdDIxXQpy
dz1yYW5kcmVhZApicz00awpmaWxlbmFtZT10ZXN0ZmlsZTIKClt0ZXN0MzBdCnJ3PXJhbmRyZWFk
CmJzPTY0awpmaWxlbmFtZT10ZXN0ZmlsZTEKc3RvbmV3YWxsCgpbdGVzdDMxXQpydz1yYW5kcmVh
ZApicz00awpmaWxlbmFtZT10ZXN0ZmlsZTIK
--0016e6469722d8eb890480eac025--
