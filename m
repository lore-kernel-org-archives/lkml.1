Return-Path: <linux-kernel-owner+w=401wt.eu-S1758462AbYHOMYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbYHOMYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 08:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbYHOMXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 08:23:51 -0400
Received: from oxygen.pond.sub.org ([88.198.11.5]:46098 "EHLO
	oxygen.pond.sub.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbYHOMXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 08:23:50 -0400
X-Greylist: delayed 1242 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Aug 2008 08:23:50 EDT
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Hugh Dickins <hugh@veritas.com>, Ian Campbell <ijc@hellion.org.uk>,
       linux-kernel@vger.kernel.org, Kel Modderman <kel@otaku42.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: Re: kernel BUG at lib/radix-tree.c:473!
References: <1218697362.26014.9.camel@localhost.localdomain>
	<Pine.LNX.4.64.0808141347480.11013@blonde.site>
	<48A48879.2000309@goop.org>
	<Pine.LNX.4.64.0808142104080.29719@blonde.site>
	<48A4AC01.7040402@goop.org>
From: Markus Armbruster <armbru@redhat.com>
Date: Thu, 14 Aug 2008 18:48:36 -0400
In-Reply-To: <48A4AC01.7040402@goop.org> (Jeremy Fitzhardinge's message of "Thu\, 14 Aug 2008 15\:04\:49 -0700")
Message-ID: <m33al7ciwr.fsf@crossbow.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
Content-Type: text/plain; charset=us-ascii
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Hugh Dickins wrote:
>> As you can see, I'm still groping towards the right answer.
>> The driver probably needs to provide its own backing_dev_info
>> (or point to a suitable default), and its own address_space_ops,
>> and perhaps more (there should be examples elsewhere).  But whether
>> it is actually wrong, or whether I was wrong to mess it up, I've
>> not yet decided.
>>   
>
> My understanding is that the driver is doing something a bit clever:
> it uses the page dirty flags to determine which parts of the
> framebuffer have been written to, and uses that information to
> minimize the amount of stuff that needs to be copied out.  The writes

Yes.

> to the pages are not expected to generate actual page faults.
>
> But I haven't really looked at it closely, and I'm not at all familiar
> with the vm at this layer.  I'm not sure how it actually allocates the
> framebuffer memory for example (vmalloc?  incrementally on faults?).

vmalloc()

> I'm hoping Markus will leap in, since wrote this stuff.  Or, gasp,
> I'll read the code myself.

The actual cleverness is in fb_defio[*], which was written by Jaya
Kumar (cc'ed).  I merely ripped out the old, somewhat racy cleverness
I inherited from Anthony Liguori (which you can still admire in Xen's
2.6.18 kernel), and switched over to use fb_defio instead.  Because
one instance of clever code is enough.

My understanding of fb_defio's inner workings is rather limited I
fear.  I'm just using it.

Jaya, could you help?

[...]


[*] Documentation/fb/deferred_io.txt drivers/video/fb_defio.c
