Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbZF3Gza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbZF3Gza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 02:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZF3GzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 02:55:22 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:40651 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbZF3GzV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 02:55:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=IRsdd39df5tks36d47nEkOVcfPxejGEyb9Dd+u24RImQWnuMZ0cQnGl0qUMe8aOpGv
         9DEDh6Nm7SMz9M8OS4O1mcIOn6DKlRqhjipbDmQXQD5hepoBYLUO+lpghdWjqY2xUBiz
         ZOZatvuCj/aV+DZLfbcMrMX5rGI3CVP4WSKdQ=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0906291642520.17663@chino.kir.corp.google.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
	 <5Hhc7UkUKEO.A.fNH.4kASKB@chimera> <4A48F114.1010702@lwfinger.net>
	 <alpine.DEB.2.00.0906291642520.17663@chino.kir.corp.google.com>
Date: Tue, 30 Jun 2009 09:55:22 +0300
X-Google-Sender-Auth: 262845fc1ad9c3bf
Message-ID: <84144f020906292355o7cf63f7ch47bd19961cf92da3@mail.gmail.com>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, Jun 30, 2009 at 2:47 AM, David Rientjes<rientjes@google.com> wrote:
> On Mon, 29 Jun 2009, Larry Finger wrote:
>
>> > Bug-Entry   : http://bugzilla.kernel.org/show_bug.cgi?id=13319
>> > Subject             : Page allocation failures with b43 and p54usb
>> > Submitter   : Larry Finger <Larry.Finger@lwfinger.net>
>> > Date                : 2009-04-29 21:01 (61 days old)
>> > References  : http://marc.info/?l=linux-kernel&m=124103897101088&w=4
>> >               http://lkml.org/lkml/2009/6/7/136
>> > Handled-By  : Johannes Berg <johannes@sipsolutions.net>
>>
>> The cause of these failures has been determined. The wireless
>> subsystem frequently requests buffers of size 4096, but when SLUB
>> debugging is enabled and the debug info is added, the request becomes
>> of order 1 and memory becomes fragmented.
>>
>> A controversial "fix" in which SLUB debugging was disabled for
>> allocations where adding such debugging info would increase the order
>> was discussed and tried. With a quick look at the commit list for
>> Linus's tree, I don't see that such a patch is available, but I will
>> be corrected if I missed it.
>>
>
> I'd disagree with disabling slub debugging by default for caches where
> oo_order(s->min) increases as the result of using it.  This particular
> page allocation failure is happening for, presumably, kmalloc-4096, and
> the system has 4K pages.  Disabling debugging for that cache (and any of
> its aliases) implicitly will lead to errors going undiagnosed as a result.

Well, I obviously don't agree here because kmalloc-4096 debugging
causes problems in the real world. Furthermore, SLUB never supported
debugging for objects that big historically because of page allocator
passthrough. And with Mel Gorman's page allocator optimizations, we
might be going back to that.

So we should fix SLUB debugging as outlined by Mel Gorman and
Christoph Lameter. I simply haven't had the time to do it. Patches are
welcome!

                              Pekka
