Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbXKRTKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbXKRTKO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 14:10:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbXKRTKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 14:10:01 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:20215 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbXKRTKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 14:10:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=eegMsowBsfB3GW9Ltn0IWVFTltuyFAIbEr41yT7ESsjdETNRyhbDlvrjBIaG4F75w30+xqA2t6GtNhTP+xYgiFQaBrKVCy/kECsv+rAi/oF8DQ7RV7KdAVE4sJq6SY6h45G8xze+lZbCHLgIq5XJeDd62DHedSTIOgJfng94ON0=
Message-ID: <47408DFF.9070701@gmail.com>
Date: Sun, 18 Nov 2007 20:09:51 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: broken suspend [Was: 2.6.24-rc2-mm1]
References: <Pine.LNX.4.44L0.0711181203220.5712-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0711181203220.5712-100000@netrider.rowland.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2007 06:07 PM, Alan Stern wrote:
> You'll get more useful results if you redo your changes to 
> notifier_call_chain().  Have it print out the address of the routine 
> _before_ making the call, and don't limit it to 20.  That way you'll 
> know exactly which notifier routine ends up hanging.

The problem is, that notifier_call_chain is called again and again zillion times
by somebody else...

Anyway you led me to another idea:
* _cpu_down
        printk("%s: u\n", __func__);
        BUBAK=1;
        /* CPU is completely dead: tell everyone.  Too late to complain. */
        if (raw_notifier_call_chain(&cpu_chain, CPU_DEAD | 0x88000 | mod,
                                    hcpu) == NOTIFY_BAD)
                BUG();
        BUBAK=0;
-----
* notifier_call_chain
        unsigned int a = val & 0x88000;
        unsigned int yes = a == 0x88000;

        nb = rcu_dereference(*nl);

        if (a && a != 0x88000)
                printk("Somebody calls with val: %lx\n", val);
        else
                val &= ~0x88000;

        while (nb && nr_to_call) {
                next_nb = rcu_dereference(nb->next);
                if (unlikely(BUBAK && yes))
                        printk("%s: %p\n", __func__, nb->notifier_call);
                ret = nb->notifier_call(nb, val, v);
-----
gives coretemp_cpu_callback -> coretemp_device_remove ->
platform_device_unregister, so coretemp seems to be what I have and you don't.


