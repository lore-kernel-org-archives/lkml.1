Return-Path: <linux-kernel-owner+w=401wt.eu-S1422768AbXBUS00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422768AbXBUS00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422760AbXBUS0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:26:25 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:49180 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422771AbXBUS0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:26:24 -0500
In-Reply-To: <b040c32a0702210035w38dda81du55bc12259324a4b5@mail.gmail.com>
References: <20070220175457.GS6133@think.oraclecorp.com> <B41635854730A14CA71C92B36EC22AAC871E37@mssmsx411> <b040c32a0702210035w38dda81du55bc12259324a4b5@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <4FF990C3-F998-4003-83D4-91CAE76FCDBE@oracle.com>
Cc: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>,
       Chris Mason <chris.mason@oracle.com>, linux-aio <linux-aio@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna bhattacharya <suparna@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 2/2] aio: propogate post-EIOCBQUEUED errors to completion event
Date: Wed, 21 Feb 2007 10:24:56 -0800
To: Ken Chen <kenchen@google.com>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 21, 2007, at 12:35 AM, Ken Chen wrote:

> On 2/20/07, Ananiev, Leonid <leonid.i.ananiev@intel.com> wrote:
>> 1) mem=1G in kernel boot param if you have more
>> 2) unmount; mk2fs; mount
>> 3) dd if=/dev/zero of=<test_file> bs=1M count=1200
>> 4) aiostress -s 1200m -O -o 2 -i 1 -r 16k <test_file>
>> 5) if i++<50 goto 2).
>
> Would you please instrument the call chain of
> invalidate_complete_page2() and tell us exactly where it returns zero
> value in your failure case?
>
>   invalidate_complete_page2
>      try_to_release_page
>         ext3_releasepage
>            journal_try_to_free_buffers
>               ???

For what it's worth, Badari has explained this race in the past in a  
credible way.  I'll take the liberty of pasting a mail from him:

"
kjournald submited buffers for IO and waiting for them to finish.
Note that it has a ref. against the buffer.

journal_commit_transaction()
         ...
         submited buffers for IO
         /* Waiting for IO to complete */
         while (commit_transaction->t_locked_list) {
                 ...
                 get_bh(bh);
                 if (buffer_locked(bh)) {
                         spin_unlock(&journal->j_list_lock);
                         wait_on_buffer(bh);  <<<<<<
                         spin_lock(&journal->j_list_lock);
                 }

                 ..
                 put_bh(bh);
         }

Now, DIO process comes to frees the jh through  
journal_try_to_free_buffers()
but fails to drop_buffers() since kjournald() has a reference against  
it.
invalidate_inode_pages2_range()
         ..
         ext3_releasepage()
                 journal_try_to_free_buffers()
                         journal_put_journal_head()
                                 __journal_try_to_free_buffer()
                                         <--- freed jh

                         try_to_free_buffers()
                                 drop_buffers()
                                         if (buffer_busy(bh))
                                                 goto failed;
                                           <<--- returns EIO due to  
b_count

"

I don't mean to say that we shouldn't get traces to confirm the  
theory, just sharing.  And now we can point to this in the archives  
next time :).

- z
