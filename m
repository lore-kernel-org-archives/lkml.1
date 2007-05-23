Return-Path: <linux-kernel-owner+w=401wt.eu-S1757903AbXEWWBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbXEWWBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 18:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbXEWWB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 18:01:29 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755293AbXEWWB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 18:01:28 -0400
Date: Wed, 23 May 2007 15:01:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
Message-Id: <20070523150122.f9946f37.akpm@linux-foundation.org>
In-Reply-To: <4654AC94.6080601@googlemail.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	<46540DB2.5000605@googlemail.com>
	<Pine.LNX.4.64.0705231016330.20031@schroedinger.engr.sgi.com>
	<4654AC94.6080601@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 23:05:24 +0200
Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Christoph Lameter napisa__(a):
> > On Wed, 23 May 2007, Michal Piotrowski wrote:
> > 
> >> Christoph, this looks like a bug in SLUB.
> > 
> > Please boot with slub_debug to find the bad code that overwrites a slab 
> > object after it was freed.
> > 
> > 
> 
> [   19.096577] Real Time Clock Driver v1.12ac
> [   21.650315] *** SLUB kmalloc-8: Redzone Active@0xc90f6d20 slab 0xc528c530
> [   21.657365]     offset=3360 flags=0x400000c3 inuse=61 freelist=0xc90f6d58
> [   21.664349]   Bytes b4 0xc90f6d10:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
> [   21.674305]     Object 0xc90f6d20:  31 30 31 39 2e 30 30 35                         1019.005        
> [   21.684259]    Redzone 0xc90f6d28:  00 cc cc cc                                     .______            
> [   21.694265] FreePointer 0xc90f6d2c -> 0xc90f6d58
> [   21.699061] Last alloc: get_modalias+0x61/0xf5 jiffies_ago=53 cpu=1 pid=554
> [   21.706362]     Filler 0xc90f6d50:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        

argh, I never 100% understood the slab gobbledygook, and now we have slub
gobbledygook.  I _hope_ what that's saying is that the 00 at 0xc90f6d28
wasn't supposed to be there.

Obvious bug:

--- a/drivers/firmware/dmi-id.c~a
+++ a/drivers/firmware/dmi-id.c
@@ -94,7 +94,7 @@ static ssize_t get_modalias(char *buffer
 		if (!c)
 			continue;
 
-		t = kmalloc(strlen(c), GFP_KERNEL);
+		t = kmalloc(strlen(c) + 1, GFP_KERNEL);
 		if (!t)
 			break;
 		ascii_filter(t, c);
_


> Here is another one

Same deal.

