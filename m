Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbYKWLHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbYKWLHg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 06:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757493AbYKWLH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 06:07:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57908 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757063AbYKWLH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 06:07:27 -0500
Date: Sun, 23 Nov 2008 12:07:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 2/3] tracing/stack-tracer: fix locking
Message-ID: <20081123110714.GE30453@elte.hu>
References: <20081123085310.GF30453@elte.hu> <1227436748-17075-2-git-send-email-edwintorok@gmail.com> <20081123105211.GC30453@elte.hu> <49293777.8070404@gmail.com> <20081123110114.GD30453@elte.hu> <492938A4.9020502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <492938A4.9020502@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Török Edwin <edwintorok@gmail.com> wrote:

> On 2008-11-23 13:01, Ingo Molnar wrote:
> > * Török Edwin <edwintorok@gmail.com> wrote:
> >
> >   
> >> On 2008-11-23 12:52, Ingo Molnar wrote:
> >>     
> >>> * Török Edwin <edwintorok@gmail.com> wrote:
> >>>
> >>>   
> >>>       
> >>>> +		down_read(&mm->mmap_sem);
> >>>> +		vma = find_vma(mm, ip);
> >>>>  		if (vma) {
> >>>>  			file = vma->vm_file;
> >>>>  			vmstart = vma->vm_start;
> >>>>  		}
> >>>> +		up_read(&mm->mmap_sem);
> >>>>  	}
> >>>>  	if (file) {
> >>>>  		ret = trace_seq_path(s, &file->f_path);
> >>>>     
> >>>>         
> >>> and now it's "file" that is held without a reference and possibly 
> >>> racy.
> >>>   
> >>>       
> >> I'll move the (file) inside the mmap_sem too, since file is part of 
> >> vma, and you need mmap_sem to access the vma nobody can modify 
> >> (file) if they don't hold mmap_sem. Am I right?
> >>     
> >
> > yeah - you can use the mm lock for that as the vma holds a reference 
> > to the file. This works as long as none of the seq functions called 
> > with this lock held can provoke a user pagefault (they shouldnt, but i 
> > havent checked in detail).
> >   
> 
> It calls d_path, that access only kernel structures AFAICT, so it 
> can't provoke a *user* pagefault. Not sure about kernel pagefaults, 
> but they shouldn't matter.

yeah - kernel pagefaults can happen in rare circumstances here but 
they are all atomic and transparent to most other parts of the kernel 
so they indeed do not matter.

	Ingo
