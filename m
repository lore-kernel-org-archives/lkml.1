Return-Path: <linux-kernel-owner+w=401wt.eu-S1752331Ab0AVNJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab0AVNJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 08:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387Ab0AVNJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 08:09:46 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54452 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab0AVNJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 08:09:44 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Fri, 22 Jan 2010 14:08:35 +0100
From: Tomasz Fujak <t.fujak@samsung.com>
Subject: RE: [PATCH v1 1/1] Extended events (platform-specific) support in perf
In-reply-to: <20100122122607.GE1244@ghostprotocols.net>
To: "'Arnaldo Carvalho de Melo'" <acme@infradead.org>
Cc: jpihet@mvista.com, peterz@infradead.org,
       Pawel Osciak <p.osciak@samsung.com>, jamie.iles@picochip.com,
       will.deacon@arm.com, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com, mingo@elte.hu,
       linux-arm-kernel@lists.infradead.org,
       Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <034a01ca9b64$01863d10$0492b730$%fujak@samsung.com>
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Thread-index: AcqbXi0jy+ARFdcuSCiJWGxZ++LXCgABS3PA
References: <1264162139-26788-1-git-send-email-t.fujak@samsung.com>
 <1264162139-26788-2-git-send-email-t.fujak@samsung.com>
 <20100122122607.GE1244@ghostprotocols.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-arm-kernel-bounces@lists.infradead.org [mailto:linux-arm-
> kernel-bounces@lists.infradead.org] On Behalf Of Arnaldo Carvalho de
> Melo
> Sent: Friday, January 22, 2010 1:26 PM
> To: Tomasz Fujak
> Cc: jpihet@mvista.com; peterz@infradead.org; p.osciak@samsung.com;
> jamie.iles@picochip.com; will.deacon@arm.com; linux-
> kernel@vger.kernel.org; kyungmin.park@samsung.com; mingo@elte.hu;
> linux-arm-kernel@lists.infradead.org; m.szyprowski@samsung.com
> Subject: Re: [PATCH v1 1/1] Extended events (platform-specific) support
> in perf
> 
> Em Fri, Jan 22, 2010 at 01:08:59PM +0100, Tomasz Fujak escreveu:
> > Signed-off-by: Tomasz Fujak <t.fujak@samsung.com>
> > Reviewed-by: Pawel Osciak <p.osciak@samsung.com>
> > Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Reviewed-by: Kyungmin Park <kuyngmin.park@samsung.com>
> 
> "Extended" seems vague, I think in this context "platform_" would be a
> better namespace specifier.

Right.

> > +#define	BYTES_PER_CHUNK 4096
> > +/* returns the number of lines read;
> > +   on fail the return is negative and no memory is allocated
> > +   otherwise the *buf contains a memory chunk of which first
> > +   *size bytes are used for file contents
> > + */
> > +static int read_file(int fd, char **buf, unsigned *size)
> > +{
> > +	unsigned bytes = BYTES_PER_CHUNK;
> > +	int lines = 0;
> > +	char *ptr = malloc(bytes);
> 
> malloc can fail... Also why is that you can't process the lines one by
> one instead of reading the whole (albeit small) file at once?

Right, no malloc check.
The purpose of not processing line-by-line is that then the collection needs
to be dynamic.

Since the file buffer gets dropped after it's processed, the overallocated
memory is returned to the system.
In case of the collection (here an array and a counter) it'd require tricks
not to overallocate, and still be O(#events).

But you're right I didn't do it right - in case the a line does not parse,
memory reserved for it is not freed. Fixing.

> > +
> > +		if (name && description) {
> > +			symbols[count].symbol = name;
> > +			symbols[count].alias = "";
> > +			++count;
> > +			/* description gets lost here */
> > +			free(description);
> > +		} else {
> > +			free(description);
> > +			free(name);
> > +		}
> 
> Having "free(description);" in both cases seems funny :-)

I wasn't so bold as to upgrade the perf with human-readable event
description.
Otherwise yes, moving it outside.

> 
> - Arnaldo
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

