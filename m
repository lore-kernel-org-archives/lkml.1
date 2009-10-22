Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZJVKn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZJVKn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 06:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbZJVKn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 06:43:29 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:48972 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbZJVKn2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 06:43:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HJh5FDRcS+6T3+7L81FWe4XY8y/Zwyb5ZvVhyF7a0rIJUuRPBR0zGNs5ToQSgvjJa2
         qiE9lLmyWnqeDSIBnFUwzH9KBp/9UtGxj3VoKonU1T1ALssS6fQuN4u58WpFFa4rPT7S
         U3+qdng9/158z/DjuwWhNf5GrW2kKPBxNKmkU=
MIME-Version: 1.0
In-Reply-To: <x49tyxs7lge.fsf@segfault.boston.devel.redhat.com>
References: <200910202011.53858.czoccolo@gmail.com>
	 <x49aazk91uj.fsf@segfault.boston.devel.redhat.com>
	 <4e5e476b0910210932l2dffdabdv67a449ca162efd0f@mail.gmail.com>
	 <x49tyxs7lge.fsf@segfault.boston.devel.redhat.com>
Date: Thu, 22 Oct 2009 12:43:32 +0200
Message-ID: <4e5e476b0910220343q2af96eedr69cda2594822af76@mail.gmail.com>
Subject: Re: [RFC V2 PATCH 1/5] cfq-iosched: adapt slice to number of 
	processes doing I/O
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,
On Wed, Oct 21, 2009 at 6:36 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
>
> OK.  The idea was to try to make the thing a bit more digestable.
> Honestly, I had to re-write it to figure out what it was doing.  Could
> you rework it so the logic is more obvious to others and still correct?

What about:
/* interested queues (we consider only the ones with the same priority class) */
unsigned iq = cfq_get_avg_queues(cfqd, cfq_class_rt(cfqq));
unsigned sync_slice = cfqd->cfq_slice[1];
unsigned expected_latency = sync_slice * iq;
if (expected_latency > target_latency) {
	unsigned base_low_slice = 2 * cfqd->cfq_slice_idle;
	/* scale low_slice according to IO priority and sync vs async */
	unsigned low_slice = min(slice,  base_low_slice * slice / sync_slice);
	/* the adapted slice value is scaled to fit all iqs into the target latency */
	slice = max(slice * cfq_target_latency / expected_latency, low_slice);
}

BTW, the other complex part of the patch, i.e. the definition of
cfq_get_avg_queues, could be simplified if we hard-code the divisor,
that is currently defined outside to allow for some experimentation.

Thanks for your comments
Corrado

>
> Thanks!
> Jeff
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
