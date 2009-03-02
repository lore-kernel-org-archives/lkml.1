Return-Path: <linux-kernel-owner+w=401wt.eu-S1758465AbZCBRTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465AbZCBRTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 12:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbZCBRTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 12:19:24 -0500
Received: from smtp-out.google.com ([216.239.33.17]:49565 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbZCBRTX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 12:19:23 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Fhazr3+f0zhO31Odb9HvWgB1gK0wQRbJ8EAXlof+LTaTnx7M1b9JTKCtkfF2EaobG
	Y9vf2yYCpMMqufYR2UV8Q==
MIME-Version: 1.0
In-Reply-To: <20090302153246A.fujita.tomonori@lab.ntt.co.jp>
References: <20090227230927.GA21377@roadking.ldev.net>
	 <20090302153246A.fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 2 Mar 2009 09:19:16 -0800
Message-ID: <da824cf30903020919q2d3496e6sb5a253b0acba681a@mail.gmail.com>
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
From: Grant Grundler <grundler@google.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mike.miller@hp.com, jens.axboe@oracle.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       coldwell@redhat.com, hare@novell.com, iss_storagedev@hp.com,
       iss.sbteam@hp.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 1, 2009 at 10:32 PM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
...
>> +/*
>> + * For operations that cannot sleep, a command block is allocated at init,
>> + * and managed by cmd_alloc() and cmd_free() using a simple bitmap to track
>> + * which ones are free or in use.  Lock must be held when calling this.
>> + * cmd_free() is the complement.
>> + */
>> +static struct CommandList_struct *cmd_alloc(struct ctlr_info *h)
>> +{
>> +     struct CommandList_struct *c;
>> +     int i;
>> +     union u64bit temp64;
>> +     dma_addr_t cmd_dma_handle, err_dma_handle;
>> +
>> +     do {
>> +             i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
>> +             if (i == h->nr_cmds)
>> +                     return NULL;
>> +     } while (test_and_set_bit
>> +              (i & (BITS_PER_LONG - 1),
>> +               h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0);
>
> Using bitmap to manage free commands looks too complicated a bit to
> me. Can we just use lists for command management?

Bit maps are generally more efficient than lists since we touch less data.
For both search and moving elements from free<->busy lists. This probably
won't matter if we are talking less than 10K IOPS. And willy demonstrated
other layers have pretty high overhead (block, libata and SCSI midlayer)
at high transaction rates.

If nr_cmds can be greater than 8*BITS_PER_LONG or so, it would
be more efficient to save the allocation offset and start the next search
from that location. But I can't tell from the code since nr_cmds is
coming from the controller:

+       /* Query controller for max supported commands: */
+       c->max_commands = readl(&(c->cfgtable->CmdsOutMax));
...
+       c->nr_cmds = c->max_commands - 4;


hth,
grant
