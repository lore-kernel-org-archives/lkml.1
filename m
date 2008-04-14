Return-Path: <linux-kernel-owner+w=401wt.eu-S1761615AbYDNOuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761615AbYDNOuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761526AbYDNOt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:49:56 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:46172 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761508AbYDNOtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:49:55 -0400
Message-ID: <48036F00.6080200@freescale.com>
Date: Mon, 14 Apr 2008 09:49:36 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       York Sun <yorksun@freescale.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Driver for Freescale 8610 and 5121 DIU
References: <12053582234100-git-send-email-yorksun@freescale.com>	<12053582231281-git-send-email-yorksun@freescale.com>	<47D8572C.8090501@gmail.com>	<47FFDBFF.1030809@gmail.com>	<20080411221817.0b1eb414.akpm@linux-foundation.org>	<48035E93.6070300@freescale.com> <48035F98.1020404@gmail.com>	<48036001.10905@freescale.com> <4803620C.6020905@gmail.com>	<48036649.6000409@freescale.com> <4803690A.3080105@gmail.com>
In-Reply-To: <4803690A.3080105@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 04/14/2008 04:12 PM, Timur Tabi wrote:
>> Unfortunately, the author of the patch, York, is out this week, so I'll have to
>> take care of this.  It'd be easier to modify rh_alloc() so that it doesn't
>> sleep, so that's what I'm going to do.
> 
> Anyway, why do you need the spin lock there (and not mutex)? 

I don't know.  A spinlock just seemed obvious.  Why would I prefer a mutex?

We need a mutual exclusion device in order to prevent multiple threads from
opening the DIU driver simultaneously.  When the driver is opened the first
time, it needs to initialize the hardware.  The hardware can't be initialized
unless we allocate a buffer first.

Now, we could pre-allocate the buffer, but then this would be a permanent 5MB
(8MB if we eliminate rh_alloc) allocation of physically contiguous memory.  I'm
assuming that this would be a bad thing.  It wouldn't eliminate the spinlock,
but at least we wouldn't be calling kmalloc().

I open to suggestion for improvements.  I'm still going to post the rh_alloc
atomic patch, because I think it makes sense anyway.  This should fix the
sleep-within-spinlock problem, but it does not fix the kmalloc-5MB-in-spinlock
problem.

-- 
Timur Tabi
Linux kernel developer at Freescale
