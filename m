Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbYAXDNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbYAXDNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 22:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYAXDNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 22:13:41 -0500
Received: from relay1.sgi.com ([192.48.171.29]:54516 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752283AbYAXDNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 22:13:40 -0500
Date: Wed, 23 Jan 2008 19:13:35 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nishanth Aravamudan <nacc@us.ibm.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Mel Gorman <mel@csn.ul.ie>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       lee.schermerhorn@hp.com, Linux MM <linux-mm@kvack.org>,
       Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH] Fix boot problem in situations where the boot CPU is
 running on a memoryless node
In-Reply-To: <20080123213637.GE3848@us.ibm.com>
Message-ID: <Pine.LNX.4.64.0801231906310.17620@schroedinger.engr.sgi.com>
References: <20080123125236.GA18876@aepfle.de> <20080123135513.GA14175@csn.ul.ie>
 <Pine.LNX.4.64.0801231611160.20050@sbz-30.cs.Helsinki.FI>
 <Pine.LNX.4.64.0801231626320.21475@sbz-30.cs.Helsinki.FI>
 <Pine.LNX.4.64.0801231648140.23343@sbz-30.cs.Helsinki.FI>
 <20080123155655.GB20156@csn.ul.ie> <Pine.LNX.4.64.0801231906520.1028@sbz-30.cs.Helsinki.FI>
 <20080123195220.GB3848@us.ibm.com> <84144f020801231302g2cafdda9kf7f916121dc56aa5@mail.gmail.com>
 <Pine.LNX.4.64.0801231312580.15681@schroedinger.engr.sgi.com>
 <20080123213637.GE3848@us.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2008, Nishanth Aravamudan wrote:

> Right, so it might have functioned before, but the correctness was
> wobbly at best... Certainly the memoryless patch series has tightened
> that up, but we missed these SLAB issues.
> 
> I see that your patch fixed Olaf's machine, Pekka. Nice work on
> everyone's part tracking this stuff down.

Another important result is that I found that GFP_THISNODE is actually 
required for proper SLAB operation and not only an optimization. Fallback 
can lead to very bad results. I have two customer reported instances of 
SLAB corruption here that can be explained now due to fallback to another 
node. Foreign objects enter the per cpu queue. The wrong node lock is 
taken during cache_flusharray(). Fields in the struct slab can become 
corrupted. It typically hits the list field and the inuse field.



