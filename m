Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980AbZIJJWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbZIJJWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 05:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbZIJJWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 05:22:06 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:38895 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752980AbZIJJWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 05:22:05 -0400
Date: Thu, 10 Sep 2009 11:22:10 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Tim Bird <tim.bird@am.sony.com>
cc: Marc Andre Tanner <mat@brain-dump.org>,
       H Hartley Sweeten <hartleys@visionengravers.com>,
       linux-embedded@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] printk: provide a filtering macro for printk
In-Reply-To: <4A9EA5C9.3010900@am.sony.com>
Message-ID: <alpine.LRH.2.00.0909101118420.31704@vixen.sonytel.be>
References: <1251844269-12394-1-git-send-email-mat@brain-dump.org> <1251844269-12394-8-git-send-email-mat@brain-dump.org> <4A9DAD2B.3080909@am.sony.com> <BD79186B4FD85F4B8E60E381CAEE190901C55CD3@mi8nycmail19.Mi8.com> <20090902130943.GE2736@debbook.brain-dump.org>
 <4A9EA5C9.3010900@am.sony.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Sep 2009, Tim Bird wrote:
> Marc Andre Tanner wrote:
> > On Tue, Sep 01, 2009 at 07:32:25PM -0400, H Hartley Sweeten wrote:
> >> On Tuesday, September 01, 2009 4:24 PM, Tim Bird wrote:
> >>> Some places in the kernel break the message into pieces, like so:
> >>>
> >>> printk(KERN_ERR, "Error: first part ");
> >>> ...
> >>> printk(" more info for error.\n");
> >> Technically, shouldn't the second part of the message actually be:
> >>
> >> printk(KERN_CONT " more info for error.\n");
> >>
> >> Maybe some mechanism could be created to handle the continued message
> >> if they have the KERN_CONT?
> > 
> > Yes it's true that KERN_CONT isn't handled correctly, but I don't see a way
> > to change that.
> > 
> >>> These parts would not be handled consistently under certain
> >>> conditions.
> >>>
> >>> It would be confusing to see only part of the message,
> >>> but I don't know how often this construct is used.  
> > 
> > $ grep -R KERN_CONT linux-2.6 | wc -l
> > 373
> > 
> >>> Maybe
> >>> another mechanism is needed to ensure that continuation
> >>> printk lines have the same log level as their start strings.
> > 
> > I currently don't see a way to achieve this with the CPP.
> 
> If it's that few, then maybe it's OK to actually change
> the code for those printk statements. (Heck, these locations
> were all changed in the last 2 years anyway.)
> 
> I'm just brainstorming here, but how about changing them from:
>   printk(KERN_INFO "foo");
>   printk(KERN_CONT "bar\n");
> to:
>   printk(KERN_INFO "foo");
>   printk_cont(KERN_INFO "bar\n");
> 
> This way the continuation line has the log level, and can
> be conditionally compiled based on the VERBOSITY level.  A little
> magic would be needed to strip the first 3 chars of the fmt
> string in printk_cont().

You could strip the first 3 chars by adding 3 to the pointer. Which will
fail horribly if the KERN_* is forgotten and the format string is very short.
And the KERN_* still consumes memory.

Or make the KERN_* an explicit first parameter:

    printk_cont(KERN_INFO, "bar\n");

Is "strcmp(p, KERN_INFO)" optimized away for constant strings?

> I think this makes the printk messages a bit more consistent anyway,
> and still marks lines that are continuation lines.

With kind regards,

Geert Uytterhoeven
Software Architect
Techsoft Centre

Technology and Software Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
