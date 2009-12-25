Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbZLYKQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbZLYKQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 05:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZLYKQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 05:16:28 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:36601 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbZLYKQ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 05:16:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=W6sJOo9KCSAtSBKP4HBVVDx6ZQEUap3gSXfeaQwg1INdC2Qf3gUDvmetJHtB1l14zd
         iLwkUo/ExqLubTihX14TyenYdK+cOAkV5LxXyjZtufTwZUhsBsDcY88LjkAgmCBMDVMX
         lrgcWSTXBOB5ozkUKuLej8h3t4CCsBZ0fZZls=
MIME-Version: 1.0
In-Reply-To: <20091224005506.GA7879@sli10-desk.sh.intel.com>
References: <20091224005506.GA7879@sli10-desk.sh.intel.com>
Date: Fri, 25 Dec 2009 11:16:27 +0100
Message-ID: <4e5e476b0912250216n2b4aceacyf22a0e73425efd3a@mail.gmail.com>
Subject: Re: cfq-iosched: tiobench regression
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, jmoyer@redhat.com,
       yanmin.zhang@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shaohua,
On Thu, Dec 24, 2009 at 1:55 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> df5fe3e8e13883f58dc97489076bbcc150789a21
> b3b6d0408c953524f979468562e7e210d8634150
> The coop merge is too aggressive. For example, if two tasks are reading two
> files where the two files have some adjecent blocks, cfq will immediately
> merge them. cfq_rq_close() also has trouble, sometimes the seek_mean is very
> big. I did a test to make cfq_rq_close() always checks the distence according
> to CIC_SEEK_THR, but still saw a lot of wrong merge. (BTW, why we take a long
> distence far away request as close. Taking them close doesn't improve any thoughtput
> to me. Maybe we should always use CIC_SEEK_THR as close criteria).
Yes, when deciding if two queues are going to be merged, we should use
the constant CIC_SEEK_THR.
> So sounds we need make split more aggressive. But the split is too lazay,
> which requires to wait 1s. Time based check isn't reliable as queue might not
> run at given time, so uses a small time isn't ok.
1s is too much, but I wouldn't abandon a time based approach. To fix
the problem of queue not being run, you can consider a slice. If at
the end of the slice, the queue is seeky, you split it.

> I'm thinking changing the split
> check based on requests number instead of time. That is if several continuous
> requests are regarded as seeky, the coop queue is split. See blow RFC patch.
> How many count a queue should be split after need more consideration,
> below patch just uses an arbitary number.  This reduce about 5% performance
> lost when doing tio 32 threads sequential read.

Thanks,
Corrado
-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
