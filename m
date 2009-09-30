Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbZI3VN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbZI3VN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 17:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZI3VN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 17:13:28 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:59791 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbZI3VN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 17:13:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lzrPGnXC3+wP2exYuVgcB3ESyJK52XpVKZW1cJCKU04NTo6tddaDfcmSIu6ljlgZTq
         MMgkBOcVJruSQ70nNgoggwTaCfk9gqs3AwLDy1QVss3PinxUspZNaKfCYlscGIAAQCKj
         1eTfSPReh/a2R8N6SFTJ5Do583go7N3PEarb8=
Message-ID: <4AC3C9B8.9080003@gmail.com>
Date: Wed, 30 Sep 2009 23:12:24 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: N_PPP_SYNC ldisc BUG: sleeping function called from invalid context
References: <4AC37032.4030901@imap.cc> <20090930174704.796b24b9@lxorguk.ukuu.org.uk> <4AC3A986.4080808@imap.cc>
In-Reply-To: <4AC3A986.4080808@imap.cc>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote, On 09/30/2009 08:55 PM:

> Alan Cox schrieb:
>>>  [<c026d39b>] tty_unthrottle+0x10/0x38
>>>  [<f8dcc31f>] ppp_sync_receive+0x168/0x170 [ppp_synctty]
>>>  [<f8fbb9ce>] handle_minor_recv+0x187/0x1cd [capi]
>>>  [<f8fbc19b>] capi_recv_message+0x1d9/0x24e [capi]
>> Really need to see the rest of the call trace to be sure
> 
> There wasn't more than what I posted. I had six of them, they looked all
> identical, and all of them ended after the kernel_thread_helper line. 
> 
>>> Turns out the ppp_sync_receive() function (drivers/net/ppp_synctty.c
>>> line 385ff.) has a comment in front stating:
>>>
>>> /*
>>>  * This can now be called from hard interrupt level as well
>>>  * as soft interrupt level or mainline.
>>>  */
>> Which is wrong. The flip_buffer_push -> rx processing path should never
>> be called from IRQ context and that was fixed for various drivers that
>> mis-set tty->low_latency, as well as in the PPP rework. The PPP case is
>> actually unrelated in many was.
> 
> Might be worth correcting that text then before is misleads someone.
> 
>>> Opinions?
>> See how we got into that code direct from an IRQ path. The expectation of
>> the tty logic is that it gets processed from work queues either
>> specifically in driver or via tty_flip_buffer_push when tty->low_latency
>> = 0
> 
> I'm at a loss here. According to all the backtraces:
> 
> - ppp_sync_receive() was called, as the LD's receive_buf method,
>   via handle_recv_skb() [drivers/isdn/capi/capi.c line 504, inlined]
>   from handle_minor_recv() [drivers/isdn/capi/capi.c line 519]
> 
> - handle_minor_recv() was called from capi_recv_message()
>   [drivers/isdn/capi/capi.c line 656]
> 
> - capi_recv_message() was called, as the CAPI application's
>   recv_message method, from recv_handler()
>   [drivers/isdn/capi/kcapi.c line 268]
> 
> - recv_handler() is never called directly. It's only scheduled
>   via the work queue ap->recv_work from capi_ctr_handle_message()
>   [drivers/isdn/capi/kcapi.c line 349]
> 
> Even if we don't trust the backtraces, there's not much room for
> another activation path. So for all I know, the expectation of the
> tty logic should have been met. The call was indeed processed from
> a work queue.
> 
> Why then does mutex_lock() complain?
 

Hmm... capi_recv_message() calls handle_minor_recv() under
spin_lock_irqsave(), doesn't it?

Jarek P.
