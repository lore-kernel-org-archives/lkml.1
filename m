Return-Path: <linux-kernel-owner+w=401wt.eu-S1760475AbYB0WQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760475AbYB0WQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761098AbYB0WPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:15:48 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50263 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760842AbYB0WPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:15:47 -0500
Date: Wed, 27 Feb 2008 14:15:45 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Torsten Kaiser <just.for.lkml@googlemail.com>
Subject: Re: NULL pointer in kmem_cache_alloc with 2.6.25-rc1
In-Reply-To: <84144f020802182338p68d412f6sa9e0f8975344a9c0@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802271412420.13186@schroedinger.engr.sgi.com>
References: <1203058021.3027.143.camel@ymzhang> 
 <Pine.LNX.4.64.0802150839180.12023@schroedinger.engr.sgi.com> 
 <1203404594.3248.32.camel@ymzhang> <84144f020802182338p68d412f6sa9e0f8975344a9c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008, Pekka Enberg wrote:

> > I will do more testing and investigation, as the bug also exists in 2.6.25-rc2.
> 
> Could you please try Ingo's patch: http://lkml.org/lkml/2008/2/19/13
> 
> Looks like there are some problems with SLUB_FASTPATH.

Yeah that would determine if its the fastpath code. Note that the new 
fastpath code may expose bugs that so far have been tolerated by the slab 
allocators. If a store of a NULL to the first word of an object occurs 
then this will be tolerated in 2.6.24 because slub will take it as the end 
of the object list and just forget about the remaining objects. The 
fastpath code will terminate with a NULL pointer deref.

Enabling full debugging may get rid of the race due to the slowdown. It 
could help to just enable minimal debugging for the slab cache in which we 
see the issue.

So do

slub_debug=F,<affected cache>

