Return-Path: <linux-kernel-owner+w=401wt.eu-S1763829AbYEFShn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763829AbYEFShn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 14:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756015AbYEFShO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 14:37:14 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:61924 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988AbYEFShH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 14:37:07 -0400
Message-ID: <4820A550.8090500@de.ibm.com>
Date: Tue, 06 May 2008 20:37:04 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ltp-list@lists.sourceforge.net, ltp-coverage@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 4/6] seq_file: add function to write binary data
References: <481F26B5.7010708@de.ibm.com> <20080505213644.b153ee68.akpm@linux-foundation.org>
In-Reply-To: <20080505213644.b153ee68.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 05 May 2008 17:24:37 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:
> 
>> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
>> Index: linux-2.6.26-rc1/fs/seq_file.c
>> ===================================================================
>> --- linux-2.6.26-rc1.orig/fs/seq_file.c
>> +++ linux-2.6.26-rc1/fs/seq_file.c
>> @@ -554,6 +554,18 @@ int seq_puts(struct seq_file *m, const c
>>  }
>>  EXPORT_SYMBOL(seq_puts);
>>  
>> +int seq_write(struct seq_file *m, const void *s, size_t len)
> 
> Most of the other seq_file interface functions are nicely documented.

Documentation will be added with the next resend.

>> +{
>> +	if (m->count + len < m->size) {
> 
> Are you sure that shouldn't be >=?

If I understood seq_read() correctly, then < is correct:
m->count == m->size seems to be used as special marker for seq_read()
and >= doesn't make sense to me in this place. Also seq_printf() and
seq_puts() follow the same scheme.

>> +		memcpy(m->buf + m->count, s, len);
>> +		m->count += len;
>> +		return 0;
>> +	}
>> +	m->count = m->size;
>> +	return -1;
>> +}
>> +EXPORT_SYMBOL(seq_write);
> 
> Usually when a write-style function is passed too much data it will write
> as much as it can and will then return a smaller-than-requested value.

A write function in the context of the seq_file interface seems to be
defined more as an all-or-nothing business: user wants to read, buffer
is half-full, write is called, item doesn't fit, buffer is emptied,
write is called again, buffer doesn't fit, buffer size is doubled,
write is called again, etc.

> That's inappropriate for your application of seq_write(), but perhaps is
> appropriate for other future callers?

seq_write() is almost identical to the already existing seq_puts() which
led me to believe that it would fit the overall logic.

> This function has an upper limit of PAGE_SIZE bytes, I think?  The covering
> documentation should explain such things.

seq_read() will double its internal buffer size if an item doesn't fit.


Regards,
  Peter
