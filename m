Return-Path: <linux-kernel-owner+w=401wt.eu-S1753060AbZIBRFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbZIBRFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 13:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbZIBRFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 13:05:42 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:50324
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751422AbZIBRFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 13:05:41 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zz146fK1432R98dN9371Pa594izz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
Message-ID: <4A9EA5C9.3010900@am.sony.com>
Date: Wed, 2 Sep 2009 10:05:13 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Marc Andre Tanner <mat@brain-dump.org>
CC: H Hartley Sweeten <hartleys@visionengravers.com>,
       linux-embedded@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] printk: provide a filtering macro for printk
References: <1251844269-12394-1-git-send-email-mat@brain-dump.org> <1251844269-12394-8-git-send-email-mat@brain-dump.org> <4A9DAD2B.3080909@am.sony.com> <BD79186B4FD85F4B8E60E381CAEE190901C55CD3@mi8nycmail19.Mi8.com> <20090902130943.GE2736@debbook.brain-dump.org>
In-Reply-To: <20090902130943.GE2736@debbook.brain-dump.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Sep 2009 17:05:14.0591 (UTC) FILETIME=[89FFEEF0:01CA2BEF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Andre Tanner wrote:
> On Tue, Sep 01, 2009 at 07:32:25PM -0400, H Hartley Sweeten wrote:
>> On Tuesday, September 01, 2009 4:24 PM, Tim Bird wrote:
>>> Some places in the kernel break the message into pieces, like so:
>>>
>>> printk(KERN_ERR, "Error: first part ");
>>> ...
>>> printk(" more info for error.\n");
>> Technically, shouldn't the second part of the message actually be:
>>
>> printk(KERN_CONT " more info for error.\n");
>>
>> Maybe some mechanism could be created to handle the continued message
>> if they have the KERN_CONT?
> 
> Yes it's true that KERN_CONT isn't handled correctly, but I don't see a way
> to change that.
> 
>>> These parts would not be handled consistently under certain
>>> conditions.
>>>
>>> It would be confusing to see only part of the message,
>>> but I don't know how often this construct is used.  
> 
> $ grep -R KERN_CONT linux-2.6 | wc -l
> 373
> 
>>> Maybe
>>> another mechanism is needed to ensure that continuation
>>> printk lines have the same log level as their start strings.
> 
> I currently don't see a way to achieve this with the CPP.

If it's that few, then maybe it's OK to actually change
the code for those printk statements. (Heck, these locations
were all changed in the last 2 years anyway.)

I'm just brainstorming here, but how about changing them from:
  printk(KERN_INFO "foo");
  printk(KERN_CONT "bar\n");
to:
  printk(KERN_INFO "foo");
  printk_cont(KERN_INFO "bar\n");

This way the continuation line has the log level, and can
be conditionally compiled based on the VERBOSITY level.  A little
magic would be needed to strip the first 3 chars of the fmt
string in printk_cont().

I think this makes the printk messages a bit more consistent anyway,
and still marks lines that are continuation lines.

>>> But, overall, very slick!  It's nice to see a solution that doesn't
>>> require changing all printks statements in the kernel.
> 
> Yes that's what I thought too. Thanks to the comments so far the next 
> version of the patch will contain even less changes to the rest of the 
> kernel.
>  
>> I haven't looked over this patch series yet but does it work with the
>> pr_<level> macros (pr_info, pr_err, etc.)?
> 
> It should work, yes.

 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

