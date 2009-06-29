Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbZF2XsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbZF2XsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 19:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZF2XsC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 19:48:02 -0400
Received: from smtp-out.google.com ([216.239.45.13]:11321 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbZF2XsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 19:48:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=fBFFUBtTLunuZcBS8v3xYSE7W7okv7Gh6U9z+6uO8T3Exd/LioCp31G2Uf8RZSKXd
	AJXP67Iv9+a371kHW6CcA==
Date: Mon, 29 Jun 2009 16:47:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
In-Reply-To: <4A48F114.1010702@lwfinger.net>
Message-ID: <alpine.DEB.2.00.0906291642520.17663@chino.kir.corp.google.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <5Hhc7UkUKEO.A.fNH.4kASKB@chimera> <4A48F114.1010702@lwfinger.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009, Larry Finger wrote:

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13319
> > Subject		: Page allocation failures with b43 and p54usb
> > Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> > Date		: 2009-04-29 21:01 (61 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124103897101088&w=4
> > 		  http://lkml.org/lkml/2009/6/7/136
> > Handled-By	: Johannes Berg <johannes@sipsolutions.net>
> 
> The cause of these failures has been determined. The wireless
> subsystem frequently requests buffers of size 4096, but when SLUB
> debugging is enabled and the debug info is added, the request becomes
> of order 1 and memory becomes fragmented.
> 
> A controversial "fix" in which SLUB debugging was disabled for
> allocations where adding such debugging info would increase the order
> was discussed and tried. With a quick look at the commit list for
> Linus's tree, I don't see that such a patch is available, but I will
> be corrected if I missed it.
> 

I'd disagree with disabling slub debugging by default for caches where 
oo_order(s->min) increases as the result of using it.  This particular 
page allocation failure is happening for, presumably, kmalloc-4096, and 
the system has 4K pages.  Disabling debugging for that cache (and any of 
its aliases) implicitly will lead to errors going undiagnosed as a result.
