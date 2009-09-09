Return-Path: <linux-kernel-owner+w=401wt.eu-S1752630AbZIIDSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbZIIDSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 23:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZIIDSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 23:18:10 -0400
Received: from smtp-out.google.com ([216.239.33.17]:22378 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbZIIDSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 23:18:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=rKaEO5MajaE7JHvDSLfZ3rX/CdoTf981Y6yynDvsKzZOP811KLOZFxcfGe9Gdg9M2
	sOzJggA1jzRHPswgxKaxA==
Date: Tue, 8 Sep 2009 20:18:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4 -mm] flex_array: poison free elements
In-Reply-To: <4AA70D4F.3040503@cn.fujitsu.com>
Message-ID: <alpine.DEB.1.00.0909081959030.5084@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com> <alpine.DEB.2.00.0908211620580.28611@chino.kir.corp.google.com> <1251129384.22398.7166.camel@nimitz> <alpine.DEB.2.00.0908241330361.5574@chino.kir.corp.google.com>
 <1251150156.22398.8289.camel@nimitz> <alpine.DEB.2.00.0908241540480.12448@chino.kir.corp.google.com> <alpine.DEB.1.00.0909081511590.26432@chino.kir.corp.google.com> <4AA70D4F.3040503@cn.fujitsu.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009, Li Zefan wrote:

> > I'm struggling to find other examples.  Dave, do you know of any 
> > subsystems in the kernel that can readily be converted to using flex 
> > array?
> 
> Actually I'm planing to try to convert to use flex array in
> kernel/trace/ftrace.c, and it needs some change in flex array,
> and I'll have to check if it will have a performance effect
> or not.
> 

That's cool, but it looks like none of those allocations currently would 
ever exceed PAGE_SIZE.  The return stack for each task would be a flex 
array of 50 elements, each element being 40 bytes for a maximum array 
size of 2KB.  The tasklist would allocate a flex array of pointers to 
struct ftrace_ret_stack with a maximum of 32 elements.  On x86_64, that 
has a maximum size of 256 bytes.

So while you would be converting existing kernel code to use the new 
interface, which is great, it doesn't have any advantage over the existing 
implementation.  I was looking for a current use-case that would otherwise 
use vmalloc because the entire array could not fit into a single page.
