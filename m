Return-Path: <linux-kernel-owner+w=401wt.eu-S1752103AbYJSDOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbYJSDOz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 23:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYJSDOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 23:14:48 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:43062 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750865AbYJSDOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 23:14:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Ftm/NMBkmKOez+jOqWADKs5EHVwzY3HItTputm2LqiBOBDSjScL+DXaPld7K6XdZE6vZqaHh4cXh3po1ZqZWSI8n7Oco3j99PnrXk7BaadT0g6rSZLNljBXpy5UaXXGIAm7ld2X4diB0Rd/JVA05ElbloRQa/tmhwvQmY6QFCQw=  ;
X-YMail-OSG: .QsL5WIVM1kECUQnKwH0qKWqJpNrI1JtCEhSb37dVXanAFoVEgMjzJNjKIZ7U38cV8M1waCMcCWn5smhcZ6Oy2dFce6fLj5KsGz6Lhws7JIopiCkKVvs7SVRVYrzSueBuXy6q.rS_3bmVPqf_yAaqleTb2AF9YM18G0ZH.3S
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] drm patches for 2.6.27-rc1
Date: Sun, 19 Oct 2008 14:14:34 +1100
User-Agent: KMail/1.9.5
Cc: Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@linux.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie> <1224357062.4384.72.camel@koto.keithp.com> <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810191414.34558.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 October 2008 06:31, Linus Torvalds wrote:
> On Sat, 18 Oct 2008, Keith Packard wrote:
> > The basic plan is to have four new functions (yes, I'm making up names
> > here):
> >
> > struct io_mapping *io_reserve_pci_resource(struct pci_dev *dev,
> >                                            int bar,
> >                                            int prot);
> > void io_mapping_free(struct io_mapping *mapping);
> >
> > void *io_map_atomic(struct io_mapping *mapping, unsigned long pfn);
> > void io_unmap_atomic(struct io_mapping *mapping, unsigned long pfn);
>
> The important thing is that mappings need to be per-CPU, so the above may
> work, but only if it's designed so that "io_reserve_pci_resource()" will
> actually reserve space for 'nr_possible_cpu' page mappings, and then the
> "io_[un]map_atomic()" functions do per-CPU mappings.
>
> Anything else is a disaster, because anything else implies TLB shootdown.

TLB shootdown need only be implied if the behaviour required is to
unmap the virtual address *and* cause any other CPU that subsequently
touches it to fault.

For kva, that would be a bug anyway (use after free). The only thing
it implies is that a TLB shootdown happens at some point before the
address get reused.

Still, it's always going to be faster than a global mapping, if done
properly. I was thinking about doing a vmap_atomic thing generically
in the vmap layer... why exactly do we need the FIXMAP stuff for it?
