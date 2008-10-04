Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbYJDLmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbYJDLmB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 07:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYJDLlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 07:41:53 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:35612 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbYJDLlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 07:41:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GhTxVCmpZ5/rdC5tOVw1LoSXKM4Uy8YfZ2AB1de76c+68o4toL+DimJpxAqXQ5lC9I
         QAJo2RzjjXZIYr8lE79/uCpc1nLlFQ8GC6b/Dy0lALBsZ3TO3+dSRaiojJmJA62xaVE9
         gndUcCDLSCaT1YpPkHnWv8gWLhl2cadHx1f+E=
Message-ID: <c384c5ea0810040441u77ebf879i8c4a2be8675ca26c@mail.gmail.com>
Date: Sat, 4 Oct 2008 13:41:50 +0200
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH] mtd: AT49BV6416 has swapped erase regions
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080930142207.72d5edaa@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222775733-6690-1-git-send-email-haavard.skinnemoen@atmel.com>
	 <c384c5ea0809300502h48915058r78a6586968c1ac1a@mail.gmail.com>
	 <20080930142207.72d5edaa@hskinnemo-gx745.norway.atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Haavard, all,

this topic has now diverted to u-boot, as Linux is fixed.  I am
posting in the existing thread to keep the information coherent.

On Tue, Sep 30, 2008 at 2:22 PM, Haavard Skinnemoen
<haavard.skinnemoen@atmel.com> wrote:
> "Leon Woestenberg" <leon.woestenberg@gmail.com> wrote:
>> Haavard,
>> On Tue, Sep 30, 2008 at 1:55 PM, Haavard Skinnemoen
>> <haavard.skinnemoen@atmel.com> wrote:
>> > The CFI information read from AT49BV6416 lists the erase regions in the
>> > wrong order, causing problems when trying to erase or update the first
>> > or last 64K block.
>> >
>> Are there other Atmel designs with this bug or only the chip with this CFI ID?
>
> That's a good question. I guess there may be others in the same family
> with the same bug. I don't really know.
>
> The replacement, AT49BV642D, does not have this bug.
>
>> I ask, because the check in u-boot is too generic; I found u-boot
>> wrongly assumes wrong order for another Atmel part, not checking on a
>> specific CFI ID.
>
> That's interesting...especially since u-boot only reads the low byte
> of the JEDEC ID, so adding a fixup for one particular ID may match tons
> of chips with 16-bit IDs.
>
> I'll have to check the latest u-boot and see if it breaks any of my
> boards.
>
I just checked on a custom design, AP7000 with AT49BV320DT, which
reports its top boot bit correctly.
info->device_id == c4 for this part.

The u-boot flash_fixup_atmel() currently reverses geometry whenever
the top boot bit is set, which seems wrong:

I have to force this to zero to make that custom board work in this
piece of code:

/* Check the "top boot" bit in the PRI */
if (info->ext_addr && !(flash_read_uchar(info, info->ext_addr + 6) & 1))
  reverse_geometry = 1;

I was hesitating to come up with a patch, because some of the check is
#ifdef'd out, and I may have missed
a u-boot convention that I should layout my sectors as
bottom-boot-block in u-boot, and reverse_geometry if 'top'?

Indeed the single byte ID check may need attention. I have to lookup
the CFI specs to be sure.

Regards,
-- 
Leon
