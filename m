Return-Path: <linux-kernel-owner+w=401wt.eu-S1751209AbXDMBOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbXDMBOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 21:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXDMBOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 21:14:32 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:39999 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751209AbXDMBOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 21:14:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=N0QwinNIZPDZlYdJBlPNv3XEKoJNf29aMdxu6BgGeub6320XwoQ3p16E7bykSuh28vcv63oDpclWVAh5v9rQEyFFK+ESSIZ03OflbRA5wtGu46F3T0K9uClHS1rNBjl7t0fdIOlfRgSFVj4nq8zDwXSu1tO2jW3ppCFyBKFRdY8=  ;
X-YMail-OSG: E6.dydIVM1nvx.RmXAdEG8apfQNkPPkfzS8TjeEJgY_mj7OrQaSMfRuVSGvg9QdGD_pe9kQTWQ--
Message-ID: <461ED96C.5030606@yahoo.com.au>
Date: Fri, 13 Apr 2007 11:14:20 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: William Lee Irwin III <wli@holomorphy.com>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
References: <1.486631555@selenic.com>	<20070412231050.GN2986@holomorphy.com>	<20070412163235.dd030637.akpm@linux-foundation.org>	<461ECB9C.8060000@yahoo.com.au> <20070412174201.065068b2.akpm@linux-foundation.org>
In-Reply-To: <20070412174201.065068b2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 13 Apr 2007 10:15:24 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

>>>>+               for (; i < 2 * chunk / KPMSIZE; i += 2, pfn++) {
>>>>+                       ppage = pfn_to_page(pfn);
>>>>+                       if (!ppage) {
>>>>+                               page[i] = 0;
>>>>+                               page[i + 1] = 0;
>>>>+                       } else {
>>>>+                               page[i] = ppage->flags;
>>>>+                               page[i + 1] = atomic_read(&ppage->_count);
>>>>+                       }
>>>>+               }
>>>
>>>
>>>Not a good idea to expose raw flags in this manner - it changes at the drop
>>>of a hat.  We'd need to also expose the kernel's PG_foo-to-bitnumber
>>>mapping to make this viable.
>>
>>I don't think it is viable because that makes the flags part of the
>>userspace ABI.
> 
> 
> It *will* be viable.  If the application wants to know if a page is dirty,
> it looks up "PG_dirty" in /proc/pg_foo-to-bitnumber and uses PG_dirty's
> numerical offset when inspecting fields in /proc/kpagemap.  If correctly
> designed, such a monitoring application will be able to report upon page
> flags which we haven't even thought up yet.

Ooh, you wanted a _runtime_ mapping of flags, yeah then I guess that works.
Still seems like a basically hit and miss affair to just use flags. What if
you want to know the process mapping a page? With systemtap or something you
could walk the rmap structures. What if you want to look at pages along the
LRU list rather than per-pfn? What about connecting pages to inodes?

I thought this type of deep poking was the whole reason the probles thingies
were merged. I'm saddened that they're no good for this. I thought it would
be an ideal usage :(


>>I wonder what they are needed for.
> 
> 
> Poking deeply into the kernel to provide information about kernel state. 
> 
> There are real-world needs for this, and the people who develop tools to
> process this information will have decent kernel understanding and will
> know that the file's contents may alter across kernel versions.  It sure
> beats poking around in /dev/kmem.
> 
> I doubt if there's a sensible way in which we can prettify this interface
> without losing information.  But we should aim to make it as robust as
> possible agaisnt future kenrel changes, of course.
> 
> And we should satisfy ourselves that all the required information has been
> made available.  The fact that it will satisfy the Oracle requirement is
> encouraging.

Yeah it is close, they need page_mapcount I think. But I was going to say
that satisfying an Oracle requirement is a good reason _not_ to merge it ;)
(I joke!)

-- 
SUSE Labs, Novell Inc.
