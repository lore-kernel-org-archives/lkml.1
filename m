Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbYEGEFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbYEGEFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 00:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbYEGEFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 00:05:33 -0400
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3197 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbYEGEFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 00:05:32 -0400
From: Roman Zippel <zippel@linux-m68k.org>
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] clocksource: shift helper
Date: Wed, 7 May 2008 05:57:36 +0200
User-Agent: KMail/1.9.9
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
References: <20080501173123.444094226@mvista.com>
In-Reply-To: <20080501173123.444094226@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805070557.39424.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 1. May 2008, Daniel Walker wrote:

> This is a little helper I pulled from the mips tree. I've seen a couple
> of bogus shift values, and this helper calculates the shift. This
> should move the shift selection away from the user, and systematically
> pick the value base on the hz.
>
> I also modified the acpi_pm timer to use this new interface. The original
> shift was 22 , and after this patch it's increased to 23. Which should make
> the clocksource slightly more accurate, but shouldn't have much of a
> visible effect.

What is this calculation based on?

Unless I miss something even 22 is far more than enough. acpi_pm has a 
resolution of 279ns, thus the clock can't be more accurate than half of this 
on average and increasing the shift doesn't change much directly about it.
What the shift value does influence is the size of the adjustment step the 
clock code can do during an update, so with shift=22 and HZ=100 the possible 
adjustment step would be 0.008ns (freq/2^shift/ntp_hz). The problem is that 
this value is also used for how soon the clock is being adjusted, this means 
the clock code is constantly busy adjusting for a very small error.
So from a clock adjustment perspective a shift value close to log2
(freq/res/10^9/ntp_hz) (with res=1/freq and being limited to 1ns<=res<=1us) 
would provide sufficient accuracy, while keeping the need for adjustment low, 
this means with the above example a shift value of much more than 8 doesn't 
improve accuracy significantly.

That said, I agree that a dynamic calculation of the shift value is a good 
thing, but I don't think that the method in the patch is a good one.

bye, Roman
