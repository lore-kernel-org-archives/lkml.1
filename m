Return-Path: <linux-kernel-owner+w=401wt.eu-S1752018AbZLRGkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbZLRGkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 01:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbZLRGkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 01:40:20 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:50145 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbZLRGkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 01:40:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=gxwVHpzdY8lMl+8jMnBaQ8btZhFj7bIRKOhbzyN0Eb2aSs/1w3jjSNVchYk8h46B7a
         pG9aIFu9gxzYLpKS56nhJLlqvhfw6+UrdX3XvXoVsK8sWcPVl5GJpbbr/BLWog3cj4I6
         nZbRP9KGq17qbhl229fikG7Lm4LYa9QASM4vY=
Date: Fri, 18 Dec 2009 15:33:30 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [RFC 4/4] speculative pag fault
Message-Id: <20091218153330.7f26a1bc.minchan.kim@barrios-desktop>
In-Reply-To: <20091218150648.09276f83.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com>
	<20091216101107.GA15031@basil.fritz.box>
	<20091216191312.f4655dac.kamezawa.hiroyu@jp.fujitsu.com>
	<20091216102806.GC15031@basil.fritz.box>
	<28c262360912160231r18db8478sf41349362360cab8@mail.gmail.com>
	<20091216193315.14a508d5.kamezawa.hiroyu@jp.fujitsu.com>
	<20091218093849.8ba69ad9.kamezawa.hiroyu@jp.fujitsu.com>
	<20091218094602.3dcd5a02.kamezawa.hiroyu@jp.fujitsu.com>
	<20091218145449.d3fb94cd.minchan.kim@barrios-desktop>
	<20091218150648.09276f83.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009 15:06:48 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Fri, 18 Dec 2009 14:54:49 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
> 
> > Hi, Kame. 
> > 
> Hi,
> 
> > On Fri, 18 Dec 2009 09:46:02 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > >  	if (flags & FAULT_FLAG_WRITE) {
> > >  		if (!pte_write(entry))
> > > 
> > 
> > I looked over the patch series and come up to one scenario.
> > 
> > CPU A				CPU 2
> > 
> > "Thread A reads page"
> > 		
> > do_page_fault
> > lookup_vma_cache
> > vma->cache_access++
> > 				"Thread B unmap the vma"
> > 
> > 				mm_write_lock
> > 				down_write(mm->mmap_sem)
> > 				mm->version++
> > 				do_munmap
> > 				wait_vmas_cache_access
> > 				wait_event_interruptible
> > mm_version_check fail
> > vma_release
> > wake_up(vma->cache_wait)
> > 				unmap_region
> > 				mm_write_unlock
> > mm_read_trylock
> > find_vma
> > !vma
> > bad_area
> > 				
> > As above scenario, Apparently, Thread A reads proper page in the vma at that time.
> > but it would meet the segment fault by speculative page fault. 
> > 
> Yes, It's intentional.
> 
> > Sorry that i don't have time to review more detail. 
> ya, take it easy. I'm not in hurry.
> 
> > If I miss something, Pz correct me. 
> > 
> 
> In multi-threaded application, mutual-exclusion of  memory-access v.s. munmap
> is the application's job. In above case, the application shouldn't unmap memory
> while it's access memory. (The application can be preempted at any point.)
> So, the kernel only have to take care of sanity of memory map status.
> In this case, no error in kernel's object. This is correct.

Ahhh. It's my fault. I need sleeping. :)
After take a enough rest, I will review continuosly. 

Thanks. Kame. 

> Thank you for your interests.
> 
> Regards,
> -Kame
> 
> 
> 
> 
> 


-- 
Kind regards,
Minchan Kim
