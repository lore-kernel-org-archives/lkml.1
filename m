Return-Path: <linux-kernel-owner+w=401wt.eu-S1761924AbZCZXKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924AbZCZXKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757008AbZCZXJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:09:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755118AbZCZXJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:09:53 -0400
Date: Thu, 26 Mar 2009 16:02:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
cc: Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Martin J. Bligh" <mbligh@mbligh.org>, linux-ext4@vger.kernel.org,
       Ying Han <yinghan@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, guichaz@gmail.com,
       Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
In-Reply-To: <20090326084723.GB8207@skywalker>
Message-ID: <alpine.LFD.2.00.0903261559200.3032@localhost.localdomain>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com> <20090324125510.GA9434@duck.suse.cz> <20090324132637.GA14607@duck.suse.cz> <200903250130.02485.nickpiggin@yahoo.com.au> <20090324144709.GF23439@duck.suse.cz> <1237906563.24918.184.camel@twins>
 <20090324152959.GG23439@duck.suse.cz> <20090326084723.GB8207@skywalker>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Mar 2009, Aneesh Kumar K.V wrote:
> 
> >page faults doing allocation can take a
> > *long* time 
> 
> That is true

Btw, this is actually a feature rather than a bug.

We want to slow down the writer, which is why we also do dirty page 
balancing when marking a page dirty. 

Basically, if block allocation is a performance problem, then it should be 
a performance problem that is attributed to the process that _causes_ it, 
rather than to some random poor unrelated process that then later ends up 
writing the page out because it wants to use some memory.

This is why tracking dirty pages is so important. Yes, it also avoids 
various nasty overcommit situations, but the whole "make it hurt for the 
person responsible, rather than a random innocent bystander" is the more 
important part of it. 

			Linus
