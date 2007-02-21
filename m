Return-Path: <linux-kernel-owner+w=401wt.eu-S1422817AbXBUTPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422817AbXBUTPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 14:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422819AbXBUTPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 14:15:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:39573 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422817AbXBUTPv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 14:15:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,202,1170662400"; 
   d="scan'208"; a="49220050:sNHT23589288"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] aio: propogate post-EIOCBQUEUED errors to completion event
Date: Wed, 21 Feb 2007 22:15:00 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC8723A6@mssmsx411>
In-Reply-To: <4FF990C3-F998-4003-83D4-91CAE76FCDBE@oracle.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] aio: propogate post-EIOCBQUEUED errors to completion event
Thread-Index: AcdV5aqwBbjQv0uSRhKrCF1Nx05qQAABAI0A
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: "Zach Brown" <zach.brown@oracle.com>, "Ken Chen" <kenchen@google.com>
Cc: "Chris Mason" <chris.mason@oracle.com>, "linux-aio" <linux-aio@kvack.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Benjamin LaHaise" <bcrl@kvack.org>,
       "Suparna bhattacharya" <suparna@in.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Badari Pulavarty" <pbadari@us.ibm.com>
X-OriginalArrivalTime: 21 Feb 2007 19:15:13.0248 (UTC) FILETIME=[9CAB8E00:01C755EC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> kjournald submited buffers for IO and waiting for them to finish.

It is means that the patch incorrectly moves internal kernel
synchronization
problem into user space as EIO instead of fixing a root cause or perform
iterative
synchronization.
After patching users will be surprised a lot of EIO
(remember 47% EIO in aio-stress runs after patching) will buy new
disk...
This patch is harmful.

Leonid
>-----Original Message-----
>From: Zach Brown [mailto:zach.brown@oracle.com]
>Sent: Wednesday, February 21, 2007 9:25 PM
>To: Ken Chen
>Cc: Ananiev, Leonid I; Chris Mason; linux-aio; Linux Kernel Mailing
List; Benjamin LaHaise; Suparna
>bhattacharya; Andrew Morton; Badari Pulavarty
>Subject: Re: [PATCH 2/2] aio: propogate post-EIOCBQUEUED errors to
completion event
>
>
>On Feb 21, 2007, at 12:35 AM, Ken Chen wrote:
>
>> On 2/20/07, Ananiev, Leonid <leonid.i.ananiev@intel.com> wrote:
>>> 1) mem=1G in kernel boot param if you have more
>>> 2) unmount; mk2fs; mount
>>> 3) dd if=/dev/zero of=<test_file> bs=1M count=1200
>>> 4) aiostress -s 1200m -O -o 2 -i 1 -r 16k <test_file>
>>> 5) if i++<50 goto 2).
>>
>> Would you please instrument the call chain of
>> invalidate_complete_page2() and tell us exactly where it returns zero
>> value in your failure case?
>>
>>   invalidate_complete_page2
>>      try_to_release_page
>>         ext3_releasepage
>>            journal_try_to_free_buffers
>>               ???
>
>For what it's worth, Badari has explained this race in the past in a
>credible way.  I'll take the liberty of pasting a mail from him:
>
>"
>kjournald submited buffers for IO and waiting for them to finish.
>Note that it has a ref. against the buffer.
>
>journal_commit_transaction()
>         ...
>         submited buffers for IO
>         /* Waiting for IO to complete */
>         while (commit_transaction->t_locked_list) {
>                 ...
>                 get_bh(bh);
>                 if (buffer_locked(bh)) {
>                         spin_unlock(&journal->j_list_lock);
>                         wait_on_buffer(bh);  <<<<<<
>                         spin_lock(&journal->j_list_lock);
>                 }
>
>                 ..
>                 put_bh(bh);
>         }
>
>Now, DIO process comes to frees the jh through
>journal_try_to_free_buffers()
>but fails to drop_buffers() since kjournald() has a reference against
>it.
>invalidate_inode_pages2_range()
>         ..
>         ext3_releasepage()
>                 journal_try_to_free_buffers()
>                         journal_put_journal_head()
>                                 __journal_try_to_free_buffer()
>                                         <--- freed jh
>
>                         try_to_free_buffers()
>                                 drop_buffers()
>                                         if (buffer_busy(bh))
>                                                 goto failed;
>                                           <<--- returns EIO due to
>b_count
>
>"
>
>I don't mean to say that we shouldn't get traces to confirm the
>theory, just sharing.  And now we can point to this in the archives
>next time :).
>
>- z
