Return-Path: <linux-kernel-owner+w=401wt.eu-S1759277AbZKYT1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbZKYT1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 14:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZKYT1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 14:27:41 -0500
Received: from waste.org ([173.11.57.241]:33916 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbZKYT1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 14:27:41 -0500
Subject: Re: hw_random fixes
From: Matt Mackall <mpm@selenic.com>
To: Ian Molton <ian.molton@collabora.co.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4B0D03FC.40406@collabora.co.uk>
References: <4B080621.5000109@collabora.co.uk>
	 <4B0C18B0.2000206@collabora.co.uk> <1259084901.17871.624.camel@calx>
	 <200911251135.41871.rusty@rustcorp.com.au> <4B0D03FC.40406@collabora.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 13:27:32 -0600
Message-ID: <1259177252.2858.17.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc:ing to linux-kernel, finally]

On Wed, 2009-11-25 at 10:16 +0000, Ian Molton wrote:
> Rusty Russell wrote:
> 
> > Make that:
> > 
> > 	ssize_t (*get_rng_data)(void *buf, size_t max, bool wait);
> > 
> > Then, if driver supplies that hook, use it exclusively.  Otherwise, use old
> > ones.  We can convert them gradually that way.
> 
> This doesn't quite solve things neatly, because it means one of:
> 
> 1) The core has to wait until there is nothing left before requesting
> more data, because it doesnt know the alignment requirements of the driver.

Hmm, this seems to imply you'd be calling get_rng_data multiple times
with different offsets into buf to accumulate data. I think that's more
complex than is needed. Just use buf as a nicely aligned scratch buffer
and empty it completely into the final output buffer before the next
driver request. If you end up with 1 byte of data hanging around until
the next read, that's not a problem - the next read might be 5 bytes.

You'll probably want to use cacheline alignment on buf to make Via
Padlock happy, if anything needs larger alignment (ie page) it should
handle it internally.

-- 
http://selenic.com : development and support for Mercurial and Linux


