Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbXDLU4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbXDLU4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 16:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbXDLU4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 16:56:13 -0400
Received: from Apollo.christiedigital.com ([65.195.57.9]:37235 "EHLO
	CDSCYPEXG01.cds.int" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753622AbXDLU4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 16:56:12 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: tmpfs and the OOM killer
Date: Thu, 12 Apr 2007 16:56:24 -0400
Message-ID: <AD98412A5373CC4AA643D9C021922A541C4DE0@cdskitexg01.cds.int>
In-Reply-To: <20070412203153.GJ943@1wt.eu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: tmpfs and the OOM killer
Thread-Index: Acd9Qetnk89ZqSWlQnioYR753PZK/QAAozEQ
From: "Mouawad, Tony" <Tony.Mouawad@christiedigital.com>
To: "Willy Tarreau" <w@1wt.eu>, "Pedro" <linux_user@izecksohn.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Apr 2007 20:56:26.0115 (UTC) FILETIME=[09090530:01C77D45]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have noticed that with overcommit_memory=2 and overcommit_ratio=100,
my system cannot leverage as much ram as it could if it was configured
for overcommit_memory=0.

Is this because when overcommit_memory=2, anything that mallocs memory
but doesn't touch that memory is counted as used memory?  I see a value
in /proc/meminfo called Commited_AS: and it seems to reflect what has
been malloced in the system but not necessarily touched.  Is this true?

Cheers,
Tony


-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Willy Tarreau
Sent: Thursday, April 12, 2007 4:32 PM
To: Pedro
Cc: linux-kernel@vger.kernel.org
Subject: Re: tmpfs and the OOM killer

On Thu, Apr 12, 2007 at 11:35:32AM -0300, Pedro wrote:
> On Thursday 12 April 2007 08:25, Theodore Tso wrote:
> > likely going to be in deep trouble anyway.  Even if you disable the
> > OOM killer, now random malloc()'s will start returning NULL because
> > your system doesn't have enough memory.  Do you have intelligent
error
> > handling and recovery mechanisms for every single malloc() failure?
> 
>   When malloc return NULL, the process may tell the user ENOMEM.
>   When OOM kill the process, the user claim the program sometimes die.

Then use overcommit=2. The default overcommit mode is a convenience
provided
to allow poorly designed applications run even when they pretend they
need
gigs of RAM when they only use a few tens of megs.

If your application correctly handles malloc(), simply switch overcommit
to 2 and let the system refuse to allocate memory when none is
available,
then your application will be aware of this by the NULL result to
malloc()
calls. It is a normal behaviour.

I do have appliances which run perfectly controlled software with
overcommit_mode=2 and overcommit_ratio around 70% and without any
swap, and they work like a charm. It just requires some finer grained
tuning on your side. I don't see what the problem is here. You know
the app, you know how much RAM you want to allocate to it, you know
how much you want to keep free. Then say this to the system.

BTW, ulimit -v is your friend here too, and does not require to be root.

Regards,
Willy

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel"
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
