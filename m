Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbYAGScF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbYAGScF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 13:32:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYAGSbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 13:31:55 -0500
Received: from relay1.sgi.com ([192.48.171.29]:53274 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751489AbYAGSby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 13:31:54 -0500
Date: Mon, 7 Jan 2008 10:31:53 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bunk@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: Linux 2.6.24-rc7 Build-Failure at __you_cannot_kmalloc_that_much
In-Reply-To: <20080107100733.3655f74f.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0801071014450.22642@schroedinger.engr.sgi.com>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
 <478200A4.4090707@linux.vnet.ibm.com> <20080107100733.3655f74f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008, Andrew Morton wrote:

> > : undefined reference to `__you_cannot_kmalloc_that_much'

There is also a kernel.org bugzilla for this at

http://bugzilla.kernel.org/show_bug.cgi?id=9669
For some reason my adds to this do not show up.

In both cases we have a 

k(z/m)alloc(sizeof(*pointer), ...)

that is for some reason failing. I guess what happens is that the function 
in which this occurs is too complex for gcc 3.2. Thus it stops constant 
folding the sizeof(*pointer) in the complex inline-if-cascade that SLAB 
needs to determine the cache and does not eliminate the 
__you_cannot_kmalloc_that_much branch().

SLUB in that case just puts a series of if comparisions in the code. This 
means compilation does not fail but a large amount of code is generated.

We could replace the __you_cannot_kmalloc_that_much() with a BUG() 
statement so we have the same effect in SLAB?

