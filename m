Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbXKQJQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbXKQJQI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 04:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbXKQJPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 04:15:55 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:44881 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbXKQJPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 04:15:53 -0500
Message-ID: <473EB138.80603@cosmosbay.com>
Date: Sat, 17 Nov 2007 10:15:36 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NR_OPEN should be raised a litle bit
References: <473E1144.9070404@cosmosbay.com> <20071116234902.75fdef5c@the-village.bc.nu>
In-Reply-To: <20071116234902.75fdef5c@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 17 Nov 2007 10:15:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox a écrit :
> On Fri, 16 Nov 2007 22:53:08 +0100
> Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
>> Time has come to change NR_OPEN value, some production servers hit the
>> not so 'ridiculously high value' of 1024*1024 file descriptors per process.
> 
> Why fiddle with the kernel defaults when every distribution can manage
> this in user space - including picking defaults by memory size or
> platform ?

Please note I am not speaking about the standard 1024 filedescriptors limit, 
but the hardcoded 1024*1024 one.

Tell me more how a user space can overcome this limit ?


Dynamically patching kernel text ?

static struct fdtable * alloc_fdtable(unsigned int nr)
{
...
         nr /= (1024 / sizeof(struct file *));
         nr = roundup_pow_of_two(nr + 1);
         nr *= (1024 / sizeof(struct file *));
         if (nr > NR_OPEN)
                 nr = NR_OPEN;

and :

int expand_files(struct files_struct *files, int nr)
{
         struct fdtable *fdt;

         fdt = files_fdtable(files);
         /* Do we need to expand? */
         if (nr < fdt->max_fds)
                 return 0;
         /* Can we expand? */
         if (nr >= NR_OPEN)
                 return -EMFILE;



