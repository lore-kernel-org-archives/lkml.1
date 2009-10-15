Return-Path: <linux-kernel-owner+w=401wt.eu-S1760797AbZJOS56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760797AbZJOS56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 14:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758572AbZJOS55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 14:57:57 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:50111 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758564AbZJOS55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 14:57:57 -0400
Message-ID: <4AD770A9.6070509@freescale.com>
Date: Thu, 15 Oct 2009 13:57:45 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Timur Tabi <timur@freescale.com>, linuxppc-dev@ozlabs.org,
       brueckner@linux.vnet.ibm.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hvc_console: returning 0 from put_chars is not an error
References: <1255557226-4403-1-git-send-email-timur@freescale.com> <200910151305.47100.borntraeger@de.ibm.com> <20091015160906.GA3730@loki.buserror.net> <200910152041.26646.borntraeger@de.ibm.com>
In-Reply-To: <200910152041.26646.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Oct 2009 18:57:19.0456 (UTC) FILETIME=[52182600:01CA4DC9]
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> Right. Looking at more drivers it seems that both ways (waiting and dropping) 
> are used.
> 
> Hmmm, if we are ok with having both options, we should let the hvc backend 
> decide if it wants to drain or to discard.

I'd say the dropping approach is quite undesirable (significant 
potential for output loss unless the buffer is huge), unless there's 
simply no way to safely spin.  Hopefully there are no such backends, but 
if there are perhaps we can have them return some special code to 
indicate that.

> If we just busy loop, it actually does not matter how we let hvc_console react 
> on 0, as long as we adopt all backends to use that interface consistent.
> 
> On the other hand, backends might want to do special magic on congestion so I 
> personally tend to let the backend loop instead of hvc_console. But I am really  
> not sure.

Doing it in the backend requires the backend to know whether it's being 
called for printk or for user I/O.  In the latter case, we don't want to 
spin, but rather wait for an IRQ (or poll with a timer if there's no IRQ).

-Scott
