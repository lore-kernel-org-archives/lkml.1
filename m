Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbZCKQsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbZCKQsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZCKQsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:48:10 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:65100 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbZCKQsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:48:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EZREpxBwxZ5YvkxhHNkmh9oBxr1R3awgUYRaVQzfHDh3UZ8flHk3yq7chpzXk6VAfB
         qoFhN1oaJJIWITpyKFEsvmpGdprFW4F1Widif7sWllt9qFYKH/HxgmJo2POQlcXiZ6fu
         sLvvTRdj6Mmtr9Sh3SxIv33VZ70kzI0GgXN4w=
MIME-Version: 1.0
In-Reply-To: <20090311003756.25ffa6f4@lxorguk.ukuu.org.uk>
References: <1236699004-1863-1-git-send-email-timur@freescale.com>
	 <20090310153537.5fd5d84d@lxorguk.ukuu.org.uk>
	 <1236729711.7086.28.camel@pasglop>
	 <20090311003756.25ffa6f4@lxorguk.ukuu.org.uk>
Date: Wed, 11 Mar 2009 11:48:05 -0500
X-Google-Sender-Auth: f46da7e68202bf0b
Message-ID: <ed82fe3e0903110948w542a864dj821106900755f14e@mail.gmail.com>
Subject: Re: [PATCH v4] introduce macro spin_event_timeout()
From: Timur Tabi <timur@freescale.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, rdreier@cisco.com, jirislaby@gmail.com,
       peterz@infradead.org, will.newton@gmail.com, hancockrwd@gmail.com,
       jeremy@goop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 7:37 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Given the proposed helper isn't a sane default for x86 I think it needs a
> good deal more work.

Alan, I'm happy to put whatever effort is requirement to make this
code satisfactory.  I believe that this is a useful macro to have in
the kernel.  I do appreciate the attention you are giving it.

> It also hides details like that timing which is bad
> sometimes.

Are you talking about the udelay() inside the loop?  If so, I agree
that this is bad and have removed it in the PowerPC-specific version:

#define spin_event_timeout(condition, timeout)			\
({								\
	unsigned long __start = get_tbl();			\
	unsigned long __loops = tb_ticks_per_usec * timeout;	\
	int __ret = 1;						\
	while (!(condition)) {					\
		if (tb_ticks_since(__start) > __loops) {	\
			__ret = 0;				\
			break;					\
		}						\
		cpu_relax();					\
	}							\
	__ret;							\
})

tb_ticks_since() is a front-end to get_tbl(), which is similar to the
rdtsc instruction.  In this case, we're not adding arbitrary delays
into the loop, and we're not using jiffies, but we are
architecture-dependent.

-- 
Timur Tabi
Linux kernel developer at Freescale
