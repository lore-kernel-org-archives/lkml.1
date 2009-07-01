Return-Path: <linux-kernel-owner+w=401wt.eu-S1763981AbZGAB3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763981AbZGAB3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761406AbZGAB3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 21:29:32 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:35663 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761342AbZGAB3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 21:29:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WiAVjBCyvvPFVwr002CJNIEdIpE+1MIM9vYFAlx14EREeu/z2QmH1obKHEEebeU4vh
         m7QwxIMVqFGLJcgKPQweUBJohEURjmqUS4nq8mmPCJMgxz+81nYw3wXE8CV2Z3QqIjtj
         kC9C8Gz+TodwziqRy8K8ZgKVsdTavv7ZI32/c=
Message-ID: <4A4ABC39.90002@gmail.com>
Date: Tue, 30 Jun 2009 19:30:33 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Korkakakis Nikos <korkakak@ceid.upatras.gr>
CC: linux-kernel@vger.kernel.org, linux-newbie@vger.kernel.org
Subject: Re: kmalloc returns twice  the same memory address?
References: <4A4A5482.3050108@ceid.upatras.gr>
In-Reply-To: <4A4A5482.3050108@ceid.upatras.gr>
Content-Type: text/plain; charset=ISO-8859-7; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2009 12:08 PM, Korkakakis Nikos wrote:
> Hi there all,
>
> first of all I am writing a kernel module to handle some device using;
> uname -a: Linux localhost 2.6.30-gentoo-r1 #1 SMP Sun Jun 28 02:52:23
> EEST 2009 i686 AMD Phenom(tm) II X4 940 Processor AuthenticAMD GNU/Linux.
> During  the init phase of the module I allocate some memory via
> kmalloc() in the following manner;
>
>      omm_dev_buffer = kmalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA | GFP_ATOMIC);

GFP_KERNEL and GFP_ATOMIC are contradictory flags. Also, drivers should 
generally not be using GFP_DMA, if the DMA mapping API is used this is 
not needed.

I don't know if this is what is causing your problem or not.

>      if (!omm_dev_buffer) {
>          return -ENOMEM;
>      }
>      clear_buffer (omm_dev_buffer, PAGE_SIZE);
>      printk("omm_dev_init: kmalloc'ed omm_dev_buffer OK\n");
>      omm_messages = kmalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
>      printk ("dev_buff @ 0x%x messages @
> 0x%x\n",omm_dev_buffer,omm_messages);
>      if (!omm_messages) {
>          kfree(omm_dev_buffer); /* failing at this point means that the
> other allocation succeeded */
>          return -ENOMEM;
>      }
>      clear_buffer (omm_messages, PAGE_SIZE);
>
>
> where clear_buffer is just a wrapper for memset. My problem is that the
> two consecutive memory allocation operations return the same memory
> space (both pointers point the same address). If I change the malloc'ed
> size ie PAGE_SIZE*2 then the process works as expected. kzalloc behaves
> the same way, while alloc_page with the same flags(i.e.
> alloc_page(GFP_KERNEL | GFP_DMA | GFP_ATOMIC) ) return a different
> memory space and works as expected.
>
> What am I missing here?
>
> Thank's in advance :D
>
> Nikos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-newbie" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.linux-learn.org/faqs
>

