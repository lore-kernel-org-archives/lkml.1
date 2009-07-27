Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbZG0JhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbZG0JhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 05:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbZG0JhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 05:37:23 -0400
Received: from smtp-out.google.com ([216.239.33.17]:7637 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbZG0JhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 05:37:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=fiY7X4s6G2W63p7OzmB45bx+8qAFkQ5t2N7wm/R/F1t19bnD70Qh/F8+kDKmV9CaK
	GfOPbZq2cyqyTa8btKPuQ==
Date: Mon, 27 Jul 2009 02:37:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
In-Reply-To: <84144f020907270008h2a985278of68e70ff1ee9265c@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0907270227420.15760@chino.kir.corp.google.com>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera> <H5-1lZIIeYK.A.Pi.BZObKB@chimera> <4A6CF220.7080605@lwfinger.net> <alpine.DEB.2.00.0907261722140.21259@chino.kir.corp.google.com> <84144f020907270008h2a985278of68e70ff1ee9265c@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="497827084-1036803123-1248687436=:15760"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--497827084-1036803123-1248687436=:15760
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 27 Jul 2009, Pekka Enberg wrote:

> > Hmm, I'm remembering differently.  I thought the root problem here has
> > only been fixed in Pekka's slab-2.6.git tree with "slub: add option to
> > disable higher order debugging slabs" and isn't currently in Linus' tree.
> 
> Yup, the fix is in slab.git and queued for 2.6.32. There was some
> complaints from Christoph from the patch that need to be addressed
> still.
> 

>From what I recall, he asked that calculate_sizes() be called twice, first 
to determine if get_order(s->size) increased as the result of the metadata 
and, if so, a second time with the flags disabled.

slab_debug=O only disables debugging options that increase the min order 
of slab as defined in DEBUG_FLAGS; it doesn't selectively disable some of 
them when get_order(s->size) grows.  So it's quite sane, like my patch 
does, to disable all DEBUG_FLAGS when

	get_order(s->objsize) + DEBUG_SIZE_FLAGS > get_order(s->objsize)

without calling calculate_sizes() twice.

We need DEBUG_FLAGS to determine which flags to mask off to reduce the 
minimum order, so I don't see DEBUG_FLAGS_SIZE as troublesome.

Christoph?
--497827084-1036803123-1248687436=:15760--
