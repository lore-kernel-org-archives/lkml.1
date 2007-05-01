Return-Path: <linux-kernel-owner+w=401wt.eu-S1946583AbXEAEAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946583AbXEAEAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946509AbXEAD71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 23:59:27 -0400
Received: from lon-del-01.spheriq.net ([195.46.50.97]:56012 "EHLO
	lon-del-01.spheriq.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933510AbXEAD7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:59:09 -0400
From: Bhuvan Kumar MITTAL <bhuvan.mittal@st.com>
To: "'Nick Piggin'" <nickpiggin@yahoo.com.au>
Cc: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>, <linux-kernel@vger.kernel.org>,
       "'Daniel J Blueman'" <daniel.blueman@gmail.com>
Subject: RE: How to make mmap'ed kernel buffer non-cacheable
Date: Tue, 1 May 2007 09:28:53 +0530
Message-ID: <03eb01c78ba5$091f4f20$142ec70a@dlh.st.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <462C3554.5000906@yahoo.com.au>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2962
Thread-Index: AceFX4Q4he4m33JnT6CX3K21yr3JAAGQyxJg
X-O-Spoofed: Not Scanned
X-O-General-Status: No
X-O-Spam1-Status: Not Scanned
X-O-Spam2-Status: Not Scanned
X-O-URL-Status: Not Scanned
X-O-Virus1-Status: No
X-O-Virus2-Status: Not Scanned
X-O-Virus3-Status: No
X-O-Virus4-Status: No
X-O-Virus5-Status: Not Scanned
X-O-Image-Status: Not Scanned
X-O-Attach-Status: Not Scanned
X-SpheriQ-Ver: 4.2.04
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,Nick

Thanks for your inputs. I was able to solve the problem of mapping kernel buffer to user space. Just FYI, I am working on a sh4 based architecture proprietary board with Linux kernel 2.6.17.3

Initially I was adopting the following approach: 
1.The kernel thread was copying some data and waiting on a semaphore for the user task to make an ioctl into the kernel space and relieve the wait.
2. Then the user task was getting spawned and taking the data from kernel.

---> This was resulting in some initial data drop coz the kernel task was overwhelming and outspeeding the user task (Maybe someone can explain how)

How I solved the problem?

Instead of making the kernel wait for the user task, I reversed the sequence and did not let the kernel task be activated till the user task was spawned and waiting in kernel space(after making ioctl) for the kernel task. Then I started the kernel task and the problem of data dropping was resolved.

In continuation to this, I have another query:
As mentioned above, If there is a kernel task waiting on a semaphore (maybe even in hung state) and I wish to kill the kernel task from user space by making an ioctl call into the kernel, then how is it possible? Is it feasible at all?


Regards,

Bhuvan

On 20 Apr, 14:20, Bhuvan Kumar MITTAL <bhuvan.mit...@st.com> wrote:
> Hi,
>   I am working on an audio device driver development on Linux. I have 
> a kernel buffer which I have mapped to user space using mmap call from 
> user space. My problem is that the data which comes to the kernel 
> buffer is getting dropped in user space and I get only 50-60% of the 
> data which is randomly ordered. The user to kernel level buffer 
> address translation code is fine and I suspect this data dropping is 
> occurring coz the kernel buffer is cacheable. Please suggest me some 
> way of making the entire buffer non cacheable. I am stuck on this for quite a while now.

You can use rdmsr() in your driver to check if the page attribute table MSR is available, then find and/or add the right entry in the table to set in each page's flags. This is documented in the Intel
IA-32 Intel Architecture Software Developer's Manuals at intel.com.
-----Original Message-----
From: Nick Piggin [mailto:nickpiggin@yahoo.com.au] 
Sent: Monday, April 23, 2007 9:56 AM
To: Bhuvan Kumar MITTAL
Cc: 'Alan Cox'; linux-kernel@vger.kernel.org
Subject: Re: How to make mmap'ed kernel buffer non-cacheable

Bhuvan Kumar MITTAL wrote:
> Hi Alan,
> 
> I believe that dma_alloc_coherent will mark the kernel buffer as uncached at alocation time. 
> But that is not my intention. I have mapped some user space memory to the kernel buffer and I wish to ensure that the contents of both are coherent and correctly ordered. 
> 
> In other words I wish to flush the contents of the kernel buffer to user space as soon as new data is available in my kernel buffer. How to do that? Will doing mysnc from the user space help?

msync is only for pagecache. If you modify user mapped RAM from the kernel, or wish
to read user modified RAM from the kernel, you should issue a flush_dcache_page after
and before, respectively. See Documentation/cachetlb.h.

Does that fix it? What are the details of your platform?

-- 
SUSE Labs, Novell Inc.

