Return-Path: <linux-kernel-owner+w=401wt.eu-S936373AbXHHU0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936373AbXHHU0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 16:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765542AbXHHU0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 16:26:07 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43064 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936051AbXHHU0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 16:26:05 -0400
Date: Wed, 8 Aug 2007 13:26:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Lucio Correia <ljhc@br.ibm.com>
cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arndb@arndb.de>
Subject: Re: SLUB doesn't work with kdump kernel on Cell
In-Reply-To: <1186604151.3608.46.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0708081321400.14478@schroedinger.engr.sgi.com>
References: <1186604151.3608.46.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007, Lucio Correia wrote:

> Hi Christoph,
> 
> I found a problem with SLUB when trying to boot a kdump kernel on a Cell
> QS20 Blade running Fedora 7, kernel 2.6.22.5. If I use SLAB for the
> kdump kernel, everything works ok. The fact is that SLUB doesn't find a
> page frame for allocation in the current node, due to the flag
> GFP_THISNODE on a call to new_slab, and stops at a BUG_ON on line 1802
> of slub.c. 

This is due to the node 1 having only one page. Could you just switch node 
1 off?

SLAB boots because it falls back to node 0 for the control structures. So 
it creates useless control structures for node 1. These are then never 
used since any allocation  attempt to node 1 falls back to node 0.

> I understand that this flag should not be removed, and that there is a
> better solution, but it demonstrates the problem. Could you give me some
> direction on the better way to solve this problem?

Do not create a node that just has one page in it?

Or make it truly empty? An empty node will cause GFP_THISNODE to fall back 
and you then have the same useless control structure allocation as on 
SLAB.

