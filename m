Return-Path: <linux-kernel-owner+w=401wt.eu-S1031683AbXEAMJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031683AbXEAMJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 08:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031686AbXEAMJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 08:09:13 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:31535 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031683AbXEAMJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 08:09:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=f+BgNUY1K3iqTGPCbr/AiupcunSvmUNKb4TYxZM/z2o5ZUnX8fyY3siBBhbZOwUu1Et1vDtR01VYdbAqGYQzswzGs5pBsucVHjjkor8lQceNNUl/D7H8nMP2FqGPDe4CCVEGf1fdn7ZL++eqlvBsENqQCU6TkyIE59DTjhHYDm4=  ;
X-YMail-OSG: zv8Syp0VM1lSIHuqoOxiSVQEpVkQ9020Yer1oSpM5QaJ8jq8S0.qoakGiJ145gcgS0LoqyXPQA--
Message-ID: <46372DDE.2040207@yahoo.com.au>
Date: Tue, 01 May 2007 22:09:02 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Bhuvan Kumar MITTAL <bhuvan.mittal@st.com>
CC: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       "'Daniel J Blueman'" <daniel.blueman@gmail.com>
Subject: Re: How to make mmap'ed kernel buffer non-cacheable
References: <03eb01c78ba5$091f4f20$142ec70a@dlh.st.com>
In-Reply-To: <03eb01c78ba5$091f4f20$142ec70a@dlh.st.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bhuvan Kumar MITTAL wrote:
> Hi Alan,Nick
> 
> Thanks for your inputs. I was able to solve the problem of mapping kernel buffer to user space. Just FYI, I am working on a sh4 based architecture proprietary board with Linux kernel 2.6.17.3

So... you used flush_dcache_page? Or what?


> Initially I was adopting the following approach: 
> 1.The kernel thread was copying some data and waiting on a semaphore for the user task to make an ioctl into the kernel space and relieve the wait.
> 2. Then the user task was getting spawned and taking the data from kernel.
> 
> ---> This was resulting in some initial data drop coz the kernel task was overwhelming and outspeeding the user task (Maybe someone can explain how)
> 
> How I solved the problem?
> 
> Instead of making the kernel wait for the user task, I reversed the sequence and did not let the kernel task be activated till the user task was spawned and waiting in kernel space(after making ioctl) for the kernel task. Then I started the kernel task and the problem of data dropping was resolved.

OK. Seems like a straightfoward producer-consumer problem.

I don't know why you should be dropping data if your kernel task blocks when
its output buffer is full and your user task blocks when it is empty. But anyway,
it seems you solved it. Good :)


> In continuation to this, I have another query:
> As mentioned above, If there is a kernel task waiting on a semaphore (maybe even in hung state) and I wish to kill the kernel task from user space by making an ioctl call into the kernel, then how is it possible? Is it feasible at all?

If the kernel task is hung because of some bug in your code, then it isn't
really possible in general. You could always just "up" the semaphore and hope,
but things might be corrupted.

If you just want to tell the kernel task to quit, I guess you'd just introduce
some quit ioctl message, and have the kernel thread respond to that.

-- 
SUSE Labs, Novell Inc.
