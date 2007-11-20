Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbXKTOlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbXKTOlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 09:41:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbXKTOk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 09:40:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbXKTOk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 09:40:57 -0500
Message-ID: <4742F1DE.1090902@redhat.com>
Date: Tue, 20 Nov 2007 15:40:30 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Alasdair G Kergon <agk@redhat.com>
Subject: Re: 2.6.24-rc2-mm1: kcryptd vs lockdep
References: <64bb37e0711182323v1e2a1341tfc7f20df771b988@mail.gmail.com>	 <20071119075627.GB28432@elte.hu>	 <64bb37e0711191134l6dac07a2ie3b4258c43e1f1f0@mail.gmail.com>	 <4741F97D.6090808@redhat.com> <64bb37e0711192255j3fabd3d9g94544b3d518828a2@mail.gmail.com>
In-Reply-To: <64bb37e0711192255j3fabd3d9g94544b3d518828a2@mail.gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Torsten Kaiser wrote:
> On Nov 19, 2007 10:00 PM, Milan Broz <mbroz@redhat.com> wrote:
>> Torsten Kaiser wrote:
>>> Anything I could try, apart from more boots with slub_debug=F?
> 
> One time it triggered with slub_debug=F, but no additional output.
> With slub_debug=FP I have not seen it again, so I can't say if that
> would yield more info.
> 
>> Please could you try which patch from the dm-crypt series cause this ?
>> (agk-dm-dm-crypt* names.)
>>
>> I suspect agk-dm-dm-crypt-move-bio-submission-to-thread.patch because
>> there is one work struct used subsequently in two threads...
>> (io thread already started while crypt thread is processing lockdep_map
>> after calling f(work)...)
> 
> After reverting only
> agk-dm-dm-crypt-move-bio-submission-to-thread.patch I also have not
> seen the 'held lock freed' message again.

Ok, then I have question: Is the following pseudocode correct
(and problem is in lock validation which checks something
already initialized for another queue) or reusing work_struct
is not permitted from inside called work function ?

(Note comment in code "It is permissible to free the struct
work_struct from inside the function that is called from it".)

struct work_struct work;
struct workqueue_struct *a, *b;

do_b(*work) 
{
	/* do something else */
}

do_a(*work)
{
	/* do something */
	INIT_WORK(&work, do_b);
	queue_work(b, &work);
}


INIT_WORK(&work, do_a);
queue_work(a, &work);

Milan
--
mbroz@redhat.com
