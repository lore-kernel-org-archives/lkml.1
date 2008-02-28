Return-Path: <linux-kernel-owner+w=401wt.eu-S1761392AbYB1RyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392AbYB1RyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 12:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbYB1RyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 12:54:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32786 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbYB1RyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 12:54:12 -0500
Message-ID: <47C6F4F9.90700@zytor.com>
Date: Thu, 28 Feb 2008 09:52:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Klaus S. Madsen" <ksm@hjernemadsen.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
References: <20080227221033.GR17932@hjernemadsen.org> <20080228091639.GB1133@elte.hu> <20080228092846.GC17932@hjernemadsen.org> <20080228094000.GA2987@elte.hu> <20080228150444.GG17932@hjernemadsen.org>
In-Reply-To: <20080228150444.GG17932@hjernemadsen.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Klaus S. Madsen wrote:
> 
> Hope this helps. 
> 

What this seems to indicate is a segfault inside VM mode that causes it 
to exit to deliver the SIGSEGV, so without more information, such as 
signal context, there isn't much to know about it.

It looks like the fault happens inside the VESA BIOS, specifically VBE 
function 3:

--------V-104F03-----------------------------
INT 10 - VESA SuperVGA BIOS - GET CURRENT VIDEO MODE
         AX = 4F03h
Return: AL = 4Fh if function supported
         AH = status
             00h successful
                 BX = video mode (see #00083,#00084)
                     bit 13: VBE/AF v1.0P accelerated video mode
                     bit 14: linear frame buffer enabled (VBE v2.0+)
                     bit 15: don't clear video memory
             01h failed
SeeAlso: AH=0Fh,AX=4E04h,AX=4F02h

... which normally would be a trivial function which only reads a couple 
of status words out of internal state and returns.

****

Typically, when the kernel reflects an error in VM86 mode it will update 
the structure in memory (in your case, the vm86plus_struct) to reflect 
the context.  Would it be possible for you to read it out?

[FWIW, that code looks like it's using assembly for no good current 
reason.  Not sure if it'd help to clean it up.]

	-hpa
