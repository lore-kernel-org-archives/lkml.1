Return-Path: <linux-kernel-owner+w=401wt.eu-S1755061AbYKDPdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbYKDPdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbYKDPdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:33:03 -0500
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:54640 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbYKDPdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:33:01 -0500
Message-ID: <49106B0A.8010205@cs.columbia.edu>
Date: Tue, 04 Nov 2008 10:32:26 -0500
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Masahiko Takahashi <m-takahashi@ex.jp.nec.com>
CC: Linus Torvalds <torvalds@osdl.org>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC v8][PATCH 05/12] x86 support for checkpoint/restart
References: <1225374675-22850-1-git-send-email-orenl@cs.columbia.edu>	 <1225374675-22850-6-git-send-email-orenl@cs.columbia.edu> <1225791016.5940.33.camel@noir.spf.cl.nec.co.jp>
In-Reply-To: <1225791016.5940.33.camel@noir.spf.cl.nec.co.jp>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Masahiko Takahashi wrote:
> Hi Oren,
> 
> I'm now trying to port your patchset to x86_64, and find a tiny
> inconsistency issue.
> 
> 
> On 2008-10-30 at 09:51 -0400, Oren Laadan wrote:
>> +/* dump the thread_struct of a given task */
>> +int cr_write_thread(struct cr_ctx *ctx, struct task_struct *t)
>> +{
>> +	struct cr_hdr h;
>> +	struct cr_hdr_thread *hh = cr_hbuf_get(ctx, sizeof(*hh));
>> +	struct thread_struct *thread;
>> +	struct desc_struct *desc;
>> +	int ntls = 0;
>> +	int n, ret;
>> +
>> +	h.type = CR_HDR_THREAD;
>> +	h.len = sizeof(*hh);
>> +	h.parent = task_pid_vnr(t);
>> +
>> +	thread = &t->thread;
>> +
>> +	/* calculate no. of TLS entries that follow */
>> +	desc = thread->tls_array;
>> +	for (n = GDT_ENTRY_TLS_ENTRIES; n > 0; n--, desc++) {
>> +		if (desc->a || desc->b)
>> +			ntls++;
>> +	}
>> +
>> +	hh->gdt_entry_tls_entries = GDT_ENTRY_TLS_ENTRIES;
>> +	hh->sizeof_tls_array = sizeof(thread->tls_array);
>> +	hh->ntls = ntls;
>> +
>> +	ret = cr_write_obj(ctx, &h, hh);
>> +	cr_hbuf_put(ctx, sizeof(*hh));
>> +	if (ret < 0)
>> +		return ret;
> 
> Please add
>    if (ntls == 0)
>             return ret;
> because, in restart phase, reading TLS entries from the image file
> is skipped if hh->ntls == 0, which may incur inconsistency and fail
> to restart.
> 

Will fix, thanks.

Oren.


