Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbZAGM6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbZAGM6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757207AbZAGM6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:58:16 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:37417 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185AbZAGM6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:58:14 -0500
From: Chandru <chandru@in.ibm.com>
Organization: ibm
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: 2.6.28-rc9 panics with crashkernel=256M while booting
Date: Wed, 7 Jan 2009 18:28:13 +0530
User-Agent: KMail/1.9.10
Cc: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <200812241325.49404.chandru@in.ibm.com> <200901051919.52327.chandru@in.ibm.com> <1231173033.19452.190.camel@nimitz>
In-Reply-To: <1231173033.19452.190.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901071828.13719.chandru@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2009 22:00:33 Dave Hansen wrote:
> OK, I had to think about this for a good, long time.  That's bad. :)
>
> There are two things that we're dealing with here: "active regions" and
> the NODE_DATA's.  The if() you've pasted above resizes the reservation
> so that it fits into the current active region.  However, as you noted,
> we haven't resized it so that it fits into the NODE_DATA() that we're
> looking at.  We call into the bootmem code, and BUG_ON().
>
> The thing I don't like about this is that it might hide bugs in other
> callers.  This really is a ppc-specific thing and, although what you
> wrote will fix the bug on ppc, it will probably cause someone in the
> future to call reserve_bootmem_node() with too large a reservation and
> get a silent failure (not reserving the requested size) back.
>
> We really do need to go take a hard look at the whole interaction
> between lmb's, node active regions, and the NUMA code some day.  It has
> kinda grown to be a bit ungainly.
>
> How about we just consult the NODE_DATA() in
> mark_reserved_regions_for_nid() instead of reserve_bootmem_node()?

I don't know how you wanted NODE_DATA() to be consulted here. i.e before 
calling reserve_bootmem_node() should we have a condition 

	if (PFN_UP(physbase+reserve_size) > node_end_pfn) 
	then
		resize reserve_size again so that PFN_UP() will equate to node_end_pfn ??
	end 

Also I was wondering if in reserve_bootmem_node()
	end = PFN_DOWN() ; will do.. 

With the recent changes from you that went into 2.6.28 stable 
(commit:a4c74ddd5ea3db53fc73d29c222b22656a7d05be), it worked on the system 
with PFN_DOWN(). 

Thanks,
Chandru
