Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbZGFWrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbZGFWrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 18:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbZGFWrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 18:47:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58746 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbZGFWrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 18:47:13 -0400
Message-ID: <4A527EE4.1080102@zytor.com>
Date: Mon, 06 Jul 2009 15:47:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "John A. Gregor" <john.gregor@qlogic.com>
CC: ralph.campbell@qlogic.com, linux-kernel@vger.kernel.org,
       johng@diamond.mv.qlogic.com
Subject: Re: [PATCH] x86_64/__iowrite32_copy: don't use string move for PIO
 writes
References: <1246907224-22758-1-git-send-email-john.gregor@qlogic.com> <4A526CE6.30200@zytor.com> <4a526e77.IPiyTZWRWfll2+00%john.gregor@qlogic.com>
In-Reply-To: <4a526e77.IPiyTZWRWfll2+00%john.gregor@qlogic.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John A. Gregor wrote:
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
>> John Gregor wrote:
>>> From: John Gregor <johng@diamond.mv.qlogic.com>
>>>
>>> Some processors can write the same word more than once if the movs
>>> instruction is used. This version uses normal memory move instructions
>>> and gets the same performance since the speed is limited by PCIe and
>>> write combining.
>>>
>> Which processors do that *when addressing I/O memory*?
> 
> Nehalem.
> 

Thanks.  That should go into the patch header with a reference to the
erratum, rather than saying "some processors".  Additionally, there
should be a comment in the code to that effect.  Otherwise when 5-10
years from now we're trying to figure out what is going on, there is
absolutely no hope, and we'll either re-trigger the bug or end up being
stuck with cargo-cult programming.

It's probably also worth nothing that with this change, there probably
is little point in writing this in assembly at all.  This is especially
so since your implementation is buggy: by definition, __iowrite32_copy()
does the I/O operations 32 bits at a time, but you are using 64-bit
operations.

This gets even more ironic when you look at the erratum, which states
that this happens only when crossing from WB/WC memory into UC/WP/WT
memory, and in the case of UC memory (the only one of those types which
is used in Linux):

	* UC the data size of each write will now always be 8 bytes, as
	  opposed to the original data size.

A workaround is also described, which is to avoid page-crossing copies.
 No mention of doubled stores or anything like that.

Note the irony in that your patch actually takes the problem described
in the erratum and implementing it in software -- with your change,
*all* stores would be 8 bytes, which of course violates the definition
entirely.

Note how critical detailed information of the erratum was to being able
to make an actual analysis of the patch, too.  Again, this is not just a
case immediately, but possibly down the line.

Hence:

- your patch is wrong and actually introduces the problem it is supposed
  to solve;
- your description of the problem was both incomplete and incorrect (it
  might be correct if there is another erratum, but if so please
  describe it, it is not Nehalem AAK6);
- the current code is fine as long as it doesn't cross from cached to
  uncached memory, which it never should in any kind of sensible driver;
- if you are worried about that, introduce code which breaks the string
  copy at page boundaries.

Thanks,

	-hpa

