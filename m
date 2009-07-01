Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbZGAHQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbZGAHQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZGAHQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:16:38 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:38578 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZGAHQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:16:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=q07QBAgJISnamOT8oyqk8lzBKNC6TnHfybjHEsWcfAWTgTRl3CqKN18rcVyiEJi9iY
         tToM/N1Jam0EpPLD7/TpLtk03sF2lVk9IUAgs4ohBq2tnD6uUhX51jplDDF8/wxGSVK6
         a+WOLr8K2rbcFdw60O7gCQuFjrEOfo0+mcbfU=
Subject: Re: [BUG] MIPS: Hibernation in the latest linux-mips:master branch
 not work
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Ralf Baechle <ralf@linux-mips.org>, linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <20090630144540.GA18212@linux-mips.org>
References: <1246372868.19049.17.camel@falcon>
	 <20090630144540.GA18212@linux-mips.org>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Wed, 01 Jul 2009 15:16:10 +0800
Message-Id: <1246432570.9660.22.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-30 at 15:45 +0100, Ralf Baechle wrote:
> On Tue, Jun 30, 2009 at 10:41:08PM +0800, Wu Zhangjin wrote:
> 
> > I just updated my git repository to the master branch of the latest
> > linux-mips git repository, and tested the STD/Hibernation support on
> > fuloong2e and yeeloong2f, it failed:
> > 
> > when using the no_console_suspend kernel command line to debug, it
> > stopped on:
> > 
> > PM: Shringking memory... done (1000 pages freed)
> > PM: Freed 160000 kbytes in 1.68 seconds (95.23 MB/s)
> > PM: Creating hibernation image:
> > PM: Need to copy 5053 pages
> > PM: Hibernation image created (4195 pages copied)
> > 
> > and then, the number indicator light of keyboard works well, but can not
> > type anything. 
> > 
> > anybody have tested it on another platform? does it work?
> 
> At the time of the merge I tested it on Malta and found it to be working.
> 

Just traced it, the executing path is something like this:

	hibernate(kernel/power/hibernate.c)
	--> hibernation_snapshot
	--> dpm_resume_end
	--> dpm_resume
        --> device_resume
	--> dev->bus->resume(generic_ide_resume), dev_name(dev) = 0.0
	--> blk_execute_rq
        {
		DECLARE_COMPLETION_ONSTACK(wait);
		...
		wait_for_completion(&wait);	// stop here
		...
	}

I guess there is a possible bug in the latest ide patches, I'm trying to
find which one is 'bad'.

the ide driver i used is VIA82CXXX chipset support.

Regards,
Wu Zhangjin

