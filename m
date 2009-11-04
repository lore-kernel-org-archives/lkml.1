Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbZKDR7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbZKDR7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754879AbZKDR7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:59:45 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:62699 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757392AbZKDR7m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:59:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xKSMSa9H2UNl5ORLkLTSgVxPKxLMOFpjol2TRFFj3YVZYX+yvDfFsOz8/M4gKVSkss
         iWFUF+IXcZ2+jPDafQfPK43vOIXq2lrEvq2xF06B+pRzHakZvNtbK1rj5Xf7KIySSjSU
         F9gPWS2tJxo4oDKKM5HzD+52OrhT6i9jsPe1w=
MIME-Version: 1.0
In-Reply-To: <20091104163752.GB2870@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
	 <1257291837-6246-3-git-send-email-vgoyal@redhat.com>
	 <x49d43yuzud.fsf@segfault.boston.devel.redhat.com>
	 <20091104163752.GB2870@redhat.com>
Date: Wed, 4 Nov 2009 18:59:45 +0100
Message-ID: <4e5e476b0911040959t122df6aaqee1039f265cbd18a@mail.gmail.com>
Subject: Re: [PATCH 02/20] blkio: Change CFQ to use CFS like queue time stamps
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 5:37 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Nov 04, 2009 at 09:30:34AM -0500, Jeff Moyer wrote:
>> Vivek Goyal <vgoyal@redhat.com> writes:
>>
>
> Thanks for the review Jeff.
>
>> > o Currently CFQ provides priority scaled time slices to processes. If a process
>> >   does not use the time slice, either because process did not have sufficient
>> >   IO to do or because think time of process is large and CFQ decided to disable
>> >   idling, then processes looses it time slice share.
>>                            ^^^^^^
>> loses
>>
should be 'process loses'

>> > +static inline u64 max_vdisktime(u64 min_vdisktime, u64 vdisktime)
>> > +{
>> > +   s64 delta = (s64)(vdisktime - min_vdisktime);
>> > +   if (delta > 0)
>> > +           min_vdisktime = vdisktime;
>> > +
>> > +   return min_vdisktime;
>> > +}
>> > +
>> > +static inline u64 min_vdisktime(u64 min_vdisktime, u64 vdisktime)
>> > +{
>> > +   s64 delta = (s64)(vdisktime - min_vdisktime);
>> > +   if (delta < 0)
>> > +           min_vdisktime = vdisktime;
>> > +
>> > +   return min_vdisktime;
>> > +}
>>
>> Is there a reason you've reimplemented min and max?
>
> I think you are referring to min_t and max_t. Will these macros take care
> of wrapping too?
>
> For example, if I used min_t(u64, A, B), then unsigned comparision will
> not work right wrapping has just taken place for any of the A or B. So if
> A=-1 and B=2, then min_t() would return B as minimum. This is not right
> in our case.
>
> If we do signed comparison (min_t(s64, A, B)), that also seems to be
> broken in another case where a value of variable moves from 63bits to 64bits,
> (A=0x7fffffffffffffff, B=0x8000000000000000). Above will return B as minimum but
> in our scanario, vdisktime will progress from 0x7fffffffffffffff to
> 0x8000000000000000 and A should be returned as minimum (unsigned
> comparison).
>
> Hence I took these difnitions from CFS.
If those are times (measured in jiffies), why are you using u64? You
could use unsigned long and time_before/time_after, that perform the
proper wrap checking.


Corrado
