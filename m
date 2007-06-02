Return-Path: <linux-kernel-owner+w=401wt.eu-S1762521AbXFBAsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762521AbXFBAsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 20:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755677AbXFBAsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 20:48:08 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:17245 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbXFBAsG (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 20:48:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QDAd72E3C9Mf5LUCUJQirO3Imqhs7wDCRGSGni9Ze2HCkUWs25fVy36ghbeBjbXEGQl+VU4Bwz3pvhroKL9MOJff4ZitBzLlCMmeT4twJns/3m2cb0h7T42/gYJip0TzMw+k2DeLE0iYSlhXKqv640qE4hQkAZH2P2uRKjdRG/k=
Message-ID: <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com>
Date: Fri, 1 Jun 2007 17:48:05 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Cc: carsteno@de.ibm.com, "Andrew Morton" <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       "Richard Griffiths" <res07ml0@verizon.net>,
       Linux-kernel@vger.kernel.org
In-Reply-To: <465BB5BA.3050900@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179871779.24163.11.camel@localhost.localdomain>
	 <20070522154905.1d7e8a2e.akpm@linux-foundation.org>
	 <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > The current xip stack relies on having struct page behind the memory
> > segment. This causes few impact on memory management, but occupies some
> > more memory. The cramfs patch chose to modify copy on write in order to
> > deal with vmas that don't have struct page behind.
> > So far, Hugh and Linus have shown strong opposition against copy on
> > write with no struct page behind. If this implementation is acceptable
> > to the them, it seems preferable to me over wasting memory. The xip
> > stack should be modified to use this vma flag in that case.
>
> I would rather not :P
>
> We can copy on write without a struct page behind the source today, no?

The existing COW techniques fail on some corner cases.  I'm not up to
speed on the vm code.  I'll try to look into this a little more but it
might be useful if I knew what questions I need to answer so you vm
experts can understand the problem.

Let me give one example.  If you try to debug an XIP application
without this patch, bad things happen.  XIP in this sense is synomous
with executing directly out of Flash and you can't just change the
physical memory to redirect it to the debugger so easily in Flash.
Now I don't know exactly why yet some, but not all applications,
trigger this added vm hack.  I'm not sure exactly why it would get
triggered under normal circumstances.  Why would a read-only map get
written to?

> What is insufficient for the XIP code with the current COW?

So I think the problem may have something to do with the nature of the
memory in question.   We are using Flash that is ioremap()'ed to a
usable virtual address.  And yet we go on to try to use it as if it
were plain old system memory, like any RAM page.  We need it to be
presented as any other memory page only physically read-only.
ioremap() seems to be a hacky way of accomplishing that, but I can't
think of better way.  In ARM we even had to invent ioremap_cached() to
improve performance.  Thoughts?
