Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbZEUOIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbZEUOIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 10:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbZEUOIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 10:08:13 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:11862 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753362AbZEUOIM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 10:08:12 -0400
X-BigFish: VPS-33(zz1432R98dR168aJ1805M179dRzz1202hzzz32i6bh6di43j)
X-FB-SS: 5,13,
X-WSS-ID: 0KJZZ9A-02-WFJ-01
Date: Thu, 21 May 2009 16:08:00 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu, norsk5@yahoo.com,
       tglx@linutronix.de, mchehab@redhat.com, aris@redhat.com, edt@aei.ca,
       linux-kernel@vger.kernel.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 01/22] x86: add methods for writing of an MSR on
	several CPUs
Message-ID: <20090521140800.GA3462@aftab>
References: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com> <1242390153-24493-2-git-send-email-borislav.petkov@amd.com> <20090519172449.GB18874@aftab> <4A1392A9.9010609@zytor.com> <20090520144905.GA27991@aftab> <4A147891.5000906@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A147891.5000906@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 21 May 2009 14:08:01.0851 (UTC) FILETIME=[8D6E90B0:01C9DA1D]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 02:39:29PM -0700, H. Peter Anvin wrote:
> Borislav Petkov wrote:
> > 
> > We currently need them for enabling the NB error reporting bank over
> > MCG_CTL on each core on the node. The question is whether we really need
> > the concurrency when accessing an MSR on several cores. With MCG_CTL,
> > BKDG says "It is expected that this register is programmed to the same
> > value in all nodes," but nothing concerning concurrency.
> > 
> > But you're right, if this interface is supposed to be generic enough,
> > it is probably wise to access an MSR concurrently. I could imagine
> > an obscure case where this is required. However, is sending IPIs
> > (smp_call_function_many) guaranteeing the needed concurrency? Or, should
> > it be more like how the mtrr code jumps through hoops (set_mtrr())
> > in order to ensure that _ALL_ registers have been written _before_
> > continuing?
> > 
> 
> smp_call_function_many() does allow concurrent execution.

Well, IMHO, not an absolutely concurrent execution since you can't
control at what moment in time the IPIs will be executed on each core,
IOW, the respective call function IPIs will generally not coincide on
each core at a given moment in time. This is especially true if you're
sending IPIs to cores across nodes.

And there's hypothetically a small window where you might get an
inconsistent MSR content across cores. It's a whole another question
whether this is going to be relevant.

> Looping over a list with smp_call_function_one() -- which you
> currently have -- is serializing, at which point we might just push
> the loop into the caller rather than worrying about a new interface.

So, the actual question is do we need that done in msr.c? If there are
no potential users, I could easily do the whole thing in the driver and
do not touch x86 code.

Hmm?

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

