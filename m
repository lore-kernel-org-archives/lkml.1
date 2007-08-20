Return-Path: <linux-kernel-owner+w=401wt.eu-S1761005AbXHTQD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761005AbXHTQD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 12:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761204AbXHTQCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 12:02:54 -0400
Received: from mailout08.sul.t-online.de ([194.25.134.20]:50488 "EHLO
	mailout08.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761184AbXHTQCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 12:02:52 -0400
Message-ID: <46C9BB01.7050008@t-online.de>
Date: Mon, 20 Aug 2007 18:02:09 +0200
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070810)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Wu, Bryan" <Bryan.Wu@analog.com>
Subject: Re: [PATCH] NOMMU: Separate out VMAs
References: <46C58B4E.4080803@t-online.de> <23249.1186492623@redhat.com> <46B86FC1.7050601@t-online.de> <46695F6D.5050600@t-online.de> <8772.1186149811@redhat.com> <23350.1186492903@redhat.com> <16451.1187622768@redhat.com>
In-Reply-To: <16451.1187622768@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: rxpe9-ZaYeb6ZS41qy2mAz4qsxk3D59JlBFyXcm1BMxx6dkWbJmbEa
X-TOI-MSGID: 31eb829e-5953-4b3a-b217-1984eea16f75
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Bernd Schmidt <bernds_cb1@t-online.de> wrote:
> 
>> In do_mmap_private, I've commented out the logic to free excess pages, as it
>> fragments terribly
> 
> I wonder if there's a good heuristic for this.  The problem is that whilst
> not releasing excess pages _may_ seem like a good idea, if your system is
> something like a single persistent app, then it really is not.
> 
> For instance, if such an app allocates a byte over 16MB (perhaps implicitly in
> the binfmt driver), then you'd completely waste a large chunk of RAM.  In the
> 16MB+1 case, the wastage would be a byte less than 16MB.

I think it would be good to have a mechanism to group free pages by 
purpose - so that if we break up a high-order page in order to allocate 
memory for process A, then the remaining pages remain in a special pool 
that the allocator will prefer to hand out only to process A.


>> Also, I think you're freeing high-order pages unaligned to
>> their order?
> 
> Yeah, but some of the pages might still be in use when we want to release
> them.

Not following you here.  Is it valid to free an order-2 page that's not 
aligned at order-2?

>> In do_munmap, we can deal with freeing more than one vma.  I've not touched
>> the rb-tree logic in the shared file case, as I have no idea what it's trying
>> to do given that only exact matches are allowed.
> 
> I'd generally rather not do this.  You can't use MAP_FIXED to request adjacent
> regions, so why should you anticipate there would be any?

Adjacent regions can happen by accident, and the uClibc malloc will try 
to merge free areas when they are adjacent - there's a lot of 
special-case code in there to prevent this on uClinux systems by 
essentially duplicating VMA tracking.  That's something we want to 
avoid, because it eats performance (especially in threaded apps due to 
additional locking).


Bernd
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif
