Return-Path: <linux-kernel-owner+w=401wt.eu-S1762867AbZCQHt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762867AbZCQHt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 03:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbZCQHtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 03:49:20 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:23781 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbZCQHtU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 03:49:20 -0400
Message-Id: <49BF643D.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 17 Mar 2009 07:50:05 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "David Airlie" <airlied@linux.ie>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH 10/27] xen: make sure swiotlb	
	 allocationisphysically contigious
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
 <1236963612-14287-11-git-send-email-jeremy@goop.org>
 <49BE627E.76E4.0078.0@novell.com> <49BEAA61.4020208@goop.org>
In-Reply-To: <49BEAA61.4020208@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 16.03.09 20:37 >>>
>Jan Beulich wrote:
>>  
>> While on native using alloc_bootmem_low_pages() is a requirement here,
>> on Xen this should explicitly not be used, as we realized just a couple of
>> days ago:
>
>Which conversation was this?

I pointed out the issue in a mail titled "alloc_bootmem_low() mis-uses", in
response to a bug report we had from HP running into an out-of-memory
panic from the bootmem allocator when allocating the 64Mb of swiotlb on
a 256Gb box.

>>  The way the bootmem allocator works, running out of space
>> below 4Gb is pretty easy on machines with lots of memory, and since the
>> swiotlb is a requirement for Dom0, the risk of allocation failures must be
>> kept as low as possible.
>>   
>
>Are we talking about a 32 or 64 bit dom0 here?  If its 32-bit, then yes, 
>low memory is a precious resource, but I don't see why that depends on 
>the total amount of memory.  And if its 64-bit, why is below-4G 
>particularly constrained?  That would only matter for 32-bit devices?

No, it's in particular about 64-bit (and native has a similar potential problem
here, just that it's not that easily fixable because, as said,
alloc_bootmem_low_pages() is a must there): Since the bootmem allocator
(generally) works from bottom to top, 'normal' (i.e. without the _low suffix)
bootmem allocations may eat up most/all memory below 4Gb, and when
finally the swiotlb initialization runs there's no memory left for it.

For boxes with yet much more memory (as I realized only after having
written that other mail), there's also another issue of the bootmem
allocation bitmap generally getting allocated as low as possible (which
again may eat up all memory below 4Gb), but fixing this at least doesn't
require touching the bootmem code itself (and is of course a really
secondary issue, as it's going to be a couple of years until this bitmap
would reach into the Gb range).

Jan

