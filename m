Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394AbZDTJIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbZDTJIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 05:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbZDTJHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 05:07:52 -0400
Received: from smtp-out.google.com ([216.239.45.13]:17647 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbZDTJHv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 05:07:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=UHCH/I2w26TIPAMewbX2HxTuYUuik4WazZh5tl+h6CdmUfzzxYcbyJ8HH0yY3fnNg
	qPphIbL3GdjNv0teQ/Zbg==
MIME-Version: 1.0
In-Reply-To: <20090420.172959.193682665.ryov@valinux.co.jp>
References: <20090416.114750.226794985.ryov@valinux.co.jp>
	 <20090416141125.GB8896@redhat.com>
	 <e98e18940904161324p9833457vdf699d66bb323591@mail.gmail.com>
	 <20090420.172959.193682665.ryov@valinux.co.jp>
Date: Mon, 20 Apr 2009 02:07:44 -0700
Message-ID: <e98e18940904200207y62eca680t7cf938049375f4b3@mail.gmail.com>
Subject: Re: [dm-devel] Re: dm-ioband: Test results.
From: Nauman Rafique <nauman@google.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: vgoyal@redhat.com, fernando@oss.ntt.co.jp, linux-kernel@vger.kernel.org,
       jmoyer@redhat.com, dm-devel@redhat.com, jens.axboe@oracle.com,
       agk@redhat.com, balbir@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 1:29 AM, Ryo Tsuruta <ryov@valinux.co.jp> wrote:
> Hi Vivek and Nauman,
>
>> On Thu, Apr 16, 2009 at 7:11 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Thu, Apr 16, 2009 at 11:47:50AM +0900, Ryo Tsuruta wrote:
>> >> Hi Vivek,
>> >>
>> >> > General thoughts about dm-ioband
>> >> > ================================
>> >> > - Implementing control at second level has the advantage tha one does not
>> >> >   have to muck with IO scheduler code. But then it also has the
>> >> >   disadvantage that there is no communication with IO scheduler.
>> >> >
>> >> > - dm-ioband is buffering bio at higher layer and then doing FIFO release
>> >> >   of these bios. This FIFO release can lead to priority inversion problems
>> >> >   in certain cases where RT requests are way behind BE requests or
>> >> >   reader starvation where reader bios are getting hidden behind writer
>> >> >   bios etc. These are hard to notice issues in user space. I guess above
>> >> >   RT results do highlight the RT task problems. I am still working on
>> >> >   other test cases and see if i can show the probelm.
>>
>> Ryo, I could not agree more with Vivek here. At Google, we have very
>> stringent requirement for latency of our RT requests. If RT requests
>> get queued in any higher layer (behind BE requests), all bets are off.
>> I don't find doing IO control at two layer for this particular reason.
>> The upper layer (dm-ioband in this case) would have to make sure that
>> RT requests are released immediately, irrespective of the state (FIFO
>> queuing and tokens held). And the lower layer (IO scheduling layer)
>> has to do the same. This requirement is not specific to us. I have
>> seen similar comments from filesystem folks here previously, in the
>> context of metadata updates being submitted as RT. Basically, the
>> semantics of RT class has to be preserved by any solution that is
>> build on top of CFQ scheduler.
>
> I could see the priority inversion by running Vivek's script and I
> understand how RT requests has to be handled. I'll create a patch
> which makes dm-ioband cooperates with CFQ scheduler. However, do you
> think we need some kind of limitation on processes which belong to the
> RT class to prevent the processes from depleting bandwidth?

If you are talking about starvation that could be caused by RT tasks,
you are right. We need some mechanism to introduce starvation
prevention, but I think that is an issue that can be tackled once we
decide where to do bandwidth control.

The real question is, once you create a version of dm-ioband that
co-operates with CFQ scheduler, how that solution would compare with
the patch set Vivek has posted? In my opinion, we need to converge to
one solution as soon as possible, so that we can work on it together
to refine and test it.

>
> Thanks,
> Ryo Tsuruta
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
