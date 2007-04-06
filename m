Return-Path: <linux-kernel-owner+w=401wt.eu-S1767656AbXDFOO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767656AbXDFOO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 10:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767659AbXDFOO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 10:14:26 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:43921 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767656AbXDFOOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 10:14:25 -0400
Message-ID: <461656DD.2000202@sw.ru>
Date: Fri, 06 Apr 2007 18:19:09 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Lockdep VS rw-semaphores strangeness
References: <46161D84.9030706@sw.ru> <4616537D.20702@linux.intel.com>
In-Reply-To: <4616537D.20702@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Pavel Emelianov wrote:
>> I've already caught a fake warning when trying to write-lock
>> an mm->mmap_sem with another mm's mmap_sem write-locked. With the
>> patch attached everything works, fine.
>>
> btw why is that a fake warning? what is your guarantee that you never
> ever do it in the opposite direction from the other thread as well?
> 

down_write(&mm->mmap_sem);
if (down_write_trylock(&another_mm->mmap_sem)) {
      ...
      up_write(...);
}
up_write(&mm->mmap_sem);

will never deadlock as if I have another thread is doing

down_write(&another_mm->mmap_sem);
if (down_write_trylock(&mm->mmap_sem)) {
      ...
      up_write(...);
}
up_write(&another_mm->mmap_sem);

booth will fail to trylock and go on.
