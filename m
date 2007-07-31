Return-Path: <linux-kernel-owner+w=401wt.eu-S1759505AbXGaXGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbXGaXGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 19:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbXGaXGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 19:06:24 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49886 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbXGaXGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 19:06:24 -0400
Subject: Re: /proc/$pid/pagemap troubles
From: Dave Hansen <haveblue@us.ibm.com>
To: Andreas Schwab <schwab@suse.de>
Cc: Matt Mackall <mpm@selenic.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <je4pjkqiya.fsf@sykes.suse.de>
References: <1185914174.18414.184.camel@localhost>
	 <20070731213718.GW11115@waste.org>  <je4pjkqiya.fsf@sykes.suse.de>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 16:06:21 -0700
Message-Id: <1185923181.18414.228.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-01 at 00:58 +0200, Andreas Schwab wrote:
> Matt Mackall <mpm@selenic.com> writes:
> 
> > On Tue, Jul 31, 2007 at 01:36:14PM -0700, Dave Hansen wrote:
> >> Since the pagemap code has a little header on it to help describe the
> >> format, I wrote a little c program to parse its output.  I get some
> >> strange results.  If I do this:
> >> 
> >> 	fd = open("/proc/1/pagemap", O_RDONLY);
> >> 	count = read(fd, &endianness, 1);
> >> 
> >> count will always be 4.  
> >
> > Known bug, fixed in my pending and not-currently-working update. It
> > ought to return 0 for short reads.
> 
> That's not a good choice.  Returning 0 means EOF, but there is actually
> data to be read.

This should actually be pretty easy to fix.  We have a nice PAGE_SIZE
buffer.  So, if we are unaligned and would have overflowed the PAGE_SIZE
buffer, we return a short read.

If they ask for a <sizeof(unsigned long) read, we can copy that into the
PAGE_SIZE buffer, then just copy_to_user() the portion that was asked
for.  

-- Dave

