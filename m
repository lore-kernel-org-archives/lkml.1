Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbZGNSxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbZGNSxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 14:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbZGNSw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 14:52:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54939 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013AbZGNSw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 14:52:58 -0400
Message-ID: <4A5CD3EB.50402@vlnb.net>
Date: Tue, 14 Jul 2009 22:52:27 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Ronald Moesbergen <intercommit@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "Alan.Brunelle@hp.com" <Alan.Brunelle@hp.com>,
       "hifumi.hisashi@oss.ntt.co.jp" <hifumi.hisashi@oss.ntt.co.jp>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
References: <a0272b440907060737n59d4b155lb40c1c6d38ee96dd@mail.gmail.com> <4A5238EC.1070505@vlnb.net> <a0272b440907062349k24041e74sbb1776ab3e172c58@mail.gmail.com> <4A5395FD.2040507@vlnb.net> <a0272b440907080149j3eeeb9bat13f942520db059a8@mail.gmail.com> <4A5493A8.2000806@vlnb.net> <a0272b440907092332o7c5bf1d0oa51d1cfc9b9e98f5@mail.gmail.com> <4A56FF32.2060303@vlnb.net> <4A570981.5080803@vlnb.net> <a0272b440907130512y60a757afqd5629f4ca3ac8e1b@mail.gmail.com> <20090713123621.GA31051@localhost>
In-Reply-To: <20090713123621.GA31051@localhost>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+pOPhBkp7y/PVqb4cOQBf5z2Cv+SkC+wmulw0
 g4rhrfYs+mQKLnRBI2x8eFjvmKziW4teNYtHAPOF+7xt2EkN9Y
 rnQkWdpphpVda+PxmKBKQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Wu Fengguang, on 07/13/2009 04:36 PM wrote:
>> Test done with XFS on both the target and the initiator. This confirms
>> your findings, using files instead of block devices is faster, but
>> only when using the io_context patch.
> 
> It shows that the one really matters is the io_context patch,
> even when context readahead is running. I guess what happened
> in the tests are:
> - without readahead (or readahead algorithm failed to do proper
>   sequential readaheads), the SCST processes will be submitting
>   small but close to each other IOs.  CFQ relies on the io_context
>   patch to prevent unnecessary idling.
> - with proper readahead, the SCST processes will also be submitting
>   close readahead IOs. For example, one file's 100-102MB pages is
>   readahead by process A, while its 102-104MB pages may be
>   readahead by process B. In this case CFQ will also idle waiting
>   for process A to submit the next IO, but in fact that IO is being
>   submitted by process B. So the io_context patch is still necessary
>   even when context readahead is working fine. I guess context
>   readahead do have the added value of possibly enlarging the IO size
>   (however this benchmark seems to not very sensitive to IO size).

Looks like the truth. Although with 2MB RA I expect CFQ to do idling >10 
times less, which should bring bigger improvement than few %%.

For how long CFQ idles? For HZ/125, i.e. 8 ms with HZ 250?

> Thanks,
> Fengguang

