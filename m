Return-Path: <linux-kernel-owner+w=401wt.eu-S1030674AbXBOTMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030674AbXBOTMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030696AbXBOTMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:12:25 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:36435 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030674AbXBOTMY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:12:24 -0500
Date: Thu, 15 Feb 2007 14:12:22 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@redhat.com>, systemtap@sources.redhat.com,
       ltt-dev@shafik.org
Subject: Re: [PATCH 02/05] Linux Kernel Markers, architecture independant code.
Message-ID: <20070215191222.GB31359@Krystal>
References: <1171224207118-git-send-email-mathieu.desnoyers@polymtl.ca> <11712242074091-git-send-email-mathieu.desnoyers@polymtl.ca> <20070214232137.7aa86259.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070214232137.7aa86259.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 14:09:42 up 13 days,  9:17,  7 users,  load average: 1.03, 1.12, 1.31
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Sun, 11 Feb 2007 15:03:24 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Linux Kernel Markers, architecture independant code.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > 
> > ...
> >
> > +
> > +#ifndef MARK
> > +#define MARK GEN_MARK
> > +#define MARK_ENABLE_TYPE GEN_MARK_ENABLE_TYPE
> > +#define MARK_ENABLE_IMMEDIATE_OFFSET GEN_MARK_ENABLE_IMMEDIATE_OFFSET
> > +#endif
> 
> Also perhaps this nastiness can go away once each architecture has
> asm/marker.h?
> 
Yes, absolutely.

> > +#ifdef MARK_POLYMORPHIC
> 
> What's this?  Is it commented somewhere?  (It should be...)
> 

No, but should be : it is defined by the architecture's marker.h when
the marker flavor has to do code motification when the marker state is
modified.


> > +static int marker_set_ins_enable(void *address, char enable)
> > +{
> > +#ifdef CONFIG_X86_32
> > +	return arch_marker_set_ins_enable(address, enable);
> > +#else
> > +	char newi[MARK_ENABLE_IMMEDIATE_OFFSET+1];
> > +	int size = MARK_ENABLE_IMMEDIATE_OFFSET+sizeof(MARK_ENABLE_TYPE);
> > +
> > +	memcpy(newi, address, size);
> > +	MARK_ENABLE(&newi[0]) = enable;
> > +	memcpy(address, newi, size);
> > +	flush_icache_range((unsigned long)address, size);
> > +	return 0;
> > +#endif //CONFIG_X86_32
> > +}
> 
> eww.  Can we put a suitable arch_marker_set_ins_enable() into each arch's
> marker.h?
> 

Or maybe put that in asm-generic so we do not duplicate code.

> > +#else
> > +static int marker_set_ins_enable(void *address, char enable)
> > +{
> > +	return -EPERM;
> > +}
> > +#endif //MARK_POLYMORPHIC
> > +
> >
> > ...
> >
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Candidate, École Polytechnique de Montréal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
