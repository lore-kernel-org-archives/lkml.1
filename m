Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318AbYJAUBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbYJAUBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 16:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbYJAUBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 16:01:08 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:22126 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbYJAUBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 16:01:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=o+0nuBuThFlYKlskbvcpP5hWoRA9UgG7pAOlcFbCYKZ32yK1375AKs/59flcmdee8j
         f13SHsuO/EEyZRDwp0YgCd6stCgzSq1y1EWKFL52JycSGY+safoHkZkPhwzdF/byAR7R
         FXdwG1zgyCZbjcX7v6qxVSgeqEpzxIdWOJwgM=
Message-ID: <48E3D6FC.7070709@gmail.com>
Date: Wed, 01 Oct 2008 22:01:00 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       Vegard Nossum <vegardno@ifi.uio.no>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix virt_addr_valid() with CONFIG_DEBUG_VIRTUAL=y
References: <20081001104717.GA7925@ben.ifi.uio.no> <48E359B4.7050708@gmail.com> <19f34abd0810010415s405dcd98j187e5c9c20fc2d16@mail.gmail.com> <48E35E83.9040101@gmail.com> <19f34abd0810010942ifef42efv6c45831789aa1293@mail.gmail.com> <20081001165246.GY25711@one.firstfloor.org> <48E3D03C.5010808@gmail.com> <20081001194655.GZ25711@one.firstfloor.org>
In-Reply-To: <20081001194655.GZ25711@one.firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2008 09:46 PM, Andi Kleen wrote:
>> Anyway virt_addr_valid() is IMHO wrong. E.g. first modules VM address
>> 0xffffffffa0000000 is after __pa() 200M which is valid pfn after the shift even
>> on the flatmem model with enough memory.
>>
>> Am I missing something? What's the exact purpose of the virt_addr_valid()?
> 
> I think it's supposed to be only used on direct mapping anyways (judging
> from a quick look a the users)

Then kmemcheck assumes something else. Citing:
 * We need to be extremely careful not to follow any invalid pointers,
 * because this function can be called for *any* possible address.
and the very first check is !virt_addr_valid(address).

> So not handling text mapping is ok, but don't panic on it.

It doesn't handle properly anything but text and direct mapping. Now it
oopses/causes BUG on that wrong cases.

I think we should set it down there that it was intended to be used only on
text/direct mapping and only for checking if there is a physical memory page
behind this kind of virtual address.
