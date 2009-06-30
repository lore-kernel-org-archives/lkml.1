Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbZF3O4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbZF3O4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 10:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZF3O4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 10:56:24 -0400
Received: from smtp.srv.ualberta.ca ([129.128.5.19]:53759 "EHLO
	mail7.srv.ualberta.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751900AbZF3O4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 10:56:24 -0400
X-Greylist: delayed 1679 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jun 2009 10:56:23 EDT
Date: Tue, 30 Jun 2009 08:01:47 -0600 (Mountain Daylight Time)
From: Marc Aurele La France <tsi@ualberta.ca>
To: hpa@kernel.org
cc: Greg KH <greg@kroah.com>, x86@kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
       Research.Support@ualberta.ca
Subject: Re: [rs] Re: [stable] [PATCH] x86, setup (2.6.30-stable) fix 80x34
 and 80x60 console modes
In-Reply-To: <4A49B1C6.9040900@kernel.org>
Message-ID: <alpine.WNT.1.10.0906300743550.2004@cluij.ucs.ualberta.ca>
References: <alpine.BSO.1.10.0906291746410.14658@fanir.ucs.ualberta.ca> <4A496A0C.809@kernel.org> <20090630034822.GC12373@kroah.com> <4A49B1C6.9040900@kernel.org>
User-Agent: Alpine 1.10 (WNT 962 2008-03-14)
X-X-Sender: tsi@maildrop.srv.ualberta.ca
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009, H. Peter Anvin wrote:
> Greg KH wrote:
>> On Mon, Jun 29, 2009 at 06:27:40PM -0700, H. Peter Anvin wrote:
>>> Marc Aurele La France wrote:
>>>> As coded, most INT10 calls in video-vga.c allow the compiler to assume EAX
>>>> remains unchanged across them, which is not always the case.  This
>>>> triggers an optimisation issue that causes vga_set_vertical_end() to be
>>>> called with an incorrect number of scanlines.  Fix this by beefing up the
>>>> asm constraints on these calls.

>>>> Reported-by: Marc Aurele La France <tsi@xfree86.org>
>>>> Signed-off-by: Marc Aurele La France <tsi@xfree86.org>
>>>> Acked-by: H. Peter Anvin <hpa@zytor.com>

>>> Note: this is not in upstream since upstream is not affected due to the
>>> new "BIOS glovebox" subsystem.

>> So it is a ".30 only" type patch?  Any older kernel versions affected?

> Yes, all the way back to .23 or something like that.

No.  The problem can only arise in 2.6.30 and is a consequence of commit 
5f641356127712fbdce0eee120e5ce115860c17f.  It disappears with subsequent 
mainline commit cf06de7b9cdd3efee7a59dced1977b3c21d43732.

Prior to 2.6.30, vga_set_480_scanlines() was passed a byte-size value (as 
an int), which means the compiler was forced to load EAX, instead of only 
AL, even if it did assume AH still contained 0x01.  That 0x01 is what the 
last INT10 call in the vga_set_{8,14}font() functions sets AH to.

In truth, only those two INT10's need beefing up.  But I did them all for 
completeness.

Marc.

PS:   That should be "80x43", not "80x34".

+----------------------------------+----------------------------------+
|  Marc Aurele La France           |  work:   1-780-492-9310          |
|  Academic Information and        |  fax:    1-780-492-1729          |
|    Communications Technologies   |  email:  tsi@ualberta.ca         |
|  352 General Services Building   +----------------------------------+
|  University of Alberta           |                                  |
|  Edmonton, Alberta               |    Standard disclaimers apply    |
|  T6G 2H1                         |                                  |
|  CANADA                          |                                  |
+----------------------------------+----------------------------------+
XFree86 developer and VP.  ATI driver and X server internals.
