Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbXJVNrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbXJVNrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 09:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbXJVNra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 09:47:30 -0400
Received: from ns1.suse.de ([195.135.220.2]:45184 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbXJVNr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 09:47:29 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: dean gaudet <dean@arctic.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>, Morten@suse.de,
       David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>
Subject: Re: Interaction between Xen and XFS: stray RW mappings
From: Andi Kleen <andi@firstfloor.org>
References: <470FA7C3.90404@goop.org> <20071014225618.GN23367404@sgi.com>
	<4712A254.4090604@goop.org>
	<200710151415.07248.nickpiggin@yahoo.com.au>
	<alpine.DEB.0.9999.0710212015430.2320@twinlark.arctic.org>
	<471C1A61.1010001@goop.org>
Date: Mon, 22 Oct 2007 15:47:27 +0200
In-Reply-To: <471C1A61.1010001@goop.org> (Jeremy Fitzhardinge's message of "Sun\, 21 Oct 2007 20\:34\:57 -0700")
Message-ID: <p73sl439s7k.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
> Yes, that's precisely the problem.  xfs does delay the unmap, leaving
> stray mappings, which upsets Xen.

Again it not just upsets Xen, keeping mappings to freed pages is wrong generally 
and violates the x86 (and likely others like PPC) architecture because it can 
cause illegal caching attribute aliases.

The patch that went into the tree was really not correct -- this
bogus optimization should have been unconditionally removed
or if you really wanted an ifdef made dependent on !CONFIG_XEN &&
!CONFIG_AGP (and likely && !CONFIG_DRM && !CONFIG_anything else that
uses uncached mappings in memory). 

You just worked around the obvious failure and leave the non obvious
rare corruptions in, which isn't a good strategy.

-Andi
